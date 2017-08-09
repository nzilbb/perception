<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ taglib  prefix="db" uri="http://fromont.net.nz/java/taglib/dbtags"
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ page import = "java.util.Vector" 
%><%
   Page pg = (Page) request.getAttribute("page");
     
     pg.setTitle(pg.localizePattern("Define options for question ''{0}''", request.getParameter("question")));
     pg.addBreadCrumb("Questions", "questions?task_id=" + request.getParameter("task_id"));
     pg.addBreadCrumb(pg.localizePattern("Options for ''{0}''", request.getParameter("question")));
%><c:set
     var="db_table" scope="request"
     ><db:table 
	 type="editdelete" insert="true" view="list"
	 inSituUpdates="true"
	 tableName="${module}_question_option" title="${page.title}"
	 connection="${page.connection}"
	 htmlTableProperties="border=0 cellpadding=0 cellspacing=\"5\" width=\"300\""
	 deleteButton="{template_path}icon/user-trash.png"
	 insertButton="{template_path}icon/document-new.png"
	 saveButton="{template_path}icon/document-save.png"
       >
    <db:field
       name="task_id"
       type="integer" access="hidden" isId="true"
       where="1"
       defaultValue="${param['task_id_0']}"
       size="8"
       />
      <db:field
	 name="question"
	 type="string" access="hidden" isId="true" required="true"
	 defaultValue="%question%"
	 forceValue="%question%"
	 where="1"
	 deleteQuery="1"
	 />
      <db:field
	 name="value" label="${resources['Value']}"
	 description="${resources['Value to save if this option is selected']}"
	 type="string" access="readwrite" isId="true" order="2"
	 deleteQuery="2"
	 />
      <db:field
	 name="description" label="${resources['Description']}"
	 description="${resources['Text to display for this option in the list']}"
	 type="string" access="readwrite"
	 languages="${languages}"
	 language="${language}"
	 />
      <db:field
	 name="list_order" label="${resources['Order']}"
	 type="integer" access="readwrite" size="2" order="1"
	 defaultValue="0"
	 />
</db:table></c:set>
