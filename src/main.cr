require "csv"
require "./softepigen"

REPEAT_SIZE = 5

minlength = 15
maxlength = 25
minamplicon = 100
maxamplicon = 150
mincpg = 3
maxcpg = 40

path = ARGV[0]? || abort "error: Missing input FASTA file"
abort "error: FASTA file not found" unless File.exists?(path)

File.open(path) do |fasta|
  fasta.each_line do |line|
    next unless line.starts_with?('>')

    name = line[1..]
    puts "Processing #{name}..."

    seq = Softepigen::Region.new(fasta.read_line)
    regions = seq.split_by_cpg
    regions.select! &.size.>=(minlength + 2) # includes CG

    downstream_primers = [] of Softepigen::Region # 5' to 3'
    upstream_primers = [] of Softepigen::Region   # 3' to 5'
    regions.each do |region|
      complex_idxs = region.complexity

      region.each_downstream(complex_idxs) do |subregion|
        next unless subregion.size <= maxlength
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
        next unless subregion.size <= maxlength
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
          amplicon = seq[dsr.start..usr.stop]
          dpg_count = 0
          amplicon.each_cpg { dpg_count += 1 }
          next unless minamplicon <= distance <= maxamplicon &&
                      mincpg <= dpg_count <= maxcpg
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
          csv << distance << ',' << dpg_count
          csv.puts
        end
      end
    end
  end
end
