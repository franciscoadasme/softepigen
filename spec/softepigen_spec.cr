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
end
