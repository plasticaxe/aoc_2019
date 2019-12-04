# --- Day 4: Secure Container ---
# You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.
#
# However, they do remember a few key facts about the password:
#
# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
# Other than the range rule, the following are true:
#
# 111111 meets these criteria (double 11, never decreases).
# 223450 does not meet these criteria (decreasing pair of digits 50).
# 123789 does not meet these criteria (no double).
# How many different passwords within the range given in your puzzle input meet these criteria?
#
# Your puzzle input is 347312-805915.

range_start = 347_312
range_end   = 805_915

puts 'day_4 part_1'

def split_digits(number)
  number.to_s.chars.map(&:to_i)
end

def contains_exact_sequence?(numbers, sequence_length)
  numbers.group_by { |n| n }.each_value.map(&:count).include?(sequence_length)
end

def contains_sequence?(numbers, sequence_length)
  sequence_length.upto(numbers.size) { |n| return true if contains_exact_sequence?(numbers, n) }
  false
end

def digits_never_decrease?(numbers)
  numbers.join.eql?(numbers.sort.join)
end

passwords = range_start.upto(range_end).select do |number|
  numbers_array = split_digits(number)
  contains_sequence?(numbers_array, 2) && digits_never_decrease?(numbers_array)
end
puts passwords.count

# Your puzzle answer was 594.
#
# The first half of this puzzle is complete! It provides one gold star: *
#
# --- Part Two ---
# An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.
#
# Given this additional criterion, but still ignoring the range rule, the following are now true:
#
# 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
# 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
# 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
# How many different passwords within the range given in your puzzle input meet all of the criteria?

puts 'day_4 part_2'

# Test Data: should return '2'
# passwords = [112233, 123444, 111122]

puts passwords.count { |p| contains_exact_sequence?(split_digits(p), 2) }
