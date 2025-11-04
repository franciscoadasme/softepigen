require "option_parser"
require "./softepigen"

primer_size = 15..25
amplicon_size = 100..150
allowed_cpg = 3..40
kmer = 4
output = nil
parser = OptionParser.parse do |parser|
  parser.banner = "Usage: softepigen [-a=N,M] [-p=N,M] [-c=N,M] [-o/--output NAME] FASTA"
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
  parser.on(
    "-o NAME",
    "--output NAME",
    "Output name (without extension) for the output files.") do |str|
    output = str
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    abort "error: #{flag} is not a valid option\n#{parser}"
  end
end

path = ARGV[0]?.try { |x| Path[x] } || abort "error: Missing input FASTA file\n#{parser}"
abort "error: FASTA file not found" unless File.exists?(path)

amplicons = Softepigen.find_amplicons(path, primer_size, amplicon_size, allowed_cpg, kmer)

if amplicons.size > 0
  folded_amplicons = Softepigen.fold_amplicons(amplicons)
  puts "Found #{folded_amplicons.size} amplicon(s) in #{path}"

  chr = FASTA::Header.read(path).name.downcase
  output ||= File.basename(path.stem, ".fasta") # sometimes ends in .fasta.txt
  Softepigen.write_csv "#{output}-out.csv", amplicons
  Softepigen.write_bed "#{output}-out.bed", chr, folded_amplicons
  puts "Written amplicons to #{output}-out.csv and #{output}-out.bed"
else
  puts "No amplicons found in #{path}."
end
