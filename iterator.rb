def get(path)
  puts "requesting #{path}"
  case path
  when '/users?page=1'
    {
      data: [
        { id: 1, name: 'Jane', age: 30 },
        { id: 2, name: 'Mattew', age: 24 },
        { id: 3, name: 'Julia', age: 28 }
      ],
      meta: { page: 1, total_pages: 3 }
    }
  when '/users?page=2'
    {
      data: [
        { id: 4, name: 'Alex', age: 28 },
        { id: 5, name: 'Bob', age: 27 },
        { id: 6, name: 'Alice', age: 29 }
      ],
      meta: { page: 2, total_pages: 3 }
    }
  when '/users?page=3'
    {
      data: [
        { id: 7, name: 'Charlie', age: 35 },
        { id: 8, name: 'Sarah', age: 33 },
      ],
      meta: { page: 3, total_pages: 3 }
    }
  end
end

def users
  paginate_through('/users')
end

def all_users
  users.to_a
end

def paginate_through(path)
  page = 1
  iter = Enumerator.new do |yielder|
    loop do
      result = get("#{path}?page=#{page}")
      result[:data].each { |item| yielder << item }

      break if page >= result[:meta][:total_pages]
      page += 1
    end
  end

  iter
end

puts "Expect 1 request"
p users.find { |user| user[:name] == 'Julia' }

puts "Expect 3 request"
p users.find { |user| user[:name] == 'Charlie' }

puts "Sorting"
p users.sort_by { |u| u[:name] }

puts "Oldest"
p users.max_by { |u| u[:age] }




