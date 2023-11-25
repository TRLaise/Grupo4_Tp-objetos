import wollok.game.*

class Mascota{
	
	var property reir = false
	var property hambre = true
	var property cansado = false
	var property comio = false
	var property jugo = false
	var property edad = 0
	var property energiaInicial = 0
	var property energiaActual = 0
	var property totalSaludables = 0
    var property totalInsalubres = 0
    var property cantAcciones = 0

	var property image = "pou limpio sonrriendo.png"
	var property position = game.at(2,3)

//es necesario inicializar "edad" antes de llamar a este metodo
	method iniciarJuego(){
		game.width(5)
		game.height(7)
		game.cellSize(100)
		game.title("Jueguito Pou")
		game.onTick(500, "actualizar", { self.actualizarEstadoPou() })
		game.start()
		game.addVisual(self)
		game.addVisual(pelota)
		game.addVisual(ducha)
		game.addVisual(energizante)
		game.addVisual(lampara)
		game.addVisual(comestibles)
		game.addVisual(estadisticas)
		keyboard.num1().onPressDo { self.baniarse()}
		keyboard.num2().onPressDo { self.jugar()}
		keyboard.num3().onPressDo { self.dormir()}
		keyboard.num4().onPressDo { self.energizarse()}
		keyboard.q().onPressDo { self.comer(fruta)}
		keyboard.w().onPressDo { self.comer(verdura)}
		keyboard.e().onPressDo { self.comer(bebida)}
		keyboard.r().onPressDo { self.comer(fritura)}
		keyboard.t().onPressDo { self.comer(carne)}	
	}
	
	method actualizarEstadoPou(){
		estadisticas.setearEstadisticas(self)
	
		//esta limpio y no se rie
		if(!self.estaSucio() && !reir)
		{
			image = "pou limpio sin sonrreir.png"
		}
		//esta limpio y se rie
		else if(!self.estaSucio() && reir)
		{
			image = "pou limpio sonrriendo.png"
		}
		//esta sucio y no se rie
		else if(self.estaSucio() && !reir)
		{
			image = "pou sucio sin sonrreir.png"
		}
		//esta sucio y se rie
		else
		{
			image = "pou sucio sonrriendo.png"
		}
	}

 method estaSucio(){
   		return comio && jugo
 }

 method asignarEdad(edadAsignada){
		edad = edadAsignada;
		energiaActual = edadAsignada * 10
		energiaInicial = energiaActual
 }

 method controlEnergia(){
 	
 	if(self.energiaActual() < self.energiaInicial()){
 		self.energizarse()
 		game.say(self, "Nivel de energia menor al inicial")
 	}
 	
 }
 
 method comer(alimento) {
	
	energiaActual += alimento.energiaQueAporta()
	if(alimento.esSaludable()) totalSaludables++
    else totalInsalubres++;
    
	if(hambre){
		reir = false
	}else reir = true
	
    hambre = false
    comio = true
    
	self.controlEnergia()
 }
 
method jugar() {
     energiaActual -= 3
     reir = true
     jugo = true
     
     self.controlEnergia()
}

method jugarConOtro(otraMascota) {
	
	if (self.estaAburrido() && otraMascota.estaAburrido()){
 		self.jugar()
    	otraMascota.jugar()
    }else if (self.estaAburrido() != otraMascota.estaAburrido() && self.menosEnergiaQue(otraMascota)){
        throw new Exception(message = "El pou feliz tiene menos energia que el pou aburrido")
    }	  
    
    self.controlEnergia()
}
   
 method estaAburrido(){
	return (self.estadoSalud() == "ABURRIDO")
}

 method menosEnergiaQue(otraMascota){
	return self.energiaActual() <= otraMascota.energiaActual()
}

 method baniarse() {
	if(comio && jugo)
	  comio = false
	  jugo = false
	  reir = false
	  energiaActual -= 2
	  
	  self.controlEnergia()
}
 
