
<!-- Substance Name, Substance Identity, Other names of Substance -->
<#macro substanceIdentity _subject>
	<#compress>

		<#if !csrRelevant?? && !pppRelevant??>
			<@com.substanceName _subject/>
			<@com.emptyLine/>
		<#elseif pppRelevant??>
			<@substanceInfo _subject/>
		</#if>

		<#assign referenceSubstance = iuclid.getDocumentForKey(_subject.ReferenceSubstance.ReferenceSubstance) />
		<#if referenceSubstance?has_content>
				<#if pppRelevant??><para><emphasis role="underline">Names and identifiers of reference substance</emphasis>: </para></#if>
				<@basicInfo referenceSubstance/>
			<#if !pppRelevant??>
				<!-- Structural formula -->
				<@com.structuralFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
			</#if>
		</#if>

		<#if !pppRelevant??>
			<#if _subject.OtherNames?has_content>
				<para>Other identifiers:</para>
				<@com.otherIdentifiersList _subject.OtherNames/>
			</#if>

			<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.Remarks?has_content>
				<para><emphasis role="bold">Remarks:</emphasis></para>
				<para>
					<@com.molecularStructuralRemarks com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
					<@com.emptyLine/>
				</para>
			</#if>
		</#if>
	</#compress>
</#macro>

<#function referenceSubstanceHasContent refSubstance>
	<#if refSubstance.Inventory?? && refSubstance.Inventory.InventoryEntry?has_content>
		<#return true>
	</#if>
	<#if refSubstance?? && (
		refSubstance.Inventory.CASNumber?has_content ||
		refSubstance.Inventory.CASName?has_content ||
		refSubstance.IupacName?has_content ||
		refSubstance.Description?has_content ||
		refSubstance.Synonyms.Synonyms?has_content)>
		<#return true>
	</#if>
	<#if refSubstance.MolecularStructuralInfo?? && (
		refSubstance.MolecularStructuralInfo.MolecularFormula?has_content ||
		refSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content)>
		<#return true>
	</#if>

	<#return false>
</#function>


<#function isNotRelevant notRelevant>
	<#if notRelevant==csrRelevant>
		<#return false>
	<#else>
		<#return true>
	</#if>
	<#return false>
</#function>

