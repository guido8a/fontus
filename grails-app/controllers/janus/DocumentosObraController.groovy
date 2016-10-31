package janus

import groovy.json.JsonBuilder

class DocumentosObraController {

    def index() { }

    def preciosService
    def dbConnectionService

    def cargarPieSel (){
        def nota = Nota.list()
        def idFinal = Nota.list().last().id
        return [nota: nota, idFinal: idFinal]
    }

    def cargarSelMemo () {
        def notaMemo = Nota.findAllByTipo('memo')
        def idFinal = notaMemo.last()
        return [notaMemo: notaMemo, nota: idFinal]
    }

    def cargarSelFormu () {
        def notaFormu = Nota.findAllByTipo('formula')
        def idFinal = notaFormu.last()
        return [notaFormu: notaFormu, nota: idFinal]
    }


    def documentosObra () {
        def cn = dbConnectionService.getConnection()
//        def nota = new Nota();
        def auxiliar = new Auxiliar();
        def auxiliarFijo = Auxiliar.get(1);
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def obra = Obra.get(params.id)
        def departamento = Departamento.get(obra?.departamento?.id)

        def notaMemo = Nota.findAllByTipo('memo')
        def notaFormu = Nota.findAllByTipo('formula');

        if(obra.estado != 'R') {
            println "antes de imprimir rubros.. actualiza desalojo y herramienta menor"
            preciosService.ac_transporteDesalojo(obra.id)
            preciosService.ac_rbroObra(obra.id)
        }

        def totalPresupuestoBien = cn.rows("select sum(totl) suma from rbro_pcun_v2(${obra.id})".toString())[0].suma?:0
        cn.close()

        def firmasAdicionales = Persona.findAllByDepartamento(departamento)
        def funcionFirmar = Funcion.findByCodigo("F")
        def funcionDirector = Funcion.findByCodigo("D")
        def funcionCoordinador = Funcion.findByCodigo("O")
        def direccion = departamento.direccion
        def dptoDireccion = Departamento.findAllByDireccion(direccion)
        def personalDireccion = Persona.findAllByDepartamentoInList(dptoDireccion, [sort: 'nombre'])
        def firmas = PersonaRol.findAllByFuncionAndPersonaInList(funcionFirmar, firmasAdicionales)
        def firmaDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personalDireccion)
        def coordinadores = PersonaRol.findAllByFuncionAndPersonaInList(funcionCoordinador, personalDireccion)

        def duenoObra = 0

        duenoObra = esDuenoObra(obra)? 1 : 0

        def funcionCoor = Funcion.findByCodigo('O')
        def funcionDire = Funcion.findByCodigo('D')

        def personasUtfpuCoor = PersonaRol.findAllByFuncionAndPersonaInList(funcionCoor, Persona.findAllByDepartamento(Departamento.findByCodigo('DNCP')))

//        def personas = Persona.findAllByDepartamentoInList(Departamento.findAllByDireccion(Departamento.findByCodigo('UTFPU').direccion))
        def personasUtfpuDire = PersonaRol.findAllByFuncionAndPersonaInList(funcionDire,Persona.findAllByDepartamentoInList(Departamento.findAllByDireccion(Departamento.findByCodigo('DNCP').direccion)))


        def firmantes = []
//        firmantes.add([persona: personasUtfpuCoor, rol:'COORDINADOR'])
//        firmantes.add([persona: personasUtfpuDire, rol:'DIRECTOR'])
        personasUtfpuCoor.each {puc->
            firmantes.add([persona: puc, rol:'COORDINADOR'])
        }
        personasUtfpuDire.each {puc->
            firmantes.add([persona: puc, rol:'DIRECTOR'])
        }

//        println "lista de personas" + firmantes

//        personasUtfpuDire.add(personasUtfpuCoor)
        personasUtfpuDire += personasUtfpuCoor
//        def personasUtfpuDire = PersonaRol.findAllByFuncionAndPersonaInList(funcionDire, Persona.findAllByDepartamentoInList(Direccion.findByDepartamento(Departamento.findByCodigo('UTFPU'))))

//        def directorUtfpu = PersonaRol.findByFuncionAndPersonaInList(funcionDirector,Persona.findAllByDepartamento(Departamento.findByCodigo('UTFPU')))

        def dirUtfpu = Departamento.findByCodigo('DNCP').direccion

        def dptoDireccion1 = Departamento.findAllByDireccion(dirUtfpu)

        def personalDirUtfpu = Persona.findAllByDepartamentoInList(dptoDireccion1, [sort: 'nombre'])

        def directorUtfpu = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personalDirUtfpu)

//        println("Dire " + directorUtfpu?.persona?.nombre)

        //coordinador

        def personasDepartamento = Persona.findAllByDepartamento(obra?.departamento)

        def coordinadorOtros = PersonaRol.findAllByFuncionAndPersonaInList(funcionCoor, Persona.findAllByDepartamento(Departamento.get(obra?.departamento?.id)))


        def personalUtfpu =  Persona.findAllByDepartamento(Departamento.findByCodigo('DNCP'))

