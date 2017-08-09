<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" %><%
   Page pg = (Page) request.getAttribute("page");
   pg.setTitle("Tasks");
   pg.addBreadCrumb("Tasks", "tasks");
%><c:set var="db_table" scope="request"><db:table 
   type="editdelete"
   insert="true" 
   view="list" 
   columns="3"
   tableName="{module}_task_definition"
   title="${resources['Tasks']}"
   connection="${page.connection}"	
   deleteQuery="SELECT count(*) FROM {module}_experiment WHERE task_id = ?"
   deleteButtonSql="(SELECT count(*) FROM ${module}_experiment x WHERE x.task_id = ${module}_task_definition.task_id) = 0"
   deleteAuxiliarySql="DELETE FROM ${module}_participant_attribute_definition WHERE task_id = ? ; DELETE FROM ${module}_participant_attribute_option WHERE task_id = ? ; DELETE FROM ${module}_question_definition WHERE task_id = ? ; DELETE FROM ${module}_stimulus_definition WHERE task_id = ?"
   deleteError="Could not delete - there have already been experiments using this task."
   deleteButton="{template_path}icon/user-trash.png"
   insertButton="{template_path}icon/document-new.png"
   saveButton="{template_path}icon/document-save.png"
   >
  <db:field
     name="task_id"
     label="ID"
     type="integer"
     access="hidden"
     isId="true"
     newValueQuery="SELECT COALESCE(MAX(task_id) + 1, 1) FROM {module}_task_definition"
     required="true"
     deleteQuery="0"
     linkAs="task_id"	
     />				
  <db:field
     name="name"	
     label="${resources['Name']}"
     description="${resources['Title for the task']}"     
     type="string"
     access="readwriteonce"
     required="true"
     order="2"
     languages="${languages}"
     language="${language}"
     size="40"
     />
  <db:link
     text="${resources['Definition']}"
     url="task"
     icon="${template_path}icon/document-properties.png"
    />
  <db:link
     text="${resources['Task']}"
     url=".."
     icon="${template_path}icon/media-playback-start.png"
    />
  <db:link
     enabledSql="(SELECT count(*) FROM ${module}_experiment x WHERE x.task_id = ${module}_task_definition.task_id) > 0"
     text="${resources['Results']}"
     url="results"
     icon="${template_path}icon/x-office-spreadsheet.png"
    />
</db:table></c:set><%
      if ("insert".equals(request.getParameter("formAction_0"))
	  && request.getAttribute("task_id") != null)
      {
	 pg.sendRedirect("task?task_id="+request.getAttribute("task_id"));
      }
%>