<#--NOTE: this macro is repeated. Modifications to be included in macros_common_general.ftl-->
<#macro otherIdentifiersList otherNamesRepeatableBlock role="">
	<#compress>
		<#if otherNamesRepeatableBlock?has_content>
			<#list otherNamesRepeatableBlock as blockItem>
				<para role="${role}">
					<@com.picklist blockItem.NameType/>: <@com.text blockItem.Name/>
					<#if blockItem.Relation?has_content>
						(<@com.picklist blockItem.Relation/>)
					</#if>
					<@com.picklistMultiple blockItem.Country/>
					<#if blockItem.Remarks?has_content>
						(<@com.text blockItem.Remarks/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro substanceInfo substance>

	<para><emphasis role="underline">Name</emphasis>: <@com.substanceName substance/></para>

	<#if substance.PublicName?has_content>
		<para><emphasis role="underline">Public name</emphasis>: <@com.text substance.PublicName/></para>
	</#if>

	<#if substance.OtherNames?has_content>
		<para><emphasis role="underline">Other identifiers:</emphasis></para>
		<@otherIdentifiersList substance.OtherNames 'indent'/>
	</#if>

	<#if substance.TypeOfSubstance?has_content>
		<para>
			<emphasis role="underline">Type of substance:</emphasis>
			<#if substance.TypeOfSubstance.Composition?has_content>
				<@com.picklist substance.TypeOfSubstance.Composition/><#if substance.TypeOfSubstance.Origin?has_content>, </#if>
			</#if>
			<#if substance.TypeOfSubstance.Origin?has_content>
				<@com.picklist substance.TypeOfSubstance.Origin/>
			</#if>
		</para>
	</#if>
</#macro>

<#macro basicInfo referenceSubstance>
	<#compress>
		<#if referenceSubstanceHasContent(referenceSubstance)>
			<@com.emptyLine/>
			<table border="1">
				<title>Substance identity</title>
				<col width="35%" />
				<col width="65%" />
				<tbody>
					<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">EC number:</emphasis></th>
						<td>
							<@com.inventoryECNumber com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
					</#if>
					<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">EC name:</emphasis></th>
						<td>
							<@com.inventoryECName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
						</td>
					</tr>
					</#if>
					<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS number (EC inventory):</emphasis></th>
						<td>
							<@com.inventoryECCasNumber com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
						</td>
					</tr>
					</#if>
					<#if referenceSubstance?? && referenceSubstance.Inventory.CASNumber?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS number:</emphasis></th>
							<td>
								<@com.casNumber com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?? && referenceSubstance.Inventory.CASName?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS name:</emphasis></th>
							<td>
								<@com.casName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?? && referenceSubstance.IupacName?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">IUPAC name:</emphasis></th>
							<td>
								<@com.iupacName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?? && referenceSubstance.Description?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description:</emphasis></th>
							<td>
								<@com.description com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?? && referenceSubstance.Synonyms.Synonyms?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Synonyms:</emphasis></th>
						<td>
							<@synonyms com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
					</#if>
					<#if !pppRelevant??>
						<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularFormula?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular formula:</emphasis></th>
								<td>
									<@com.molecularFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
								</td>
							</tr>
						</#if>
						<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular weight range:</emphasis></th>
								<td>
									<@com.molecularWeight com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
								</td>
							</tr>
						</#if>
					</#if>
				</tbody>
			</table>

		<#else>
			<@com.emptyLine/>
			<table border="0">
				<title>Substance identity</title>
				<col width="100%" />
				<tbody><tr><td>No information available</td></tr></tbody>
			</table>
		</#if>
	</#compress>
</#macro>

<#macro molecularAndStructuralInfo _subject>
	<#compress>

		<#assign referenceSubstance = iuclid.getDocumentForKey(_subject.ReferenceSubstance.ReferenceSubstance) />
		<#if referenceSubstance?has_content && referenceSubstance.MolecularStructuralInfo?has_content>
			<table border="1">
				<title>Molecular and structural information of the substance</title>
				<col width="35%" />
				<col width="65%" />
				<tbody>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularFormula?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular formula:</emphasis></th>
							<td>
								<@com.molecularFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular weight:</emphasis></th>
							<td>
								<@com.molecularWeight com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.SmilesNotation?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">SMILES:</emphasis></th>
							<td>
								<@com.smilesNotation com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.InChl?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">InChI:</emphasis></th>
							<td>
								<@inchi com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.StructuralFormula?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Structural formula:</emphasis></th>
							<td>
								<@structuralFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
							</td>
						</tr>
					</#if>
				</tbody>
			</table>

			<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.Remarks?has_content>
				<para><emphasis role="bold">Remarks:</emphasis></para>
				<para>
					<@com.molecularStructuralRemarks com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
				</para>
			</#if>
		<#else>
			<table border="0">
				<title>Molecular and structural information of the substance</title>
				<col width="100%" />
				<tbody><tr><td>No information available</td></tr></tbody>
			</table>
		</#if>
	</#compress>
</#macro>

<#--macros to be moved to macros_common_general.ftl-->
<#macro inchi referenceSubstanceID>
	<#compress>
		<#if referenceSubstanceID?has_content>
			<#if referenceSubstanceID.MolecularStructuralInfo.InChl?has_content>
				<@com.text referenceSubstanceID.MolecularStructuralInfo.InChl />
			<#else>No SMILES notation provided
			</#if>
		</#if>
	</#compress>
</#macro>

<#--Need to disable figure numbering-->
<#macro structuralFormula referenceSubstanceID>
	<#compress>
		<#if referenceSubstanceID?has_content>
			<#local attachmentKey = referenceSubstanceID.MolecularStructuralInfo.StructuralFormula />
			<#if attachmentKey?has_content>
				<#local structuralFormula = iuclid.getMetadataForAttachment(attachmentKey) />
				<#if structuralFormula?has_content && structuralFormula.isImage>
					<#if structuralFormula.exceedsLimit(10000000)>
						<para><emphasis>Image size is too big (${structuralFormula.size} bytes) and cannot be displayed!</emphasis></para>
					<#elseif !iuclid.imageMimeTypeSupported(structuralFormula.mediaType) >
						<para><emphasis>Image type (${structuralFormula.mediaType}) is not yet supported!</emphasis></para>
					<#else>
						<figure>
							<mediaobject>
								<imageobject>
									<imagedata scalefit="1" fileref="data:${structuralFormula.mediaType};base64,${iuclid.getContentForAttachment(attachmentKey)}" />
								</imageobject>
							</mediaobject>
						</figure>
					</#if>
				</#if>
			<#else>
				<emphasis>No structural formula image attached to the Reference substance</emphasis>
			</#if>
		</#if>
	</#compress>
</#macro>

<#macro synonyms referenceSubstanceID>
	<#compress>

		<#if referenceSubstanceID?has_content && referenceSubstanceID.Synonyms.Synonyms?has_content>

			<#if !pppRelevant??><para>Synonyms</para></#if>
			<#list referenceSubstanceID.Synonyms.Synonyms as synonyms>
				<#if synonyms?has_content>

					<para>
						<#if synonyms.Identifier?has_content>
							<#if !csrRelevant?? && !pppRelevant??>Synonym identifier:</#if>
							<@com.picklist synonyms.Identifier/><#if csrRelevant?? && !pppRelevant??>:</#if>
						</#if>

						<#if synonyms.Name?has_content>
							<#if !csrRelevant?? && !pppRelevant??>Synonym name/identity:</#if> <@com.text synonyms.Name/>
						</#if>

						<#if pppRelevant??>
							<#if synonyms.Remarks?has_content>
								(<@com.text synonyms.Remarks/>)
							</#if>
						</#if>
					</para>

					<#if synonyms.Remarks?has_content>
						<#if !csrRelevant?? && !pppRelevant??>
							<para>Synonym remarks: <@com.text synonyms.Remarks/></para>
						</#if>
					</#if>

					<#if synonyms_has_next><?linebreak?></#if>

				<#else>
					No synonyms provided
				</#if>
			</#list>
		</#if>

	</#compress>
</#macro>