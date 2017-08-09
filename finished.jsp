<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.io.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Site site = pg.getSite();
   Module module = pg.getModule();
   User user = pg.getUser();
   Connection connection = pg.getConnection();

   pg.setTitle(module.getName());
   if (request.getParameter("x") == null)
   { // no experiment_id
      pg.addError("Invalid task");
   } // no experiment_id
   else
   { // experiment_id set
      Integer experiment_id = new Double(request.getParameter("x")).intValue();
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
	    String email = rsTask.getString("email");
	    try
	    {	       
	       if (rsTask.getString("comment").length() > 0)
	       {
		  if (request.getParameter("comment") == null)
		  {
		     pg.set("promptForComment", true);
		     return;
		  }
		  else
		  { // save the comment
		     PreparedStatement sql = pg.prepareStatement(
			"UPDATE " + module + "_experiment SET comment = ? WHERE experiment_id = ?");
		     sql.setString(1, request.getParameter("comment"));
		     sql.setString(2, request.getParameter("x"));
		     sql.executeUpdate();
		     sql.close();
		  }
	       }

	       // score answers
	       PreparedStatement sqlScore = pg.prepareStatement(
		  "SELECT COUNT(given.answer) AS correct, COUNT(correct.answer) AS outOf"
		  +" FROM " + module + "_stimulus_answer correct"
		  +" INNER JOIN " + module + "_experiment exp ON exp.task_id = correct.task_id"
		  +" LEFT OUTER JOIN " + module + "_experiment_stimulus_answer given"
		  +" ON given.experiment_id = exp.experiment_id"
		  +" AND given.stimulus_id = correct.stimulus_id"
		  +" AND given.question = correct.question"
		  +" AND given.answer = correct.answer"
		  + " WHERE exp.experiment_id = ?");
	       sqlScore.setString(1, request.getParameter("x"));
	       ResultSet rsScore = sqlScore.executeQuery();
	       if (rsScore.next())
	       {
		  pg.set("score", pg.localizePattern(
			    "{0} out of {1}, that''s {2}% correct!",
			    rsScore.getString("correct"), rsScore.getString("outOf"),
			    new Integer(rsScore.getInt("correct")*100/rsScore.getInt("outOf"))), false);
	       }
	       rsScore.close();
	       sqlScore.close();

	       // send notification
	       if (email != null && email.length() > 0)
	       {
		  // get experiment data for file name
		  PreparedStatement sql = pg.prepareStatement(
		     "SELECT experiment_id, started FROM " + module + "_experiment WHERE experiment_id = ?");
		  sql.setString(1, request.getParameter("x"));
		  ResultSet rs = sql.executeQuery();
		  rs.next();
		  String fileName = rs.getString("experiment_id") + "_" + rs.getDate("started");
		  rs.close();
		  sql.close();

		  // get CSV data
		  %><c:set var="csv" scope="request"><c:import url="/WEB-INF/modules/${module}/admin/data.jsp" /><c:import url="/WEB-INF/modules/${module}/admin/data.csv.jsp" /></c:set><%
		  // write it to a file
		  File f = new File(new File(System.getProperty("java.io.tmpdir")), fileName + ".csv");
		  FileWriter w = new FileWriter(f);
		  w.write((String)request.getAttribute("csv"));
		  w.close();
		  try
		  {
		     pg.getSite().sendEmail(email, email, pg.getTitle(), 
					    "A participant has finished the task:\n"
					    +session.getAttribute("baseUrl").toString() + "/" + module
					    +"/admin/data?x=" + experiment_id, f);
		  }
		  catch(Exception exception)
		  {
		     pg.set("mailError", exception.toString());
		  }
		  f.delete();
	       }
	    }
	    finally
	    {
	       rsTask.close();
	       sqlTask.close();
	    }
	 } // task found
      } // task_id set
   } // experiment_id set
}
%>
