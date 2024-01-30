class Heap
  @push: heappush
  @pop: heappop
  @replace: heapreplace
  @pushpop: heappushpop
  @heapify: heapify
  @updateItem: updateItem
  @nlargest: nlargest
  @nsmallest: nsmallest

  constructor: (@cmp=defaultCmp) ->
    @nodes = []

  push: (x) ->
    heappush(@nodes, x, @cmp)

  pop: ->
    heappop(@nodes, @cmp)

  peek: ->
    @nodes[0]

  contains: (x) ->
    @nodes.indexOf(x) isnt -1

  replace: (x) ->
    heapreplace(@nodes, x, @cmp)

  pushpop: (x) ->
    heappushpop(@nodes, x, @cmp)

  heapify: ->
    heapify(@nodes, @cmp)

  updateItem: (x) ->
    updateItem(@nodes, x, @cmp)

  clear: ->
    @nodes = []

  empty: ->
    @nodes.length is 0

  size: ->
    @nodes.length

  clone: ->
    heap = new Heap()
    heap.nodes = @nodes.slice(0)
    heap

  toArray: ->
    @nodes.slice(0)

  # aliases
  insert: @::push
  top:    @::peek
  front:  @::peek
  has:    @::contains
  copy:   @::clone


# exports to global
((root, factory) ->
  if typeof define is 'function' and define.amd
    define [], factory
  else if typeof exports is 'object'
    module.exports = factory()
  else
    root.Heap = factory()
) @, -> Heap


