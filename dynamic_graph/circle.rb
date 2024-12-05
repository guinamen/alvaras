radius = 10
arr = ['', 'Q', 'R', 'S', 'T', 'U', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P']
(1..21).each do |i|
  x = Math.cos(((Math::PI*2)/21.0)*i.to_f)*radius
  y = Math.sin(((Math::PI*2)/21.0)*i.to_f)*radius
  puts "echo '#{arr[i]}[label=\"#{arr[i]}\", pos=\"#{x},#{y}!\", shape = \"square\"];'"
end
