package janus

class ReportesPdfTagLib {

    static namespace = "rep"

    Closure capitalize = { attrs, body ->
        def str = body()
        if (str == "") {
            str = attrs.string
        }
        str = str.replaceAll(/[a-zA-Z_0-9áéíóúÁÉÍÓÚñÑüÜ]+/, {
            it[0].toUpperCase() + ((it.size() > 1) ? it[1..-1].toLowerCase() : '')
        })
        out << str
    }

    Closure nombrePersona = { attrs, body ->
        def persona = attrs.persona
        def str = ""
        if (persona instanceof janus.Persona) {
            str = capitalize(string: (persona.titulo ? persona.titulo + " " : "") + persona.nombre + " " + persona.apellido)
        } else if (persona instanceof janus.pac.Proveedor) {
            str = capitalize(string: (persona.titulo ? persona.titulo + " " : "") + persona.nombreContacto + " " + persona.apellidoContacto)
        }
        out << str
    }

    Closure numero = { attrs ->
        def decimales = attrs.decimales ? attrs.decimales.toInteger() : 2
        def cero = attrs.cero ? attrs.cero.toString().toLowerCase() : "hide"
        def num = attrs.numero
        println ">> " + attrs + "   " + num + "   " + cero + "   " + (num.toDouble() == 0.toDouble()) + " " + (cero.toString().toLowerCase() == "hide") + '   ' + (num == 0 && cero.toString().toLowerCase() == "hide")
        if (num.toDouble() == 0.toDouble() && cero.toString().toLowerCase() == "hide") {
            out << " ";
        } else {
            def formato = "##,###"
            def formatoDec = ""
            decimales.times {
                formatoDec += "#"
            }
            if (formatoDec != "") {
                formato += "." + formatoDec
            }
            out << formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec", format: formato)
        }
    }

    /**
     * Muestra header y footer para los reportes
     */
    def headerFooter = { attrs ->
        println("header footer attr " + attrs)
        attrs.title = attrs.title ?: ""
        def header = headerReporte(attrs)
        def footer = footerReporte(attrs)

        out << header << footer
//        out << footer
    }

    /**
     * Muestra el header para los reportes
     * @param title el título del reporte
     */
    def headerReporte = { attrs ->
        println("AQUI atributos headerReporte  " + attrs)
        def title = attrs.title ?: ""
        def titulo = attrs.titulo ?: ""

        if(!attrs.anio){
            attrs.anio = new Date().format("yyyy")
        }

        def subtitulo = attrs.subtitulo ?: ""
        def estilo = attrs.estilo ?: "center"

        def form
        if(attrs.title.contains("permanente")) {
            form = attrs.form ?: 'GAF-001'
        }  else {
            form = attrs.form ?: 'GPE-DPI-01'
        }

        def h = 55

//        def logoPath = resource(dir: 'images', file: 'logo-pdf-header.png')
        def html = ""

        html += '<div id="header">' + "\n"
//        html += "<img src='${logoPath}' style='height:${h}px;'/>" + "\n"
        html += '</div>' + "\n"
//        html += "<div class='tituloRprt tituloReporteSinLinea'>"
        html += "<div class='tituloRprt '>"
        html += "SERVICIO DE CONTRATACIÓN DE OBRAS"
        html += '</div>'

        if (titulo) {
            html += "<div class='tituloRprt'>"
            html += titulo
            html += '</div>'
        }
        if (title) {
            if (subtitulo == "") {
                html += "<div class='tituloReporte'>" + "\n"
            } else {
                html += "<div class='tituloReporteSinLinea'>" + "\n"
            }
            html += title + "\n"
            html += '</div>' + "\n"
            if (subtitulo != "") {
//                html += "<div class='tituloRprt'>"
                html += "<div class='tituloReporteSinLinea'>"
                html += subtitulo
                html += '</div>'
            }
        }
        if (titulo) {
            html += "<div class='tituloRprt'>"
            html += titulo
            html += '</div>'
        }

        if (attrs.unidad || attrs.numero != null) {
            html += "<div class='numeracion'>" + "\n"
            html += "<table border='1' ${estilo == 'right' ? 'style=\'float: right\'' : ''}>" + "\n"
            html += "<tr>" + "\n"
            html += "<td style='background: #0F243E;'>Form. ${form}</td>" + "\n"
            html += "<td style='background: #008080;'>Numeración:</td>" + "\n"
//            if(attrs.unidad.id)
//            {
//                if(attrs.title.trim().toLowerCase() in ['aval de poa', 'reforma al poa']) {
//
//                    html += "<td style='background: #008080;'>${attrs.anio}-GPE</td>" + "\n"
//                }
//                if(attrs.title.trim().toLowerCase() in ['aval de poa de gasto permanente', 'ajuste al poa de gasto permanente', 'reforma al poa de gasto permanente']){
//                    html += "<td style='background: #008080;'>${attrs.anio}-GAF</td>" + "\n"
//                }
//            }else{
//            }

            html += "<td style='background: #008080;'>No. ${attrs.numero != null ? attrs.numero.toString().padLeft(3, '0') : ''}</td>" + "\n"
            html += "</tr>" + "\n"
            html += "</table>" + "\n"
            html += "</div>" + "\n"
        }

        out << raw(html)
    }

