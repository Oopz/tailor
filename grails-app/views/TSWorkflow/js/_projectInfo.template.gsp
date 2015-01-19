<style>
.detailTable {width:100%;border-collapse: collapse;}
.detailTable tr {height:36px;border-bottom:1px dotted #ccc;}
.detailTable td:FIRST-CHILD {width:120px;}
.detailTable td {min-width:160px;}
</style>
<table class="detailTable">
	<tr>
  		<td>业务单号：</td>
		<td>${project?.projectNumber?.encodeAsHTML()}</td>
  		<td>业务单名：</td>
		<td>${project?.projectName?.encodeAsHTML()}</td>
  		<td>款式描述：</td>
		<td>${project?.projectDesc?.encodeAsHTML()}</td>
	</tr>
	<tr>
  		<td>客户名称：</td>
		<td>${project?.projectCustomer?.encodeAsHTML()}</td>
  		<td>色组：</td>
		<td>${project?.projectColors?.encodeAsHTML()}</td>
  		<td>成衣交期：</td>
		<td>${formatDate(format:'yyyy-MM-dd',date:project?.projectDate1)}</td>
   	</tr>
   	<tr>
   		<td>公司款号：</td>
		<td>${project?.projectInnerNumber?.encodeAsHTML()}</td>
   		<td>客户款号：</td>
		<td>${project?.projectOuterNumber?.encodeAsHTML()}</td>
   		<td>要求面料交期：</td>
		<td>${formatDate(format:'yyyy-MM-dd',date:project?.projectDate2)}</td>
   	</tr>
	<tr>
   		<td>创建者：</td>
		<td>
			<span>${project?.projectOwner?.username?.encodeAsHTML()}</span>
			<span style="margin-left:10px;">(${project?.projectOwner?.userAlias?.encodeAsHTML()})</span>
		</td>
   		<td>创建日期：</td>
		<td><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${project?.dateCreated}"/></td>
   		<td>下单数：</td>
		<td>${project?.projectAmount}</td>
   	</tr>
   	<tr>
   		<td>附件：</td>
   		<td colspan="5">
   			<g:each in="${project?.projectAccessories}">
   				<g:if test="${it.fileType?.startsWith('image/')}">
   					<!-- 当图片时 background-size:32px -->
   					<g:set var="previewCSS" value="height:32px;
   						background-color:rgba(255,255,255,0.5);
   						background-blend-mode:screen;
   						background-size:32px;
   						line-height:32px;background-repeat:no-repeat;background-position:center top;display:inline-block;
   						background-image:url('${createLink(uri:"/file/${it.fileName?.encodeAsHTML()}/${it.fileOriginName?.encodeAsHTML()}?size=120",absolute:true)}');"></g:set>
				</g:if>
				<g:else>
					<!-- 非图片时 -->
					<g:set var="previewCSS" value=""></g:set>
				</g:else>
    			<a href="${createLink(uri:"/file/${it.fileName?.encodeAsHTML()}/${it.fileOriginName?.encodeAsHTML()}",absolute:true)}" 
					target="_blank" style="margin-right:15px;${previewCSS}">
							${it?.fileOriginName?.encodeAsHTML()}
				</a>
   			</g:each>
   		</td>
   	</tr>
</table>