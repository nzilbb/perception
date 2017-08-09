<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Site site = pg.getSite();
   Module module = pg.getModule();
   User user = pg.getUser();
   Connection connection = pg.getConnection();

   pg.setTitle(module.getName());
   if (request.getParameter("task_id") == null)
   { // no task_id
      if (request.getParameter("classId") != null && request.getParameter("objectId") != null)
      {
	 // save the attributes
	 %><c:set var="attributePage" scope="request"><db:attributePage
	    connection="${page.connection}"
	    attributeDefinitionTable="${module}_participant_attribute_definition"
	    classIdField="task_id"
	    attributeField="attribute"
	    attributeRequiredField="required"
	    typeField="type"
	    labelField="label"
	    attributeOrderField="display_order"
	    descriptionField="description"
	    styleField="style"
	    optionDefinitionTable="${module}_participant_attribute_option"
	    optionValueField="value"
	    optionDescriptionField="description"
	    optionOrderField="list_order"
	    attributeTable="${module}_experiment_participant_attribute"
	    dataObjectField="experiment_id"
	    dataAttributeNameField="attribute"
	    dataAttributeValueField="value"
	    classId="${param['classId']}"
	    objectId="${param['objectId']}"
	    resources="${resources}"
	    saveText="Next"
	    saveButton="${template_path}/icon/go-next.png"
	    ><!-- need this here --></db:attributePage></c:set><%

	 pg.sendRedirect(session.getAttribute("baseUrl")+"/"+module
	  		 +"/start?task_id="+request.getParameter("classId")+"&x="+request.getParameter("objectId"));
      }
      else
      {
	 pg.addError("Invalid task");
      }
   } // no task_id
   else if (request.getParameter("signature") != null)
   { // task_id and signature set
      PreparedStatement sqlTask = pg.prepareStatement(
	 "SELECT * FROM " + module + "_task_definition WHERE active = 1 AND task_id = ?");
      sqlTask.setString(1, request.getParameter("task_id"));
      ResultSet rsTask = sqlTask.executeQuery();
      String email = "";
      if (!rsTask.next())
      {
	 pg.addError("Invalid task");
      }
      else
      {
	 pg.set("task", Page.HashtableFromResultSet(rsTask));      
	 pg.setTitle(rsTask.getString("name"));
	 email = rsTask.getString("email");
      }
      rsTask.close();
      sqlTask.close();

      // start experiment
      PreparedStatement sql = pg.prepareStatement(
	 "INSERT INTO " + module + "_experiment"
	 + " (task_id, signature, started) VALUES (?,?,Now())");
      sql.setString(1, request.getParameter("task_id"));
      sql.setString(2, request.getParameter("signature"));
      sql.executeUpdate();
      sql.close();
      sql = pg.prepareStatement("SELECT LAST_INSERT_ID()");
      ResultSet rs = sql.executeQuery();
      rs.next();
      long experiment_id = rs.getLong(1);
      rs.close();
      sql.close();
      pg.set("experiment_id", experiment_id);
      pg.set("task_id", request.getParameter("task_id"));

      // send notification
      if (email != null && email.length() > 0)
      {
	 try
	 {
	    pg.getSite().sendEmail(email, email, pg.getTitle(), 
				   "A participant has started the task:\n"
				   +session.getAttribute("baseUrl").toString() + "/" + module
				   +"/admin/data?x=" + experiment_id);
	 }
	 catch(Exception exception)
	 {
	    pg.set("mailError", exception.toString());
	 }
      }

      %><c:set var="attributePage" scope="request"><db:attributePage
      connection="${page.connection}"
      attributeDefinitionTable="${module}_participant_attribute_definition"
      classIdField="task_id"
      attributeField="attribute"
      attributeRequiredField="required"
      typeField="type"
      labelField="label"
      attributeOrderField="display_order"
      descriptionField="description"
      styleField="style"
      optionDefinitionTable="${module}_participant_attribute_option"
      optionValueField="value"
      optionDescriptionField="description"
      optionOrderField="list_order"
      attributeTable="${module}_experiment_participant_attribute"
      dataObjectField="experiment_id"
      dataAttributeNameField="attribute"
      dataAttributeValueField="value"
      classId="${param['task_id']}"
      objectId="${experiment_id}"
      resources="${resources}"
      saveText="Next"
      saveButton="${template_path}/icon/go-next.png"
      ><!-- need this here --></db:attributePage></c:set><%

   } // task_id set
}
%>
