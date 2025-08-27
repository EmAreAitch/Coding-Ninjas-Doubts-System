import { Controller } from "@hotwired/stimulus"
import HotwireNotyf from "misc/hotwire_notyf"
// Connects to data-controller="flash"
export default class extends Controller {
  static values = { type: String }      
  
  connect() {    
    HotwireNotyf[this.typeValue](this.element.textContent)
  }
}
