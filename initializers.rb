
class Color
  def self.new_hex(value)
    instance = allocate
    instance.initialize_rgb(*hex_to_rgb(value))
    instance
  end

  def self.new_rgb(*values)
    instance = allocate
    instance.initialize_rgb(*values)
    instance
  end

  def self.hex_to_rgb(value)
    value.chars.each_slice(2).map { |hex_1, hex_2| 
      ['0x', hex_1, hex_2].join.hex
    }
  end

  def initialize_rgb(*rgb_values)
    @red, @green, @blue = rgb_values
  end
end

p blue = Color.new_hex('0000FF')
p red = Color.new_hex('FF0000')
p green = Color.new_rgb(100, 200, 34)

