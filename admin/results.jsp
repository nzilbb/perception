<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Module module = pg.getModule();
   String task_id = request.getParameter("task_id");
   pg.set("task_id", task_id, false);

   PreparedStatement sql = pg.prepareStatement(
      "SELECT * FROM " + module + "_task_definition WHERE task_id = ?");
   sql.setString(1, task_id);
   ResultSet rs = sql.executeQuery();
   try
   {
      if (!rs.next())
      {
	 pg.addError("Invalid task: " + task_id);
	 return;
      }
      
      Object[] a = { rs.getString("name") };
      pg.setTitle(pg.localize("Results for task ''{0}''", a));
      pg.addBreadCrumb("Tasks", "tasks");
      pg.addBreadCrumb(rs.getString("name"), "task?task_id="+task_id);
      pg.addBreadCrumb("Results");

   }
   finally
   {
      rs.close();
      sql.close();
   }

   if ("delete".equals(request.getParameter("todo")))
   {
      sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_experiment_stimulus_answer WHERE experiment_id = ?");
      sql.setString(1, request.getParameter("x"));
      sql.executeUpdate();
      sql.close();

      sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_experiment_stimulus WHERE experiment_id = ?");
      sql.setString(1, request.getParameter("x"));
      sql.executeUpdate();
      sql.close();

      sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_experiment_participant_attribute WHERE experiment_id = ?");
      sql.setString(1, request.getParameter("x"));
      sql.executeUpdate();
      sql.close();

      sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_experiment WHERE experiment_id = ?");
      sql.setString(1, request.getParameter("x"));
      sql.executeUpdate();
      sql.close();

      pg.addMessage("Records deleted");
   }

   sql = pg.prepareStatement(
      "SELECT * FROM " + module + "_experiment WHERE task_id = ? ORDER BY experiment_id");
   sql.setString(1, task_id);
   rs = sql.executeQuery();
   pg.set("experiments", pg.HashtableCollectionFromResultSet(rs));
   rs.close();
   sql.close();
}
%>
