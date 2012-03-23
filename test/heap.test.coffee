{Heap} = require '..'
{random} = Math

describe 'Heap', ->
  describe '#push(), #pop()', ->
    it 'should sort an array using push and pop', ->
      heap = new Heap
      heap.push(random()) for i in [1..10]
      sorted = (heap.pop() until heap.empty())
      sorted.slice().sort().should.eql(sorted)

    it 'should work with custom comparison function', ->
      cmp = (a, b) ->
        return -1 if a > b
        return 1 if a < b
        0
      heap = new Heap(cmp)
      heap.push(random()) for i in [1..10]
      sorted = (heap.pop() until heap.empty())
      sorted.slice().sort().reverse().should.eql(sorted)

  describe '#replace()', ->
    it 'should behave like pop() followed by push()', ->
      heap = new Heap
      heap.push(v) for v in [1..5]
      heap.replace(3).should.eql(1)
      heap.toArray().sort().should.eql([2,3,3,4,5])

  describe '#pushpop()', ->
    it 'should behave like push() followed by pop()', ->
      heap = new Heap
      heap.push(v) for v in [1..5]
      heap.pushpop(6).should.eql(1)
      heap.toArray().sort().should.eql([2..6])

  describe '#nsmallest()', ->
    it 'should return exactly n elements when size() >= n', ->
      heap = new Heap
      heap.push(v) for v in [1..10]
      heap.nsmallest(3).should.eql([1..3])

    it 'should return size() elements when size() <= n', ->
      heap = new Heap
      heap.push(v) for v in [3..1]
      heap.nsmallest(10).should.eql([1..3])

  describe '#nlargest()', ->
    it 'should return exactly n elements when size() >= n', ->
      heap = new Heap
      heap.push(v) for v in [1..10]
      heap.nlargest(3).should.eql([10..8])

    it 'should return size() elements when size() <= n', ->
      heap = new Heap
      heap.push(v) for v in [3..1]
      heap.nlargest(10).should.eql([3..1])
