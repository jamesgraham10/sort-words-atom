RangeFinder = require './range-finder'

convertToUppercase = (s) -> s.toUpperCase()

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor:not([mini])',
      'sort-words:sort-case-insensitive': ->
        sortWords(atom.workspace.getActiveTextEditor(), convertToUppercase)
      'sort-words:sort-case-sensitive': ->
        sortWords(atom.workspace.getActiveTextEditor())

sortWords = (editor, convertFn) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    words = editor.getTextInBufferRange(range).trim().split(/\s+/g)
    words.sort (a, b) ->
      a = if convertFn then convertFn(a) else a
      b = if convertFn then convertFn(b) else b
      alen = a.length
      blen = b.length
      for i in [0...Math.min(alen, blen)]
        ca = a.codePointAt(i)
        cb = b.codePointAt(i)
        return -1 if ca < cb
        return 1 if ca > cb
      return if alen < blen then -1 else (if alen == blen then 0 else 1)

    editor.setTextInBufferRange(range, words.join(' '))
