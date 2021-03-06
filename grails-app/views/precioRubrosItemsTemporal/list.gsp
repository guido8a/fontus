
<%@ page import="janus.PrecioRubrosItemsTemporal" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de precioRubrosItemsTemporal
        </title>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
    </head>
    <body>

        <div class="span12">
            <g:if test="${flash.message}">
                <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                    <a class="close" data-dismiss="alert" href="#">×</a>
                    ${flash.message}
                </div>
            </g:if>
        </div>

        <div class="span12 btn-group" role="navigation">
            <a href="#" class="btn btn-ajax btn-new">
                <i class="icon-file"></i>
                Nuevo PrecioRubrosItemsTemporal
            </a>
        </div>

        <g:form action="delete" name="frmDelete-precioRubrosItemsTemporalInstance">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-precioRubrosItemsTemporal" class="span12" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <th>Item</th>
                    
                        <g:sortableColumn property="precioUnitario" title="Precio Unitario" />
                    
                        <th>Lugar</th>
                    
                        <g:sortableColumn property="fecha" title="Fecha" />
                    
                        <th width="150">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                <g:each in="${precioRubrosItemsTemporalInstanceList}" status="i" var="precioRubrosItemsTemporalInstance">
                    <tr>
                    
                        <td>${fieldValue(bean: precioRubrosItemsTemporalInstance, field: "item")}</td>
                    
                        <td>${fieldValue(bean: precioRubrosItemsTemporalInstance, field: "precioUnitario")}</td>
                    
                        <td>${fieldValue(bean: precioRubrosItemsTemporalInstance, field: "lugar")}</td>
                    
                        <td><g:formatDate date="${precioRubrosItemsTemporalInstance.fecha}" /></td>
                    
                        <td>
                            <a class="btn btn-small btn-show btn-ajax" href="#" rel="tooltip" title="Ver" data-id="${precioRubrosItemsTemporalInstance.id}">
                                <i class="icon-zoom-in"></i>
                            </a>
                            <a class="btn btn-small btn-edit btn-ajax" href="#" rel="tooltip" title="Editar" data-id="${precioRubrosItemsTemporalInstance.id}">
                                <i class="icon-pencil"></i>
                            </a>

                            <a class="btn btn-small btn-delete" href="#" rel="tooltip" title="Eliminar" data-id="${precioRubrosItemsTemporalInstance.id}">
                                <i class="icon-trash"></i>
                            </a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <div class="pagination">
                <elm:paginate total="${precioRubrosItemsTemporalInstanceTotal}" params="${params}" />
            </div>
        </div>

        <div class="modal hide fade" id="modal-precioRubrosItemsTemporal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">×</button>

                <h3 id="modalTitle"></h3>
            </div>

            <div class="modal-body" id="modalBody">
            </div>

            <div class="modal-footer" id="modalFooter">
            </div>
        </div>

        <script type="text/javascript">
            var url = "${resource(dir:'images', file:'spinner_24.gif')}";
            var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");


            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".btn-new").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');

                            btnSave.click(function () {
                                if ($("#frmSave-precioRubrosItemsTemporalInstance").valid()) {
                                    btnSave.replaceWith(spinner);
                                }
                                $("#frmSave-precioRubrosItemsTemporalInstance").submit();
                                return false;
                            });

                            $("#modalTitle").html("Crear PrecioRubrosItemsTemporal");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                            $("#modal-precioRubrosItemsTemporal").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

                $(".btn-edit").click(function () {
                    var id = $(this).data("id");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');

                            btnSave.click(function () {
                                if ($("#frmSave-precioRubrosItemsTemporalInstance").valid()) {
                                    btnSave.replaceWith(spinner);
                                }
                                $("#frmSave-precioRubrosItemsTemporalInstance").submit();
                                return false;
                            });

                            $("#modalTitle").html("Editar PrecioRubrosItemsTemporal");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                            $("#modal-precioRubrosItemsTemporal").modal("show");
                        }
                    });
                    return false;
                }); //click btn edit

                $(".btn-show").click(function () {
                    var id = $(this).data("id");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'show_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                            $("#modalTitle").html("Ver PrecioRubrosItemsTemporal");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk);
                            $("#modal-precioRubrosItemsTemporal").modal("show");
                        }
                    });
                    return false;
                }); //click btn show

                $(".btn-delete").click(function () {
                    var id = $(this).data("id");
                    $("#id").val(id);
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

                    btnDelete.click(function () {
                        btnDelete.replaceWith(spinner);
                        $("#frmDelete-precioRubrosItemsTemporalInstance").submit();
                        return false;
                    });

                    $("#modalTitle").html("Eliminar PrecioRubrosItemsTemporal");
                    $("#modalBody").html("<p>¿Está seguro de querer eliminar este precioRubrosItemsTemporal?</p>");
                    $("#modalFooter").html("").append(btnOk).append(btnDelete);
                    $("#modal-precioRubrosItemsTemporal").modal("show");
                    return false;
                });

            });

        </script>

    </body>
</html>
