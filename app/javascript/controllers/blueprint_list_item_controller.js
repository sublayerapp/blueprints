import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: Number
  }

  delete(event) {
    event.preventDefault()
    console.log("In here");
    if (confirm("Are you sure you want to delete this blueprint?")) {
      fetch(`/blueprints/${this.idValue}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        }
      }).then(() => {
        this.element.parentNode.parentNode.remove()
        }).catch(error => {
          console.log(error)
        })
    }
  }
}
