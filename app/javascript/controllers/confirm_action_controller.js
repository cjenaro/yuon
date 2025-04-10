import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "confirmContent"]
  static values = {
    message: String,
    timeout: { type: Number, default: 3000 }
  }
  
  connect() {
    this.originalContent = this.buttonTarget.innerHTML
  }
  
  confirm(event) {
    // confirmation state
    if (this.isConfirming) {
      return true
    }
    
    event.preventDefault()
    
    this.buttonTarget.innerHTML = this.messageValue || "Are you sure?"
    this.isConfirming = true
    
    this.element.classList.add('confirming')
    this.buttonTarget.parentElement.style.setProperty('--confirm-duration', `${this.timeoutValue}ms`)
    
    this.timeoutId = setTimeout(() => {
      this.reset()
    }, this.timeoutValue)
    
    return false
  }
  
  reset() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
    
    this.element.classList.remove('confirming')
    
    this.buttonTarget.innerHTML = this.originalContent
    this.isConfirming = false
  }
} 