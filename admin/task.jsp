<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "java.sql.*" 
%><%
Page pg = (Page) request.getAttribute("page");
pg.setTitle("Tasks");
pg.addBreadCrumb("Tasks", "tasks");
PreparedStatement sql = pg.prepareStatement(
   "SELECT name FROM " + pg.getModule() + "_task_definition WHERE task_id = ?");
sql.setString(1, request.getParameter("task_id"));
ResultSet rs = sql.executeQuery();
rs.next();
pg.addBreadCrumb(rs.getString("name"), "task?task_id="+request.getParameter("task_id"));
rs.close();
sql.close();
pg.set("folder", pg.getModule().getModuleRoot() + "/files", false);
%><c:set var="db_table" scope="request"><db:table 
   type="edit"
   insert="false" 
   view="form" 
   columns="3"
   tableName="{module}_task_definition"
   title="${resources['Tasks']}"
   connection="${page.connection}"	
   deleteQuery="SELECT count(*) FROM {module}_experiment WHERE task_id = ?"
   deleteAuxiliarySql="DELETE FROM {module}_participant_attribute_definition where task_id = ? ; DELETE FROM {module}_participant_attribute_option where task_id = ? ; DELETE FROM {module}_question_definition where task_id = ? ; DELETE FROM {module}_stimulus_definition where task_id = ?"
   deleteError="Could not delete - there have already been experiments using this task."
   deleteButton="{template_path}icon/user-trash.png"
   insertButton="{template_path}icon/document-new.png"
   saveButton="{template_path}icon/document-save.png"
   iconAndText="true"
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
     where="1"
     />				
  <db:field
     name="name"	
     label="${resources['Name']}"
     description="${resources['Title for the task']}"     
     type="string"
     access="readwrite"
     required="true"
     order="2"
     languages="${languages}"
     language="${language}"
     size="30"
     />
  <db:field
     name="stimuli_order"
     label="${resources['Stimuli Order']}"
     type="integer"
     optionValues="${resources['0:Random|1:In Order']}"
     access="readwrite"
     required="true"
     />
  <db:field
     name="active"
     label="${resources['Active']}"
     type="select"
     access="readwrite"
     required="true"
     optionValues="${resources['0:Disabled|1:Enabled']}"
     defaultValue="1"
     />
  <db:field
     name="email"	
     label="${resources['Email']}"
     description="${resources['Email for notifications']}"     
     type="string"
     access="readwrite"
     required="false"
     columns="3"
     size="50"
     />
  <db:field
     name="description"
     label="${resources['Description']}"
     description="${resources['Description and instructions for the task']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="3"
     />
  <db:field
     name="consent"
     label="${resources['Consent']}"
     description="${resources['Consent form text']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="3"
     />
  <db:field
     name="valid_signature_pattern"	
     label="${resources['Consent Pattern']}"
     description="${resources['Regular expression defining valid signatures, if it is to be restricted - e.g. ACCEPT']}"     
     type="string"
     access="readwrite"
     required="false"
     columns="3"
     size="20"
     />
  <db:field
     name="before_start"
     label="${resources['Before Start']}"
     description="${resources['Message displayed after consent and demographic forms but before the task begins']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="3"
     />
  <db:field
     name="stimulus_preamble"
     label="${resources['Stimulus Preamble']}"
     description="${resources['Displayed above the playback controls for each stimulus']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="3"
     />
  <db:field
     name="comment"
     label="${resources['Comment Prompt']}"
     description="${resources['Text to ask the participant for final comments, or blank to not ask']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="6"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="3"
     />
  <db:field
     name="finished"
     label="${resources['Finished Task']}"
     description="${resources['Text displayed when the participant has finished']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="6"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="3"
     />
  <db:link
     text="${resources['Participant Attributes']}"
     url="participantAttributes"
     icon="${template_path}icon/system-users.png"
    />
  <db:link
     text="${resources['Questions']}"
     url="questions"
     icon="${template_path}icon/help-browser.png"
    />
  <db:link
     text="${resources['Stimuli']}"
     url="stimuli"
     icon="${template_path}icon/audio-volume-high.png"
    />

</db:table></c:set>
