<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<div class="stimulus">
  <div class="preamble">${task.stimulus_preamble}</div>
  <div class="media">
    <audio autoplay src="media/${stimulus.task_id}/${stimulus.stimulus_id}.mp3" controls>
      <!-- XP/IE8 support: use Windows Media Player -->
      <OBJECT ID="wmp${index}" CLASS="wmpaudio" HEIGHT="0"
	      CLASSID="CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6">
	<PARAM name="URL" value="media/${stimulus.task_id}/${stimulus.stimulus_id}.mp3" />
	<PARAM name="autostart" value="true"/>
	<PARAM NAME="SendPlayStateChangeEvents" VALUE="True" />
	${resources['Sorry, your browser does not support audio']}
      </OBJECT>
    </audio>
  </div>
  <div class="questions">
    <form accept-charset="utf-8" method="post" id="frm" onsubmit="return next();">
      ${attributePage}
      <button class="db_submit"><img src="${template_path}/icon/go-next.png"/> ${resources['Next']}&nbsp;</button>
      <script type="text/javascript">//<![CDATA[
// form validation
function next() {
var frm = document.getElementById("frm");
  if (!validate_${task.task_id}_${experiment.experiment_id}_${stimulus.stimulus_id}(frm)) return false;
  var nothingChanged = true;
  for (var e in frm.elements) {
    if (frm.elements[e].type == "range"
        && frm.elements[e].min != null && frm.elements[e].max != null) {
      if (frm.elements[e].step == 1) { // integers are assumed to be changed
        nothingChanged = false;
      } else {
        var startValue = parseFloat(frm.elements[e].min) + ((frm.elements[e].max - frm.elements[e].min) / 2);
        if (frm.elements[e].value != startValue) nothingChanged = false;
      }
    }
  } // next element
  if (nothingChanged) {
    alert("${resources['Please change at least one rating']}");
    return false;
  }
  return true;
}
//]]></script>

    </form>
  </div>
  <div class="progress">
    <progress max="${stimuliTotal}" value="${stimuliSoFar}" title="${stimuliSoFar}/${stimuliTotal}">${stimuliSoFar}/${stimuliTotal}</progress>
  </div>
</div>
