require "./softepigen/**"

# TODO: Write documentation for `Softepigen`
module Softepigen
  VERSION = "0.1.0"

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
end
