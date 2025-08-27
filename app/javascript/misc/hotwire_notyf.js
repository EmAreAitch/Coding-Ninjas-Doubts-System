import {Notyf} from "notyf"

class HotwireNotyf {
	static #notyf = new Notyf()	
	static #node = document.querySelector('.notyf')
	static success(msg) {		
		return HotwireNotyf.#safeNotyf().success(msg)
	}
	static error(msg) {				
		return HotwireNotyf.#safeNotyf().error(msg)
	}
	static #safeNotyf() {
		if (!HotwireNotyf.#node.isConnected) {
			HotwireNotyf.#notyf = new Notyf()
			HotwireNotyf.#node = document.querySelector('.notyf')
		}		
		return HotwireNotyf.#notyf
	}
}

export default HotwireNotyf
