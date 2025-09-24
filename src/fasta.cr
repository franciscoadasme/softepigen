module FASTA
  FLOAT_REGEX  = /\d+((\.\d+)?[eE]\+?\d+)?/
  HEADER_REGEX = /(?<name>chr\d+)([:\-](?<start>#{FLOAT_REGEX})-(?<end>#{FLOAT_REGEX}))?/

  record Header, name : String, range : Range(Int32, Int32) | Nil

  def self.each(io : IO, & : Header?, String ->) : Nil
    line = io.gets
    loop do
      break unless line
      unless line.starts_with?('>')
        line = io.gets
        next
      end

      if line =~ HEADER_REGEX
        start = $~["start"]?.try &.to_f.to_i
        stop = $~["end"]?.try &.to_f.to_i
        header = Header.new $~["name"], start && stop ? start..stop : nil
      else
        name = io.is_a?(File) ? Path[io.path].stem : "seq"
        header = Header.new name, nil
      end

      seq = String.build do |builder|
        while (line = io.gets) && !line.starts_with?('>')
          builder << line
        end
      end

      yield header, seq
    end
  end

  def self.each(path : Path | String, & : Header?, String ->) : Nil
    File.open(path) do |file|
      each(file) do |header, seq|
        yield header, seq
      end
    end
  end
end
