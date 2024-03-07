import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  upload_file(e) {
    e.preventDefault();

    this.fileInput().click();
  }

  submit(e) {
    e.preventDefault();

    this.element.submit();
    this.fileInput().value = null;
  }

  fileInput() {
    return this.element.querySelector("#file-input");
  }
}
