<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><hex:blockmenu>
  <hex:blockmenuitem 
     urlModule="${block.module.moduleRoot}" urlPath="admin/tasks"
     text="${resources['Edit Tasks']}" />
</hex:blockmenu>
