package janus

import groovy.time.TimeCategory

class MatrizController extends janus.seguridad.Shield {

    def preciosService
    def dbConnectionService

    def index() {}


    def coeficientes() {
        //println "coef "+params
        def obra = Obra.get(params.id)
        def fp = FormulaPolinomica.findAllByObra(obra, [order: "numero"])
        [obra: obra, fp: fp]
    }

    def pantallaMatriz_old() {
        println "....." + params
        def obra = params.id
        def cn = dbConnectionService.getConnection()
        def sql = "SELECT clmncdgo,clmndscr,clmntipo from mfcl where obra__id = ${obra} and sbpr__id = ${params.sbpr} order by  1"
//        println "sql desc "+sql
        def columnas = []
        def nombre = ""
        def cont = 0
        def indices = ["mano": [], "saldo": [], "total": []]
        cn.eachRow(sql.toString()) { r ->
            def col = ""
            if (r[2] != "R") {
                def parts = r[1].split("_")
                //println "parts "+parts
                //def num
                try {
                    nombre = Item.get(parts[0].toLong()).nombre
                    col = nombre.size() > 60 ? nombre[0..60] + "..." : nombre
                } catch (e) {
                    //println "matriz controller l 37: "+"error: " + e
                    col = parts[0]
                }

                if (col =~ "Mano de Obra") {
                    indices["mano"].add(cont)
                }
                if (col =~ "SALDO") {
                    indices["saldo"].add(cont)
                }
                if (col =~ "TOTAL") {
                    indices["total"].add(cont)
                }
                //println "col "+col
                col += " " + parts[1]?.replaceAll("T", "<br/>Total")?.replaceAll("U", "<br/>Unitario")
            }

            columnas.add([r[0], col, r[2]])
            cont++
        }
        println "columnas $columnas"

        session.indices = indices
        def titulo = Obra.get(obra).desgloseTransporte == "S" ? 'Matriz con desglose de Transporte' : 'Matriz sin desglose de Transporte'
        [obra: obra, cols: columnas, titulo: titulo, sbpr: params.sbpr]
    }

    def matrizPolinomica() {
        println "matriz " + params
        def obra = params.id
        def offset = params.inicio
        def indices = session.indices
        if (!offset)
            offset = 0
        else
            offset = offset.toInteger()
        def limit = params.limit.toInteger()
        offset = offset * limit
        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = "SELECT clmncdgo, clmndscr, clmntipo from mfcl where obra__id = ${obra} and sbpr__id = ${params.sbpr}  order by 1"

        def columnas = []
        def filas = []
        def cont = offset + 1
        cn.eachRow(sql.toString()) { r ->
            columnas.add([r[0], r[1], r[2]])
        }
        sql = "SELECT * from mfrb where obra__id =${obra} and sbpr__id = ${params.sbpr} order by orden limit ${limit} offset ${offset}"

/*
        cn.eachRow(sql.toString()) { r ->
            def tmp = [cont, r[0].trim(), r[2], r[3], r[4]]
            def sq = ""
            columnas.each { c ->
                if (c[2] != "R") {
                    sq = "select valor from mfvl where clmncdgo=${c[0]} and codigo='${r[0].trim()}' and obra__id =${obra} and sbpr__id = ${params.sbpr}"
                    cn2.eachRow(sq.toString()) { v ->
                        tmp.add(v[0])
                    }
                }
            }
            filas.add(tmp)
            cont++
        }
*/

        def sq = "select * from valores(${obra}, ${params.sbpr}) order by 1 limit ${limit} offset ${offset}"
        cn2.eachRow(sq.toString()) { v ->
            def tmp = [cont, v.cdgo.trim(), v.rbro, v.undd, v.cntd]
//            filas += "<tr style='font-size: 10px !important;' class='item_row' fila_${cont}>"
//            filas += "<td>${v.ordn}</td><td>${v.cdgo}</td><td>${v.rbro}</td><td>${v.undd}</td><td>${v.cntd}</td>"
            def valores = v.vlor.getArray()
            valores.each() {
                tmp.add(it)
//                filas += "<td>${it}</td>"
            }
            filas.add(tmp)
            cont++
//                        if(cont == 1) println "f: $filas"
        }

        println "$filas"
        if (filas.size() == 0)
            render "fin"
        else
            [filas: filas, cols: columnas, obraId: params.id, offset: offset, indices: indices, sbpr: params.sbpr]
    }

