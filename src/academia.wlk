
class Academia{
	const property muebles =#{}
	method tiene(cosa){
		return muebles.any({mueble => mueble.tiene(cosa	)})
	}
	method dondeGuarda(cosa){
		return muebles.findOrElse({mueble => mueble.tiene(cosa)},{self.error("No tengo ese objeto")})
	}
	method sePuedeGuardar(cosa){
		return muebles.any({mueble => mueble.sePuedeGuardar(cosa)})
	}
	method dondeSePuedeGuardar(cosa){
		return muebles.filter({mueble => mueble.sePuedeGuardar(cosa)})
	}
	method guardarCosa(cosa){
		self.validarGuardado(cosa)
		self.dondeSePuedeGuardar(cosa).anyOne().guardarCosa(cosa)
	}
	method validarGuardado(cosa){
		if (not self.sePuedeGuardar(cosa)) self.error("No se puede guardar este objeto en la acade")
	}
	
}
class Marca{
	
}
class Mueble{
	const contenido = #{}
	method guardarCosa(cosa){
		self.validarGuardado(cosa)
		contenido.add(cosa)
		cosa.guardarse()
	}
	method validarGuardado(cosa){
		if (not self.sePuedeGuardar(cosa)) self.error("Esa cosa no se puede guardar")
	}
	method tiene(cosa){
		return contenido.contains(cosa)
	}
	method sePuedeGuardar(cosa){
		return cosa.sePuedeGuardar()
	}
}
class CosaGuardable{
	const property volumen  //numero
	const property marca // marca
	const property esMagica // Booleano
	const property esReliquia // Booleano
	var property estaGuardado = false// Booleano
	method sePuedeGuardar(){
		return not self.estaGuardado()
	}
	method guardarse(){
		estaGuardado = true
	}
}

class Armario inherits Mueble{
	var capacidadMaxima
	
	method capacidadMaxima(){
		return capacidadMaxima
	}
	
	override method sePuedeGuardar(cosa){
		return super(cosa) && self.hayEspacio()
	}
	method hayEspacio(){
		return self.capacidadMaxima() > contenido.size() 
	}
	method cambiarCapacidadMaxima(capacidadNueva){
		capacidadMaxima = capacidadNueva
	}
}

class Baul inherits Mueble{
	const property capacidadMaximaDeVolumen //numero
	
	method volumenActual(){
		return contenido.sum({cosa => cosa.volumen()})
	}
	override method sePuedeGuardar(cosa){
		return super(cosa) && not self.superaLaCapacidadMaxima(cosa)
	}
	method superaLaCapacidadMaxima(cosa){
		return (cosa.volumen() + self.volumenActual()) > self.capacidadMaximaDeVolumen()
	}
	
}
class GabineteMagico inherits Mueble{
	
	override method sePuedeGuardar(cosa){
		return super(cosa) && cosa.esMagica()
	}
}