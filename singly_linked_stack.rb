require 'minitest/autorun'

class Node
  attr_accessor :value, :next

  def initialize(value)
    @value = value
    @next = nil
  end	

  def to_s
    @value
  end
end

class SinglyLinkedStack
  
  attr_accessor :head

  def initialize
    @head = nil
  end

  def push(node)
    if @head.nil?
      @head = node
    else
      node.next = @head
      @head = node
    end  
  end
 
  def pop
    pop_node = @head
    @head = @head.next
    pop_node
  end

  def each(&block)
    node = @head
    while node
      yield node
      node = node.next
    end
  end	
end

class StackTest < Minitest::Test
  
  def setup 
    @stack = SinglyLinkedStack.new
  end

  def test_should_insert_element
    node = Node.new(1)
    @stack.push(node)
    assert_equal node, @stack.head 
  end
  
  def test_should_pop_element
    @stack.push(Node.new(1))
    popped_element = @stack.pop
    assert_equal 1, popped_element.value  
  end

  def test_should_iterate_all_elements
    @stack.push(Node.new(1))
    @stack.push(Node.new(2))
    @stack.push(Node.new(3))
    values = [3, 2, 1]
    index = 0
    @stack.each do |node|
      assert_equal values[index], node.value
      index += 1
    end
  end
end

