<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 14/10/16
  Time: 11:55
--%>

<g:select name="departamento_name" from="${janus.DepartamentoItem.findAllBySubgrupo(subgrupo, [sort: 'codigo', order: 'asc'])}" value="${item?.departamento?.id}" optionKey="id" optionValue="${{it.codigo + " : " + it.descripcion}}"/>