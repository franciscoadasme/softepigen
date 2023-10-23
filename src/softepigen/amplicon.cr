require "./region"

struct Softepigen::Amplicon
  @region : Region

  getter downstream_primer : Region
  getter upstream_primer : Region
  delegate to_s, to: @region
  forward_missing_to @region

  def initialize(@downstream_primer : Region, @upstream_primer : Region)
    size = upstream_primer.stop - @downstream_primer.start + 1
    buffer = Bytes.new(@downstream_primer.to_unsafe, size)
    @region = Region.new buffer, @downstream_primer.start
  end

  def primers : Tuple(Region, Region)
    {@downstream_primer, @upstream_primer}
  end
end
