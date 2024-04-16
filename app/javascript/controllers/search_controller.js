import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  updatelist() {
    const listElement = document.querySelector("#blueprint-list");
    if (!listElement) { return; }

    listElement.querySelectorAll("li").forEach((li) => {
      li.style.display = "none";

      if (li.dataset.name.toLowerCase().includes(this.element.value.toLowerCase())) {
        li.style.display = "block";
      }
    })
  }
}
