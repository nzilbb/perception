<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "java.sql.*" 
%><%
   Page pg = (Page) request.getAttribute("page");
   pg.setTitle("Participant Attributes");
   pg.addBreadCrumb("Tasks", "tasks");
PreparedStatement sql = pg.prepareStatement(
   "SELECT name FROM " + pg.getModule() + "_task_definition WHERE task_id = ?");
sql.setString(1, request.getParameter("task_id"));
ResultSet rs = sql.executeQuery();
rs.next();
pg.addBreadCrumb(rs.getString("name"), "task?task_id="+request.getParameter("task_id"));
rs.close();
sql.close();
   pg.addBreadCrumb("Questions");
%><c:set
     var="db_table" scope="request"
     ><db:table 
	 type="editdelete" insert="true" view="list"
	 tableName="${module}_question_definition" title=""
	 inSituUpdates="true"
	 connection="${page.connection}"
	 htmlTableProperties="border=0 cellpadding=0 cellspacing=\"5\" width=\"300\""
	 deleteButton="{template_path}icon/user-trash.png"
	 insertButton="{template_path}icon/document-new.png"
	 saveButton="{template_path}icon/document-save.png"
	 resources="${resources}"
	 >
    <db:field
       name="task_id"
       type="integer" access="hidden" isId="true"
       where="1"
       forceValue="{task_id}"
       linkAs="task_id_0"
       size="8"
       />
    <db:field
       name="question" label="${resources['Question ID']}"
       type="string" access="readwriteonce" isId="true" required="true"
       order="1"
       linkAs="question"
       size="8"
       />
    <db:field
       name="type" label="${resources['Type']}"
       type="string" access="readwrite" required="true"
       optionValues="string|integer|number|select|date|time|datetime|boolean|text|readonly"
       linkAs="type"
       otherField="style"
       />
    <db:field
       name="style" label="${resources['Style']}"
       type="style" access="readwrite" required="false"
       otherField="type"
       />
    <db:field
       name="label" label="${resources['Label']}"
       type="string" access="readwrite" required="true"
       languages="${languages}"
       language="${language}" 
       size="8"
       />
    <db:field
       name="description" label="${resources['Description']}"
       type="string" access="readwrite" required="false"
       languages="${languages}"
       language="${language}" 
       size="12"
       />
    <db:field
       name="required" label="${resources['Required']}"
       type="integer" access="readwrite" required="true"
       optionValues="${resources['0:Optional|1:Required']}"
       />
    <db:field
       name="scored" label="${resources['Scored']}"
       description="${resources['Whether the participant is scored against the correct answers for this question']}"
       type="integer" access="readwrite" required="true"
       optionValues="${resources['0:Not Scored|1:Scored']}"
       />
    <db:field
       name="display_order" label="${resources['Display Order']}"
       description="${resources['The order in which attributes appear in listings']}"
       type="integer" access="readwrite" required="true"
       size="2"
       order="0"
       />
    <db:link
       url="questionOptions"
       htmlTitle="${resources['Options']}"
       enabledSql="type = 'select'"
       icon="${template_path}icon/document-properties.png"
       />
</db:table></c:set>
