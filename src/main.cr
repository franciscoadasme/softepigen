require "csv"
require "option_parser"
require "./softepigen"

REPEAT_SIZE = 5

primer_size = 15..25
amplicon_size = 100..150
allowed_cpg = 3..40
parser = OptionParser.parse do |parser|
  parser.banner = "Usage: softepigen [-a=N,M] [-p=N,M] [-c=N,M] FASTA"
  parser.on(
    "-a=N,M", "--amplicon=N,M",
    "Amplicon size from N to M. Defaults to #{amplicon_size}") do |str|
    str =~ /^\d+(,|-|..)\d+$/ || abort "error: Invalid amplicon size #{str.inspect}"
    minamplicon, maxamplicon = str.split($~[1]).map &.to_i
  end
  parser.on(
    "-p=N,M", "--primer=N,M",
    "Primer size from N to M. Defaults to #{primer_size}") do |str|
    str =~ /^\d+(,|-|..)\d+$/ || abort "error: Invalid primer size #{str.inspect}"
    minlength, maxlength = str.split($~[1]).map &.to_i
  end
  parser.on(
    "-c=N,M", "--cpg=N,M",
    "Number of CpG from N to M. Defaults to #{allowed_cpg}") do |str|
    str =~ /^\d+(,|-|..)\d+$/ || abort "error: Invalid number of CpG #{str.inspect}"
    mincpg, maxcpg = str.split($~[1]).map &.to_i
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    abort "error: #{flag} is not a valid option\n#{parser}"
  end
end

path = ARGV[0]? || abort "error: Missing input FASTA file\n#{parser}"
abort "error: FASTA file not found" unless File.exists?(path)

File.open(path) do |fasta|
  fasta.each_line do |line|
    next unless line.starts_with?('>')

    name = line[1..]
    puts "Processing #{name}..."

    seq = Softepigen::Region.new(fasta.read_line)
    regions = seq.split_by_cpg
    regions.select! &.size.>=(primer_size.begin + 2) # includes CG

    downstream_primers = [] of Softepigen::Region # 5' to 3'
    upstream_primers = [] of Softepigen::Region   # 3' to 5'
    regions.each do |region|
      complex_idxs = region.complexity

      region.each_downstream(complex_idxs) do |subregion|
        next unless subregion.size.in?(primer_size)
        next if subregion.has_repeats?(REPEAT_SIZE)
        if subregion.stop - 4 >= 0
          4.downto(1) do |i|
            other = subregion.unsafe_upstream_expand(i)
            downstream_primers << other unless other.has_repeats?(REPEAT_SIZE)
          end
        end
        downstream_primers << subregion
      end

      region.each_upstream(complex_idxs) do |subregion|
        next unless subregion.size.in?(primer_size)
        upstream_primers << subregion unless subregion.has_repeats?(REPEAT_SIZE)
        if subregion.stop + 4 < seq.size
          1.upto(4) do |i|
            other = subregion.unsafe_downstream_expand(i)
            upstream_primers << other unless other.has_repeats?(REPEAT_SIZE)
          end
        end
      end
    end

    File.open("#{name}-out.csv", "w") do |csv|
      {"FORWARD POSITION", "LENGTH IN BP", "FORWARD PRIMER",
       "REVERSE POSITION", "LENGTH IN BP", "REVERSE PRIMER",
       "AMPLICON SIZE", "NUMBERCpG"}.join csv, ','
      csv.puts

      downstream_primers.each do |dsr|
        upstream_primers.each do |usr|
          distance = usr.stop - dsr.start
          # next upstream primers will produce an amplicon too large so stop
          break unless distance <= amplicon_size.end
          # skip if upstream primer is before downstream primer
          next unless distance >= amplicon_size.begin

          amplicon = seq[dsr.start..usr.stop]
          cpg_count = 0
          amplicon.each_cpg { cpg_count += 1 }
          next unless cpg_count.in?(allowed_cpg)

          csv << dsr.start + 1 << ',' << dsr.size << ','
          dsr[...-dsr.padding].to_s(csv, replacing: {'C' => 'T'})    # output C=>T before CG
          dsr[-dsr.padding..-dsr.padding + 1].to_s(csv)              # output CG intact
          dsr[-dsr.padding + 2..].to_s(csv, replacing: {'C' => 'T'}) # output C=>T after CG
          csv << ','
          csv << usr.start + 1 << ',' << usr.size << ','
          usr[-usr.padding - 1..].to_s(csv, complement: true, replacing: {'C' => 'T'}) # output C=>T before CG
          usr[-usr.padding - 3..-usr.padding - 2].to_s(csv, complement: true)          # output complement CG intact
          usr[..-usr.padding - 4].to_s(csv, complement: true, replacing: {'C' => 'T'}) # output C=>T after CG
          csv << ','
          csv << distance << ',' << cpg_count
          csv.puts
        end
      end
    end
  end
end
