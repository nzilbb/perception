<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
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
   if (request.getParameter("x") == null)
   { // no experiment_id
      pg.addError("Invalid task");
   } // no experiment_id
   else
   { // experiment_id set
      Integer experiment_id = new Double(request.getParameter("x")).intValue();
      PreparedStatement sql = pg.prepareStatement(
	 "SELECT * FROM " + module + "_experiment WHERE experiment_id = ?");
      sql.setInt(1, experiment_id);
      ResultSet rs = sql.executeQuery();
      if (!rs.next())
      {
	 pg.addError("Invalid task");
      }
      else
      {
	 pg.set("experiment", Page.HashtableFromResultSet(rs));
	 int task_id = rs.getInt("task_id");
	 rs.close();
	 sql.close();
	 
	 sql = pg.prepareStatement(
	    "SELECT * FROM " + module + "_task_definition WHERE task_id = ?");
	 sql.setInt(1, task_id);
	 rs = sql.executeQuery();
	 rs.next();
	 pg.set("task", Page.HashtableFromResultSet(rs));
	 int stimuli_order = rs.getInt("stimuli_order");
	 rs.close();
	 sql.close();
	 
	 // are they saving the last values?
	 if (request.getParameter("prFormAction") != null)
	 {
	    // save those values
	    %><c:set var="prevAttributePage" scope="request"><db:attributePage
	       connection="${page.connection}"
	       attributeDefinitionTable="${module}_question_definition"
	       classIdField="task_id"
	       attributeField="question"
	       attributeRequiredField="required"
	       typeField="type"
	       labelField="label"
	       attributeOrderField="display_order"
	       descriptionField="description"
	       styleField="style"
	       optionDefinitionTable="${module}_question_option"
	       optionValueField="value"
	       optionDescriptionField="description"
	       optionOrderField="list_order"
	       attributeTable="${module}_experiment_stimulus_answer"
	       dataObjectField="experiment_id|stimulus_id"
	       dataAttributeNameField="question"
	       dataAttributeValueField="answer"
	       classId="${task.task_id}"
	       objectId="${param['objectId']}"
	       resources="${resources}"
	       ><!-- need this here --></db:attributePage></c:set><%
	 }

	 // total stimuli
	 sql = pg.prepareStatement(
	    "SELECT COUNT(*) FROM " + module + "_stimulus_definition WHERE task_id = ?");
	 sql.setInt(1, task_id);
	 rs = sql.executeQuery();
	 rs.next();
	 int stimuliTotal = rs.getInt(1);
	 pg.set("stimuliTotal", stimuliTotal);

	 // get a list of stimuli we haven't presented yet
	 sql = pg.prepareStatement(
	    "SELECT d.* FROM " + module + "_stimulus_definition d"
	    +" INNER JOIN " + module + "_experiment e ON d.task_id = e.task_id"
	    +" LEFT OUTER JOIN " + module + "_experiment_stimulus s"
	    +" ON d.stimulus_id = s.stimulus_id AND s.experiment_id = e.experiment_id"
	    +" WHERE e.experiment_id = ? AND s.experiment_id IS NULL"
	    +" ORDER BY d.list_order");
	 sql.setInt(1, experiment_id);
	 rs = sql.executeQuery();
	 Vector stimuli = Page.HashtableCollectionFromResultSet(rs);
	 rs.close();
	 sql.close();
	 pg.set("stimuliLeft", stimuli.size());
	 pg.set("stimuliSoFar", stimuliTotal - stimuli.size());
	 if (stimuli.size() > 0)
	 {
	    int s = 0;
	    if (stimuli_order == 0)
	    {
	       s = new java.util.Random().nextInt(stimuli.size());
	    }
	    Hashtable stimulus = (Hashtable)stimuli.elementAt(s);
	    pg.set("stimulus", stimulus);
	    int stimulus_id = new Integer(stimulus.get("stimulus_id").toString());

	    %><c:set var="attributePage" scope="request"><db:attributePage
		  connection="${page.connection}"
		  attributeDefinitionTable="${module}_question_definition"
		  classIdField="task_id"
		  attributeField="question"
		  attributeRequiredField="required"
		  typeField="type"
		  labelField="label"
		  attributeOrderField="display_order"
		  descriptionField="description"
		  styleField="style"
		  optionDefinitionTable="${module}_question_option"
		  optionValueField="value"
		  optionDescriptionField="description"
	          optionOrderField="list_order"
		  attributeTable="${module}_experiment_stimulus_answer"
		  dataObjectField="experiment_id|stimulus_id"
		  dataAttributeNameField="question"
		  dataAttributeValueField="answer"
		  classId="${task.task_id}"
		  objectId="${experiment.experiment_id}|${stimulus.stimulus_id}"
		  resources="${resources}"
		  saveText="Next"
		  saveButton="${template_path}/icon/go-next.png"
		  embedFieldsInOtherForm="true"
		  ><!-- need this here --></db:attributePage></c:set><%
	    
	    // register the presentation of the stimulus
	    sql = pg.prepareStatement(
	       "INSERT INTO " + module + "_experiment_stimulus"
	       +" (experiment_id, stimulus_id, stimulus_ordinal, started) VALUES (?,?,?,Now())");
	    sql.setInt(1, experiment_id);
	    sql.setInt(2, stimulus_id);
	    sql.setInt(3, (stimuliTotal - stimuli.size()) + 1);
	    sql.executeUpdate();
	    sql.close();
	 }
	 else
	 {
	    // mark the experiment as finished
	    sql = pg.prepareStatement(
	       "UPDATE " + module + "_experiment SET finished = Now() WHERE experiment_id = ?");
	    sql.setInt(1, experiment_id);
	    sql.executeUpdate();
	    sql.close();
	    
	    pg.sendRedirect(session.getAttribute("baseUrl")+"/"+module+"/finished?task_id="+task_id+"&x=" + request.getParameter("x"));
	 }
	 
      }
      rs.close();
      sql.close();
   } // task_id set
}
%>
