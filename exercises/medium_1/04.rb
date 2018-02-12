# Your task is to write a CircularQueue class that implements a circular
# queue for arbitrary objects. The class should obtain the buffer size
# with an argument provided to CircularQueue::new, and should provide
# the following methods:

# enqueue to add an object to the queue
# dequeue to remove (and return) the oldest object in the queue. It should
# return nil if the queue is empty.
# You may assume that none of the values stored in the queue are nil (however,
# nil may be used to designate empty spots in the buffer).

class CircularQueue
  attr_reader :buffer
  attr_accessor :current_idx, :oldest_idx

  def initialize(buffer_size)
    @buffer = Array.new(buffer_size)
    @current_idx = 0
    @oldest_idx = 0
  end

  def enqueue(obj)
    if buffer.none?(&:nil?)
      self.current_idx = oldest_idx
      dequeue
    end
    buffer[current_idx] = obj
    self.current_idx = update_idx(current_idx)
  end

  def dequeue
    return if buffer.all?(&:nil?)
    deleted = buffer[oldest_idx]
    buffer[oldest_idx] = nil
    self.oldest_idx = update_idx(oldest_idx)
    deleted
  end

  private

  def update_idx(idx)
    idx + 1 == buffer.size ? 0 : idx + 1
  end
end
# Examples:

queue = CircularQueue.new(3)
p queue.dequeue.nil?
queue.enqueue(1)
queue.enqueue(2)
p queue.dequeue == 1
queue.enqueue(3)
queue.enqueue(4)
p queue.dequeue == 2
queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
p queue.dequeue == 5
p queue.dequeue == 6
p queue.dequeue == 7
p queue.dequeue.nil?

queue = CircularQueue.new(4)
p queue.dequeue.nil?
queue.enqueue(1)
queue.enqueue(2)
p queue.dequeue == 1
queue.enqueue(3)
queue.enqueue(4)
p queue.dequeue == 2
queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
p queue.dequeue == 4
p queue.dequeue == 5
p queue.dequeue == 6
p queue.dequeue == 7
p queue.dequeue.nil?

# The above code should display true 15 times.
