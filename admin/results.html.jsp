<%@ taglib prefix="input" uri="http://fromont.net.nz/java/taglib/htmlui" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<table id="experiments">
  <thead>
    <tr>
      <th class="experiment_id">${resources['ID']}</th>
      <th class="started">${resources['Started']}</th>
      <th class="finished">${resources['Finished']}</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="experiment" items="${experiments}">
    <tr id="${experiment.experiment_id}">
      <td class="experiment_id">${experiment.experiment_id}</td>
      <td class="started">${experiment.started}</td>
      <td class="finished">${experiment.finished}</td>
      <td class="delete">
	<hex:button text="${resources['Delete']}" 
		    icon="${template_path}/icon/user-trash.png"
		    url="?task_id=${task_id}&todo=delete&x=${experiment.experiment_id}"/></td>
      <td class="data">
	<hex:button text="${resources['Trial Data']}" 
		    icon="${template_path}/icon/x-office-spreadsheet.png"
		    url="data?x=${experiment.experiment_id}"/></td>
    </tr></c:forEach>
  </tbody>
</table>
