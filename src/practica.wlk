

class Attack{
    var property potencia = 0
}

class AtaqueFisico inherits Attack{
    method calcularDaño(enemigo, atacante) {
        const razaEnemigo = enemigo.miRaza()
        var daño
        daño = razaEnemigo.calcularDaño(enemigo, self).max(1)
      return daño
    }
}

class Hechizo inherits Attack{
    var property elemento 
    method calcularDaño(enemigo, atacante) {
        var daño = potencia
        const elementoEnemigo = enemigo.miElemento()
        if (elementoEnemigo.soyDebilA() == elemento){
            daño = daño*2
        }
        if (elementoEnemigo == elemento) { return 0 }
        return daño
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
    method recibirAtaque(ataque, atacante) {
        self.puntosDeVida((self.puntosDeVida() - ataque.calcularDaño(self, atacante)).max(0))
    }

}

// Espada
class Espada {
    var property poderFisico
    var property poderMagico 
}
object llaveDelReino inherits Espada (poderFisico = 3, poderMagico = 5){}

object exploradorEstelar inherits Espada(poderFisico = 2, poderMagico = 10){}

object caminoAlAlba inherits Espada(poderFisico = 5, poderMagico = 3){} 

object brisaDescarada inherits Espada(poderFisico = 5, poderMagico = 2){} 


// Hechizo

class Piro inherits Hechizo(potencia = 5, elemento = elementoFuego){}
class Chispa inherits Hechizo(potencia = 1, elemento = elementoLuz){}
class Ragnarok inherits Hechizo(potencia = 30, elemento = elementoLuz){}

// Heroes
class ExcepcionPMInsuficiente inherits wollok.lang.Exception {}
class Heroe{
    var property puntosDeMana
    var property fuerza
    var property espada
    var property ataqueFisico = new AtaqueFisico(potencia = fuerza + espada.poderFisico())
    method realizarAtaqueFisico(enemigo){
        enemigo.recibirAtaque(ataqueFisico, self)
    }
    method lanzarHechizo(enemigo, hechizo){
        if (puntosDeMana > hechizo.potencia()){
            self.puntosDeMana((puntosDeMana-hechizo.potencia()).max(0))
            hechizo.potencia(hechizo.potencia()*espada.poderMagico())
            enemigo.recibirAtaque(hechizo, self)
            }
            throw new ExcepcionPMInsuficiente()
    }
    method descansar() { self.puntosDeMana(30) }
}

object sora inherits Heroe(fuerza = 10, puntosDeMana = 8, espada = llaveDelReino){}
object mickey inherits Heroe(fuerza = 5, puntosDeMana = 13, espada = exploradorEstelar){}
object riku inherits Heroe(fuerza = 15, puntosDeMana = 4, espada = caminoAlAlba){}

// Equipos
class Equipo {
    const property integrantes
    method necesitamosFrenar(){
        return integrantes.any{miembro => (miembro.puntosDeMana() == 0)}
    }
    method emboscar(enemigo){
        integrantes.map{miembro => miembro.realizarAtaqueFisico(enemigo)}
    }
    method convieneCambiarEspadaPor(llaveEspada){
        return integrantes.filter{miembro => (miembro.ataqueFisico().potencia() < (llaveEspada.poderFisico() + miembro.fuerza()))}
    }
    method hallarMejorCandidatoPara(llaveEspada, lista){
        const candidato = lista.anyOne()
        if (lista.length() > 1 && lista.any{miembro => ((miembro.fuerza()+llaveEspada.poderFisico()) - miembro.ataqueFisico().potencia() > (candidato.fuerza()+llaveEspada.poderFisico()) - miembro.ataqueFisico().potencia())}){
            return self.hallarMejorCandidatoPara(llaveEspada, lista.filter{ miembro => !(miembro == candidato)})
        }
        return candidato
    }
    method legarEspada(llaveEspada){
        if (!self.convieneCambiarEspadaPor(llaveEspada).isEmpty()) {
            self.hallarMejorCandidatoPara(llaveEspada, self.convieneCambiarEspadaPor(llaveEspada)).espada(llaveEspada)
        }
    }
}

