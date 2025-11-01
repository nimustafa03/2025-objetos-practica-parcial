

class Attack{
    var property potencia = 1.0
}

class AtaqueFisico inherits Attack{
    method calcularDaño(enemigo) {
        const razaEnemigo = enemigo.miRaza()
        const daño = razaEnemigo.calcularDaño(enemigo, self).max(1)
      return daño
    }
}

class Hechizo inherits Attack{
    var property elemento 
    method calcularDaño(enemigo) {
        const daño = potencia
        const elementoEnemigo = enemigo.miElemento()
        if (elementoEnemigo.soyDebilA() == elemento){
            return daño*2
        }
        else { if (elementoEnemigo == elemento) { return 0 } 
        return daño
        }
    }
}

// Elementos

object elementoFuego{
    method soyDebilA() = elementoHielo
}
object elementoHielo{
    method soyDebilA() = elementoFuego
}
object elementoLuz{
    method soyDebilA() = elementoOscuridad
}
object elementoOscuridad{
  method soyDebilA() = elementoLuz
}

// Razas
object incorporeo{
    method calcularDaño(enemigo, ataque) {
        const daño = (ataque.potencia() - enemigo.valorDeDefensa()).abs()
        return daño
    }
}

object sinCorazon {
    method calcularDaño(enemigo, ataque) {
        const daño = ataque.potencia()*0.9
        return daño
    }
}

class Enemigo{
    var property miRaza
    var property miElemento
    var property puntosDeVida = 1.0
    var property valorDeDefensa = 1.0 
    method recibirAtaque(ataque) {
        self.puntosDeVida((self.puntosDeVida() - ataque.calcularDaño(self)).max(0))
    }

}