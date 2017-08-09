<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Site site = pg.getSite();
   Module module = pg.getModule();
   User user = pg.getUser();
   Connection connection = pg.getConnection();

   pg.setTitle(module.getName());
   String task_id = request.getParameter("task_id");
   if (task_id == null)
   { // no task_id
      PreparedStatement sqlTask = pg.prepareStatement(
	 "SELECT * FROM " + module + "_task_definition WHERE active = 1 ORDER BY name");
      ResultSet rsTask = sqlTask.executeQuery();
      Vector tasks = Page.HashtableCollectionFromResultSet(rsTask);
      if (tasks.size() == 1)
      { // only one, so just show it
	 task_id = ((Hashtable)tasks.elementAt(0)).get("task_id").toString();
      }
      else
      { // more than one, so list them
	 pg.set("tasks", tasks);
      }
      rsTask.close();
      sqlTask.close();
   } // no task_id


   if (task_id != null)
   { // task_id set
      PreparedStatement sqlTask = pg.prepareStatement(
	 "SELECT * FROM " + module + "_task_definition WHERE active = 1 AND task_id = ?");
      sqlTask.setString(1, task_id);
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
