<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<c:if test="${promptForComment}">
  <form method="post" id="commentform">
    <input type="hidden" name="task_id" value="${task.task_id}"/>
    <input type="hidden" name="experiment_id" value="${param['x']}"/>
    <div class="comment">
      <div class="prompt">${task.comment}</div>
      <div class="control"><textarea name="comment"></textarea></div>
      <div class="controls">
	<hex:button text="${resources['Finish']}" 
		    title="${resources['Save your comments if any, and finish']}"
		    icon="${template_path}/icon/go-next.png"
		    url="javascript:comment();"/>
      </div>
    </div>
    <script type="text/javascript">//<![CDATA[
// submit the form
function comment() {
   document.getElementById("commentform").submit();
}
//]]></script>

  </form>
</c:if>
<c:if test="${!promptForComment}">
  <div class="finished">${task.finished}</div>
</c:if>
<c:if test="${!empty score}">
  <div class="score">${score}</div>
</c:if>
