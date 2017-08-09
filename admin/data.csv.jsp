<%@ taglib prefix="input" uri="http://fromont.net.nz/java/taglib/htmlui" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
${resources["Started"]},${experiment.started}
${resources["Finished"]},${experiment.finished}
${resources["Comment"]},"${experiment.comment}"
<c:forEach var="attribute" items="${participantAttributes}">
${attribute.attribute},${fn:replace(attribute.value,"
",",")}</c:forEach>

${resources['Stimulus']},${resources['Started']}<c:forEach var="question" items="${questions}">,${question}</c:forEach><c:forEach var="stimulus" items="${stimuli}">
${stimulus.label},${stimulus.started}<c:forEach var="answer" items="${stimulus.answers}">,${answer}</c:forEach></c:forEach>
