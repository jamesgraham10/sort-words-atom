'use babel';

import SortWordsView from './sort-words-view';
import { CompositeDisposable } from 'atom';

export default {

  sortWordsView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.sortWordsView = new SortWordsView(state.sortWordsViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.sortWordsView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'sort-words:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.sortWordsView.destroy();
  },

  serialize() {
    return {
      sortWordsViewState: this.sortWordsView.serialize()
    };
  },

  sortWords(selection) {
    const hasSpaces = Boolean(selection.match(' '));

    if(hasSpaces) {
      return selection.split(/\s/g).sort().join(' ').trim();
    } else {
      return selection.split(/\./g).sort().join('.').trim();
    }
  },

  toggle() {
    let editor
    if (editor = atom.workspace.getActiveTextEditor()) {
      let selection = editor.getSelectedText();
      let sortedWords = this.sortWords(selection);
      editor.insertText(sortedWords);
    }
  }

};
