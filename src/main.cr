require "csv"
require "option_parser"
require "./softepigen"

REPEAT_SIZE = 5

def write_csv(io : IO, amplicons : Array(Softepigen::Amplicon)) : Nil
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
  fasta.each_line do |line|
    next unless line.starts_with?('>')

    name = line[1..]
    puts "Processing #{name}..."

    seq = Softepigen::Region.new fasta.read_line
    downstream_primers, upstream_primers = Softepigen.find_primers(seq, primer_size, kmer)
    amplicons = Softepigen.generate_amplicons(
      downstream_primers, upstream_primers, amplicon_size, allowed_cpg)

    File.open("#{name}-out.csv", "w") do |io|
      write_csv io, amplicons
    end
  end
end
