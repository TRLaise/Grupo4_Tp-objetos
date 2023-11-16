class Mascota {
    var reir = false
    var hambre = true
    var cansado = false
    var comio = false
    var jugo = false
    var edad = 0
    var energiaInicial
    var energiaActual
    var totalSaludables = 0
    var totalInsalubres = 0

    method EstaSucio() {
        return comio && jugo
    }

    method asignarEdad(edadAsignada) {
        edad = edadAsignada
        energiaActual = edadAsignada * 10
        energiaInicial = energiaActual
    }

    method comer(alimento) {
        energiaActual += alimento.energiaAportada()

        if (alimento.esSaludable()) totalSaludables++
        else totalInsalubres++;

        if (hambre) {
            reir = false
        } else reir = true

        hambre = false
        comio = true
    }

    method jugar(juego) {
        energiaActual -= 3
        reir = true
        jugo = true
    }

    method baniarse() {
        if (comio && jugo) {
            comio = false
            jugo = false
            reir = false
            energiaActual -= 2
        }
    }

    method energizarse() {
        if (reir && energiaActual <= energiaInicial)
            energiaActual = energiaInicial
    }

    method dormir() {
        energiaActual += 0.1 * energiaInicial
        reir = true
    }

    method estaSaludable() = ((totalSaludables + totalInsalubres) * (0.01)) > totalInsalubres

    method estadoSalud() {
        if (totalInsalubres > totalSaludables) {
            return "DEPLORABLE"
        } else if (totalInsalubres == totalSaludables && !reir) {
            return "ALARMANTE"
        } else if (self.estaSaludable() && reir) {
            return "NORMAL"
        } else if (self.estaSaludable() && !reir) {
            return "ABURRIDO"
        }

        return "INCIERTO"
    }
}

class PouAdulto extends Mascota {
    method envejecer() {
        edad += 1
    }

    override method estaDormido() {
        return edad >= 10
    }
}
method jugarConOtro(otraMascota) {
        if (self.estaAburrido() && otraMascota.estaAburrido()) {

            // metodo para jugar con otro 

            self.reir = true
            otraMascota.reir = true
        } else if (self.estaAburrido() && !otraMascota.estaAburrido()) {
            throw Exception("¡Pou aburrido quiere jugar con Pou feliz!");
        } else if (otraMascota.estaAburrido() && otraMascota.energiaActual < self.energiaActual) {
            throw Exception("¡Pou aburrido tiene menos energía que Pou feliz!");
        } 
    }
}
