import wollok.game.*

object pou {
	
	var property reir = false
	var property hambre = true
	var property cansado = false
	var property comio = false
	var property jugo = false
	var property edad 
	var property energiaInicial
	var property energiaActual
	var property totalSaludables = 0
    var property totalInsalubres = 0

	var property image = "pou limpio sonrriendo.png"
	var property position = game.at(2,3)

//es necesario inicializar "edad" antes de llamar a este metodo
	method IniciarJuego()
	{
		game.width(5)
		game.height(7)
		game.cellSize(100)
		game.title("Jueguito Pou")
		game.onTick(500, "actualizar", { self.ActualizarEstadoPou() })
		game.start()
		game.addVisual(self)
		game.addVisual(pelota)
		game.addVisual(ducha)
		game.addVisual(energizante)
		game.addVisual(lampara)
		game.addVisual(comestibles)
		game.addVisual(estadisticas)
		keyboard.num1().onPressDo { self.baniarse()}
		keyboard.num2().onPressDo { self.jugar(pelota)}
		keyboard.num3().onPressDo { self.dormir()}
		keyboard.num4().onPressDo { self.energizarse()}
		keyboard.q().onPressDo { self.comer(fruta)}
		keyboard.w().onPressDo { self.comer(verdura)}
		keyboard.e().onPressDo { self.comer(bebida)}
		keyboard.r().onPressDo { self.comer(fritura)}
		keyboard.t().onPressDo { self.comer(carne)}	
	}
	
	method ActualizarEstadoPou()
	{
		estadisticas.SetearEstadisticas(self)
	
		//esta limpio y no se rie
		if(!self.EstaSucio() && !reir)
		{
			image = "pou limpio sin sonrreir.png"
		}
		//esta limpio y se rie
		else if(!self.EstaSucio() && reir)
		{
			image = "pou limpio sonrriendo.png"
		}
		//esta sucio y no se rie
		else if(self.EstaSucio() && !reir)
		{
			image = "pou sucio sin sonrreir.png"
		}
		//esta sucio y se rie
		else
		{
			image = "pou sucio sonrriendo.png"
		}
	}

method EstaSucio()
    {
    	return comio && jugo
    }

 method asignarEdad(edadAsignada){
		edad = edadAsignada;
		energiaActual = edadAsignada * 10
		energiaInicial = energiaActual
 }

 method comer(alimento) {
	
	energiaActual += alimento.energiaAportada()
	if(alimento.esSaludable()) totalSaludables++
    else totalInsalubres++;
    
	if(hambre){
		reir = false
	}else reir = true
	
    hambre = false
    comio = true
 }
 
 method jugar(juego) {
 	energiaActual -= 3
	reir = true
	jugo = true
 }
	
 method baniarse(){
	if(comio && jugo)
	  comio = false
	  jugo = false
	  reir = false
	  energiaActual -= 2
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

object fruta { 
  const property esSaludable = true
  const property energiaAportada = 1
}

object verdura {
  const property esSaludable = true
  const property energiaAportada = 1
}

object bebida {
  const property esSaludable = true
  const property energiaAportada = 0.5
}

object fritura {
  const property esSaludable = false
  const property energiaAportada = 0.2
}

object carne {
  const property esSaludable = true
  const property energiaAportada = 0
}

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
	var property position = game.at(4,0) 
	var property image = "comestibles.png"
}

object estadisticas
{
	var property text = ""
	var property position = game.at(1,6)
	method SetearEstadisticas(pou)
	{	
		text = "Energia Actual: " + pou.energiaActual() + "\nEstado de Salud: " + pou.estadoSalud()
	}
}