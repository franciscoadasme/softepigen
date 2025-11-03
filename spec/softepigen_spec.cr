require "./spec_helper"

describe Softepigen do
  it "reports primers" do
    basename = "chr1777777"

    `shards run --without-development softepigen -- #{__DIR__}/data/#{basename}.fasta`
    $?.success?.should be_true

    expected = File.read "#{__DIR__}/data/#{basename}-out.csv"
    File.read("#{basename}-out.csv").should eq expected
  ensure
    Dir.glob("#{basename}-out.*") do |path|
      File.delete path
    end
  end

  describe "#find_amplicons" do
    it "works on gzipped" do
      amplicons = Softepigen.find_amplicons "#{__DIR__}/data/chr1777777.fasta.gz"
      amplicons.size.should eq 50
    end
  end
end
