<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 06/01/17
  Time: 10:28
--%>

<style type="text/css">
.formato {
    font-weight : bold;
}

.dpto {
    font-size  : smaller;
    font-style : italic;
}
</style>
%{--<g:form name="frmSave-Planilla" action="savePagoPlanilla" id="${planilla.id}">--}%
<g:form name="frmSave-Planilla" action="savePagoPlanilla">
    %{--<g:hiddenField name="tipo" value="${tipo}"/>--}%
    <fieldset>
        <div class="row">
            <div class="span5">
                %{--${extra}--}%

            </div>
        </div>

        %{--<g:if test="${tipo.toInteger() < 5}">--}%
            <div class="row">
                <div class="span2 formato">
                    %{--${lblMemo}--}%
                    Memo de pedido de pago
                </div>

                <div class="span4">
                    %{--<g:textField name="memo" class="span3 required allCaps" maxlength="20" value="${planilla.memoPagoPlanilla}"/>--}%
                    <g:textField name="memo" class="span3 required allCaps" maxlength="20" value=""/>
                    <span class="mandatory">*</span>

                    <p class="help-block ui-helper-hidden"></p>
                </div>
            </div>
        %{--</g:if>--}%
        <div class="row">
            <div class="span2 formato">
                %{--${lblFecha}--}%
                Fecha de memo de pedido de pago
            </div>

            <div class="span4">
                %{--<elm:datepicker name="fecha" class=" span3 required" maxDate="${fechaMax}" minDate="${fechaMin}" value="${fecha}"/>--}%
                <elm:datepicker name="fecha" class=" span3 required"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
            <div class="span2 formato">
                Envia documento
            </div>

            <div class="span4">
                <g:select from="" name="persona" class="span3"/>
                <span class="mandatory">*</span>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
            <div class="span2 formato">
                Recibe documento
            </div>

            <div class="span4">
                <g:select from="" name="personaEnvia" class="span3"/>
                <span class="mandatory">*</span>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
            <div class="span2 formato">
                Asunto
            </div>

            <div class="span4">
                <g:textArea name="asunto" value="" style="width: 344px; height: 80px; resize: none"/>

                <span class="mandatory">*</span>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

    </fieldset>
</g:form>

<script type="text/javascript">
    $("#frmSave-Planilla").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function (form) {
            $("[name=btnSave-rubroInstance]").replaceWith(spinner);
            form.submit();
        }
    });
</script>