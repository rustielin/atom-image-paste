'use babel';

import AtomImagePasteView from './atom-image-paste-view';
import { CompositeDisposable } from 'atom';

export default {

  atomImagePasteView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.atomImagePasteView = new AtomImagePasteView(state.atomImagePasteViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.atomImagePasteView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'atom-image-paste:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.atomImagePasteView.destroy();
  },

  serialize() {
    return {
      atomImagePasteViewState: this.atomImagePasteView.serialize()
    };
  },

  toggle() {
    console.log('AtomImagePaste was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
