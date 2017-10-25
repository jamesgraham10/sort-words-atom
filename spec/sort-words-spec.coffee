describe 'sorting words', ->
  [activationPromise, editor, editorView] = []

  runCommand = (commandName, callback) ->
    atom.commands.dispatch(editorView, commandName)
    waitsForPromise -> activationPromise
    runs(callback)

  sortWordsCaseInsensitive = (callback) ->
    runCommand('sort-words:sort-case-insensitive', callback)

  sortWordsCaseSensitive = (callback) ->
    runCommand('sort-words:sort-case-sensitive', callback)

  beforeEach ->
    waitsForPromise -> atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)
      activationPromise = atom.packages.activatePackage('sort-words')

  describe 'when nothing is selected', ->
    it 'sorts all words in all lines (case-insensitive)', ->
      editor.setText(
        'Hydrogen abc Zyx \n' +
        'Helium   \n' +
        'Lithium    '
      )
      editor.setCursorBufferPosition [0, 0]

      sortWordsCaseInsensitive ->
        expect(editor.getText()).toBe('abc Helium Hydrogen Lithium Zyx')

    it 'sorts all words in all lines (case-sensitive)', ->
      editor.setText(
        'Hydrogen abc Zyx \n' +
        'Helium   \n' +
        'Lithium    '
      )
      editor.setCursorBufferPosition [0, 0]

      sortWordsCaseSensitive ->
        expect(editor.getText()).toBe('Helium Hydrogen Lithium Zyx abc')

  describe 'when entire lines are selected', ->
    it 'sorts the selected lines as if newlines were spaces', ->
      editor.setText(
        'Hydrogen  \n' +
        'Helium    \n' +
        'Lithium   \n' +
        'Beryllium \n' +
        'Boron     \n'
      )
      # Select from `Helium` to before `Boron` (including the newline,
      # which should be trimmed away)
      editor.setSelectedBufferRange [[1, 0], [4, 0]]
      expect(editor.getTextInBufferRange(editor.getSelectedBufferRange())).toBe(
        'Helium    \n' +
        'Lithium   \n' +
        'Beryllium \n'
      )

      sortWordsCaseSensitive ->
        expect(editor.getText()).toBe(
          'Hydrogen  \n' +
          'Beryllium Helium LithiumBoron     \n'
        )
