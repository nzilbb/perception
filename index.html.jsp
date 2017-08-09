<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<c:if test="${!empty tasks}">
  <ul id="tasks">
    <c:forEach var="task" items="${tasks}">
    <li id="${task.task_id}"><a href="?task_id=${task.task_id}">${task.name}</a></li></c:forEach>
  </ul>
</c:if>

<c:if test="${!empty task}">
  <div id="description">${task.description}</div>
  <hex:button text="${resources['Start']}" 
	      title="${resources['Start the task now']}"
	      icon="${template_path}/icon/go-next.png"
	      url="consent?task_id=${task.task_id}"/>
</c:if>
