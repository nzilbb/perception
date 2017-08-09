<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Module module = pg.getModule();
   int experiment_id = new Double(request.getParameter("x")).intValue();
   pg.set("experiment_id", experiment_id);

   PreparedStatement sql = pg.prepareStatement(
      "SELECT * FROM " + module + "_experiment WHERE experiment_id = ?");
   sql.setInt(1, experiment_id);
   ResultSet rs = sql.executeQuery();
   try
   {
      if (!rs.next())
      {
	 pg.addError("Invalid result: " + experiment_id);
	 return;
      }

      if (pg.getUser().hasAccess(module, "admin/data"))
      {
	Object[] a = { new Integer(experiment_id) };
      	pg.setTitle(pg.localize("Data for experiment {0}", a));
      	pg.addBreadCrumb("Tasks", "tasks");
      	pg.addBreadCrumb("task", "task?task_id="+rs.getString("task_id"));
      	pg.addBreadCrumb("Results", "results?task_id="+rs.getString("task_id"));
      	pg.addBreadCrumb("" + experiment_id);
      	pg.addBreadCrumb("CSV", "?x="+experiment_id+"&content-type=text/csv");
      }
      pg.set("experiment", pg.HashtableFromResultSet(rs));

      if ("text/csv".equals(request.getParameter("content-type")))
      {
	 pg.setTemplatePage(null); // don't wrap the template around this page
	 pg.addResponseHeader("Content-Disposition", 
			      "attachment; filename=" + rs.getInt("experiment_id") + "_" + rs.getDate("started") + ".csv;");
      }

   }
   finally
   {
      rs.close();
      sql.close();
   }

   sql = pg.prepareStatement(
      "SELECT p.* FROM " + module + "_experiment_participant_attribute p"
      +" INNER JOIN " + module + "_experiment x ON p.experiment_id = x.experiment_id"
      +" LEFT OUTER JOIN " + module + "_participant_attribute_definition a"
      +" ON a.task_id = x.task_id AND a.attribute = p.attribute"
      +" WHERE p.experiment_id = ?"
      +" ORDER BY a.display_order, p.attribute");
   sql.setInt(1, experiment_id);
   rs = sql.executeQuery();
   pg.set("participantAttributes", pg.HashtableCollectionFromResultSet(rs));
   rs.close();
   sql.close();

   Vector<String> questions = new Vector<String>();
   sql = pg.prepareStatement(
      "SELECT q.question FROM " + module + "_question_definition q"
      +" INNER JOIN " + module + "_experiment x ON x.task_id = q.task_id"
      +" WHERE x.experiment_id = ?"
      +" ORDER BY q.display_order");
   sql.setInt(1, experiment_id);
   rs = sql.executeQuery();
   while (rs.next()) questions.add(rs.getString("question"));
   pg.set("questions", questions);
   rs.close();
   sql.close();

   PreparedStatement sqlAnswer = pg.prepareStatement(
      "SELECT answer FROM " + module + "_experiment_stimulus_answer"
      +" WHERE experiment_id = ? AND stimulus_id = ? AND question = ?");
   sqlAnswer.setInt(1, experiment_id);

   sql = pg.prepareStatement(
      "SELECT e.*, s.label FROM " + module + "_experiment_stimulus e"
      +" INNER JOIN " + module + "_experiment x ON e.experiment_id = x.experiment_id"
      +" INNER JOIN " + module + "_stimulus_definition s"
      +" ON s.task_id = x.task_id AND s.stimulus_id = e.stimulus_id"
      +" WHERE e.experiment_id = ?"
      +" ORDER BY e.stimulus_ordinal");
   sql.setInt(1, experiment_id);
   rs = sql.executeQuery();
   Vector<Hashtable> stimuli = new Vector<Hashtable>();
   pg.set("stimuli", stimuli);
   while (rs.next())
   {
      Hashtable stimulus = pg.HashtableFromResultSet(rs);
      stimuli.add(stimulus);
      Vector<String> answers = new Vector<String>();
      stimulus.put("answers", answers);
      sqlAnswer.setInt(2, rs.getInt("stimulus_id"));
      for (String question : questions)
      {
	 sqlAnswer.setString(3, question);
	 ResultSet rsAnswer = sqlAnswer.executeQuery();
	 if (rsAnswer.next())
	 {
	    answers.add(rsAnswer.getString(1));
	 }
	 else
	 {
	    answers.add("");
	 }
	 rsAnswer.close();
      } // next question
   } // next stimulus
   rs.close();
   sql.close();
   sqlAnswer.close();
}
%>