    def insertarVolumenesItem() {
//        println "insert vlobitem "+params
        def obra = Obra.get(params.obra)
        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def updates = dbConnectionService.getConnection()
        def sql = "SELECT v.voit__id,v.obra__id,v.item__id,v.voitpcun,v.voitcntd,v.voitcoef,v.voitordn,v.voittrnp,v.voitrndm, " +
                "i.itemnmbr,i.dprt__id,d.sbgr__id,s.grpo__id, o.clmndscr, o.clmncdgo " +
                "from vlobitem v, dprt d, sbgr s, item i, mfcl o " +
                "where v.item__id=i.item__id and i.dprt__id=d.dprt__id and d.sbgr__id=s.sbgr__id  and o.clmndscr = i.itemcmpo || '_T' and " +
                "v.obra__id = ${params.obra} and o.obra__id=${params.obra}  and v.sbpr__id = ${params.sbpr} and o.sbpr__id = v.sbpr__id " +
                "order by s.grpo__id"
//        println "sql "+sql
        cn.eachRow(sql.toString()) { r ->
//            println "r-> "+r
            def codigo = ""
            if (r['grpo__id'] == 1 || r['grpo__id'] == 3)
                codigo = "sS3"
            else
                codigo = "sS5"
            def select = "select valor from mfvl where clmncdgo=${r['clmncdgo']} and codigo='${codigo}' and obra__id =${params.obra}  and sbpr__id = ${params.sbpr} "
            def valor = 0
            cn2.eachRow(select.toString()) { r2 ->
//                println "r2 "+r2
                valor = r2['valor']
                if (!valor)
                    valor = 0
                def sqlUpdate = "update vlobitem set voitcoef= ${valor} where voit__id = ${r['voit__id']}"
                updates.execute(sqlUpdate.toString())
            }
        }

        def fp = FormulaPolinomica.findAllByObra(obra)
        if (fp.size() == 0) {
            def indice21 = Indice.findByCodigo("021")
            def indiSldo = Indice.findByCodigo("SLDO")
            def indiMano = Indice.findByCodigo("MO")
            def indiPeon = Indice.findByCodigo("C.1")
            11.times {
                def fpx = new FormulaPolinomica()
                fpx.obra = obra
                if (it < 10) {
                    fpx.numero = "p0" + (it + 1)
                    if (it == 0) {
                        fpx.indice = indiMano
                        def select = "select clmncdgo from mfcl where clmndscr = 'MANO DE OBRA_T' and obra__id = ${params.obra} "
                        def columna
                        def valor = 0
                        //println "sql it 0 mfcl "+select
                        cn.eachRow(select.toString()) { r ->
                            columna = r[0]
                        }
                        select = "select valor from mfvl where clmncdgo=${columna} and codigo='sS3' and obra__id =${params.obra} "
                        cn.eachRow(select.toString()) { r ->
                            valor = r[0]
                        }
                        if (!valor)
                            valor = 0
                        fpx.valor = valor
                    } else {
                        if (it == 9)
                            fpx.numero = "p" + (it + 1)
                        fpx.indice = indice21
                        fpx.valor = 0
                    }
                } else {
                    fpx.numero = "px"
                    fpx.indice = indiSldo
                    fpx.valor = 0
                }
                if (!fpx.save(flush: true))
                    println "matriz controller l 164: " + "error save fpx " + fpx.errors

                if (it < 10) {
                    def cuadrilla = new FormulaPolinomica()
                    cuadrilla.obra = obra
                    cuadrilla.numero = "c0" + (it + 1)
                    if (it == 9)
                        cuadrilla.numero = "c" + (it + 1)
                    cuadrilla.valor = 0
                    cuadrilla.indice = indiPeon
                    if (!cuadrilla.save(flush: true))
                        println "matriz controller l 175: " + "error save cuadrilla " + cuadrilla.errors
                }


            }
        }
        render "ok"
    }


//    def matrizFP() {
    def pantallaMatriz() {
        println "....." + params
        def inicio = new Date()
        def obra = params.id
        def cn = dbConnectionService.getConnection()
        def sql = "SELECT clmncdgo,clmndscr,clmntipo from mfcl where obra__id = ${obra} and sbpr__id = ${params.sbpr} order by  1"
        println "sql desc "+sql
        def columnas = []
        def nombre = ""
        def cont = 0
        def indices = ["mano": [], "saldo": [], "total": []]
        def filas = ""
        def filasF = ""
        cn.eachRow(sql.toString()) { r ->
            def col = ""
            if (r[2] != "R") {
                def parts = r[1].split("_")
                //println "parts "+parts
                try {
                    nombre = Item.get(parts[0].toLong()).nombre
                    col = nombre.size() > 60 ? nombre[0..60] + "..." : nombre
                } catch (e) {
                    //println "matriz controller l 37: "+"error: " + e
                    col = parts[0]
                }

                if (col =~ "Mano de Obra") {
                    indices["mano"].add(cont)
                }
                if (col =~ "SALDO") {
                    indices["saldo"].add(cont)
                }
                if (col =~ "TOTAL") {
                    indices["total"].add(cont)
                }
                //println "col "+col
                col += " " + parts[1]?.replaceAll("T", "<br/>Total")?.replaceAll("U", "<br/>Unitario")
            }
            columnas.add([r[0], col, r[2]])
            cont++
        }
//        println "columnas $columnas"


        def cn2 = dbConnectionService.getConnection()
        def fin = new Date()

        println "1---- ${TimeCategory.minus(fin, inicio)}"

        filas = ""
        filasF = ""

        def estilo
        def estiloF
        def offset = params.offset?: 0
        println("off " + offset)
        cont = offset.toInteger()

        /** usar el parámetro pagina **/
        def sq = "select * from valores(${obra}, ${params.sbpr}) order by 1 limit 30 offset $offset"
        def gris = ""
        def i = 0
        println("sq " + sq)
        cn2.eachRow(sq.toString()) { v ->

            gris = (cont%2==0)? 'gr' : 'bl'
            estilo = "class=\"rb f_" + cont + " " + gris + "\" color=\"" + gris + "\" f=\"f_" + cont + "\" num=\"" + cont + "\" id='r" + cont + "'"
            estiloF = "id='rf" + cont + "'"
//            println "estilo: $estilo"
            filas += "<tr $estilo>"
//            filas += "<td class='lb'>${cont}</td><td class='lb'>${v.cdgo}</td><td class='lb'>${v.rbro}</td><td class='lb'>${v.undd?:''}</td><td class='nn'>${v.cntd?:''}</td>"
            filas += "<td class='lb'>${v.rbro}</td><td class='lb'>${v.undd?:''}</td><td class='nn'>${v.cntd?:''}</td>"
            filasF += "<tr $estiloF >"
            filasF += "<td class='lb estaticas c_0'>${cont}</td><td class='lb estaticas c_1'>${v.cdgo}</td><td class='lb hh'>${v.rbro}</td>"
            def valores = v.vlor.getArray()
            i = 5

            for(j in (0..valores.size()-1)) {
                estilo = "class=\"c_" + i + "\" c=\"" + i + "\""
                filas += "<td " + estilo + ">" + valores[j] + "</td>"
                i++
            }

            filas += "</tr>"
            filasF += "</tr>"
            cont++
        }
        fin = new Date()
        println "2---- ${TimeCategory.minus(fin, inicio)}"
//        }

        fin = new Date()
        println "3---- ${TimeCategory.minus(fin, inicio)}"

        def titulo = Obra.get(obra).desgloseTransporte == "S" ? 'Matriz con desglose de Transporte' : 'Matriz sin desglose de Transporte'

        [obra: obra, cols: columnas, titulo: titulo, sbpr: params.sbpr, cols: columnas, indices: indices, offset: cont, filas: filas, filasF: filasF]
    }


}
