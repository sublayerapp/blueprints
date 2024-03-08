import { Controller } from "@hotwired/stimulus"
import hljs from 'highlight.js';

export default class extends Controller {
  static values = { categories: Array }

  connect() {
    const code = this.element.querySelector('code');
    const language = this.findLanguage();

    if (language) { code.classList.add(`language-${language}`) };
    hljs.highlightElement(code);
  }

  findLanguage() {
    for (const category of this.categoriesValue) {
      if (hljs.listLanguages().includes(category)) { return category; }
    }
    return null;
  }
}
