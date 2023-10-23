require "./spec_helper"

describe Softepigen do
  it "reports primers" do
    expected = File.read "#{__DIR__}/data/chr1777777-out.csv"
    `shards run --without-development softepigen -- #{__DIR__}/data/chr1777777.fasta`
    $?.success?.should be_true
    output = File.read "chr1777777-out.csv"
    output.should eq expected
  ensure
    File.delete "chr1777777-out.csv" if File.exists?("chr1777777-out.csv")
  end
end
