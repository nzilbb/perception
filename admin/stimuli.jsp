<%@ page import = "java.io.*" 
%><%@ page import = "java.util.*" 
%><%@ page import = "java.text.*" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.awt.*" 
%><%@ page import = "java.awt.image.*" 
%><%@ page import = "java.awt.geom.*" 
%><%@ page import = "javax.imageio.*" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "nz.net.fromont.dbtags.*" 
%><%@ page import = "org.apache.commons.fileupload.*" 
%><%@ page import = "org.apache.commons.fileupload.servlet.*" 
%><%@ page import = "org.apache.commons.fileupload.disk.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Site site = pg.getSite();
   Module module = pg.getModule();
   User user = pg.getUser();
   Connection connection = pg.getConnection();
   
   String task_id = request.getParameter("task_id");
   pg.set("task_id", task_id, false);
   String sFile = request.getParameter("file");
   String sRoot = "/" + module.getModuleRoot() + "/media";
   File fRoot = new File(module.getRealPath(pg),"media");
   if (!fRoot.exists()) fRoot.mkdir();
   File fTaskRoot = new File(fRoot, task_id);
   if (!fTaskRoot.exists()) fTaskRoot.mkdir();
   
   PreparedStatement sqlTask = pg.prepareStatement(
      "SELECT * FROM " + module + "_task_definition WHERE task_id = ?");
   sqlTask.setString(1, task_id);
   ResultSet rsTask = sqlTask.executeQuery();
   try
   {
      if (!rsTask.next())
      {
	 pg.addError("Invalid task: " + task_id);
	 return;
      }

      Object[] a = { rsTask.getString("name") };
      pg.setTitle(pg.localize("Stimuli for task ''{0}''", a));
      pg.addBreadCrumb("Tasks", "tasks");
      pg.addBreadCrumb(rsTask.getString("name"), "task?task_id="+task_id);
      pg.addBreadCrumb("Stimuli");
   
   }
   finally
   {
      sqlTask.close();
      rsTask.close();
   }
   
   PreparedStatement sqlScoredQuestions = pg.prepareStatement(
      "SELECT * FROM " + module + "_question_definition"
      +" WHERE task_id = ? AND scored = 1 ORDER BY display_order");
      sqlScoredQuestions.setString(1, task_id);
   ResultSet rsScoredQuestions = sqlScoredQuestions.executeQuery();
   LinkedHashMap<String,String> scoredQuestions = new LinkedHashMap<String,String>();
   pg.set("scoredQuestions", scoredQuestions);
   while (rsScoredQuestions.next())
   {
      scoredQuestions.put(rsScoredQuestions.getString("question"), rsScoredQuestions.getString("label"));
   } // next scored field
   rsScoredQuestions.close();
   sqlScoredQuestions.close();      

   // get the next stimulus ID
   PreparedStatement sqlId = pg.prepareStatement(
      "SELECT COALESCE(MAX(stimulus_id) + 1, 1) AS next FROM " + module + "_stimulus_definition"
      +" WHERE task_id = ?");
   sqlId.setString(1, task_id);
   ResultSet rsId = sqlId.executeQuery();
   rsId.next();
   int stimulus_id = rsId.getInt(1);
   rsId.close();
   sqlId.close();
   pg.set("default_order", stimulus_id);
   
   // Check that we have a file upload request
   boolean isMultipart = ServletFileUpload.isMultipartContent(request);

   if (isMultipart)
   {
      // Create a factory for disk-based file items
      FileItemFactory factory = new DiskFileItemFactory();
      
      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);

      // Parse the request
      java.util.List /* FileItem */ items = upload.parseRequest(request);

      Iterator i = items.iterator();
      String sLabel = "";
      String sListOrder = "";
      String sFileName = "";
      HashMap<String,String> answers = new HashMap<String,String>();
      while (i.hasNext())
      {
	 FileItem item = (FileItem) i.next();
	 if (item.getFieldName().equals("label"))
	 {
	    sLabel = item.getString();
	 }
	 else if (item.getFieldName().equals("list_order"))
	 {
	    sListOrder = item.getString();
	 }
	 else if (item.getFieldName().equals("uploadfile"))
	 {
	    sFileName = item.getName();
	    // some browsers provide a full path, which must be truncated
	    int iLastSlash = sFileName.lastIndexOf('/');
	    if (iLastSlash < 0) iLastSlash = sFileName.lastIndexOf('\\');
	    if (iLastSlash >= 0)
	    {
	       sFileName = sFileName.substring(iLastSlash + 1);
	    }
	    File file = new File(fTaskRoot, ""+stimulus_id+".mp3");
	    item.write(file);
	 } // uploadfile
	 else
	 {
	    answers.put(item.getFieldName(), item.getString());
	 }
      } // next file

      PreparedStatement sqlInsert = pg.prepareStatement(
	 "INSERT INTO " + module + "_stimulus_definition"
	 +" (task_id, stimulus_id, label, list_order) VALUES(?,?,?,?)");
      sqlInsert.setString(1, task_id);
      sqlInsert.setInt(2, stimulus_id);
      sqlInsert.setString(3, sLabel);
      sqlInsert.setString(4, sListOrder);
      sqlInsert.executeUpdate();
      sqlInsert.close();

      sqlInsert = pg.prepareStatement(
	 "INSERT INTO " + module + "_stimulus_answer"
	 +" (answer, stimulus_id, task_id, question) VALUES (?,?,?,?)");
      sqlInsert.setInt(2, stimulus_id);
      sqlInsert.setString(3, task_id);
      for (String question : scoredQuestions.keySet())
      {
	 sqlInsert.setString(4, question);
	 sqlInsert.setString(1, answers.get("answer_" + question));
	 sqlInsert.executeUpdate();
      } // next answer
      sqlInsert.close();

      pg.addMessage("Added <tt>" + sFileName + "</tt>");
      
   } // isMultipart
   else if ("update".equals(request.getParameter("command")))
   {
      PreparedStatement sqlUpdate = pg.prepareStatement(
	 "UPDATE " + module + "_stimulus_definition"
	 +" SET label = ?, list_order = ?"
	 +" WHERE task_id = ? AND stimulus_id = ?");
      sqlUpdate.setString(1, request.getParameter("label"));
      sqlUpdate.setString(2, request.getParameter("list_order"));
      sqlUpdate.setString(3, task_id);
      sqlUpdate.setString(4, request.getParameter("stimulus_id"));
      sqlUpdate.executeUpdate();
      sqlUpdate.close();

      sqlUpdate = pg.prepareStatement(
	 "UPDATE " + module + "_stimulus_answer"
	 +" SET answer = ?"
	 +" WHERE stimulus_id = ? AND task_id = ? AND question = ?");
      sqlUpdate.setString(2, request.getParameter("stimulus_id"));
      sqlUpdate.setString(3, task_id);
      for (String question : scoredQuestions.keySet())
      {
	 sqlUpdate.setString(4, question);
	 sqlUpdate.setString(1, request.getParameter("answer_" + question));
	 sqlUpdate.executeUpdate();
      } // next answer
      sqlUpdate.close();

      pg.addMessage("Simulus updated");
   }
   else if ("delete".equals(request.getParameter("command")))
   {
      PreparedStatement sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_stimulus_definition"
	 +" WHERE task_id = ? AND stimulus_id = ?");
      sql.setString(1, task_id);
      sql.setString(2, request.getParameter("stimulus_id"));
      sql.executeUpdate();
      sql.close();

      sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_stimulus_answer"
	 +" WHERE task_id = ? AND stimulus_id = ?");
      sql.setString(1, task_id);
      sql.setString(2, request.getParameter("stimulus_id"));
      sql.executeUpdate();
      sql.close();
      
      pg.addMessage("Deleted stimulus");
      

      File file = new File(fTaskRoot, request.getParameter("stimulus_id") + ".mp3");
      if (!file.exists())
      {
	 pg.addError("File <tt>" + file.getName() + "</tt> has already been deleted.");
      }
      else if (!file.delete())
      {
	 pg.addError("Could not delete file <tt>" + file.getPath() + "</tt>");
      }
   }

   PreparedStatement sql = pg.prepareStatement(
      "SELECT * FROM " + module + "_stimulus_definition WHERE task_id = ? ORDER BY list_order");
   sql.setString(1, task_id);
   ResultSet rs = sql.executeQuery();
   Vector<Hashtable> stimuli = Page.HashtableCollectionFromResultSet(rs);
   pg.set("stimuli", stimuli);
   rs.close();
   sql.close();

   // get the answers
   sql = pg.prepareStatement(
      "SELECT * FROM " + module + "_stimulus_answer WHERE task_id = ? AND stimulus_id = ?");
   sql.setString(1, task_id);
   for (Hashtable stimulus : stimuli)
   {
      Integer stimulusId = (Integer)stimulus.get("stimulus_id");
      sql.setInt(2, stimulusId);
      rs = sql.executeQuery();
      while (rs.next())
      {
	 stimulus.put(rs.getString("question"), rs.getString("answer"));
      }
      rs.close();
   }
   sql.close();
}
%>
