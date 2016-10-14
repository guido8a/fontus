<%@ page import="janus.Grupo; janus.pac.CodigoComprasPublicas; janus.Item" %>

<div id="create" class="span" role="main">
<link href="${resource(dir: 'js/jquery/css/bw', file: 'jquery-ui-1.10.2.custom.min.css')}" rel="stylesheet"/>
<script src="${resource(dir: 'js/jquery/js', file: 'jquery-ui-1.10.2.custom.min.js')}"></script>
<g:form class="form-horizontal" name="frmSave" action="saveIt_ajax">
    <g:hiddenField name="id" value="${itemInstance?.id}"/>
    <table>
        <tr>
            <td width="500px">
                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Grupo
                        </span>
                    </div>

                    <div class="controls">
                        %{--<g:hiddenField name="departamento.id" value="${departamento.id}"/>--}%
                        %{--${departamento.descripcion}--}%
                        <g:select name="subgrupo_name" id="selSubgrupo" value="${itemInstance?.departamento?.subgrupo?.id}" from="${janus.SubgrupoItems.findAllByGrupo(janus.Grupo.get(grupo), [sort: 'codigo', order: 'asc']) }" optionValue="${{it.codigo + ' : ' + it.descripcion}}" optionKey="id"/>
                    </div>
                </div>

            </td>
            <td>
                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Subgrupo
                        </span>
                    </div>

                    <div class="controls" id="divDepartamento">
                    </div>
                </div>
            </td>
        </tr>
    </table>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombre
            </span>
        </div>

        <div class="controls">
            <g:textField name="nombre" maxlength="160" class="allCaps required input-xxlarge" value="${itemInstance?.nombre}" style="width: 600px"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <table>
       <tr>
           <td width="500px">
               <div class="control-group">
                   <div>
                       <span class="control-label label label-inverse">
                           Código
                       </span>
                   </div>

                   <div class="controls" style="font-weight: bolder">
                       <g:set var="cd1" value="${departamento.subgrupo.codigo.toString().padLeft(3, '0')}"/>
                       <g:set var="cd2" value="${departamento.codigo.toString().padLeft(3, '0')}"/>
                       <g:set var="cd" value="${itemInstance?.codigo}"/>
                       <g:if test="${itemInstance.id && cd}">
                           <g:set var="cd" value="${cd?.replace(cd1 + ".", '').replace(cd2 + ".", '')}"/>
                       </g:if>
                       <g:if test="${itemInstance.id}">
                           <g:if test="${itemInstance?.departamento?.subgrupo?.grupoId != 2 && departamento.subgrupo.grupoId != 2}">
                               ${cd1}.</g:if>${cd2}.${cd}
                       </g:if>
                       <g:else>
                           <div class="input-prepend">
                               <g:if test="${itemInstance?.departamento?.subgrupo?.grupoId != 2 && departamento.subgrupo.grupoId != 2}">
                                   <span class="add-on">${cd1}</span>
                               </g:if>
                               <span class="add-on">${cd2}</span>
                               <g:textField name="codigo" maxlength="20" class="allCaps required input-small" value="${cd}"/>
                               <span class="mandatory">*</span>

                               <p class="help-block ui-helper-hidden"></p>
                           </div>
                       </g:else>
                   </div>
               </div>
           </td>
           <td>
               <div class="control-group">
                   <div>
                       <span class="control-label label label-inverse">
                           Código CPC (SERCOP)
                       </span>
                   </div>
                   <div class="controls">
                       <input readonly="" type="text" style="width: 154px;;font-size: 12px;" id="item_codigo" value="${janus.pac.CodigoComprasPublicas.get(itemInstance?.codigoComprasPublicas?.id)?.numero}">
                       <input type="hidden" style="width: 60px" id="item_cpac" name="codigoComprasPublicas.id" value="${itemInstance?.codigoComprasPublicas?.id}">
                       <p class="help-block ui-helper-hidden"></p>
                   </div>
               </div>
           </td>
       </tr>
    </table>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Unidad
            </span>
        </div>

        <div class="controls">
            <g:select id="unidad" name="unidad.id" from="${janus.Unidad.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                      class="many-to-one " value="${itemInstance?.unidad?.id}" noSelection="['': '']"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <g:if test="${grupo.toString() == '1'}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Lista de Precios
                </span>
            </div>

            <div class="controls">
                <elm:select from="${janus.TipoLista.findAllByUnidadIsNotNull([sort: 'descripcion'])}" optionClass="unidad" id="tipoLista"
                            name="tipoLista.id" class="span4" value="${itemInstance?.tipoListaId}" optionKey="id" optionValue="descripcion"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="control-group" id="grupoPeso">
            <div>
                <span class="control-label label label-inverse">
                    Peso/Volumen
                </span>
            </div>

            <div class="controls">
                <div class="input-append">
                    <g:field type="number" name="peso" maxlength="20"
                             step="${10**-(formatNumber(number: itemInstance?.peso, format: '#,#####0', minFractionDigits: 3, maxFractionDigits: 6, locale: 'ec').toString().size()-2)}"
                             class=" required input-small peso" value="${formatNumber(number: itemInstance?.peso, format: '##,######0', minFractionDigits: 6, maxFractionDigits: 6, locale: 'ec')}"/>

                    <span class="add-on" id="spanPeso">
                    </span>
                </div>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
    </g:if>
    <g:else>
        <g:hiddenField name="peso" maxlength="20" class=" required input-small" value="0"/>
    </g:else>

    <table>
        <tr>
            <td width="500px">
                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Estado
                        </span>
                    </div>

                    <div class="controls">
                        <g:select from="['A': 'Activo', 'B': 'Dado de baja']" name="estado" class="input-medium" value="${itemInstance?.estado}" optionKey="key" optionValue="value"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>
            </td>
            <td>
                <div class="control-group">
                    <div>
                        <span class="control-label label label-inverse">
                            Fecha
                        </span>
                    </div>

                    <div class="controls">
                        <elm:datepicker name="fecha" class="datepicker" style="width: 90px" value="${itemInstance?.fecha}"/>

                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

            </td>
        </tr>
    </table>


    <g:if test="${grupo.toString() == '3'}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Combustible
                </span>
            </div>

            <div class="controls">
                <g:select from="['S': 'Sí', 'N': 'No']" name="combustible" class="input-small" value="${itemInstance?.combustible}" optionKey="key" optionValue="value"/>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
    </g:if>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Observaciones
            </span>
        </div>

        <div class="controls">
            <g:textArea cols="5" rows="4" style="resize: none; height: 65px;" name="observaciones" maxlength="127" class="input-xxlarge allC3aps" value="${itemInstance?.observaciones}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>

