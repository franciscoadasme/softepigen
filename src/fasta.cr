module FASTA
  FLOAT_REGEX  = /\d+((\.\d+)?[eE]\+?\d+)?/
  HEADER_REGEX = /(?<name>chr\d+)([:\-](?<start>#{FLOAT_REGEX})-(?<end>#{FLOAT_REGEX}))?/i

  record Header, name : String, range : Range(Int32, Int32) | Nil do
    def self.parse(line : String) : Header
      if line =~ HEADER_REGEX
        start = $~["start"]?.try &.to_f.to_i
        stop = $~["end"]?.try &.to_f.to_i
        Header.new $~["name"], start && stop ? start..stop : nil
      else
        Header.new "chr??", nil
      end
    end
  end

  def self.each(io : IO, & : Header, String ->) : Nil
    line = io.gets
    loop do
      break unless line
      unless line.starts_with?('>')
        line = io.gets
        next
      end

      header = Header.parse line
      seq = String.build do |builder|
        while (line = io.gets) && !line.starts_with?('>')
          builder << line
        end
      end

      yield header, seq
    end
  end

  def self.each(path : Path | String, & : Header, String ->) : Nil
    File.open(path) do |file|
      each(file) do |header, seq|
        yield header, seq
      end
    end
  end
end