    /**
     * Muestra el footer para los reportes
     */
    def footerReporte = { attrs ->
        def html = ""
        def h = 50
//        def logoPath = resource(dir: 'images', file: 'logo-pdf-footer.png')

        html += '<div id="footer">'
//        html += "<img src='${logoPath}' style='height:${h}px; float:right; margin-left: 1cm; margin-bottom: 1cm;'/>"
        html += "<div style='float:right; font-size:8pt;'>"
        html += "Av. de los Shyris N34-382 y Portugal<br/>"
        html += "Teléfono: +593 2 3964 800<br/>"
        html += "Quito - Ecuador<br/>"
//        html += "http://www.contratacionobras.gob.ec<br/>"
        html += "</div>"
        html += "</div>"

        out << raw(html)
    }

    /**
     * genera los estilos básicos para los reportes según la orientación deseada
     */
    def estilos = { attrs ->

        def pags = false
        if (attrs.pags == 1 || attrs.pags == "1" || attrs.pags == "true" || attrs.pags == true || attrs.pags == "si") {
            pags = true
        }
        if (!pags && attrs.pagTitle) {
            pags = true
        }

        if (!attrs.orientacion) {
            attrs.orientacion = "p"
        }
        def pOrientacion = attrs.orientacion.toString().toLowerCase()
        def orientacion = "portrait"
        def margenes = [
                top   : 1.8,
                right : 2,
                bottom: 2,
                left  : 2
        ]
        switch (pOrientacion) {
            case "l":
            case "landscape":
            case "horizontal":
            case "h":
                orientacion = "landscape"
                break;
        }

        def css = "<style type='text/css'>"
        css += "* {\n" +
                "    font-family   : 'PT Sans Narrow';\n" +
                "    font-size     : 8pt;\n" +
                "}"
        css += " @page {\n" +
                "    size          : A4 ${orientacion};\n" +
                "    margin-top    : ${margenes.top}cm;\n" +
                "    margin-right  : ${margenes.right}cm;\n" +
                "    margin-bottom : ${margenes.bottom}cm;\n" +
                "    margin-left   : ${margenes.left}cm;\n" +
                "}"
        css += "@page {\n" +
                "    @top-right {\n" +
                "        content : element(header);\n" +
                "    }\n" +
                "}"
        css += "@page {\n" +
                "    @bottom-right {\n" +
                "        content : element(footer);\n" +
                "    }\n" +
                "}"
        if (pags) {
            css += "@page {\n" +
                    "    @bottom-left { \n" +
                    "        content     : '${attrs.pagTitle ?: ''} pág.' counter(page) ' de ' counter(pages);\n" +
                    "        font-family : 'PT Sans Narrow';\n" +
                    "        font-size   : 8pt;" +
                    "        font-style  : italic\n" +
                    "    }\n" +
                    "}"
        }
        css += "#header{\n" +
                "    width      : 100%;\n" +
                "    text-align : right;\n" +
                "    position   : running(header);\n" +
                "}"

        css += "#footer{\n" +
                "    text-align : right;\n" +
                "    position   : running(footer);\n" +
                "    color      : #7D807F;\n" +
                "}"
        css += "@page{\n" +
                "    orphans    : 4;\n" +
                "    widows     : 2;\n" +
                "}"
        css += "table {\n" +
//                "    page-break-inside : avoid;\n" +
                "}"
        css += ".table tr {\n" +
                "    page-break-inside : avoid;\n" +
                "}"
        css += ".no-break {\n" +
                "    page-break-inside : avoid;\n" +
                "}"
        css += ".tituloReporte{\n" +
                "    text-align     : center;\n" +
                "    text-transform : uppercase;\n" +
//                "    font-family    : 'PT Sans';\n" +
                "    font-size      : 10pt;\n" +
//                "    font-weight    : bold;\n" +
                "    color          : #17365D;\n" +
                "    border-bottom  : solid 2px #4F81BD;\n" +
                "}"
        css += ".tituloReporteSinLinea{\n" +
                "    text-align     : center;\n" +
                "    text-transform : uppercase;\n" +
//                "    font-family    : 'PT Sans';\n" +
                "    font-size      : 10pt;\n" +
                "    top : -10px;\n" +
//                "    font-weight    : bold;\n" +
                "    color          : #17365D;\n" +
                "}"
        css += ".tituloRprt{\n" +
                "    text-align     : center;\n" +
                "    text-transform : uppercase;\n" +
                "    font-size      : 12pt;\n" +
                "    color          : #17365D;\n" +
                "}"
        css += ".numeracion {\n" +
                "    margin-top     : 0.5cm;\n" +
                "    margin-bottom  : 0.5cm;\n" +
                "    font-size      : 12.5pt;\n" +
                "    font-family    : 'PT Sans';\n" +
                "    color          : white;\n" +
                "    text-align     : center;\n" +
                "}"
        css += ".numeracion table {\n" +
                "    border-collapse : collapse;\n" +
                "    border          : solid 1px #C0C0C0;" +
                "    margin-left     : auto;\n" +
                "    margin-right    : auto;\n" +
                "}"
        css += ".numeracion table td {\n" +
                "    padding : 5px;\n" +
                "}"
        css += ".fechaReporte{\n" +
                "    color          : #000;\n" +
                "    margin-bottom  : 5px;\n" +
                "}"
        css += "thead {\n" +
                "    display:  table-header-group;\n" +
                "}"
        css += "tbody {\n" +
                "    display:  table-row-group;\n" +
                "}"
        css += "</style>"

        out << raw(css)
    }






}