//        println("-->" + personalUtfpu)

        def duo = 0

        personalUtfpu.each {
             if(it.id == obra?.responsableObra?.id){
                duo = 1
             }
         }

        def firmaCambiada

        if(esDuenoObra(obra)){

        }else{

        }

        println "obra: $obra, auxiliar: $auxiliar, auxiliarFijo: $auxiliarFijo, " +
                "firmas: $firmas.persona, totalPresupuestoBien: $totalPresupuestoBien, persona: $persona, " +
//                "resComp: $resComp, resMano: $resMano, resEq: $resEq, " +
                "firmaDirector: $firmaDirector, coordinadores: $coordinadores," +
                "notaMemo: $notaMemo, notaFormu: $notaFormu, duenoObra: $duenoObra, personasUtfpuCoor: $personasUtfpuCoor," +
                "personasUtfpuDire: $personasUtfpuDire, cordinadorOtros: $coordinadorOtros, duo: $duo, directorUtfpu: $directorUtfpu"

        [obra: obra, auxiliar: auxiliar, auxiliarFijo: auxiliarFijo, firmas: firmas.persona,
                totalPresupuestoBien: totalPresupuestoBien, persona: persona,
//                resComp: resComp, resMano: resMano, resEq: resEq,
                firmaDirector: firmaDirector, coordinadores: coordinadores,
                notaMemo: notaMemo, notaFormu: notaFormu, duenoObra: duenoObra, personasUtfpuCoor: personasUtfpuCoor,
                personasUtfpuDire: personasUtfpuDire, cordinadorOtros: coordinadorOtros, duo: duo, directorUtfpu: directorUtfpu]

    }


    def esDuenoObra(obra) {
//
        def dueno = false
        def funcionElab = Funcion.findByCodigo('E')
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, Persona.findAllByDepartamento(Departamento.findByCodigo('DNCP')))
        def responsableRol = PersonaRol.findByPersonaAndFuncion(obra?.responsableObra, funcionElab)
//
//        if(responsableRol) {
////            println personasUtfpu
//            dueno = personasUtfpu.contains(responsableRol) && session.usuario.departamento.codigo == 'UTFPU'
//        }

//        println "responsable" + responsableRol + " dueño " + dueno
//                dueno = session.usuario.departamento.id == obra?.responsableObra?.departamento?.id || dueno

        if (responsableRol) {
//            println "..................."
//            println "${obra?.responsableObra?.departamento?.id} ==== ${Persona.get(session.usuario.id).departamento?.id}"
//            println "${Persona.get(session.usuario.id)}"
            if (obra?.responsableObra?.departamento?.direccion?.id == Persona.get(session.usuario.id).departamento?.direccion?.id) {
                dueno = true
            } else {
                dueno = personasUtfpu.contains(responsableRol) && session.usuario.departamento.codigo == 'DNCP'
            }
        }


//        println(" usuarioDep " + Persona.get(session.usuario.id).departamento?.direccion?.id + " respDep " + obra?.responsableObra?.departamento?.direccion?.id + " dueño " + dueno)

//        println ">>>>responsable" + responsableRol + " dueño " + dueno + " usuario " + session.usuario.departamento.id + " respDep " + obra?.responsableObra?.departamento?.id
//        println ">>>>responsable" + responsableRol + " dueño " + dueno + " usuario " + Persona.get(session.usuario.id).departamento?.direccion?.id + " respDep " + obra?.responsableObra?.departamento?.direccion?.id

        dueno
    }


    def getDatos () {
        def nota = Nota.get(params.id)
        def map
        if (nota) {
            map=[
                    id: nota.id,
                    descripcion: nota.descripcion?:"",
                    texto: nota.texto,
                    adicional:nota.adicional?:""
            ]
        } else {

            map=[
                    id: "",
                    descripcion: "",
                    texto: "",
                    adicional:""
            ]
        }
        def json = new JsonBuilder( map)
        render json
    }

    def getDatosMemo () {
        def nota = Nota.get(params.id)
        def map
        if (nota) {
            map=[
                    id: nota.id,
                    descripcion: nota.descripcion?:"",
                    texto: nota.texto,
                    adicional:nota.adicional?:""
            ]
        } else {

            map=[
                    id: "",
                    descripcion: "",
                    texto: "",
                    adicional:""
            ]
        }
        def json = new JsonBuilder( map)
        render json
    }

    def getDatosFormu () {
        def nota = Nota.get(params.id)
        def map
        if (nota) {
            map=[
                    id: nota.id,
                    descripcion: nota.descripcion?:"",
                    texto: nota.texto,
                    adicional:nota.adicional?:""
            ]
        } else {

            map=[
                    id: "",
                    descripcion: "",
                    texto: "",
                    adicional:""
            ]
        }
        def json = new JsonBuilder( map)
        render json
    }

}
