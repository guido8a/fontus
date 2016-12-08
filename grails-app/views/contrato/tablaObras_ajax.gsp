<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/12/16
  Time: 14:46
--%>

<table class="table table-bordered table-striped table-condensed table-hover">
    <tbody id="tabla_material">
    <g:each in="${obras}" var="obra">
        <tr>
            <td style="width: 15px" >${obra?.obra?.codigo}</td>
            <td style="width: 270px" >${obra?.obra?.nombre}</td>
            <td style="width: 10px; text-align: right"><g:formatNumber number="${obra?.valor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td style="width: 10px" title="${"Parroquia: " + obra?.obra?.parroquia?.nombre + " - Cantón: " + obra?.obra?.parroquia?.canton?.nombre}">${obra?.obra?.parroquia?.canton?.provincia?.nombre}</td>
        </tr>
    </g:each>
    </tbody>
</table>