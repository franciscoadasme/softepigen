require "spec"
require "../src/softepigen"

def test_seq : Softepigen::Region
  str = File.read("#{__DIR__}/data/chr1777777.fasta").split("\n")[1]
  str.size.should eq 4162
  Softepigen::Region.new(str)
end
