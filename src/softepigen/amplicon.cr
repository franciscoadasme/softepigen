require "./region"

struct Softepigen::Amplicon
  @region : Region

  getter forward_primer : Region
  getter reverse_primer : Region
  delegate to_s, to: @region
  forward_missing_to @region

  def initialize(@forward_primer : Region, @reverse_primer : Region)
    size = reverse_primer.stop - @forward_primer.start + 1
    buffer = Bytes.new(@forward_primer.to_unsafe, size)
    @region = Region.new buffer, @forward_primer.start
  end

  def primers : Tuple(Region, Region)
    {@forward_primer, @reverse_primer}
  end
end
