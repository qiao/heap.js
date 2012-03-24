{floor, min} = Math

### 
Default comparison function to be used 
###
defaultCmp = (x, y) ->
  return -1 if x < y
  return 1 if x > y
  0

### 
Insert item x in list a, and keep it sorted assuming a is sorted.

If x is already in a, insert it to the right of the rightmost x.

Optional args lo (default 0) and hi (default a.length) bound the slice
of a to be searched.
###
insort = (a, x, lo=0, hi, cmp=defaultCmp) ->
  throw new Error('lo must be non-negative') if lo < 0
  hi ?= a.length
  while cmp(lo, hi) < 0
    mid = floor((lo + hi) / 2)
    if cmp(x, a[mid]) < 0
      hi = mid
    else
      lo = mid + 1
  a[lo...lo] = x

###
Push item onto heap, maintaining the heap invariant.
###
heappush = (array, item, cmp=defaultCmp) ->
  array.push(item)
  _siftdown(array, 0, array.length - 1, cmp)

###
Pop the smallest item off the heap, maintaining the heap invariant.
###
heappop = (array, cmp=defaultCmp) ->
  lastelt = array.pop()
  if array.length
    returnitem = array[0]
    array[0] = lastelt
    _siftup(array, 0, cmp)
  else
    returnitem = lastelt
  returnitem

###
Pop and return the current smallest value, and add the new item.

This is more efficient than heappop() followed by heappush(), and can be 
more appropriate when using a fixed size heap. Note that the value
returned may be larger than item! That constrains reasonable use of
this routine unless written as part of a conditional replacement:
    if item > array[0]
      item = heapreplace(array, item)
###
heapreplace = (array, item, cmp=defaultCmp) ->
  returnitem = array[0]
  array[0] = item
  _siftup(array, 0, cmp)
  returnitem

###
Fast version of a heappush followed by a heappop.
###
heappushpop = (array, item, cmp=defaultCmp) ->
  if array.length and cmp(array[0], item) < 0
    [item, array[0]] = [array[0], item]
    _siftup(array, 0, cmp)
  item

###
Transform list into a heap, in-place, in O(array.length) time.
###
heapify = (array, cmp=defaultCmp) ->
  for i in [0...floor(array.length / 2)].reverse()
    _siftup(array, i, cmp)

###
Find the n largest elements in a dataset.
###
nlargest = (n, array, cmp=defaultCmp) ->
  result = array[0...n]
  return result unless result.length
  heapify(result, cmp)
  heappushpop(result, elem, cmp) for elem in array[n..]
  result.sort(cmp).reverse()

###
Find the n smallest elements in a dataset.
###
nsmallest = (n, array, cmp=defaultCmp) ->
  if n * 10 <= array.length
    result = array[0...n].sort(cmp)
    return result unless result.length
    los = result[result.length - 1]
    for elem in array[n..]
      if cmp(elem, los) < 0
        insort(result, elem, 0, null, cmp)
        result.pop()
        los = result[result.length - 1]
    return result

  heapify(array, cmp)
  (heappop(array, cmp) for i in [0...min(n, array.length)])

_siftdown = (array, startpos, pos, cmp=defaultCmp) ->
  newitem = array[pos]
  while pos > startpos
    parentpos = (pos - 1) >> 1
    parent = array[parentpos]
    if cmp(newitem, parent) < 0
      array[pos] = parent
      pos = parentpos
      continue
    break
  array[pos] = newitem

_siftup = (array, pos, cmp=defaultCmp) ->
  endpos = array.length
  startpos = pos
  newitem = array[pos]
  childpos = 2 * pos + 1
  while childpos < endpos
    rightpos = childpos + 1
    if rightpos < endpos and not (cmp(array[childpos], array[rightpos]) < 0)
      childpos = rightpos
    array[pos] = array[childpos]
    pos = childpos
    childpos = 2 * pos + 1
  array[pos] = newitem
  _siftdown(array, startpos, pos, cmp)

class Heap
  @push: heappush
  @pop: heappop
  @replace: heapreplace
  @pushpop: heappushpop
  @heapify: heapify
  @nlargest: nlargest
  @nsmallest: nsmallest

  constructor: (@cmp=defaultCmp) ->
    @data = []

  push: (x) ->
    heappush(@data, x, @cmp)

  pop: ->
    heappop(@data, @cmp)

  replace: (x) ->
    heapreplace(@data, x, @cmp)

  pushpop: (x) ->
    heappushpop(@data, x, @cmp)

  heapify: ->
    heapify(@data, @cmp)

  empty: ->
    @data.length is 0

  size: ->
    @data.length

  toArray: ->
    @data.slice()

# exports to global
(module?.exports or window).Heap = Heap
