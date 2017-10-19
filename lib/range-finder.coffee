module.exports =
class RangeFinder
  @rangesFor: (editor) ->
    new RangeFinder(editor).ranges()

  constructor: (@editor) ->

  ranges: ->
    selectionRanges =
      this.editor.getSelectedBufferRanges().filter (range) -> not range.isEmpty()
    if selectionRanges.length == 0
      return [this.editor.getBuffer().getRange()]
    return selectionRanges