 method energizarse(){
	if(reir && energiaActual <= energiaInicial)
	  energiaActual = energiaInicial
 }
 
 method dormir(){
    energiaActual += 0.1 * energiaInicial
    reir = true
 }
 
 method estaSaludable() = ((totalSaludables + totalInsalubres)*(0.01)) > totalInsalubres //Devuelve un Booleano verificando que cumple con el 1%

 method estadoSalud() {
 
    if (totalInsalubres > totalSaludables) {
      return "DEPLORABLE"
    } else if (totalInsalubres == totalSaludables && !reir) {
      return "ALARMANTE"
    } else if ( self.estaSaludable() && reir) {
      return "NORMAL"
    } else if ( self.estaSaludable() && !reir) {
      return "ABURRIDO"
    }
    
    return "INCIERTO"
    
 }

}

object pouAdulto inherits Mascota{
	
override method comer(alimento) {
	
	energiaActual += alimento.energiaQueAporta()
	if(alimento.esSaludable()) totalSaludables++
    else totalInsalubres++;
    
	if(hambre){
		reir = false
	}else reir = true
	
    hambre = false
    comio = true
    cantAcciones++
    
    if(cantAcciones == 5){
			edad += 1
			cantAcciones = 0
	}
	
	self.controlEnergia()
 }
 
override method jugar() {
	
 	energiaActual -= 3
	reir = true
	jugo = true
	cantAcciones++	
	
	 if(cantAcciones == 5){
			edad += 1
			cantAcciones = 0
	}

	self.controlEnergia()
}
	
override method baniarse(){
	if(comio && jugo)
	  comio = false
	  jugo = false
	  reir = false
	  energiaActual -= 2
	  cantAcciones++
    
    if(cantAcciones == 5){
			edad += 1
			cantAcciones = 0
	}
	
	self.controlEnergia()
 }
 
override method energizarse(){
	if(reir && energiaActual <= energiaInicial)
	  energiaActual = energiaInicial
	  
	cantAcciones++
    
    if(cantAcciones == 5){
			edad += 1
			cantAcciones = 0
	}
 }
 
override method dormir(){
    energiaActual += 0.1 * energiaInicial
    reir = true
    cantAcciones++
    
    if(cantAcciones == 5){
			edad += 1
			cantAcciones = 0
	}
 }
 
}

class Alimento{
	
	var property elementoCocina = null
	
	
	method energiaQueAporta(){
		
		if(!elementoCocina.frie()){
			return 0.2
		  }else{
			return -0.2
		}
	}
	
	method esSaludable(){
		return !elementoCocina.frie()
	}
	
}

object sarten {
	const property frie = false
}

object freidora {
	const property frie = true
}

object plancha {
	const property frie = false
}

object olla {
	const property frie = false
}

object fruta inherits Alimento{
	
	override method energiaQueAporta(){
		return 1
	}
	
	override method esSaludable(){
		return true
	}
	
}

object verdura inherits Alimento{
	
	override method energiaQueAporta(){
		return 1
	}
	
	override method esSaludable(){
		return true
	}

}

object bebida inherits Alimento{
	
	override method energiaQueAporta(){
		return 0.5
	}
	
	override method esSaludable(){
		return true
	}
} 

object carne inherits Alimento{}

object fritura inherits Alimento{}

object pelota
{
	var property position = game.at(1,0) 
	var property image = "pelota.png"
	}

object ducha
{
	var property position = game.at(0,0) 
	var property image = "duchador.png"
}

object energizante
{
	var property position = game.at(3,0) 
	var property image = "energizante.png"
}

object lampara
{
	var property position = game.at(2,0) 
	var property image = "lampara.png"
}

object comestibles
{
	var property position = game.at(4,1) 
	var property image = "comestibles.png"
}

object estadisticas
{
	var property text = ""
	var property position = game.at(1,6)
	method setearEstadisticas(pou)
	{	
		text = "Energia Actual: " + pou.energiaActual() + "\nEstado de Salud: " + pou.estadoSalud()
	}

}
