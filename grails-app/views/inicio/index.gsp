<%@ page contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <title>${empr.empresa}</title>
    <meta name="layout" content="main"/>
    <style type="text/css">
    @page {
        size: 8.5in 11in;  /* width height */
        margin: 0.25in;
    }

    .item {
        width: 260px;
        height: 220px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        border: none;

    }

    .imagen {
        width: 180px;
        height: 120px;
        margin: auto;
        margin-top: 10px;
    }

    .texto {
        width: 90%;
        height: 50px;
        padding-top: 0px;
        margin: auto;
        margin: 8px;
        font-size: 16px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 20px;
        background-color: rgb(181, 181, 181);
        border: none;

    }

    .desactivado {
        color: #bbc;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
        color: #00496E;
        margin-top: 20px;
    }
    </style>
</head>

<body>
<div class="dialog">
    <div style="text-align: center;"><h1 class="titl" style="font-size: 26px;">${empr.nombre}</h1></div>

    <div class="body ui-corner-all" style="width: 850px;position: relative;margin: auto;margin-top: 0px;height: 510px;
    background: rgba(0, 32, 52, 0.73);">

        <g:if test="${prms.contains('rubroPrincipal')}">
            <a href="${createLink(controller: 'rubro', action: 'rubroPrincipal')}" title="Análisis de Precios Unitarios">
        </g:if>
        <div class="ui-corner-all  item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'apu1.png')}" width="100%" height="100%"/>
                </div>

                <div class="texto"><b>Precios y análisis de precios unitarios</b>: registro y mantenimiento de
                ítems y rubros. Análisis de precios y listas de precios...</div>
            </div>
        </div>
        <g:if test="${prms.contains('rubroPrincipal')}">
            </a>
        </g:if>

        <g:if test="${prms.contains('registroObra')}">
            <a href= "${createLink(controller:'obra', action: 'registroObra')}" title="Presupuesto de obras">
        </g:if>
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all ui-widget-content item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'obra100.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Presupuesto</b>: registro de Obras, georeferenciación, los volúmenes de obra,
                    presupuesto y costos indirectos ...</div>
                </div>
            </div>
        <g:if test="${prms.contains('registroObra')}">
            </a>
        </g:if>

        <g:if test="${prms.contains('registrarPac')}">
            <a href= "${createLink(controller:'pac', action: 'registrarPac')}" title="Registro de Contratos">
        </g:if>
            <div class="ui-corner-all item fuera">
                <div class="ui-corner-all ui-widget-content item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'compras.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Registro de Contratos</b>: registro de contratos, contratos complementarios,
                    cronograma y valores contratados ...</div>
                </div>
            </div>
        <g:if test="${prms.contains('registrarPac')}">
            </a>
        </g:if>

        <g:if test="${prms.contains('verContrato')}">
            <a href= "${createLink(controller:'contrato', action: 'verContrato')}" title="Ejecución de Obras">
        </g:if>
            <div class="ui-corner-all  item fuera">
                <div class="ui-corner-all ui-widget-content item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'fiscalizar.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Ejecución</b>: seguimiento a la ejecución de las obras: incio de obra,
                    avance de obra, planillas, cronograma valorado...</div>
                </div>
            </div>
        <g:if test="${prms.contains('verContrato')}">
            </a>
        </g:if>

        <g:link controller="reportes" action="index" title="Reportes del Sistema">
            <div class="ui-corner-all  item fuera">
                <div class="ui-corner-all ui-widget-content item">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'reporte.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Reportes</b>: presupuestos, obras contratadas, estado de ejecución.
                    Contratistas, Obras por zonas, Inversiones...</div>
                </div>
            </div>
        </g:link>
    %{--<g:link  controller="documento" action="list" title="Documentos de los Proyectos">--}%
        <div class="ui-corner-all  item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'manuales1.png')}" width="100%" height="100%" title="Manuales en línea"/>
                </div>

                <div class="texto"><b>Manuales del sistema:</b>
                    <a href="${resource(dir: 'manuales', file: 'Manual obras.html')}" title="Manual de Obras">Obras</a>,
                    <a href="${resource(dir: 'manuales', file: 'Manual APU.html')}" title="Manual de Obras">Análisis de Precios Unitarios</a>,
                    <a href="${resource(dir: 'manuales', file: 'Manual contrataciones.html')}" title="Manual de Contratación">Contratos</a>,
                    <a href="${resource(dir: 'manuales', file: 'Manual de ejecución.html')}" title="Manual de Fiscalización">Fiscalización</a>,
                    <a href="${resource(dir: 'manuales', file: 'Manual financiero.html')}" title="Manual de Financiero">Financiero</a>,
                    <a href="${resource(dir: 'manuales', file: 'Manual de reportes.html')}" title="Manual de Reportes">Reportes</a>.
                </div>
            </div>
        </div>

        <div style="text-align: center ; color:#bebe95">Desarrollado por: TEDEIN S.A. Versión ${message(code: 'version', default: '1.1.0x')}</div>

    </div>
    <script type="text/javascript">
        $(".fuera").hover(function () {
            var d = $(this).find(".imagen")
            d.width(d.width() + 10)
            d.height(d.height() + 10)
//        $.each($(this).children(),function(){
//            $(this).width( $(this).width()+10)
//        });
        }, function () {
            var d = $(this).find(".imagen")
            d.width(d.width() - 10)
            d.height(d.height() - 10)
        })
    </script>
</body>
</html>

%{--
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title></title>
    </head>
    <body>
    </body>
</html>--}%
