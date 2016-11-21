<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 21/11/16
  Time: 14:34
--%>

<div class="tituloTree">
    Rubro: ${rubro.codigo} - ${rubro.nombre} (${rubro?.unidad?.encodeAsHTML().trim()})<br/>
    Fecha creación: <g:formatDate date="${rubro?.fecha}" format="dd-MM-yyyy"/><br/>
    Fecha modificación: <g:formatDate date="${rubro?.fechaModificacion}" format="dd-MM-yyyy hh:mm"/>
</div>

<div id="list-grupo" role="main">


    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 80px;background-color: #ffb96d">
                Descripción
            </th>
        </thead>
        <tbody>
        <tr>
            <td>
                ${rubro?.descripcion}
            </td>
        </tr>
        </tbody>
    </table>


    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 80px;background-color: #ffb96d">
                Especificaciones
            </th>
        </thead>
        <tbody>
        <tr>
            <td>
                ${rubro?.especificaciones}
            </td>
        </tr>
        </tbody>
    </table>

    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 80px;background-color: #ffb96d">
                Pago
            </th>
        </thead>
        <tbody>
        <tr>
            <td>
                ${rubro?.pago}
            </td>
        </tr>
        </tbody>
    </table>

</div>


<div id="list-grupo" role="main">
    <div id="tablas">
        <p class="css-vertical-text">Composición</p>

        <div class="linea" style="height: 98%;"></div>
        <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
            <thead>
            <tr>
                <th style="width: 80px;">
                    Código
                </th>
                <th style="width: 600px;">
                    Equipo
                </th>
                %{--<th style="width: 80px;">--}%
                %{--Cantidad--}%
                %{--</th>--}%
            </tr>
            </thead>
            <tbody id="tabla_equipo">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 3}">
                    <tr class="item_row " id="${rub.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        %{--<td style="text-align: right" class="cant">--}%
                        %{--<g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"/>--}%
                        %{--</td>--}%
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 80px;">
                    Código
                </th>
                <th style="width: 600px;">
                    Mano de obra
                </th>
                %{--<th style="width: 80px">--}%
                %{--Cantidad--}%
                %{--</th>--}%
            </tr>
            </thead>
            <tbody id="tabla_mano">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">
                    <tr class="item_row" id="${rub.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        %{--<td style="text-align: right" class="cant">--}%
                        %{--<g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"/>--}%
                        %{--</td>--}%
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 80px;">
                    Código
                </th>
                <th style="width: 600px;">
                    Materiales
                </th>
                <th style="width: 60px" class="col_unidad">
                    Unidad
                </th>
                %{--<th style="width: 80px">--}%
                %{--Cantidad--}%
                %{--</th>--}%
            </tr>
            </thead>
            <tbody id="tabla_material">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 1}">
                    <tr class="item_row" id="${rub.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="width: 60px !important;text-align: center" class="col_unidad">${rub.item.unidad.codigo}</td>
                        %{--<td style="text-align: right" class="cant">--}%
                        %{--<g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"/>--}%
                        %{--</td>--}%
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>

        <div id="tabla_transporte"></div>

        <div id="tabla_indi"></div>

        <div id="tabla_costos" style="height: 120px;display: none;float: right;width: 100%;margin-bottom: 10px;"></div>
    </div>

</div>