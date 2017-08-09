<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<c:if test="${!empty task}">
  <div id="before_start">${task.before_start}</div>
  <hex:button text="${resources['Next']}" 
	      title="${resources['Next']}"
	      icon="${template_path}/icon/go-next.png"
	      url="stimulus?x=${param['x']}"/>
</c:if>
