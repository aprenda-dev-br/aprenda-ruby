# string_to_seconds.rb

# To run tests:
#   ruby -Ilib:test string_to_seconds.r

require "minitest/autorun"

module StringToSeconds
  class ShouldBeString < StandardError; end
  class InvalidFormat < StandardError; end

  def self.convert(input)
    raise ShouldBeString unless input.is_a?(String)
    hours, minutes, seconds = input.split(':')
    [hours, minutes, seconds].each { |segment| check_format(segment) }

    hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
  end

  def self.check_format(input)
    raise InvalidFormat if input.nil? || input.size != 2 || input.to_i.to_s.rjust(2, '0') != input
  end
end

=begin
"00:01:53" => 113
"00:00:00" => 0
"a" => Error # Invalid format
"aa:00:00" => Error # Invalid format
"000:000:123" => Error # Invalid format
15 => Error # Should be a string
=end

class StringToSecondsTest < Minitest::Test

  def test_correct_format
    assert_equal 113, StringToSeconds.convert("00:01:53")
  end

  def test_zero_seconds
    assert_equal 0, StringToSeconds.convert("00:00:00")
  end

  def test_single_string
    assert_raises(StringToSeconds::InvalidFormat) do
      StringToSeconds.convert("a")
    end
  end

  def test_invalid_hour
    assert_raises(StringToSeconds::InvalidFormat) do
      StringToSeconds.convert("aa:00:00")
    end
  end

  def test_invalid_minute
    assert_raises(StringToSeconds::InvalidFormat) do
      StringToSeconds.convert("00:aa:00")
    end
  end

  def test_invalid_second
    assert_raises(StringToSeconds::InvalidFormat) do
      StringToSeconds.convert("00:00:aa")
    end
  end

  def test_invalid_size_with_zeros
    assert_raises(StringToSeconds::InvalidFormat) do
      StringToSeconds.convert("000:000:123")
    end
  end

  def test_invalid_size_without_zeros
    assert_raises(StringToSeconds::InvalidFormat) do
      StringToSeconds.convert("123:123:123")
    end
  end

  def test_should_be_string
    assert_raises(StringToSeconds::ShouldBeString) do
      StringToSeconds.convert(15)
    end
  end
end