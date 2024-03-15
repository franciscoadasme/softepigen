require "./softepigen/**"

# TODO: Write documentation for `Softepigen`
module Softepigen
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  KMERS = {
    4 => %w(
      TGAT TGTA GTAT TAGT TATG GTAG GTGA TGAG GATG GAGT AGTG AGTA AGAT
      GATA ATGA ATAG TAGA ATGT
    ).map(&.to_slice),
    5 => %w(
      GTAGA AGTGA GTGAG ATGAG AGATG GATGA GAGTA GAGTG GAGAT AGATA GATAG
      ATAGA
    ).map(&.to_slice),
  }

  enum Sense
    Forward
    Backward
  end

  record Primer, range : Range(Int32, Int32), sense : Sense do
    include Comparable(Primer)

    def <=>(other : self) : Int32
      @range.begin <=> other.range.begin
    end

    def includes?(other : self) : Bool
      other.sense == sense && other.start >= start && other.stop <= stop
    end

    def size : Int32
      stop - start + 1
    end

    def start : Int32
      @range.begin
    end

    def stop : Int32
      @range.end
    end
  end

  def self.find_primers(
    seq : Region,
    primer_size : Range(Int, Int),
    kmer : Int
  ) : Tuple(Array(Region), Array(Region))
    regions = seq.split_by_cpg
    regions.select! &.size.>=(primer_size.begin)

    forward_primers = [] of Region # 5' to 3'
    reverse_primers = [] of Region # 3' to 5'
    regions.each do |region|
      complex_idxs = region.complexity(kmer)

      region.each_downstream(complex_idxs) do |subregion|
        next unless subregion.size.in?(primer_size)
        next if subregion.has_repeats?(REPEAT_SIZE)
        if subregion.start - 4 >= 0
          4.downto(1) do |i|
            other = subregion.unsafe_upstream_expand(i)
            forward_primers << other unless other.has_repeats?(REPEAT_SIZE)
          end
        end
        forward_primers << subregion
      end

      region.each_upstream(complex_idxs) do |subregion|
        next unless subregion.size.in?(primer_size)
        reverse_primers << subregion unless subregion.has_repeats?(REPEAT_SIZE)
        if subregion.stop + 4 < seq.size
          1.upto(4) do |i|
            other = subregion.unsafe_downstream_expand(i)
            reverse_primers << other unless other.has_repeats?(REPEAT_SIZE)
          end
        end
      end
    end
    {forward_primers, reverse_primers}
  end

  def self.generate_amplicons(
    forward_primers : Array(Region),
    reverse_primers : Array(Region),
    amplicon_size : Range(Int, Int),
    allowed_cpg : Range(Int, Int)
  ) : Array(Amplicon)
    amplicons = [] of Amplicon
    offset = 0
    forward_primers.each do |dsr|
      reverse_primers.each(within: offset..) do |usr|
        distance = usr.stop - dsr.start
        if distance < amplicon_size.begin
          # skip if reverse primer is before forward primer
          offset += 1
          next
        elsif distance > amplicon_size.end
          # next reverse primers will produce an amplicon too large so stop
          break
        end

        amplicon = Amplicon.new(dsr, usr)
        amplicons << amplicon if amplicon.cpg_count.in?(allowed_cpg)
      end
    end
    amplicons
  end

  def self.write_bed(
    io : IO,
    chromosome : String,
    primers : Array(Primer)
  ) : Nil
    counter = {Sense::Forward => 0, Sense::Backward => 0}
    start = primers.min_of &.range.begin
    stop = primers.max_of &.range.end

    io.puts "browser position #{chromosome}:#{start}-#{stop}"
    io.puts "browser hide all"
    io.puts %(track type=bed name="Primers" description="Primers detected by the MS-HRM method" itemRgb="On")
    CSV.build(io, '\t', quoting: :none) do |csv|
      primers.sort!.each do |primer|
        prefix = primer.sense.forward? ? "Pos" : "Neg"
        name = prefix + (counter[primer.sense] += 1).to_s
        sense_symbol = primer.sense.forward? ? '+' : '-'
        rgb = primer.sense.forward? ? "0,0,255" : "255,0,0"
        csv.row do |row|
          row << chromosome
          row << primer.start
          row << primer.stop
          row << name
          row << 0
          row << sense_symbol
          row << primer.start
          row << primer.stop
          row << rgb
        end
      end
    end
  end

  def self.write_bed(path : Path | String, chromosome : String, primers : Array(Primer)) : Nil
    File.open(path, "w") do |io|
      write_bed io, chromosome, primers
    end
  end

  def self.write_csv(io : IO, amplicons : Array(Amplicon)) : Nil
    {"FORWARD POSITION", "LENGTH IN BP", "FORWARD PRIMER",
     "REVERSE POSITION", "LENGTH IN BP", "REVERSE PRIMER",
     "AMPLICON SIZE", "NUMBERCpG"}.join io, ','
    io.puts

    amplicons.each do |amplicon|
      dsr, usr = amplicon.primers
      io << dsr.start + 1 << ',' << dsr.size << ','
      dsr[...-dsr.padding].to_s(io, replacing: {'C' => 'T'})    # output C=>T before CG
      dsr[-dsr.padding..-dsr.padding + 1].to_s(io)              # output CG intact
      dsr[-dsr.padding + 2..].to_s(io, replacing: {'C' => 'T'}) # output C=>T after CG
      io << ','
      io << usr.start + 1 << ',' << usr.size << ','
      usr[-usr.padding - 1..].to_s(io, complement: true, replacing: {'C' => 'T'}) # output C=>T before CG
      usr[-usr.padding - 3..-usr.padding - 2].to_s(io, complement: true)          # output complement CG intact
      usr[..-usr.padding - 4].to_s(io, complement: true, replacing: {'C' => 'T'}) # output C=>T after CG
      io << ','
      io << amplicon.size - 1 << ',' << amplicon.cpg_count
      io.puts
    end
  end

  def self.write_csv(path : Path | String, amplicons : Array(Amplicon)) : Nil
    File.open(path, "w") do |io|
      write_csv io, amplicons
    end
  end
end