<div class="modal grande hide fade" id="modal-ccp" style="overflow: hidden;">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle2"></h3>
    </div>

    <div class="modal-body" id="modalBody2">
        <bsc:buscador name="pac.buscador.id" value="" accion="buscaCpac" controlador="mantenimientoItems" campos="${campos}" label="cpac" tipo="lista"/>
    </div>

    <div class="modal-footer" id="modalFooter2">
    </div>
</div>


<script type="text/javascript">

    cargarDepartamento($("#selSubgrupo").val());

    function cargarDepartamento (subgrupo) {
        var item = '${itemInstance?.id}'
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'departamento_ajax')}',
            data:{
                subgrupo: subgrupo,
                item: item
            },
            success: function (msg){
                $("#divDepartamento").html(msg)
            }
        })
    }

    $("#selSubgrupo").change(function () {
        var subgrupo = $(this).val();
        cargarDepartamento(subgrupo)
    });

    function label() {
        var c = $("#tipoLista").children("option:selected").attr("class");
        if (c == "null") {
            $("#grupoPeso").hide();
        } else {
            $("#grupoPeso").show();
            $("#spanPeso").text(c);
        }
    }

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
        ev.keyCode == 190 || ev.keyCode == 110 ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39);
    }

    label();

    $(".peso").bind({
        keydown : function (ev) {
            // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
            if (ev.keyCode == 190 || ev.keyCode == 110) {
                var val = $(this).val();
                if (val.length == 0) {
                    $(this).val("0");
                }
                return val.indexOf(".") == -1;
            } else {
                // esta parte valida q sean solo numeros, punto, tab, backspace, delete o flechas izq/der
                return validarNum(ev);
            }
        }, //keydown
        keyup   : function () {
            var val = $(this).val();
            // esta parte valida q no ingrese mas de 2 decimales
            var parts = val.split(".");
            if (parts.length > 1) {
                if (parts[1].length > 6) {
                    parts[1] = parts[1].substring(0, 6);
                    val = parts[0] + "." + parts[1];
                    $(this).val(val);
                }
            }

        }
    });

    $("#tipoLista").change(function () {
        label();
    });

    $(".allCaps").blur(function () {
        this.value = this.value.toUpperCase();
    });

    $("#transporte").change(function () {
        var v = $(this).val();
        var l = "";
        if (v == 'P' || v == 'P1') {
            l = "Ton";
        } else {
            l = "M<sup>3</sup>";
        }
        $("#spanPeso").html(l);
    });

    $("#frmSave").validate({
        rules          : {
            codigo : {
                remote : {
                    url  : "${createLink(action:'checkCdIt_ajax')}",
                    type : "post",
                    data : {
                        id  : "${itemInstance?.id}",
                        dep : "${departamento.id}"
                    }
                }
            },
            nombre : {
                remote : {
                    url  : "${createLink(action:'checkNmIt_ajax')}",
                    type : "post",
                    data : {
                        id : "${itemInstance?.id}"
                    }
                }
            },
            campo  : {
                remote : {
                    url  : "${createLink(action:'checkCmIt_ajax')}",
                    type : "post",
                    data : {
                        id : "${itemInstance?.id}"
                    }
                },
                regex  : /^[A-Za-z\d_]+$/
            }
        },
        messages       : {
            codigo : {
                remote : "El código ya se ha ingresado para otro item"
            },
            nombre : {
                remote : "El nombre ya se ha ingresado para otro item"
            },
            campo  : {
                regex  : "El nombre corto no permite caracteres especiales",
                remote : "El nombre ya se ha ingresado para otro item"
            }
        },
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important"
    });

    $(function () {
        $("#item_codigo").dblclick(function () {
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle2").html("Código compras públicas");
            $("#modalFooter2").html("").append(btnOk);
            $(".contenidoBuscador").html("")
            $("#modal-ccp").modal("show");
            $("#buscarDialog").unbind("click")
            $("#buscarDialog").bind("click", enviar)
        });
    });

</script>
