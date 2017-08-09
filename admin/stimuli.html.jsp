<%@ taglib prefix="input" uri="http://fromont.net.nz/java/taglib/htmlui" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>


<table class="stimuli_edit">
  <tr>
    <th>${resources['Stimulus']}:</th>
    <th>${resources['ID']}:</th>
    <th>${resources['Order']}:</th>
    <c:forEach var="question" items="${scoredQuestions}">
      <th>${question.value}</th></c:forEach>
  </tr>  
  <c:forEach items="${stimuli}" var="stimulus">
    <form method="POST" name="frm${stimulus.stimulus_id}" id="frm${stimulus.stimulus_id}">
      <tr>
	<td class="task_edit_stimulus">
	  <audio src="../media/${task_id}/${stimulus.stimulus_id}.mp3" controls />
	  <input name="command" type="hidden" value="update">
	  <input type="hidden" name="task_id" value="${task_id}">
	  <input name="stimulus_id" type="hidden" value="${stimulus.stimulus_id}">
	</td>
	<td>
	  <c:if test="${empty languages}"
		><input 
		    name="label" required
		    type="text" 
		    value="${stimulus.label}" 
		    size="30" 
		    title="${resources['Enter ID for the stimulus']}"></c:if>
	  <c:if test="${!empty languages}"
		><input:multilingual 
		    languages="${languages}"
		    name="label" 
		    value="${stimulus.label}" 
		    size="30" 
		    title="${resources['Enter ID for the stimulus']}"/></input></c:if>
	</td>
	<td><input name="list_order" 
		   value="${stimulus.list_order}" 
		   type="number" size="3" style="width: 50px;"
		   title="${resources['Enter the stumulus place in order']}"></input></td>
	<c:forEach var="question" items="${scoredQuestions}">
	  <td><input name="answer_${question.key}" 
		     value="${stimulus[question.key]}" 
		     type="text" size="3" style="width: 50px;"
		     title="${resources['Enter the correct answer for this question']}"></input></td></c:forEach>
	<td>
	  <hex:linkbutton 
	     icon="${template_path}/icon/document-save.png"
	     title="${resources['Save']}"
	     text="${resources['Save']}"
	     url="javascript:document.getElementById('frm${stimulus.stimulus_id}').submit();" />
	</td>
	<td><hex:linkbutton 
	     icon="${template_path}/icon/user-trash.png"
	     title="${resources['Delete']}"
	     text="${resources['Delete']}"
	     url="javascript:if (confirm('${resources['Are you sure you want to delete this stimulus?']}') ) { document.getElementById('frm${stimulus.stimulus_id}').command.value='delete'; document.getElementById('frm${stimulus.stimulus_id}').submit();}" />
	</td>
      </tr>
    </form>
  </c:forEach><%-- image --%>
  <form method="post" name="upform" id="upform" enctype="multipart/form-data" onsubmit="return validate();">
      <script language="JavaScript">
<!-- Protection for non-JavaScript browsers

 // validation
 function validate()
 {
        var frm = document.getElementById('upform');
	if (frm.label.value == "")
	{
	 alert("${resources['You must enter a ID for the stimulus.']}");
	 frm.label.focus();
	 return false;
	}
	else if (frm.uploadfile.value == "")
	{
	 alert("${resources['You must enter a file to upload.']}");
	 frm.uploadfile.focus();
	 return false;
	}
	else
	{
	 return true;
	}
 }
// end of non-JavaScript browser protection -->
      </script>
      
      <tr>
	<td>
	  <hex:filechooser text="${resources['Browse']}" name="uploadfile" acceptsExtension="mp3"
			   onchange="this.form.label.value = this.form.uploadfile_name.value.replace(/\\.[^.]*$/,'');"/>
	</td>
	<td>
	  <c:if test="${empty languages}"
		><input name="label" value="" type="text" size="30" required
			title="${resources['Enter ID for the stimulus']}"></input></c:if>
	  <c:if test="${!empty languages}"
		><input:multilingual 
		    languages="${languages}"
		    name="label" value="" size="30" 
		    title="${resources['Enter ID for the stimulus']}"/></input></c:if>
	</td>
	<td><input name="list_order" value="${default_order}" type="number" size="1" style="width: 50px;"
		   title="${resources['Enter the stumulus place in order']}"></input></td>
	<c:forEach var="question" items="${scoredQuestions}">
	  <td><input name="answer_${question.key}" 
		     value="" 
		     type="text" size="3" style="width: 50px;"
		     title="${resources['Enter the correct answer for this question']}"></input></td></c:forEach>
	<td>
	  <input type="hidden" name="todo" value="upload">
	  <input type="hidden" name="task_id" value="${task_id}">
	  <hex:linkbutton 
	     icon="${template_path}/icon/document-new.png"
	     title="${resources['New']}"
	     text="${resources['New']}"
	     url="javascript:if (validate()) document.upform.submit();" />
	</td>
      </tr>
  </form>

</table>
