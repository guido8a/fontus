<%@ page import="janus.seguridad.Sesn" contentType="text/html;charset=UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>

    <head>
        <meta name="layout" content="login2">
        <title>Ingreso</title>

        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
        <link href='${resource(dir: "css", file: "custom.css")}' rel='stylesheet' type='text/css'>

        <style type="text/css">
        /*.titl {*/
            /*font-family: 'open sans condensed';*/
            /*font-weight: bold;*/
            /*text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);*/
            /*color: #00496e;*/
            /*margin-top: 20px;*/
        /*}*/

        @page {
            size   : 8.5in 11in;  /* width height */
            margin : 0.25in;
        }

        .titl{
            font-family: 'open sans condensed';
            font-weight: bold;
            text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
            color: #5C6E80;
            margin-top: 20px;
        }

        .centrado {
            text-align: center;
            margin-top: 40px;
        }
        .logo {
            height: 595px;
            background: #d7d7d7;
            padding: 10px;
            width: 910px;
            margin: auto;
            margin-top: 5px
        }

        </style>

    </head>

    <body style="background-color: #d7d7d7">
    <div class="dialog ui-corner-all " style="height: 595px;background: #d9d9d9;;padding: 10px;width: 910px; margin-left: 100px; text-align: center">
        <div style="text-align: center;"><h1 class="titl" style="font-size: 32px;">${empr.empresa}</h1>
        <h1 class="titl" style="font-size: 24px;">${empr.nombre}</h1>
    </div>

        <g:form class="well form-horizontal span" action="savePer" name="frmLogin" style="border: 5px solid #002335; background:#c7c7c5;color: #939Aa2; width: 300px; margin-left: 240px; margin-top: 80px; position: relative; padding-left: 100px">
            <p class="css-vertical-text" style="left: 12px;;font-family: 'Tulpen One',cursive;font-weight: bold;font-size: 35px; color:#334;">Sistema SECOB</p>

            <div class="linea" style="height: 95%;left: 45px; border-left-color: #334"></div>
            <fieldset>
                <legend style="color: white;border:none;font-family: 'Open Sans Condensed', serif;font-weight: bolder;font-size: 25px; color:#334;">Ingreso</legend>

                <g:if test="${flash.message}">
                    <div class="alert alert-info" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        ${flash.message}
                    </div>
                </g:if>

                <div class="control-group">
                    <label class="control-label" style="width: 50px;text-align: left;font-size: 25px;font-family: 'Tulpen One',cursive;font-weight: bolder;float: left; color:#334">Perfil:</label>

                    <div class="controls" style="width: 180px;margin-left: 5px;float: right;margin-right: 60px">
                        <g:select name="perfiles" from="${perfilesUsr}" class="span2 control-group" required="" optionKey="id" style="width: 210px;"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </div>
                </div>

                <div class="control-group">

                    <a href="#" class="btn btn-primary" id="btnLogin">Entrar</a>
                </div>
            </fieldset>
        </g:form>
    </div>




    <div class="modal login fade " id="modal-perfiles" style="">
        <div class="modal-body" id="modalBody" style="padding: 0px">
            <g:form class="well form-horizontal span" action="savePer" name="frmLoginPerfil" style="border: 5px solid #002335; background:#c7c7c5;color: #939Aa2; width: 300px; margin-left: 240px; margin-top: 80px; position: relative; padding-left: 100px">
                <p class="css-vertical-text" style="left: 12px;;font-family: 'Tulpen One',cursive;font-weight: bold;font-size: 35px; color:#334;">Sistema SECOB</p>

                <div class="linea" style="height: 95%;left: 45px; border-left-color: #334"></div>
                <fieldset>
                    <legend style="color: white;border:none;font-family: 'Open Sans Condensed', serif;font-weight: bolder;font-size: 25px; color:#334;">Ingreso</legend>

                    <g:if test="${flash.message}">
                        <div class="alert alert-info" role="status">
                            <a class="close" data-dismiss="alert" href="#">×</a>
                            ${flash.message}
                        </div>
                    </g:if>

                    <div class="control-group">
                        <label class="control-label" style="width: 50px;text-align: left;font-size: 25px;font-family: 'Tulpen One',cursive;font-weight: bolder;float: left; color:#334">Perfil:</label>

                        <div class="controls" style="width: 180px;margin-left: 5px;float: right;margin-right: 60px">
                            <g:select name="perfiles" from="${perfilesUsr}" class="span2 control-group" required="" optionKey="id" style="width: 210px;"/>
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group">
                        <a href="#" class="btn btn-primary" id="btnLoginPerfil">Entrar</a>
                    </div>
                </fieldset>
            </g:form>
        </div>
    </div>


        <script type="text/javascript">

//           iniciar();
//           function iniciar () {
//               $("#modal-perfiles").modal("open");
//           }

            $(function () {

                $("input").keypress(function (ev) {
                    if (ev.keyCode == 13) {
                        $("#frmLogin").submit();
                    }
                });

                $("#btnLogin").click(function () {
                    $("#frmLogin").submit();
                    return false;
                });

                $("#frmLogin").validate({
                    errorPlacement : function (error, element) {
                        element.parent().find(".help-block").html(error).show();
                    },
                    success        : function (label) {
                        label.parent().hide();
                    },
                    errorClass     : "label label-important",
                    submitHandler  : function (form) {
                        $("#btnLogin").replaceWith(spinnerLogin);
                        form.submit();
                    }
                });

            });
        </script>

    </body>
</html>