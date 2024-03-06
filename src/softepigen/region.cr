struct Softepigen::Region
  getter padding : Int32
  getter start : Int32
  getter stop : Int32 { @start + size - 1 }

  BYTE_C = 'C'.ord.to_u8
  BYTE_G = 'G'.ord.to_u8

  def initialize(@buffer : Bytes, @start : Int32, @padding : Int32 = 0)
    raise ArgumentError.new("Negative start") if @start.negative?
  end

  def self.new(str : String) : self
    new str.to_slice, 0
  end

  def [](range : Range(Int?, Int?)) : self
    offset = range.begin || 0
    offset += size if offset.negative?
    self.class.new(@buffer[range], @start + offset)
  end

  def complexity(k : Int = 4) : Array(Int32)
    kmers = KMERS[k]? || raise ArgumentError.new("Invalid k-mer #{k}")
    offset = 0
    offset += 2 if @buffer[0].unsafe_chr == 'C' && @buffer[1].unsafe_chr == 'G'
    (offset..(size - k)).select do |i|
      kmers.any? do |kmer|
        (0...k).all? do |j|
          byte = @buffer.unsafe_fetch(i + j)
          byte = 'T'.ord.to_u8 if byte == 'C'.ord # bisulfite (C => T)
          byte == kmer.unsafe_fetch(j)
        end
      end
    end
  end

  def cpg_count : Int32
    count = 0
    each_cpg { count += 1 }
    count
  end

  def each_cpg(& : Int32 ->) : Nil
    offset = 0
    while (index = @buffer.index(BYTE_C, offset))
      if @buffer.unsafe_fetch(index + 1) == BYTE_G
        yield index
        offset = index + 2
      else
        offset = index + 1
      end
    end
  end

  def each_downstream(complex_idxs : Array(Int32), & : Region ->) : Nil
    return unless @buffer[2] == 'C'.ord # starts with bisulfite conversion (CG*)
    complex_idxs.each do |i|
      next unless size - i >= 15
      yield Region.new @buffer[0...(i + 15)], @start
    end
  end

  def each_upstream(complex_idxs : Array(Int32), & : Region ->) : Nil
    complex_idxs.each do |i|
      next unless i >= 11 + 2
      next unless @buffer[i - 11] == 'C'.ord # starts with bisulfite conversion (*CG)
      # WARN: It's overextending by two characters at the end, which may
      # be out of bounds. Remove trailing zeros
      slice = Bytes.new(@buffer.to_unsafe + i - 11, size - i + 11 + 2)
      slice = slice[..slice.rindex!(&.positive?)] if slice.last == 0
      yield Region.new(slice, @start + i - 11)
    end
  end

  def forward : Array(Region)
    forward complexity
  end

  def forward(complex_idxs : Array(Int32)) : Array(Region)
    Array(Region).new.tap do |regions|
      each_downstream(complex_idxs) do |region|
        regions << region
      end
    end
  end

  def has_repeats?(count : Int) : Bool
    count -= 1
    repeat_count = 0
    (size - 1).times do |i|
      if @buffer.unsafe_fetch(i) == @buffer.unsafe_fetch(i + 1)
        repeat_count += 1
        return true if repeat_count == count
      else
        repeat_count = 0
      end
    end
    false
  end

  def reverse : Array(Region)
    reverse complexity
  end

  def reverse(complex_idxs : Array(Int32)) : Array(Region)
    Array(Region).new.tap do |regions|
      each_upstream(complex_idxs) do |region|
        regions << region
      end
    end
  end

  def size : Int32
    @buffer.size
  end

  def split_by_cpg : Array(Region)
    regions = [] of Region
    prev_index = 0
    each_cpg do |index|
      regions << self[prev_index...index]
      prev_index = index
    end
    regions << self[prev_index...size]
    regions
  end

  def to_s(
    complement : Bool = false,
    replacing replacements : Hash(Char, Char)? = nil
  ) : String
    String.build do |io|
      to_s io, complement, replacements
    end
  end

  def to_s(
    io : IO,
    complement : Bool = false,
    replacing replacements : Hash(Char, Char)? = nil
  ) : Nil
    if complement
      @buffer.reverse_each do |byte|
        char = byte.unsafe_chr
        char = replacements.fetch(char, char) if replacements
        io << case char
        when 'C' then 'G'
        when 'G' then 'C'
        when 'T' then 'A'
        when 'A' then 'T'
        else          raise ArgumentError.new("Invalid letter #{char}")
        end
      end
    elsif replacements
      @buffer.each do |byte|
        if char = replacements[byte.unsafe_chr]?
          io << char
        else
          io.write_byte byte
        end
      end
    else
      io.write_string @buffer
    end
  end

  def to_unsafe : Pointer(UInt8)
    @buffer.to_unsafe
  end

  # WARN: potentially dangerous (no bounds check)
  def unsafe_downstream_expand(count : Int) : self
    raise ArgumentError.new("Negative count") if count.negative?
    slice = Bytes.new(@buffer.to_unsafe, size + count)
    Region.new(slice, @start, count)
  end

  # WARN: potentially dangerous (no bounds check)
  def unsafe_upstream_expand(count : Int) : self
    raise ArgumentError.new("Negative count") if count.negative?
    slice = Bytes.new(@buffer.to_unsafe - count, size + count)
    Region.new(slice, @start - count, -count)
  end
end
