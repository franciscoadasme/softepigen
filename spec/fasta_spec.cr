require "./spec_helper"

describe FASTA do
  it "reads a file" do
    FASTA.each("#{__DIR__}/data/apoeALL.fasta") do |header, seq|
      header = header.should_not be_nil
      header.name.should eq "chr19"
      range = header.range.should_not be_nil
      range.begin.should eq 45409053
      range.end.should eq 45412650
      seq.size.should eq range.size
    end
  end

  it "reads multiple entries" do
    count = 0
    FASTA.each("#{__DIR__}/data/chr21.fasta") do |header, seq|
      header = header.should_not be_nil
      header.name.should eq "chr21"
      range = header.range.should_not be_nil
      range.size.should eq seq.size
      count += 1
    end
    count.should eq 963
  end
end
