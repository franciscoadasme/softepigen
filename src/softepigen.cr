require "./softepigen/**"

# TODO: Write documentation for `Softepigen`
module Softepigen
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  KMERS = {
    4 => %w(
      TGAT TGTA GTAT TAGT TATG GTAG GTGA TGAG GATG GAGT AGTG AGTA AGAT
      GATA ATGA ATAG TAGA ATGT
    ).map(&.to_slice),
    5 => %w(
      GTAGA AGTGA GTGAG ATGAG AGATG GATGA GAGTA GAGTG GAGAT AGATA GATAG
      ATAGA
    ).map(&.to_slice),
  }

  def self.find_primers(
    seq : Region,
    primer_size : Range(Int, Int),
    kmer : Int
  ) : Tuple(Array(Region), Array(Region))
    regions = seq.split_by_cpg
    regions.select! &.size.>=(primer_size.begin)

    downstream_primers = [] of Region # 5' to 3'
    upstream_primers = [] of Region   # 3' to 5'
    regions.each do |region|
      complex_idxs = region.complexity(kmer)

      region.each_downstream(complex_idxs) do |subregion|
        next unless subregion.size.in?(primer_size)
        next if subregion.has_repeats?(REPEAT_SIZE)
        if subregion.stop - 4 >= 0
          4.downto(1) do |i|
            other = subregion.unsafe_upstream_expand(i)
            downstream_primers << other unless other.has_repeats?(REPEAT_SIZE)
          end
        end
        downstream_primers << subregion
      end

      region.each_upstream(complex_idxs) do |subregion|
        next unless subregion.size.in?(primer_size)
        upstream_primers << subregion unless subregion.has_repeats?(REPEAT_SIZE)
        if subregion.stop + 4 < seq.size
          1.upto(4) do |i|
            other = subregion.unsafe_downstream_expand(i)
            upstream_primers << other unless other.has_repeats?(REPEAT_SIZE)
          end
        end
      end
    end
    {downstream_primers, upstream_primers}
  end
end
