require "./spec_helper"

describe Softepigen::Region do
  describe "#new" do
    it "creates the amplicon from primers" do
      seq = Softepigen::Region.new "CGCCTGCAGGGCTGGAAGA"
      amplicon = Softepigen::Amplicon.new seq[3..4], seq[15..17]
      amplicon.to_s.should eq seq[3..17].to_s
      amplicon.downstream_primer.to_s.should eq seq[3..4].to_s
      amplicon.downstream_primer.start.should eq 3
      amplicon.downstream_primer.stop.should eq 4
      amplicon.upstream_primer.to_s.should eq seq[15..17].to_s
      amplicon.upstream_primer.start.should eq 15
      amplicon.upstream_primer.stop.should eq 17
    end
  end
end
