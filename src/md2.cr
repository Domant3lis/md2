# This is a simple library which creates MD2 hashes
module MD2
  VERSION = "0.1.0"

  # This is a precomputed table needed to create a hash
  S = [ 41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240, 6, 19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217, 188, 76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66, 111, 24, 138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73, 160, 251, 245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178, 7, 63, 148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154, 90, 144, 50, 39, 53, 62, 204, 231, 191, 247, 151, 3, 255, 25, 48, 179, 72, 165, 181, 209, 215, 94, 146, 42, 172, 86, 170, 198, 79, 184, 56, 210, 150, 164, 125, 182, 118, 252, 107, 226, 156, 116, 4, 241, 69, 157, 112, 89, 100, 113, 135, 32, 134, 91, 207, 101, 230, 45, 168, 2, 27, 96, 37, 173, 174, 176, 185, 246, 28, 70, 97, 105, 52, 64, 126, 15, 85, 71, 163, 35, 221, 81, 175, 58, 195, 92, 249, 206, 186, 197, 234, 38, 44, 83, 13, 110, 133, 40, 132, 9, 211, 223, 205, 244, 65, 129, 77, 82, 106, 220, 55, 200, 108, 193, 171, 250, 36, 225, 123, 8, 12, 189, 177, 74, 120, 136, 149, 139, 227, 99, 232, 109, 233, 203, 213, 254, 59, 0, 29, 57, 242, 239, 183, 14, 102, 88, 208, 228, 166, 119, 114, 248, 235, 117, 75, 10, 49, 68, 80, 180, 143, 237, 31, 26, 219, 153, 141, 51, 159, 17, 131, 20]

  BLOCK_SIZE = UInt8.new 16

  # Takes a string and returns a hexadecimal MD2 hash
  #
  # ```
  # MD2.get_hash("hello") => "a9046c73e00331af68917d3804f70655"
  # ```
  def self.get_hash(message : String) : String
    message = message.bytes

    lines = Array(Array(UInt8)).new
    line = Array(UInt8).new

    # Constructs an array of an array  and
    # Devides the message into blocks of 16 bytes
    message.each_with_index do |c, i|
      # Initiales a new line
      if (i % BLOCK_SIZE == 0 && i != 0)
        lines << line
        line = Array(UInt8).new
      end

      line << c
      ii = i
    end


    # since the later loop only appends `line`s if 16 characters have been looped
    # it is neccessary to append the rest of left line if there is any
    if (line.size != 0)
      lines << line
    end

    # padding
    if (line.size != BLOCK_SIZE && message.size != 0)
      pad_value = (BLOCK_SIZE - line.size).to_u8

      pad_value.times do
        lines[-1] << pad_value
      end
    else
      lines << [BLOCK_SIZE] * BLOCK_SIZE
    end

    # marked as C in the spec
    checksum = [UInt8.new 0] * BLOCK_SIZE

    # Calculates the checksum
    l = 0
    lines.each_with_index do |line, i|
      line.each_with_index do |c, j|
        checksum[j] = checksum[j] ^ S[c ^ l]
        l = checksum[j]
      end
    end

    lines << checksum

    # marked as X in the spec
    hash = [UInt8.new 0] * 48

    # the last part
    lines.each_with_index do |line, i|
      BLOCK_SIZE.times do |j|
        hash[BLOCK_SIZE + j] = line[j].clone
        hash[2*BLOCK_SIZE + j] = (hash[BLOCK_SIZE + j] ^ hash[j])
      end

      t = 0

      18.times do |j|
        48.times do |k|
          t = hash[k] ^ S[t]
          hash[k] = t
        end

        t = UInt16.new t
        t = (t + j) % 256
      end
    end

    # Creates an output string
    result : String = ""
    16.times do |i|
      result += hash[i].to_s(base: 16, precision: 2)
    end

    result
  end
end


class String
  # Takes a string and returns a hexadecimal MD2 hash
  #
  # ```
  # "hello".get_md2 => "a9046c73e00331af68917d3804f70655"
  # ```
  def get_md2
    MD2.get_hash(self)
  end
end
