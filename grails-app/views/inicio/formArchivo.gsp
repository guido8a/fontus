<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
        <title>Subir archivo excel composición</title>
    </head>

    <body>
        <g:if test="${flash.message}">
            <div class="alert alert-error">
                ${flash.message}
            </div>
        </g:if>

        <g:uploadForm action="cargaArch" method="post" name="cargaArch">
            <div id="list-grupo" class="span12" role="main" style="margin: 10px 0 0 0;">
                <div class="row-fluid" style="margin: 0 0 20px 0;">
                    <div class="span9">
                        <h3>Migrar datos de distribución items</h3>
                        El archivo debe contener al menos 5 columnas (los nombres de las columnas no son importantes):
                        <table class="table table-bordered table-condensed">
                            <tr>
                                <th>CODIGO</th>
                                <th>ITEM</th>
                                <th>UNIDAD</th>
                                <th>[categoria]</th>
                                <th>PRECIO</th>
                                <th>CPC</th>
                                <th>NP-ND-EP</th>
                                <th>[precios1 .. precioN]</th>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="row-fluid" style="margin-left: 0px">
                    <div class="span12">
                        <div class="span2"><b>Archivo:</b></div>
                        <input type="file" class="required" id="file" name="file"/>
                    </div>
                </div>
                <div class="row-fluid" style="margin-top: 20px">
                    <div class="span12">
                        <div class="span5"><b>Tipo: Civil:C, Mecánica M, Eléctrico: E, Electrónico: D, Hidrosanitario: H</b></div>
                        <input type="text" class="required span1" id="tipo" name="tipo"/>
                    </div>
                </div>
                <div class="row-fluid" style="margin-top: 20px">
                    <div class="span12">
                        <div class="span6"><b>Subgrupo Equipo: Civil:101, Mecánica: 104, Eléctrico: 102, Electrónico: 103, Sanitario: 105</b></div>
                        <input type="text" class="required span1" id="sbgr" name="sbgr"/>
                    </div>
                </div>
                <div class="row-fluid" style="margin-top: 20px">
                    <div class="span12">
                        <div class="span6"><b>Subgrupo Materiales: Civil:001, Mecánica: 004, Eléctrico: 002, Electrónico: 003, Sanitario: 005</b></div>
                        <input type="text" class="required span1" id="sbgr_mt" name="sbgr_mt"/>
                    </div>
                </div>
            </div>

            <div class="row-fluid" style="margin-left: 0px">
                <div class="span4">
                    <a href="#" class="btn btn-success" id="btnSubmit">Subir</a>
                </div>
            </div>
        </g:uploadForm>

        <g:uploadForm action="cargaProv" method="post" name="cargaProv">
            <div id="list-grupo" class="span12" role="main" style="margin: 10px 0 0 0;">
                <div class="row-fluid" style="margin: 0 0 20px 0;">
                    <div class="span9">
                        <h3>Migrar datos de distribución geográfica</h3>
                        <table class="table table-bordered table-condensed">
                            <tr>
                                <th>CODIGO</th>
                                <th>Provincia</th>
                                <th>Cód_Cantón</th>
                                <th>Cantón</th>
                                <th>Cod_Parroquia</th>
                                <th>Parroquia</th>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="row-fluid" style="margin-left: 0px">
                    <div class="span8">
                        <div class="span4"><b>Archivo de distribución geográfica:</b></div>
                        <input type="file" class="required span4" id="file" name="file"/>
                    </div>
                    <div class="span2">
                        <a href="#" class="btn btn-success" id="btnSubir">Subir</a>
                    </div>
                </div>
            </div>

            <div class="row-fluid" style="margin-left: 0px">
            </div>
        </g:uploadForm>

        <script type="text/javascript">
            $(function () {
                $("#cargaArch").validate({

                });

                $("#btnSubmit").click(function () {
                    if ($("#cargaArch").valid()) {
                        $(this).replaceWith(spinner);
                        $("#cargaArch").submit();
                    }
                });

                $("#cargaProv").validate({

                });

                $("#btnSubir").click(function () {
                    if ($("#cargaProv").valid()) {
                        $(this).replaceWith(spinner);
                        $("#cargaProv").submit();
                    }
                });
            });
        </script>
    </body>
</html>