<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<c:if test="${!empty task}">
  <div id="consent">${task.consent}</div>
  <div class="signature">
    <form id="consentform" action="form" method="post">
      <input type="hidden" name="task_id" value="${task.task_id}"/>
      <input type="text" name="signature" class="signature" autofocus />
    </form>
  </div>
  <hex:button text="${resources['Start']}" 
	      title="${resources['Start the task now']}"
	      icon="${template_path}/icon/go-next.png"
	      url="javascript:consent();"/>
  <script type="text/javascript">//<![CDATA[
// get consent
function consent() {
  var frm = document.getElementById("consentform");
  if (frm.signature.value.trim() == "") {
    alert("${resources['Please fill in the box to indicate your consent.']}");
    frm.signature.focus();
    return false;
<c:if test="${!empty task.valid_signature_pattern}">
  } else if (!new RegExp("${task.valid_signature_pattern}").test(frm.signature.value)) {
    alert("${resources['Please fill in the box to indicate your consent.']}");
    frm.signature.focus();
    return false;
</c:if>
  } else {
    frm.submit();
  }
}
//]]></script>

</c:if>
