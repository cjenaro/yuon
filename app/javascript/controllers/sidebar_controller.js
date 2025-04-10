import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pageItem", "children", "dropdown", "searchInput", "sidebarPanel", "overlay"]
  static values = { expandedPages: Object }

  connect() {
    this.closeSidebar();
    
    this.setupEventListeners()
  }

  setupEventListeners() {
    document.addEventListener('click', this.closeDropdowns.bind(this))
  }

  toggleChildren(event) {
    const pageItem = event.currentTarget.closest('.page-item')
    const children = pageItem.querySelector('.children')
    const pageId = pageItem.dataset.pageId
    
    children.classList.toggle('hidden')
    
    const svg = event.currentTarget.querySelector('svg')
    svg.classList.toggle('transform')
    svg.classList.toggle('rotate-180')
    
    this.saveExpandedState(pageId, !children.classList.contains('hidden'))
  }

  saveExpandedState(pageId, isExpanded) {
    const expandedPages = { ...this.expandedPagesValue }
    
    if (isExpanded) {
      expandedPages[pageId] = true
    } else {
      delete expandedPages[pageId]
    }
    
    this.expandedPagesValue = expandedPages
    
    fetch('/update_sidebar_state', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ expanded_pages: expandedPages })
    })
  }

  toggleMenu(event) {
    event.stopPropagation()
    const pageId = event.currentTarget.id.replace('page-menu-', '')
    const dropdown = document.getElementById(`page-menu-dropdown-${pageId}`)
    
    document.querySelectorAll('[id^="page-menu-dropdown-"]').forEach(menu => {
      if (menu.id !== `page-menu-dropdown-${pageId}`) {
        menu.classList.add('hidden')
      }
    })
    
    dropdown.classList.toggle('hidden')
  }

  closeDropdowns(event) {
    if (!event.target.closest('.page-actions')) {
      document.querySelectorAll('[id^="page-menu-dropdown-"]').forEach(menu => {
        menu.classList.add('hidden')
      })
    }
  }

  search(event) {
    const searchTerm = event.currentTarget.value.toLowerCase()
    
    this.pageItemTargets.forEach(item => {
      const title = item.querySelector('a').textContent.toLowerCase()
      
      if (title.includes(searchTerm)) {
        item.style.display = ''
        let parent = item.parentElement
        while (parent && parent.classList.contains('children')) {
          parent.classList.remove('hidden')
          parent = parent.parentElement.parentElement
        }
      } else {
        const hasVisibleChildren = Array.from(item.querySelectorAll('.page-item'))
          .some(child => child.style.display !== 'none')
        
        if (!hasVisibleChildren) {
          item.style.display = 'none'
        }
      }
    })
  }

  toggleSidebar() {
    if (this.sidebarPanelTarget.classList.contains('translate-x-0')) {
      this.closeSidebar();
    } else {
      this.openSidebar();
    }
  }

  openSidebar() {
    this.sidebarPanelTarget.classList.remove('-translate-x-full');
    this.sidebarPanelTarget.classList.add('translate-x-0');
    this.overlayTarget.classList.remove('hidden');
  }

  closeSidebar() {
    if (window.innerWidth < 1024) {
      this.sidebarPanelTarget.classList.remove('translate-x-0');
      this.sidebarPanelTarget.classList.add('-translate-x-full');
      this.overlayTarget.classList.add('hidden');
    }
  }
} 