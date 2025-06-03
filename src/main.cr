require "option_parser"
require "./softepigen"

primer_size = 15..25
amplicon_size = 100..150
allowed_cpg = 3..40
kmer = 4
parser = OptionParser.parse do |parser|
  parser.banner = "Usage: softepigen [-a=N,M] [-p=N,M] [-c=N,M] FASTA"
  parser.on(
    "-a=N,M", "--amplicon=N,M",
    "Amplicon size from N to M. Defaults to #{amplicon_size}") do |str|
    str =~ /^\d+(,|-|..)\d+$/ || abort "error: Invalid amplicon size #{str.inspect}"
    minamplicon, maxamplicon = str.split($~[1]).map &.to_i
    amplicon_size = minamplicon..maxamplicon
  end
  parser.on(
    "-p=N,M", "--primer=N,M",
    "Primer size from N to M. Defaults to #{primer_size}") do |str|
    str =~ /^\d+(,|-|..)\d+$/ || abort "error: Invalid primer size #{str.inspect}"
    minlength, maxlength = str.split($~[1]).map &.to_i
    primer_size = minlength..maxlength
  end
  parser.on(
    "-c=N,M", "--cpg=N,M",
    "Number of CpG from N to M. Defaults to #{allowed_cpg}") do |str|
    str =~ /^\d+(,|-|..)\d+$/ || abort "error: Invalid number of CpG #{str.inspect}"
    mincpg, maxcpg = str.split($~[1]).map &.to_i
    allowed_cpg = mincpg..maxcpg
  end
  parser.on(
    "-a={0,1}", "--astringency={0,1}",
    "Astringency for complexity analysis. Defaults to 0.") do |str|
    kmer = case str
           when "0" then 4
           when "1" then 5
           else          abort "error: Invalid astringency #{str.inspect}"
           end
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
  chr = ""
  amplicons = [] of Softepigen::Amplicon
  fasta.each_line do |line|
    next unless line.starts_with?('>')

    name = line[1..]
    puts "Processing #{name}..."

    tokens = name.split(/[\-:]/)
    chr = tokens[0]
    seq_offset = tokens[1]?.try(&.to_f.to_i) || 1

    seq = Softepigen::Region.new fasta.read_line, seq_offset
    forward_regions, reverse_regions = Softepigen.find_primers(seq, primer_size, kmer)
    amplicons.concat Softepigen.generate_amplicons(
      forward_regions, reverse_regions, amplicon_size, allowed_cpg)
  end

  Softepigen.write_csv "#{chr}-out.csv", amplicons
  Softepigen.write_bed "#{chr}-out.bed", chr, Softepigen.fold_amplicons(amplicons)
end
