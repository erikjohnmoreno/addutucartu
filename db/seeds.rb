Product.find_or_create_by(code: 'GR1') do |product|
  product.name = 'Green Tea'
  product.price = 3.11
end

Product.find_or_create_by(code: 'SR1') do |product|
  product.name = 'Strawberries'
  product.price = 5.00
end

Product.find_or_create_by(code: 'CF1') do |product|
  product.name = 'Coffee'
  product.price = 11.23
end

puts "Products created successfully!"
puts "Available products:"
Product.all.each do |product|
  puts "- #{product.code}: #{product.name} - €#{product.price}"
end
