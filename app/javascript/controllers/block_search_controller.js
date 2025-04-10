import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["results", "input"]

  connect() {
    this.element.addEventListener('mouseenter', this.focusInput.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('mouseenter', this.focusInput.bind(this))
  }

  focusInput() {
    this.inputTarget.focus()
  }

  filter(event) {
    const query = event.target.value.toLowerCase()
    const blockLinks = this.resultsTarget.querySelectorAll(".data-block-type")
    
    blockLinks.forEach(link => {
      const text = link.textContent.toLowerCase()
      if (text.includes(query)) {
        link.classList.remove("hidden")
      } else {
        link.classList.add("hidden")
      }
    })
  }
  
  handleKeydown(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
      
      const firstVisibleLink = this.resultsTarget.querySelector('.data-block-type:not(.hidden)')
      
      if (firstVisibleLink) {
        firstVisibleLink.click()
      }
    }
  }
} 