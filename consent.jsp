<%@ page import = "nz.net.fromont.hexagon.*" 
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
	 pg.addError("Invalid task");
   } // no task_id
   else
   { // task_id set
      PreparedStatement sqlTask = pg.prepareStatement(
	 "SELECT * FROM " + module + "_task_definition WHERE active = 1 AND task_id = ?");
      sqlTask.setString(1, request.getParameter("task_id"));
      ResultSet rsTask = sqlTask.executeQuery();
      if (!rsTask.next())
      {
	 pg.addError("Invalid task");
      }
      else
      {
	 pg.set("task", Page.HashtableFromResultSet(rsTask));      
	 pg.setTitle(rsTask.getString("name"));
      }
      rsTask.close();
      sqlTask.close();
   } // task_id set
}
%>
