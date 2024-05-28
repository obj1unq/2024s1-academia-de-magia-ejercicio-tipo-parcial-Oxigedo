
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
	method cosasMenosUtiles(){
		return muebles.map({mueble => mueble.cosaMenosUtil()}).asSet()
	}
	method marcaDeLaCosaMenosUtil(){
		return self.cosaMenosUtil().marca()
	}
	method cosaMenosUtil(){
		return self.cosasMenosUtiles().min({cosa => cosa.utilidad()})
	}
	method cosasMenosUtilesNoMagicas(){
		return self.cosasMenosUtiles().filter({cosa => not cosa.esMagica()})
	}
	method removerCosasMenosUtilesNoMagicas(){
		self.cosasMenosUtilesNoMagicas().forEach({cosa => self.removerCosa(cosa)})
	}
	method removerCosa(cosa){
		self.dondeGuarda(cosa).removerCosa(cosa)
	}
	
}
object acme{
	method utilidadQueAporta(cosa){
		return cosa.volumen() / 2
	}
}
object fenix {
	method utilidadQueAporta(cosa){
		return if (cosa.esReliquia()) 3 else 0
	}
}
object cuchuflito{
	method utilidadQueAporta(cosa){
		return 0
	}
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
	method utilidad(){
		return contenido.sum({cosa => cosa.utilidad()}) / self.precio()
	}
	method precio(){return null}
	method cosaMenosUtil(){
		return contenido.min({cosa => cosa.utilidad()})
	}
	method removerCosa(cosa){
		self.validarRemover(cosa)
		contenido.remove(cosa)
		cosa.salirDelMueble()
	}
	method validarRemover(cosa){
		if (not contenido.contains(cosa)) self.error("No tengo esa cosa")
	}
}
class CosaGuardable{
	const property volumen  //numero
	const property marca // marca
	const property esMagica // Booleano
	const property esReliquia // Booleano
	var property estaGuardado = false// Booleano
	
	method utilidad(){
		return self.volumen() + self.indiceMagico() + self.indiceReliquia() + self.utilidadDeMarca()
	}
	method utilidadDeMarca(){
		return self.marca().utilidadQueAporta(self)
	}
	method indiceMagico(){
		return if (self.esMagica()) 3 else 0
	}
	method indiceReliquia(){
		return if (self.esReliquia()) 5 else 0
	}
	method sePuedeGuardar(){
		return not self.estaGuardado()
	}
	method guardarse(){
		estaGuardado = true
	}
	method salirDelMueble(){
		estaGuardado = false
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
	override method precio(){
		return 5 * self.capacidadMaxima()
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
	override method precio(){
		return self.capacidadMaximaDeVolumen() + 2
	}
	
	override method utilidad(){
		return super() + self.indiceUtilidadReliquias()
	}
	method indiceUtilidadReliquias(){
		return if (self.tieneSoloReliquias()) 2 else 0
	}
	method tieneSoloReliquias(){
		return contenido.all({cosa => cosa.esReliquia()})
	}
	
}
class GabineteMagico inherits Mueble{
	const precio
	override method sePuedeGuardar(cosa){
		return super(cosa) && cosa.esMagica()
	}
	override method precio(){
		return precio
	}
}
class BaulMagico inherits Baul{
	override method precio(){
		return super()*2
	}
	override method utilidad(){
		return super() + self.cantidadDeElementosMagicos()
	}
	method cantidadDeElementosMagicos(){
		return contenido.count({cosa => cosa.esMagica()})
	}
}