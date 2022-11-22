require "./spec_helper"

describe Softepigen::Region do
  describe "#[]" do
    it "returns a subregion" do
      str = "CGCCTGCAGGGCTGGAAGA"
      region = seq(str)
      region[..].should eq Softepigen::Region.new(str.to_slice, 0)
      region[3..].should eq Softepigen::Region.new(str[3..].to_slice, 3)
      region[..-5].should eq Softepigen::Region.new(str[..14].to_slice, 0)
      region[-3..].should eq Softepigen::Region.new(str[16..].to_slice, 16)
      region[-5..-3].should eq Softepigen::Region.new(str[-5..-3].to_slice, 14)
    end
  end

  describe "#complexity" do
    it "returns the positions with linguistic complexity" do
      test_seq.split_by_cpg
        .select!(&.size.>(15 + 2))
        .map { |r| {r.start, r.start + r.size - 1, r.complexity(k: 4)} }
        .zip([
          {0, 48, [34, 44]},
          {49, 135, [17, 18, 19, 20, 21, 22, 43, 48, 49, 50, 51, 59, 81, 82]},
          {136, 280, [42, 43, 83, 84, 85, 86, 106, 107, 108, 126, 127, 128]},
          {281, 331, [23, 24, 25, 28]},
          {332, 379, [6, 7, 8, 9, 10, 11, 12, 23, 32, 33, 34, 35]},
          {380, 521, [12, 32, 36, 38, 39, 48, 49, 51, 52, 60, 62, 63, 75, 76, 87, 88, 105, 109, 110, 118, 119, 136, 138]},
          {522, 582, [6, 34, 35, 48, 49]},
          {583, 616, [12, 13, 14, 29, 30]},
          {629, 789, [44, 49, 50, 54, 55, 88, 89, 90, 91, 104, 120, 121, 122, 131, 134, 140, 141, 142, 143, 144, 148, 149]},
          {790, 812, [6, 7, 8, 9, 19]},
          {849, 869, [10]},
          {870, 890, [3, 14, 15, 16, 17]},
          {891, 915, [3, 4]},
          {923, 978, [6, 23, 24, 25, 26, 31, 32, 33, 34, 36, 37, 38, 39, 40, 51, 52]},
          {983, 1003, [2]},
          {1004, 1028, [5, 6]},
          {1029, 1059, [21]},
          {1096, 1148, [6, 7, 12, 28, 29, 33, 35, 36, 37]},
          {1158, 1178, [7]},
          {1179, 1243, [6, 7, 18, 19, 24, 44, 45, 47, 48, 49]},
          {1244, 1338, [16, 36, 37, 42, 48, 49, 54, 74, 75, 77, 78, 79]},
          {1339, 1359, [16]},
          {1360, 1418, [15, 16, 21, 27, 28, 33, 50, 51, 55]},
          {1435, 1514, [16, 36, 37, 42, 48, 49, 54, 71, 72, 76]},
          {1531, 1560, [16]},
          {1561, 1603, [6, 7, 12, 13, 18, 34, 35, 39]},
          {1604, 1631, [23, 24]},
          {1632, 1667, [21]},
          {1668, 1686, [15]},
          {1687, 1730, [7, 8, 16, 24, 25]},
          {1741, 1763, [10, 15]},
          {1793, 1829, [8, 10, 14, 15, 16, 17, 18, 19, 21, 22]},
          {1830, 1863, [11, 12, 13, 15, 16, 26, 27]},
          {1868, 1887, [5, 6, 7]},
          {1888, 1909, [3, 4, 5, 6, 12, 13]},
          {1910, 1973, [3, 4, 6, 16, 20, 21, 35, 36, 37, 38, 39, 40, 45, 49, 50, 51]},
          {1981, 1999, [] of Int32},
          {2000, 2019, [12]},
          {2063, 2124, [5, 6, 21, 23, 24, 57, 58]},
          {2135, 2155, [2, 7, 11, 16, 17]},
          {2161, 2179, [7, 8, 12, 13]},
          {2193, 2223, [2, 3, 7]},
          {2236, 2284, [6, 7, 11, 12, 13, 21, 22, 23, 24, 25, 26, 36, 37]},
          {2285, 2388, [2, 12, 21, 22, 38, 46, 51, 61, 66, 96, 100]},
          {2389, 2465, [12, 17, 18, 31, 63, 70, 71]},
          {2466, 2487, [] of Int32},
          {2497, 2548, [4, 5, 33, 44, 45]},
          {2549, 2596, [4, 41]},
          {2597, 2627, [8, 9, 10, 11, 16, 17, 25]},
          {2654, 2695, [4, 5, 18, 19, 20, 22, 23]},
          {2696, 2714, [] of Int32},
          {2715, 2783, [2, 11, 12, 21, 43]},
          {2807, 2830, [3, 4, 16]},
          {2831, 2854, [13]},
          {2855, 2903, [12, 13, 17, 18, 24, 25, 42, 43, 44, 45]},
          {2913, 2944, [8, 9, 10, 14, 15, 21, 22, 23, 28]},
          {2945, 2970, [] of Int32},
          {2974, 3023, [15, 20, 28]},
          {3024, 3043, [] of Int32},
          {3050, 3074, [3, 4, 10, 14, 15, 16, 17]},
          {3081, 3111, [2, 11, 13, 20, 21, 25]},
          {3112, 3151, [9, 10, 16, 17]},
          {3158, 3183, [3]},
          {3189, 3210, [16]},
          {3211, 3236, [2, 21, 22]},
          {3237, 3281, [] of Int32},
          {3297, 3336, [3, 4, 8, 13, 24, 25]},
          {3337, 3363, [3, 4, 17]},
          {3364, 3411, [32]},
          {3412, 3505, [4, 5, 6, 13, 27, 28, 37, 49, 65, 80, 84, 88, 89, 90]},
          {3522, 3541, [2]},
          {3555, 3636, [31, 32, 33, 57]},
          {3687, 3708, [5]},
          {3709, 3758, [2, 7, 8, 9, 11, 22, 23, 24]},
          {3759, 3787, [6]},
          {3801, 3839, [21, 23, 24, 25]},
          {3840, 3897, [14, 15, 17, 18, 19, 20, 24, 26, 27, 32, 33, 41, 42, 43]},
          {3914, 3931, [5]},
          {3945, 4072, [30, 31, 32, 81, 82, 96, 106, 107, 108, 118, 123, 124]},
          {4078, 4115, [7]},
          {4123, 4140, [2, 12]},
          {4141, 4161, [] of Int32},
        ]) do |actual, expected|
          actual.should eq expected
        end
    end

    it "works with k=5" do
      seq("CGTATTTTAAAGAGAAAATATTTTAAATTTTTATATTAGTTATTTTTATGG")
        .complexity(k: 5).should be_empty
      seq("CGATTTTTAATATTTTAATGTAGTATTTTTTAATTTTTTTTGGGTATTTATGTATAAATTGTAATAAA\
           ATTGGGTTTTTATTGTATA").complexity(k: 5).should be_empty
      seq("CGTTGTTTGTTGGTTTTTAAATAAAATTGGGTTTTTATTATATATGTTGTTTGTTGGTTTTTTAAATT\
           ATTTTGTGTTTTTTTATAGTATTAAAGTTTTTTAAAAATATGATTTTAAATTATAATTTAGTATTTTG\
           AATATAATA").complexity(k: 5).should be_empty
      seq("CGTTTTATTATTTTTTTGTTTGGGAGTATATGGATTGTTTTTAATTTTGTT")
        .complexity(k: 5).should eq [23]
      seq("CGATTATATGTAGTATTGAAATGGATATTTTGGTAGATAAATTTTTGA")
        .complexity(k: 5).should eq [32, 34]
      seq("CGATTGTTTTAGGATAAGTTTTTAAAAGGGAAATGAAGTGTATTTTTTTAGTGTATTTTTTGAGATAT\
           TTTTTTTATAGTTAGGTTTATAGTTATTTAAAGTTGTTAGTTGTAGGTTTTATGTTTGTTGTTTTTAA\
           AGTGTA").complexity(k: 5).should eq [61, 62]
      seq("CGTATAAGTGTTTATTATATAAATTTTGTTGGAGGTAGTTGTGTTTTGGTAGTTTAATTTG")
        .complexity(k: 5).should be_empty
      seq("CGGATTTTTAATTAGATGGTTTTAATAAGGTAGA").complexity(k: 5).should eq [13, 29]
      seq("CGTAAAAAAATAAATAAATAAAATAAAATAAAGGGTTTTTTTTTTGTAAATAGTTGTATTTATTTAAA\
           AGAAGGTTTTTATTTTTTTAATAGTATTTGTGGGTTTAGAAGTTGGTAAAGTTAGTATTGGTTTGAGA\
           GTTTTGAGTGATTAGTGGTTGGGGT").complexity(k: 5).should eq [141, 142]
      seq("CGGTTATATGATATTTTTTTAGT").complexity(k: 5).should be_empty
      seq("CGGGTTTTGGGAGTTTATTTT").complexity(k: 5).should be_empty
      seq("CGTATAGGTTAGGAAGTAGTG").complexity(k: 5).should be_empty
      seq("CGTATAGTTATTATTTTAGGAGAAT").complexity(k: 5).should be_empty
      seq("CGATTTTGATTTTTTAAAATTTTTAGTAGTTATAGTATAGTGAGAAAAATAATAGT")
        .complexity(k: 5).should eq [38, 39]
      seq("CGTAGTTGTTTGTTTTTAATA").complexity(k: 5).should be_empty
      seq("CGTATTAGATTTTGAAAAATATATT").complexity(k: 5).should be_empty
      seq("CGGAGGTAAAATAATTTGTTTTAGAGAAGTT").complexity(k: 5).should be_empty
      seq("CGGGGGGATAGGGATAAGGTAATTATTTTAGTAAGTGTAGTTTTTTTTTTTTA")
        .complexity(k: 5).should eq [6]
      seq("CGAGGGTTAGTTTATTTATTG").complexity(k: 5).should be_empty
      seq("CGGAGGGATAGGAATAAGGATAGGGATAAGGTAATTATTTTATTTAGTGTAGTTTTTTTTTTTTA")
        .complexity(k: 5).should eq [6, 18]
      seq("CGTTTTTTTTTAGGGTTAGTTTATTTATTGTGGAGGGATAGGGATAAGGATAGGGATAAGGTAATTAT\
           TTTATTTAGTGTAGTTTTTTTTTTTTA").complexity(k: 5).should eq [36, 48]
      seq("CGTTTTTTTTTAGGGTTAGTT").complexity(k: 5).should be_empty
      seq("CGTTTATTGTGGAGGGATAGGGATAAGGATAGGGATAAGGTAATTATTTTTAGTAAGTG")
        .complexity(k: 5).should eq [15, 27]
      seq("CGTTTTTTTTTAGGGTTAGTTTATTTATTGTGGAGGGATAGGGATAAGGATAGGGATAAGGTAATTAT\
           TTTTAGTAAGTG").complexity(k: 5).should eq [36, 48]
      seq("CGTTTTTTTTTAGGGTTAGTTTATTTATTG").complexity(k: 5).should be_empty
      seq("CGGAGGGATAGGGATAGGGATAAGGTAATTATTTTAGTAAGTG")
        .complexity(k: 5).should eq [6, 12]
      seq("CGGTTTTTTTTTTTTTTAGGGTTGTGAT").complexity(k: 5).should be_empty
      seq("CGTTTTTTATTTTATATTTTGGTATTTTTATTTTTT").complexity(k: 5).should be_empty
      seq("CGATTTTGTTTTAGGGATA").complexity(k: 5).should be_empty
      seq("CGTTTATTGATATAATTGAGGTTTTAGATTTTTAGGGTGTGGTA")
        .complexity(k: 5).should be_empty
      seq("CGTTTTTATTTAGTTATAGGGTT").complexity(k: 5).should be_empty
      seq("CGAGTTTTTGAGATTAGTAGATATGTTTGGTTGGGGA")
        .complexity(k: 5).should eq [9, 16, 18]
      seq("CGTATTTTTAAGAGTATAGTTATATTGTGATTTT").complexity(k: 5).should eq [11]
      seq("CGATTGTGATAAAGGGGGTT").complexity(k: 5).should be_empty
      seq("CGGGTATGAGGGTGTAGGTGTT").complexity(k: 5).should eq [5]
      seq("CGGGTGAGATTATTTTTATGGTGAGAATAAAGGAAATGATGTAGGGTGAATAGTGGGAAGGAGG")
        .complexity(k: 5).should eq [3, 5, 20]
      seq("CGGAGGGGTTGGGGGAAGT").complexity(k: 5).should be_empty
      seq("CGTTGTGTTTAGGATATTTA").complexity(k: 5).should be_empty
      seq("CGGTTATAGAGAGAGGGTTTAAGTGTATTTTTTATATTAGGGGTGGTTGGTGTTTTTTGAGT")
        .complexity(k: 5).should eq [5]
      seq("CGATGTTTAGAATGAAATGTA").complexity(k: 5).should be_empty
      seq("CGGTTAAGAGTGGTAGAAT").complexity(k: 5).should eq [7, 12]
      seq("CGTAGATTGAGGAGGGGTAATAAATGGTGGT").complexity(k: 5).should be_empty
      seq("CGTTTGGATAGGTATGTTTGTTATGTAGTGTTATTTTAGTAATATATAA")
        .complexity(k: 5).should eq [6]
      seq("CGGATAAAAATGGTATTTGGTTGATAAAATTTTAATTTTGATTTTAATGTTTAGAATTATTTAGTTTG\
           ATTTTTTATTTGTGGTGGAAAGGTTAAAAGATTAGA").complexity(k: 5).should be_empty
      seq("CGAGGGAGGTAAATAGGAGATATAAGAGGTAAGTAAAATTTATTTTTTTTTTTTTTTAGGTGTTAGAG\
           GAAGTATTT").complexity(k: 5).should eq [16, 17]
      seq("CGTGGAGAGGGTTTGGAGGTTT").complexity(k: 5).should be_empty
      seq("CGTTTGTAGGGTTGGAAGAGAGGTTTTATTTTAAGTGTTAAATTTGAGTTGG")
        .complexity(k: 5).should be_empty
      seq("CGTTTAGAGGGTTGGGTTGAAAAGGGGTTGGAGGTTGTTTTTAGTTTT")
        .complexity(k: 5).should be_empty
      seq("CGTAGGAAAGTATGTTGTGATTTGTTAGTTA").complexity(k: 5).should be_empty
      seq("CGGTTGTATATTTGTTGTTGTAGAGTGTGTTATTTTATTGGG")
        .complexity(k: 5).should eq [19, 22]
      seq("CGTTGTGTTTAGGTTAGGG").complexity(k: 5).should be_empty
      seq("CGATAGGGAGGAGATGGGGTTTAGAGGAGGGAAAAGAAGTTGGGATAAATATAAAAGAATATTTGTTAT")
        .complexity(k: 5).should eq [10, 11]
      seq("CGAAGATATTGTGTGGGAGTTTTT").complexity(k: 5).should eq [3]
      seq("CGTTTAATATAAGGTATTAATATT").complexity(k: 5).should be_empty
      seq("CGAGGGGATTTTTAGTAATAGTTTTGATATTTGTTTTGTTATTATGATA")
        .complexity(k: 5).should be_empty
      seq("CGAGGAGGGTAGTAAGATAAGGTGAGTTTAGA").complexity(k: 5).should eq [14, 21]
      seq("CGTTAATATTTTTTTTATTTGTTAGG").complexity(k: 5).should be_empty
      seq("CGTTGGGAGGATTAAAGATTTAGAGAGGGAGTTTTAAAGGTTTGTTTAAA")
        .complexity(k: 5).should be_empty
      seq("CGTTTAAAGAATTATTTATT").complexity(k: 5).should be_empty
      seq("CGTTGTAGGTTGATTATGTATTAAG").complexity(k: 5).should be_empty
      seq("CGAGTGGATTTTAGAGTTGAAGTAGGAGTTT").complexity(k: 5).should be_empty
      seq("CGGGGAAATTAGTGTTTGATAAATTTTTTTTAAATTTTAT").complexity(k: 5).should be_empty
      seq("CGGGTATTTTGTTAGGTTTGTTTGTT").complexity(k: 5).should be_empty
      seq("CGGTTTTTTTTTTTTTTAGTTT").complexity(k: 5).should be_empty
      seq("CGATGTTTTTTTTTTTTTGTTTAGAT").complexity(k: 5).should be_empty
      seq("CGTGGTAAATTTTTTTTATTTGTTTTGGAATTTGTTGGGGTTTTT")
        .complexity(k: 5).should be_empty
      seq("CGTATAGTTAGAGAGATTATTTTTATAGTTTAGGTTAGGT").complexity(k: 5).should eq [12]
      seq("CGTGTGATTTTTTTGTTTAGAAATTTT").complexity(k: 5).should be_empty
      seq("CGGTGGTTTTTTATTATTAAGGAAATAAGTTTTAGTTGTTTTTAAGGT")
        .complexity(k: 5).should be_empty
      seq("CGTTTATGATTTGGTATAAATTATTTTTGTATTTTGTTAGTTATTTTTTTGTAAAATTGGTGTTTTAG\
           TTATTAGGATTTTGAGGTATTGTAGT").complexity(k: 5).should be_empty
      seq("CGGTATTTTTTTATTTGGAA").complexity(k: 5).should be_empty
      seq("CGTTGTTTATTTTTTTTATTTGGGGGTGGTTTAGTATTATTTTTTTTGGGAATTTTTTAGTTTTTTTT\
           ATTAGGTTTTTATT").complexity(k: 5).should be_empty
      seq("CGGGGGTATTTATTTGTTATTT").complexity(k: 5).should be_empty
      seq("CGATGTTTAGATATGGTGGGTTTAGTATTTTTTTAGGGGATTAATTTAAT")
        .complexity(k: 5).should eq [8]
      seq("CGTTAAGAGTTTGTTATTTATTGGAATTA").complexity(k: 5).should be_empty
      seq("CGTATTAATAATTTTTTTTTTTGAGATAGGGTTTTGTTT").complexity(k: 5)
        .should eq [22, 23, 24]
      seq("CGTTGTTTAGGTTGGAGTGTAGTGGTATAGTTATAGTTTATTGTAGTTTTTAATTTTT")
        .complexity(k: 5).should eq [14]
      seq("CGTATTAGTTTTTTAAGT").complexity(k: 5).should be_empty
      seq("CGTTTGGTTAATTTTTTAATTTTTTGGTAAAGATAGGGTTTTGTTTTGTTGTTTAGGTTGGTTTTAAA\
           TTTTTGGGTTTAAATGATTTTTTTGTTTTAGTTTTTTAAGTAGTTGGGATTATGGGAGTA")
        .complexity(k: 5).should eq [30, 31, 123]
      seq("CGATATTTAGTTTGTTAATAAAATTTTATTTTAAAAAT").complexity(k: 5).should be_empty
      seq("CGGTATAAGGTTTAGTTT").complexity(k: 5).should be_empty
      seq("CGTTGGTTTTTTTAATTTGTT").complexity(k: 5).should be_empty
    end
  end

  describe "#forward" do
    it "returns primers downstream" do
      test_seq[0..48].forward.should be_empty
      test_seq[49..135].forward.should be_empty
      test_seq[136..280].forward.map { |r| {r.start, r.size} }.should eq [
        {136, 57}, {136, 58}, {136, 98}, {136, 99}, {136, 100}, {136, 101},
        {136, 121}, {136, 122}, {136, 123}, {136, 141}, {136, 142}, {136, 143},
      ]
      test_seq[281..331].forward.should be_empty
      test_seq[332..379].forward.should be_empty
      test_seq[380..521].forward.should be_empty
      test_seq[522..582].forward.should be_empty
      test_seq[583..616].forward.should be_empty
      test_seq[629..789].forward.map { |r| {r.start, r.size} }.should eq [
        {629, 59}, {629, 64}, {629, 65}, {629, 69}, {629, 70}, {629, 103},
        {629, 104}, {629, 105}, {629, 106}, {629, 119}, {629, 135}, {629, 136},
        {629, 137}, {629, 146}, {629, 149}, {629, 155}, {629, 156}, {629, 157},
        {629, 158}, {629, 159},
      ]
      test_seq[790..812].forward.should be_empty
      test_seq[849..869].forward.should be_empty
      test_seq[870..890].forward.should be_empty
      test_seq[891..915].forward.map { |r| {r.start, r.size} }.should eq [
        {891, 18}, {891, 19},
      ]
      test_seq[923..978].forward.should be_empty
      test_seq[983..1003].forward.map { |r| {r.start, r.size} }.should eq [
        {983, 17},
      ]
      test_seq[1004..1028].forward.should be_empty
      test_seq[1029..1059].forward.should be_empty
      test_seq[1096..1148].forward.should be_empty
      test_seq[1158..1178].forward.should be_empty
      test_seq[1179..1243].forward.should be_empty
      test_seq[1244..1338].forward.map { |r| {r.start, r.size} }.should eq [
        {1244, 31}, {1244, 51}, {1244, 52}, {1244, 57}, {1244, 63}, {1244, 64},
        {1244, 69}, {1244, 89}, {1244, 90}, {1244, 92}, {1244, 93}, {1244, 94},
      ]
      test_seq[1339..1359].forward.should be_empty
      test_seq[1360..1418].forward.should be_empty
      test_seq[1435..1514].forward.map { |r| {r.start, r.size} }.should eq [
        {1435, 31}, {1435, 51}, {1435, 52}, {1435, 57}, {1435, 63}, {1435, 64},
        {1435, 69},
      ]
      test_seq[1531..1560].forward.should be_empty # original code reported one
      test_seq[1561..1603].forward.should be_empty
      test_seq[1604..1631].forward.should be_empty
      test_seq[1632..1667].forward.map { |r| {r.start, r.size} }.should eq [
        {1632, 36},
      ]
      test_seq[1668..1686].forward.should be_empty
      test_seq[1687..1730].forward.should be_empty
      test_seq[1741..1763].forward.should be_empty
      test_seq[1793..1829].forward.should be_empty
      test_seq[1830..1863].forward.map { |r| {r.start, r.size} }.should eq [
        {1830, 26}, {1830, 27}, {1830, 28}, {1830, 30}, {1830, 31},
      ]
      test_seq[1868..1887].forward.should be_empty
      test_seq[1888..1909].forward.should be_empty
      test_seq[1910..1973].forward.should be_empty
      test_seq[1981..1999].forward.should be_empty
      test_seq[2000..2019].forward.should be_empty
      test_seq[2063..2124].forward.should be_empty
      test_seq[2135..2155].forward.should be_empty
      test_seq[2161..2179].forward.should be_empty
      test_seq[2193..2223].forward.should be_empty
      test_seq[2236..2284].forward.should be_empty
      test_seq[2285..2388].forward.should be_empty
      test_seq[2389..2465].forward.should be_empty
      test_seq[2466..2487].forward.should be_empty
      test_seq[2497..2548].forward.map { |r| {r.start, r.size} }.should eq [
        {2497, 19}, {2497, 20}, {2497, 48},
      ]
      test_seq[2549..2596].forward.map { |r| {r.start, r.size} }.should eq [
        {2549, 19},
      ]
      test_seq[2597..2627].forward.should be_empty
      test_seq[2654..2695].forward.should be_empty
      test_seq[2696..2714].forward.should be_empty
      test_seq[2715..2783].forward.should be_empty
      test_seq[2807..2830].forward.should be_empty
      test_seq[2831..2854].forward.should be_empty
      test_seq[2855..2903].forward.should be_empty
      test_seq[2913..2944].forward.should be_empty
      test_seq[2945..2970].forward.should be_empty
      test_seq[2974..3023].forward.map { |r| {r.start, r.size} }.should eq [
        {2974, 30}, {2974, 35}, {2974, 43},
      ]
      test_seq[3024..3043].forward.should be_empty
      test_seq[3050..3074].forward.should be_empty
      test_seq[3081..3111].forward.should be_empty
      test_seq[3112..3151].forward.should be_empty
      test_seq[3158..3183].forward.should be_empty
      test_seq[3189..3210].forward.should be_empty
      test_seq[3211..3236].forward.should be_empty
      test_seq[3237..3281].forward.should be_empty
      test_seq[3297..3336].forward.should be_empty
      test_seq[3337..3363].forward.should be_empty
      test_seq[3364..3411].forward.should be_empty
      test_seq[3412..3505].forward.should be_empty
      test_seq[3522..3541].forward.should be_empty
      test_seq[3555..3636].forward.map { |r| {r.start, r.size} }.should eq [
        {3555, 46}, {3555, 47}, {3555, 48}, {3555, 72},
      ]
      test_seq[3687..3708].forward.should be_empty
      test_seq[3709..3758].forward.should be_empty
      test_seq[3759..3787].forward.should be_empty
      test_seq[3801..3839].forward.map { |r| {r.start, r.size} }.should eq [
        {3801, 36}, {3801, 38}, {3801, 39}, # original code reported duplicates
      ]
      test_seq[3840..3897].forward.should be_empty
      test_seq[3914..3931].forward.should be_empty
      test_seq[3945..4072].forward.map { |r| {r.start, r.size} }.should eq [
        {3945, 45}, {3945, 46}, {3945, 47}, {3945, 96}, {3945, 97}, {3945, 111},
        {3945, 121}, {3945, 122}, {3945, 123},
      ]
      test_seq[4078..4115].forward.should be_empty
      test_seq[4123..4140].forward.should be_empty
      test_seq[4141..4161].forward.should be_empty
    end
  end

  describe "#reverse" do
    it "returns primers upstream" do
      test_seq[0..48].reverse.should be_empty
      test_seq[49..135].reverse.map { |r| {r.start, r.size} }.should eq [
        {59, 79}, {87, 51}, {88, 50},
      ]
      test_seq[136..280].reverse.map { |r| {r.start, r.size} }.should eq [
        {233, 50},
      ]
      test_seq[281..331].reverse.map { |r| {r.start, r.size} }.should eq [
        {295, 39},
      ]
      test_seq[332..379].reverse.should be_empty
      test_seq[380..521].reverse.map { |r| {r.start, r.size} }.should eq [
        {401, 123}, {420, 104}, {474, 50}, {488, 36},
      ]
      test_seq[522..582].reverse.map { |r| {r.start, r.size} }.should eq [
        {560, 25},
      ]
      test_seq[583..616].reverse.should be_empty
      test_seq[629..789].reverse.map { |r| {r.start, r.size} }.should eq [
        {667, 125}, {706, 86}, {739, 53}, {749, 43}, {752, 40}, {758, 34}, {766, 26}, {767, 25},
      ]
      test_seq[790..812].reverse.should be_empty
      test_seq[849..869].reverse.should be_empty
      test_seq[870..890].reverse.map { |r| {r.start, r.size} }.should eq [
        {874, 19},
      ]
      test_seq[891..915].reverse.should be_empty
      test_seq[923..978].reverse.map { |r| {r.start, r.size} }.should eq [
        {936, 45}, {937, 44}, {944, 37}, {946, 35}, {949, 32}, {952, 29},
      ]
      test_seq[983..1003].reverse.should be_empty
      test_seq[1004..1028].reverse.should be_empty
      test_seq[1029..1059].reverse.should be_empty
      test_seq[1096..1148].reverse.map { |r| {r.start, r.size} }.should eq [
        {1118, 33}, {1121, 30}, {1122, 29},
      ]
      test_seq[1158..1178].reverse.should be_empty
      test_seq[1179..1243].reverse.map { |r| {r.start, r.size} }.should eq [
        {1187, 59}, {1213, 33}, {1216, 30}, {1217, 29},
      ]
      test_seq[1244..1338].reverse.map { |r| {r.start, r.size} }.should eq [
        {1269, 72}, {1282, 59}, {1308, 33}, {1311, 30}, {1312, 29},
      ]
      test_seq[1339..1359].reverse.should be_empty
      test_seq[1360..1418].reverse.map { |r| {r.start, r.size} }.should eq [
        {1364, 57}, {1377, 44}, {1400, 21}, {1404, 17},
      ]
      test_seq[1435..1514].reverse.map { |r| {r.start, r.size} }.should eq [
        {1460, 57}, {1473, 44}, {1496, 21}, {1500, 17},
      ]
      test_seq[1531..1560].reverse.should be_empty
      test_seq[1561..1603].reverse.map { |r| {r.start, r.size} }.should eq [
        {1589, 17},
      ]
      test_seq[1604..1631].reverse.map { |r| {r.start, r.size} }.should eq [
        {1616, 18},
      ]
      test_seq[1632..1667].reverse.map { |r| {r.start, r.size} }.should eq [
        {1642, 28},
      ]
      test_seq[1668..1686].reverse.map { |r| {r.start, r.size} }.should eq [
        {1672, 17},
      ]
      test_seq[1687..1730].reverse.should be_empty
      test_seq[1741..1763].reverse.should be_empty
      test_seq[1793..1829].reverse.map { |r| {r.start, r.size} }.should eq [
        {1797, 35}, {1799, 33}, {1800, 32},
      ]
      test_seq[1830..1863].reverse.map { |r| {r.start, r.size} }.should eq [
        {1832, 34}, {1846, 20},
      ]
      test_seq[1868..1887].reverse.should be_empty
      test_seq[1888..1909].reverse.should be_empty
      test_seq[1910..1973].reverse.map { |r| {r.start, r.size} }.should eq [
        {1919, 57},
      ]
      test_seq[1981..1999].reverse.should be_empty
      test_seq[2000..2019].reverse.should be_empty
      test_seq[2063..2124].reverse.map { |r| {r.start, r.size} }.should eq [
        {2109, 18},
      ]
      test_seq[2135..2155].reverse.map { |r| {r.start, r.size} }.should eq [
        {2140, 18},
      ]
      test_seq[2161..2179].reverse.should be_empty
      test_seq[2193..2223].reverse.should be_empty
      test_seq[2236..2284].reverse.map { |r| {r.start, r.size} }.should eq [
        {2261, 26},
      ]
      test_seq[2285..2388].reverse.map { |r| {r.start, r.size} }.should eq [
        {2320, 71}, {2335, 56},
      ]
      test_seq[2389..2465].reverse.map { |r| {r.start, r.size} }.should eq [
        {2409, 59}, {2441, 27},
      ]
      test_seq[2466..2487].reverse.should be_empty
      test_seq[2497..2548].reverse.should be_empty
      test_seq[2549..2596].reverse.should be_empty
      test_seq[2597..2627].reverse.map { |r| {r.start, r.size} }.should eq [
        {2611, 19},
      ]
      test_seq[2654..2695].reverse.map { |r| {r.start, r.size} }.should eq [
        {2662, 36},
      ]
      test_seq[2696..2714].reverse.should be_empty
      test_seq[2715..2783].reverse.should be_empty
      test_seq[2807..2830].reverse.should be_empty
      test_seq[2831..2854].reverse.should be_empty
      test_seq[2855..2903].reverse.map { |r| {r.start, r.size} }.should eq [
        {2888, 18},
      ]
      test_seq[2913..2944].reverse.map { |r| {r.start, r.size} }.should eq [
        {2925, 22},
      ]
      test_seq[2945..2970].reverse.should be_empty
      test_seq[2974..3023].reverse.should be_empty
      test_seq[3024..3043].reverse.should be_empty
      test_seq[3050..3074].reverse.map { |r| {r.start, r.size} }.should eq [
        {3055, 22},
      ]
      test_seq[3081..3111].reverse.map { |r| {r.start, r.size} }.should eq [
        {3091, 23},
      ]
      test_seq[3112..3151].reverse.should be_empty
      test_seq[3158..3183].reverse.should be_empty
      test_seq[3189..3210].reverse.map { |r| {r.start, r.size} }.should eq [
        {3194, 19},
      ]
      test_seq[3211..3236].reverse.map { |r| {r.start, r.size} }.should eq [
        {3221, 18}, {3222, 17},
      ]
      test_seq[3237..3281].reverse.should be_empty
      test_seq[3297..3336].reverse.should be_empty
      test_seq[3337..3363].reverse.should be_empty
      test_seq[3364..3411].reverse.should be_empty
      test_seq[3412..3505].reverse.map { |r| {r.start, r.size} }.should eq [
        {3428, 80}, {3481, 27}, {3489, 19}, {3490, 18},
      ]
      test_seq[3522..3541].reverse.should be_empty
      test_seq[3555..3636].reverse.should be_empty
      test_seq[3687..3708].reverse.should be_empty
      test_seq[3709..3758].reverse.map { |r| {r.start, r.size} }.should eq [
        {3720, 41},
      ]
      test_seq[3759..3787].reverse.should be_empty
      test_seq[3801..3839].reverse.should be_empty
      test_seq[3840..3897].reverse.map { |r| {r.start, r.size} }.should eq [
        {3846, 54}, {3847, 53}, {3871, 29},
      ]
      test_seq[3914..3931].reverse.should be_empty
      test_seq[3945..4072].reverse.map { |r| {r.start, r.size} }.should eq [
        {4015, 60}, {4016, 59}, {4041, 34},
      ]
      test_seq[4078..4115].reverse.should be_empty
      test_seq[4123..4140].reverse.should be_empty
      test_seq[4141..4161].reverse.should be_empty
    end
  end

  describe "#size" do
    it "to_s" do
      test_seq.split_by_cpg
        .select!(&.size.>(17))
        .map { |r| {r.to_s, r.start, r.start + r.size - 1} }
        .zip([
          {"TATCCTAAAGAGAAAACACCTTAAATTCTCACATCAGCCACCCCCATGG", 0, 48},
          {"CGACTCTTAACACCTTAATGTAGCACCTTCCAACTTTTCCTGGGCATTTATGTACAAATTGTAATAAAATTGGGTTCTTACTGCATA", 49, 135},
          {"CGCTGCTTGCTGGTTTCTAAATAAAATTGGGTTCTTACTATATATGCTGCTTGCTGGTTTTTTAAACCACCTTGTGCTTTCCCACAGTATTAAAGTTCTTTAAAAATATGATTTTAAACTATAACTTAGTATTCTGAATACAATA", 136, 280},
          {"CGTTTTACCATCTTCCTGTTTGGGAGCACATGGATTGTTTCCAATTTTGCT", 281, 331},
          {"CGATTATATGCAGCACTGAAATGGACATCCTGGCAGATAAATCTCTGA", 332, 379},
          {"CGACTGCCTTAGGATAAGTTCCCAAAAGGGAAATGAAGTGCATTTTTTCAGTGTATTTTTTGAGATACCTTTTCCATAGTCAGGTTCACAGCCACTCAAAGCTGTCAGCTGCAGGCCTCATGCTTGCTGTCTCCAAAGTGCA", 380, 521},
          {"CGTACAAGTGTCCACTACACAAATTCTGCTGGAGGCAGCTGTGTCTTGGTAGCCTAATCTG", 522, 582},
          {"CGGATCTCCAATTAGATGGTTTCAATAAGGCAGA", 583, 616},
          {"CGCAAAAAAATAAATAAATAAAATAAAATAAAGGGCCTCTTCTTTGCAAACAGTTGCATCTACTTAAAAGAAGGCTTCTATCTCCTTAACAGCATTTGTGGGCTCAGAAGCTGGTAAAGCCAGCACTGGCTTGAGAGCCCTGAGTGACCAGTGGCTGGGGC", 629, 789},
          {"CGGTCACATGACACCCCTCCAGC", 790, 812},
          {"CGGGCCTTGGGAGCTCATCCC", 849, 869},
          {"CGTACAGGCTAGGAAGCAGTG", 870, 890},
          {"CGCATAGTCATCACTCCAGGAGAAC", 891, 915},
          {"CGACCCTGACCTTCCAAAACTCTCAGCAGCCACAGCACAGTGAGAAAAACAACAGC", 923, 978},
          {"CGCAGCTGTCTGTCTCTAACA", 983, 1003},
          {"CGTATCAGACTTTGAAAAACATATC", 1004, 1028},
          {"CGGAGGCAAAACAACCTGCCTCAGAGAAGCC", 1029, 1059},
          {"CGGGGGGACAGGGACAAGGCAACCACCCCAGCAAGTGCAGCTCCTTCTCCCCA", 1096, 1148},
          {"CGAGGGCCAGCCCATCCACTG", 1158, 1178},
          {"CGGAGGGACAGGAACAAGGACAGGGACAAGGCAACCACCCCACCCAGTGCAGCTCCTTCTCCCCA", 1179, 1243},
          {"CGCCTTCCCCCAGGGCCAGCCCATCCACTGTGGAGGGACAGGGACAAGGACAGGGACAAGGCAACCACCCCACCCAGTGCAGCTCCTTCTCCCCA", 1244, 1338},
          {"CGCCTTCCCCCAGGGCCAGCC", 1339, 1359},
          {"CGTCCACTGTGGAGGGACAGGGACAAGGACAGGGACAAGGCAACCACCCCCAGCAAGTG", 1360, 1418},
          {"CGCCTTCCCCCAGGGCCAGCCCATCCACTGTGGAGGGACAGGGACAAGGACAGGGACAAGGCAACCACCCCCAGCAAGTG", 1435, 1514},
          {"CGCCTTCCCCCAGGGCCAGCCCATCCACTG", 1531, 1560},
          {"CGGAGGGACAGGGACAGGGACAAGGCAACCACCCCAGCAAGTG", 1561, 1603},
          {"CGGCTCCTCCTTCTTCCAGGGCTGTGAT", 1604, 1631},
          {"CGCTCCCCACCTTACACCCTGGCATTTTCACCTCTT", 1632, 1667},
          {"CGATCTTGTTTCAGGGACA", 1668, 1686},
          {"CGTTCACTGATATAACTGAGGCTTCAGACTCCTAGGGTGTGGCA", 1687, 1730},
          {"CGCTTTCATCCAGCCACAGGGTC", 1741, 1763},
          {"CGAGCTCCTGAGACCAGCAGATATGCTTGGCTGGGGA", 1793, 1829},
          {"CGCATTCCCAAGAGCACAGCCACACTGTGACCCC", 1830, 1863},
          {"CGACTGTGACAAAGGGGGCC", 1868, 1887},
          {"CGGGTATGAGGGTGCAGGTGTC", 1888, 1909},
          {"CGGGTGAGACTATCTCTATGGTGAGAATAAAGGAAATGATGCAGGGTGAACAGTGGGAAGGAGG", 1910, 1973},
          {"CGGAGGGGCTGGGGGAAGT", 1981, 1999},
          {"CGCTGTGCCTAGGACACCCA", 2000, 2019},
          {"CGGCCACAGAGAGAGGGCTCAAGTGCATTTTCCACACCAGGGGTGGCTGGTGCCCTCTGAGC", 2063, 2124},
          {"CGATGCTTAGAATGAAATGCA", 2135, 2155},
          {"CGGCCAAGAGTGGCAGAAC", 2161, 2179},
          {"CGTAGACTGAGGAGGGGTAATAAATGGTGGT", 2193, 2223},
          {"CGTTTGGACAGGTATGCTTGTCATGCAGTGTTACCCCAGCAATATATAA", 2236, 2284},
          {"CGGATAAAAATGGCATCTGGCTGATAAAATCCCAACCCTGACCTCAATGTCCAGAACTATTCAGTTTGATTTTCCACTTGTGGTGGAAAGGCCAAAAGACCAGA", 2285, 2388},
          {"CGAGGGAGGCAAACAGGAGACACAAGAGGCAAGCAAAACCCACTCCCCTCCCCTCCCAGGTGCCAGAGGAAGTACCC", 2389, 2465},
          {"CGTGGAGAGGGCCTGGAGGCTT", 2466, 2487},
          {"CGCCTGCAGGGCTGGAAGAGAGGCTTCATCCCAAGTGCTAAATCTGAGCTGG", 2497, 2548},
          {"CGCCCAGAGGGCTGGGTTGAAAAGGGGCTGGAGGCTGCCTCCAGCCTC", 2549, 2596},
          {"CGTAGGAAAGCATGCTGTGATCTGTTAGTCA", 2597, 2627},
          {"CGGCTGCACATTTGCTGCTGCAGAGTGTGCCATCCCACTGGG", 2654, 2695},
          {"CGCTGTGCCTAGGCCAGGG", 2696, 2714},
          {"CGACAGGGAGGAGATGGGGTTTAGAGGAGGGAAAAGAAGCTGGGACAAACATAAAAGAATACTTGCCAC", 2715, 2783},
          {"CGAAGACACTGTGTGGGAGCCCTT", 2807, 2830},
          {"CGTCCAACACAAGGTATTAATATC", 2831, 2854},
          {"CGAGGGGACCCTTAGCAACAGCTCTGACATCTGCTCTGTTACTATGACA", 2855, 2903},
          {"CGAGGAGGGCAGCAAGATAAGGTGAGCCCAGA", 2913, 2944},
          {"CGTCAACATTTCCTCCACCTGTCAGG", 2945, 2970},
          {"CGCTGGGAGGATTAAAGACTCAGAGAGGGAGCCTCAAAGGCCTGTCTAAA", 2974, 3023},
          {"CGCCCAAAGAACCACTCACT", 3024, 3043},
          {"CGTTGCAGGCTGACTATGCACCAAG", 3050, 3074},
          {"CGAGTGGATTCCAGAGTTGAAGCAGGAGCCC", 3081, 3111},
          {"CGGGGAAACCAGTGCCTGACAAACCTCCCTCAAACTCCAC", 3112, 3151},
          {"CGGGCACCCTGCCAGGTCTGCCTGCT", 3158, 3183},
          {"CGGCTCCCCCTCCTCCCAGCTC", 3189, 3210},
          {"CGATGCTCCTCCTCTCTTGCCCAGAC", 3211, 3236},
          {"CGTGGCAAATCTTCCTCATCTGCCTTGGAACCTGCTGGGGCTCCC", 3237, 3281},
          {"CGTACAGCCAGAGAGACCATCCTTACAGCCCAGGTCAGGC", 3297, 3336},
          {"CGTGTGATTCCCCTGCTCAGAAACCTT", 3337, 3363},
          {"CGGTGGCTCCCCACTACTAAGGAAACAAGCCCTAGCTGCCCTCAAGGC", 3364, 3411},
          {"CGTCCATGATCTGGCACAAACCACCCTTGCATTCTGCCAGCCACCCCTCTGCAAAACTGGTGCTCCAGCCACCAGGACCTTGAGGCATTGCAGC", 3412, 3505},
          {"CGGCACCCTCTCACCTGGAA", 3522, 3541},
          {"CGCTGTCTACCTCCTCCACCTGGGGGTGGCCCAGCACCACCTCCCCTGGGAATTCTCCAGCTCCTCCCATCAGGCTCCCATT", 3555, 3636},
          {"CGGGGGCATTTACCTGTTACCC", 3687, 3708},
          {"CGATGCCCAGACATGGTGGGTCCAGTACCCCTTCAGGGGACTAATTTAAC", 3709, 3758},
          {"CGTCAAGAGTTTGCCACTCACTGGAACTA", 3759, 3787},
          {"CGCACCAATAATTTTTTTTTTTGAGACAGGGTCTTGCTC", 3801, 3839},
          {"CGTTGCCCAGGCTGGAGTGCAGTGGCACAGTCACAGTTCACTGCAGCCTCCAACTCCT", 3840, 3897},
          {"CGCATCAGCCTCCCAAGT", 3914, 3931},
          {"CGCCTGGCTAATTTTTTAATTTTTTGGTAAAGACAGGGTCTTGCTCTGTTGTCCAGGCTGGTCTCAAACTCCTGGGCTCAAATGATCCTCCTGCCTCAGCCTCCCAAGTAGCTGGGACTATGGGAGTA", 3945, 4072},
          {"CGACACCCAGCCTGCCAACAAAATTTTATCTTAAAAAC", 4078, 4115},
          {"CGGCATAAGGCTCAGCCT", 4123, 4140},
          {"CGCTGGCCTCCTTAACCTGCC", 4141, 4161},
        ]) do |actual, expected|
          actual.should eq expected
        end
    end
  end

  describe "#has_repeats?" do
    it "tells whether region includes single-letter subregions" do
      region = seq("AATACCCCCGGGATTC")
      region.has_repeats?(2).should be_true
      region.has_repeats?(3).should be_true
      region.has_repeats?(5).should be_true
      region.has_repeats?(6).should be_false
      region.has_repeats?(16).should be_false
    end
  end

  describe "#each_cpg" do
    it "yields CpG indexes" do
      idxs = [] of Int32
      seq("CGATTCAGTTTCCGCTCG").each_cpg { |i| idxs << i }
      idxs.should eq [0, 12, 16]
    end
  end

  describe "#split_by_cpg" do
    it "returns regions between CpG" do
      test_seq.split_by_cpg.map { |r| {r.to_s, r.start, r.stop} }.zip([
        {"TATCCTAAAGAGAAAACACCTTAAATTCTCACATCAGCCACCCCCATGG", 0, 48},
        {"CGACTCTTAACACCTTAATGTAGCACCTTCCAACTTTTCCTGGGCATTTATGTACAAATTGTAATAAAATTGGGTTCTTACTGCATA", 49, 135},
        {"CGCTGCTTGCTGGTTTCTAAATAAAATTGGGTTCTTACTATATATGCTGCTTGCTGGTTTTTTAAACCACCTTGTGCTTTCCCACAGTATTAAAGTTCTTTAAAAATATGATTTTAAACTATAACTTAGTATTCTGAATACAATA", 136, 280},
        {"CGTTTTACCATCTTCCTGTTTGGGAGCACATGGATTGTTTCCAATTTTGCT", 281, 331},
        {"CGATTATATGCAGCACTGAAATGGACATCCTGGCAGATAAATCTCTGA", 332, 379},
        {"CGACTGCCTTAGGATAAGTTCCCAAAAGGGAAATGAAGTGCATTTTTTCAGTGTATTTTTTGAGATACCTTTTCCATAGTCAGGTTCACAGCCACTCAAAGCTGTCAGCTGCAGGCCTCATGCTTGCTGTCTCCAAAGTGCA", 380, 521},
        {"CGTACAAGTGTCCACTACACAAATTCTGCTGGAGGCAGCTGTGTCTTGGTAGCCTAATCTG", 522, 582},
        {"CGGATCTCCAATTAGATGGTTTCAATAAGGCAGA", 583, 616},
        {"CGATCCTCTATT", 617, 628},
        {"CGCAAAAAAATAAATAAATAAAATAAAATAAAGGGCCTCTTCTTTGCAAACAGTTGCATCTACTTAAAAGAAGGCTTCTATCTCCTTAACAGCATTTGTGGGCTCAGAAGCTGGTAAAGCCAGCACTGGCTTGAGAGCCCTGAGTGACCAGTGGCTGGGGC", 629, 789},
        {"CGGTCACATGACACCCCTCCAGC", 790, 812},
        {"CGACTGTTCCC", 813, 823},
        {"CGCCC", 824, 828},
        {"CGACTACAGGGTCC", 829, 842},
        {"CGTAAA", 843, 848},
        {"CGGGCCTTGGGAGCTCATCCC", 849, 869},
        {"CGTACAGGCTAGGAAGCAGTG", 870, 890},
        {"CGCATAGTCATCACTCCAGGAGAAC", 891, 915},
        {"CG", 916, 917},
        {"CGGCT", 918, 922},
        {"CGACCCTGACCTTCCAAAACTCTCAGCAGCCACAGCACAGTGAGAAAAACAACAGC", 923, 978},
        {"CGCC", 979, 982},
        {"CGCAGCTGTCTGTCTCTAACA", 983, 1003},
        {"CGTATCAGACTTTGAAAAACATATC", 1004, 1028},
        {"CGGAGGCAAAACAACCTGCCTCAGAGAAGCC", 1029, 1059},
        {"CGGCAAACACCCA", 1060, 1072},
        {"CGGAGTCTCTAGCC", 1073, 1086},
        {"CGTCCACTG", 1087, 1095},
        {"CGGGGGGACAGGGACAAGGCAACCACCCCAGCAAGTGCAGCTCCTTCTCCCCA", 1096, 1148},
        {"CGCCTTCTC", 1149, 1157},
        {"CGAGGGCCAGCCCATCCACTG", 1158, 1178},
        {"CGGAGGGACAGGAACAAGGACAGGGACAAGGCAACCACCCCACCCAGTGCAGCTCCTTCTCCCCA", 1179, 1243},
        {"CGCCTTCCCCCAGGGCCAGCCCATCCACTGTGGAGGGACAGGGACAAGGACAGGGACAAGGCAACCACCCCACCCAGTGCAGCTCCTTCTCCCCA", 1244, 1338},
        {"CGCCTTCCCCCAGGGCCAGCC", 1339, 1359},
        {"CGTCCACTGTGGAGGGACAGGGACAAGGACAGGGACAAGGCAACCACCCCCAGCAAGTG", 1360, 1418},
        {"CGGCTCCTTCTCCCCA", 1419, 1434},
        {"CGCCTTCCCCCAGGGCCAGCCCATCCACTGTGGAGGGACAGGGACAAGGACAGGGACAAGGCAACCACCCCCAGCAAGTG", 1435, 1514},
        {"CGGCTCCTTCTCCCCA", 1515, 1530},
        {"CGCCTTCCCCCAGGGCCAGCCCATCCACTG", 1531, 1560},
        {"CGGAGGGACAGGGACAGGGACAAGGCAACCACCCCAGCAAGTG", 1561, 1603},
        {"CGGCTCCTCCTTCTTCCAGGGCTGTGAT", 1604, 1631},
        {"CGCTCCCCACCTTACACCCTGGCATTTTCACCTCTT", 1632, 1667},
        {"CGATCTTGTTTCAGGGACA", 1668, 1686},
        {"CGTTCACTGATATAACTGAGGCTTCAGACTCCTAGGGTGTGGCA", 1687, 1730},
        {"CGAA", 1731, 1734},
        {"CGAG", 1735, 1738},
        {"CG", 1739, 1740},
        {"CGCTTTCATCCAGCCACAGGGTC", 1741, 1763},
        {"CGACCCA", 1764, 1770},
        {"CGGTGAG", 1771, 1777},
        {"CGTGGGCAGCATACC", 1778, 1792},
        {"CGAGCTCCTGAGACCAGCAGATATGCTTGGCTGGGGA", 1793, 1829},
        {"CGCATTCCCAAGAGCACAGCCACACTGTGACCCC", 1830, 1863},
        {"CGAG", 1864, 1867},
        {"CGACTGTGACAAAGGGGGCC", 1868, 1887},
        {"CGGGTATGAGGGTGCAGGTGTC", 1888, 1909},
        {"CGGGTGAGACTATCTCTATGGTGAGAATAAAGGAAATGATGCAGGGTGAACAGTGGGAAGGAGG", 1910, 1973},
        {"CGG", 1974, 1976},
        {"CGGA", 1977, 1980},
        {"CGGAGGGGCTGGGGGAAGT", 1981, 1999},
        {"CGCTGTGCCTAGGACACCCA", 2000, 2019},
        {"CGTG", 2020, 2023},
        {"CGAAGGCCAACACCAG", 2024, 2039},
        {"CGCTGCAGGA", 2040, 2049},
        {"CGCCAGTTGGTGT", 2050, 2062},
        {"CGGCCACAGAGAGAGGGCTCAAGTGCATTTTCCACACCAGGGGTGGCTGGTGCCCTCTGAGC", 2063, 2124},
        {"CGCTGCATCA", 2125, 2134},
        {"CGATGCTTAGAATGAAATGCA", 2135, 2155},
        {"CGGCC", 2156, 2160},
        {"CGGCCAAGAGTGGCAGAAC", 2161, 2179},
        {"CGCC", 2180, 2183},
        {"CGGC", 2184, 2187},
        {"CGGCC", 2188, 2192},
        {"CGTAGACTGAGGAGGGGTAATAAATGGTGGT", 2193, 2223},
        {"CGTGAGCCCCCA", 2224, 2235},
        {"CGTTTGGACAGGTATGCTTGTCATGCAGTGTTACCCCAGCAATATATAA", 2236, 2284},
        {"CGGATAAAAATGGCATCTGGCTGATAAAATCCCAACCCTGACCTCAATGTCCAGAACTATTCAGTTTGATTTTCCACTTGTGGTGGAAAGGCCAAAAGACCAGA", 2285, 2388},
        {"CGAGGGAGGCAAACAGGAGACACAAGAGGCAAGCAAAACCCACTCCCCTCCCCTCCCAGGTGCCAGAGGAAGTACCC", 2389, 2465},
        {"CGTGGAGAGGGCCTGGAGGCTT", 2466, 2487},
        {"CGCAGGTGG", 2488, 2496},
        {"CGCCTGCAGGGCTGGAAGAGAGGCTTCATCCCAAGTGCTAAATCTGAGCTGG", 2497, 2548},
        {"CGCCCAGAGGGCTGGGTTGAAAAGGGGCTGGAGGCTGCCTCCAGCCTC", 2549, 2596},
        {"CGTAGGAAAGCATGCTGTGATCTGTTAGTCA", 2597, 2627},
        {"CGTCTGCCCC", 2628, 2637},
        {"CGG", 2638, 2640},
        {"CGTGGAGGGAGAA", 2641, 2653},
        {"CGGCTGCACATTTGCTGCTGCAGAGTGTGCCATCCCACTGGG", 2654, 2695},
        {"CGCTGTGCCTAGGCCAGGG", 2696, 2714},
        {"CGACAGGGAGGAGATGGGGTTTAGAGGAGGGAAAAGAAGCTGGGACAAACATAAAAGAATACTTGCCAC", 2715, 2783},
        {"CGAGC", 2784, 2788},
        {"CGGTGCTTCC", 2789, 2798},
        {"CGAGGCCT", 2799, 2806},
        {"CGAAGACACTGTGTGGGAGCCCTT", 2807, 2830},
        {"CGTCCAACACAAGGTATTAATATC", 2831, 2854},
        {"CGAGGGGACCCTTAGCAACAGCTCTGACATCTGCTCTGTTACTATGACA", 2855, 2903},
        {"CGGGAAACA", 2904, 2912},
        {"CGAGGAGGGCAGCAAGATAAGGTGAGCCCAGA", 2913, 2944},
        {"CGTCAACATTTCCTCCACCTGTCAGG", 2945, 2970},
        {"CGG", 2971, 2973},
        {"CGCTGGGAGGATTAAAGACTCAGAGAGGGAGCCTCAAAGGCCTGTCTAAA", 2974, 3023},
        {"CGCCCAAAGAACCACTCACT", 3024, 3043},
        {"CGGAAG", 3044, 3049},
        {"CGTTGCAGGCTGACTATGCACCAAG", 3050, 3074},
        {"CGGGCT", 3075, 3080},
        {"CGAGTGGATTCCAGAGTTGAAGCAGGAGCCC", 3081, 3111},
        {"CGGGGAAACCAGTGCCTGACAAACCTCCCTCAAACTCCAC", 3112, 3151},
        {"CGCCCC", 3152, 3157},
        {"CGGGCACCCTGCCAGGTCTGCCTGCT", 3158, 3183},
        {"CGGGG", 3184, 3188},
        {"CGGCTCCCCCTCCTCCCAGCTC", 3189, 3210},
        {"CGATGCTCCTCCTCTCTTGCCCAGAC", 3211, 3236},
        {"CGTGGCAAATCTTCCTCATCTGCCTTGGAACCTGCTGGGGCTCCC", 3237, 3281},
        {"CGTTGCCCCTCTTCA", 3282, 3296},
        {"CGTACAGCCAGAGAGACCATCCTTACAGCCCAGGTCAGGC", 3297, 3336},
        {"CGTGTGATTCCCCTGCTCAGAAACCTT", 3337, 3363},
        {"CGGTGGCTCCCCACTACTAAGGAAACAAGCCCTAGCTGCCCTCAAGGC", 3364, 3411},
        {"CGTCCATGATCTGGCACAAACCACCCTTGCATTCTGCCAGCCACCCCTCTGCAAAACTGGTGCTCCAGCCACCAGGACCTTGAGGCATTGCAGC", 3412, 3505},
        {"CGCCCAGCCTTGTCTC", 3506, 3521},
        {"CGGCACCCTCTCACCTGGAA", 3522, 3541},
        {"CGCCTTTGGTTCA", 3542, 3554},
        {"CGCTGTCTACCTCCTCCACCTGGGGGTGGCCCAGCACCACCTCCCCTGGGAATTCTCCAGCTCCTCCCATCAGGCTCCCATT", 3555, 3636},
        {"CGGCTTGAGCCCAC", 3637, 3650},
        {"CGCCCTCC", 3651, 3658},
        {"CGTCAGCATTTCATTC", 3659, 3674},
        {"CGCC", 3675, 3678},
        {"CGCATCCT", 3679, 3686},
        {"CGGGGGCATTTACCTGTTACCC", 3687, 3708},
        {"CGATGCCCAGACATGGTGGGTCCAGTACCCCTTCAGGGGACTAATTTAAC", 3709, 3758},
        {"CGTCAAGAGTTTGCCACTCACTGGAACTA", 3759, 3787},
        {"CGTACAT", 3788, 3794},
        {"CGGTTA", 3795, 3800},
        {"CGCACCAATAATTTTTTTTTTTGAGACAGGGTCTTGCTC", 3801, 3839},
        {"CGTTGCCCAGGCTGGAGTGCAGTGGCACAGTCACAGTTCACTGCAGCCTCCAACTCCT", 3840, 3897},
        {"CGGCTCC", 3898, 3904},
        {"CGTGATCCT", 3905, 3913},
        {"CGCATCAGCCTCCCAAGT", 3914, 3931},
        {"CGCTAGAACTACA", 3932, 3944},
        {"CGCCTGGCTAATTTTTTAATTTTTTGGTAAAGACAGGGTCTTGCTCTGTTGTCCAGGCTGGTCTCAAACTCCTGGGCTCAAATGATCCTCCTGCCTCAGCCTCCCAAGTAGCTGGGACTATGGGAGTA", 3945, 4072},
        {"CGCCA", 4073, 4077},
        {"CGACACCCAGCCTGCCAACAAAATTTTATCTTAAAAAC", 4078, 4115},
        {"CGCCTCA", 4116, 4122},
        {"CGGCATAAGGCTCAGCCT", 4123, 4140},
        {"CGCTGGCCTCCTTAACCTGCC", 4141, 4161},
      ]) do |actual, expected|
        actual.should eq expected
      end
    end
  end

  describe "#to_s" do
    it "returns the sequence" do
      seq("GGCTGG").to_s.should eq "GGCTGG"
    end

    it "returns the reverse complement" do
      seq("CGCCTCA").to_s(complement: true).should eq "TGAGGCG"
    end

    it "returns the sequence with replacements" do
      seq("CGCCTGCAGGGCTGGAAGA").to_s(replacing: {'C' => 'T'}).should eq "TGTTTGTAGGGTTGGAAGA"
    end

    it "returns the reverse complement with replacements" do
      seq("CGCCTCA").to_s(complement: true, replacing: {'C' => 'T'}).should eq "TAAAACA"
      seq("CTGTGTCTTGGTAGCCTAATCTG").to_s(complement: true, replacing: {'C' => 'T'}).should eq "CAAATTAAACTACCAAAACACAA"
    end
  end

  describe "#unsafe_downstream_expand" do
    it "expands region downstream" do
      str = "CGCCTGCAGGGCTGGAAGA"
      expected = Softepigen::Region.new str[10..17].to_slice, 10, 2
      seq(str)[10..15].unsafe_downstream_expand(2).should eq expected
    end
  end

  describe "#unsafe_upstream_expand" do
    it "expands region upstream" do
      str = "CGCCTGCAGGGCTGGAAGA"
      expected = Softepigen::Region.new str[7..15].to_slice, 7, -3
      seq(str)[10..15].unsafe_upstream_expand(3).should eq expected
    end
  end
end

private def seq(str)
  Softepigen::Region.new(str)
end
