import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.element.value) {
      this.element.focus()
      
      const valueLength = this.element.value.length
      this.element.setSelectionRange(valueLength, valueLength)
    }
  }
} 