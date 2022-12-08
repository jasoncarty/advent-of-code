Directory = Struct.new(:name, :children, :parent, :size)
File_ = Struct.new(:name, :size)

file_regex = /[0-9]{1,} ([a-zA-Z]{1,}.[a-zA-Z]{1,}|[a-zA-Z]{1,})/
dir_regex = /^dir \S{1,}/
move_into_dir_command_regex = /\$ cd ([a-zA-Z]|\S$)/
move_out_of_dir_command_regex = /\$ cd (..$)/
list_all_command_regex = /\$ ls/
@dir_sizes = []

input = File.read("real_input.txt").split("\n")

def sum_filesystem(dir)
  case dir
  when Directory
    sum = 0
    dir.children.each { |_, v| sum += sum_filesystem(v) }
    sum += dir.size if dir.size <= 100_000
    return sum
  when File_
    return 0
  end
end

def compute_directory_sizes(dir)
  sum = 0
  dir.children.each do |_, v|
    case v
    when Directory
      compute_directory_sizes(v)
    end
    sum += v.size
  end
  @dir_sizes.push(sum)
  dir.size = sum
end

root = Directory.new("/", {}, nil, 0)
current_dir = root

input[1..-1].each do |item|
  if item.match(move_into_dir_command_regex)
    if item.split[2] == "/"
      current_dir = root
    else
      current_dir = current_dir.children[item.split[2]]
    end
  elsif item.match(move_out_of_dir_command_regex)
    current_dir = current_dir.parent
  elsif item.match(file_regex)
    size, name = item.split
    current_dir.children[name] = File_.new(name, size.to_i)
  elsif item.match(dir_regex)
    name = item.split[1]
    current_dir.children[name] = Directory.new(name, {}, current_dir, 0)
  end
end

compute_directory_sizes(root)

part1 = sum_filesystem(root)

total_system_size = @dir_sizes.sort().last
max_system_size = 70_000_000
min_space = 30_000_000
over_max = max_system_size - total_system_size
missing_space = min_space - over_max

part2 = @dir_sizes.sort().find { |item| item >= missing_space }

p "The answer to part 1 is: #{part1}" # The answer to part 1 is: 1432936
p "The answer to part 2 is: #{part2}" # The answer to part 1 is: 1432936
