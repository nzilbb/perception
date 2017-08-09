<%@ taglib prefix="input" uri="http://fromont.net.nz/java/taglib/htmlui" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<table id="experiment">
  <tbody>
    <tr><th>${resources["Started"]}</th><td>${experiment.started}</td></tr>
    <tr><th>${resources["Finished"]}</th><td>${experiment.finished}</td></tr>
    <tr><th>${resources["Comment"]}</th></tr>
    <tr><td colspan="2"><pre>${experiment.comment}</pre></td></tr>
  </tbody>
</table>

<table id="experiment_participant_attribute">
  <tbody>
    <c:forEach var="attribute" items="${participantAttributes}">
    <tr id="${attribute.attribute}">
      <th>${attribute.attribute}</th>
      <td>${attribute.value}</td>
    </tr></c:forEach>
  </tbody>
</table>
<table id="experiment_participant_attribute">
  <thead>
    <tr>
      <th>${resources['Order']}</th>
      <th>${resources['Stimulus']}</th>
      <th>${resources['Started']}</th>
      <c:forEach var="question" items="${questions}">
	<th>${question}</th></c:forEach>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="stimulus" items="${stimuli}">
    <tr id="${stimulus.stimulus_id}">
      <td>${stimulus.stimulus_ordinal}</td>
      <td>${stimulus.label}</td>
      <td>${stimulus.started}</td>
      <c:forEach var="answer" items="${stimulus.answers}">
	<td>${answer}</td></c:forEach>
    </tr></c:forEach>
  </tbody>
</table>
