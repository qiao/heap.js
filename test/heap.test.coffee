{Heap} = require '..'
{random} = Math

describe 'Heap#push, Heap#pop', ->
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

describe 'Heap#replace', ->
  it 'should behave like pop() followed by push()', ->
    heap = new Heap
    heap.push(v) for v in [1..5]
    heap.replace(3).should.eql(1)
    heap.toArray().sort().should.eql([2,3,3,4,5])

describe 'Heap#pushpop', ->
  it 'should behave like push() followed by pop()', ->
    heap = new Heap
    heap.push(v) for v in [1..5]
    heap.pushpop(6).should.eql(1)
    heap.toArray().sort().should.eql([2..6])

describe 'Heap#contains', ->
  it 'should return whether it contains the value', ->
    heap = new Heap
    heap.push(v) for v in [1..5]
    heap.contains(v).should.be.true for v in [1..5]
    heap.contains(0).should.be.false
    heap.contains(6).should.be.false
    

describe 'Heap.nsmallest', ->
  it 'should return exactly n elements when size() >= n', ->
    Heap.nsmallest(3, [1..10]).should.eql([1..3])

    array = [1,3,2,1,3,4,4,2,3,4,5,1,2,3,4,5,2,1,3,4,5,6,7,2]
    Heap.nsmallest(2, array).should.eql([1, 1])

  it 'should return size() elements when size() <= n', ->
    Heap.nsmallest(10, [3..1]).should.eql([1..3])

describe 'Heap.nlargest', ->
  it 'should return exactly n elements when size() >= n', ->
    Heap.nlargest(3, [1..10]).should.eql([10..8])

  it 'should return size() elements when size() <= n', ->
    Heap.nlargest(10, [3..1]).should.eql([3..1])

