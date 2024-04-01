require "csv"
require "option_parser"
require "./softepigen"

REPEAT_SIZE = 5

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
  primers = [] of Softepigen::Primer
  fasta.each_line do |line|
    next unless line.starts_with?('>')

    name = line[1..]
    puts "Processing #{name}..."

    seq = Softepigen::Region.new fasta.read_line
    forward_regions, reverse_regions = Softepigen.find_primers(seq, primer_size, kmer)
    amplicons = Softepigen.generate_amplicons(
      forward_regions, reverse_regions, amplicon_size, allowed_cpg)
    amplicons = Softepigen.fold_amplicons(amplicons)

    tokens = name.split(/[\-:]/)
    chr = tokens[0]
    seq_start = tokens[1]?.try(&.to_f.to_i)
    # TODO: filter primers that produce valid amplicons only?
    {
      {forward_regions, Softepigen::Sense::Forward},
      {reverse_regions, Softepigen::Sense::Backward},
    }.each do |regions, sense|
      regions.each do |region|
        start = (seq_start || 0) + region.start
        primers << Softepigen::Primer.new(start..(start + region.size), sense)
      end
    end

    Softepigen.write_csv "#{name}-out.csv", amplicons
  end

  # Report non-overlap primers only
  primers = primers.uniq!
    .chunk_while(reuse: true) { |pi, pj| pi.in?(pj) || pj.in?(pi) }
    .map(&.max_by &.size)
    .to_a
  Softepigen.write_bed "#{chr}-out.bed", chr, primers
end
