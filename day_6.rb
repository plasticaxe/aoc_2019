# --- Day 6: Universal Orbit Map ---
# You've landed at the Universal Orbit Map facility on Mercury. Because navigation in space often involves transferring between orbits, the orbit maps here are useful for finding efficient routes between, for example, you and Santa. You download a map of the local orbits (your puzzle input).
#
# Except for the universal Center of Mass (COM), every object in space is in orbit around exactly one other object. An orbit looks roughly like this:
#
#                   \
#                    \
#                     |
#                     |
# AAA--> o            o <--BBB
#                     |
#                     |
#                    /
#                   /
# In this diagram, the object BBB is in orbit around AAA. The path that BBB takes around AAA (drawn with lines) is only partly shown. In the map data, this orbital relationship is written AAA)BBB, which means "BBB is in orbit around AAA".
#
# Before you use your map data to plot a course, you need to make sure it wasn't corrupted during the download. To verify maps, the Universal Orbit Map facility uses orbit count checksums - the total number of direct orbits (like the one shown above) and indirect orbits.
#
# Whenever A orbits B and B orbits C, then A indirectly orbits C. This chain can be any number of objects long: if A orbits B, B orbits C, and C orbits D, then A indirectly orbits D.
#
# For example, suppose you have the following map:
#
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# Visually, the above map of orbits looks like this:
#
#         G - H       J - K - L
#        /           /
# COM - B - C - D - E - F
#                \
#                 I
# In this visual representation, when two objects are connected by a line, the one on the right directly orbits the one on the left.
#
# Here, we can count the total number of orbits as follows:
#
# D directly orbits C and indirectly orbits B and COM, a total of 3 orbits.
# L directly orbits K and indirectly orbits J, E, D, C, B, and COM, a total of 7 orbits.
# COM orbits nothing.
# The total number of direct and indirect orbits in this example is 42.
#
# What is the total number of direct and indirect orbits in your map data?

require 'tree'

test_input = 'COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN'
# input = test_input

input = File.read('day_6_input.txt')

puts 'day_6 part_1'

def add_children(base_node, input)
  input.split.select { |i| i =~ /^#{base_node.name}:/ }.map { |i| i.split(':').last }.each do |i|
    node = Tree::TreeNode.new(i)
    base_node << node
    add_children(node, input)
  end
end

root_node = Tree::TreeNode.new('COM')
# Parenthesis causing grief in regex
add_children(root_node, input.tr(')', ':'))
puts "total orbits = #{root_node.each.map(&:size).inject(:+) - root_node.size}"

# Your puzzle answer was 271151.
#
# The first half of this puzzle is complete! It provides one gold star: *
#
# --- Part Two ---
# Now, you just need to figure out how many orbital transfers you (YOU) need to take to get to Santa (SAN).
#
# You start at the object YOU are orbiting; your destination is the object SAN is orbiting. An orbital transfer lets you move from any object to an object orbiting or orbited by that object.
#
# For example, suppose you have the following map:
#
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
# K)YOU
# I)SAN
# Visually, the above map of orbits looks like this:
#
#                           YOU
#                          /
#         G - H       J - K - L
#        /           /
# COM - B - C - D - E - F
#                \
#                 I - SAN
# In this example, YOU are in orbit around K, and SAN is in orbit around I. To move from K to I, a minimum of 4 orbital transfers are required:
#
# K to J
# J to E
# E to D
# D to I
# Afterward, the map of orbits looks like this:
#
#         G - H       J - K - L
#        /           /
# COM - B - C - D - E - F
#                \
#                 I - SAN
#                  \
#                   YOU
# What is the minimum number of orbital transfers required to move from the object YOU are orbiting to the object SAN is orbiting? (Between the objects they are orbiting - not between YOU and SAN.)

puts 'day_6 part_2'

you_path = root_node.each.select { |n| n.name.eql?('YOU') }.map(&:path_as_array).flatten.reject { |n| n.eql?('YOU') }
san_path = root_node.each.select { |n| n.name.eql?('SAN') }.map(&:path_as_array).flatten.reject { |n| n.eql?('SAN') }
common = you_path & san_path
you_path_less_common = you_path - common
san_path_less_common = san_path - common
puts "steps = #{you_path_less_common.count + san_path_less_common.count}"

# Your puzzle answer was 388.
