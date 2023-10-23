require "./spec_helper"

describe Softepigen::Region do
  describe "#new" do
    it "creates the amplicon from primers" do
      seq = Softepigen::Region.new "CGCCTGCAGGGCTGGAAGA"
      amplicon = Softepigen::Amplicon.new seq[3..4], seq[15..17]
      amplicon.to_s.should eq seq[3..17].to_s
      amplicon.forward_primer.to_s.should eq seq[3..4].to_s
      amplicon.forward_primer.start.should eq 3
      amplicon.forward_primer.stop.should eq 4
      amplicon.reverse_primer.to_s.should eq seq[15..17].to_s
      amplicon.reverse_primer.start.should eq 15
      amplicon.reverse_primer.stop.should eq 17
    end
  end
end
