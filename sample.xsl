<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="XML" select="/"/>
	<xsl:variable name="ImagesDir">
		<xsl:value-of select="$XML/root/imagedir"/>
	</xsl:variable>
	<xsl:variable name="LogoPath">
		<xsl:value-of select="$XML/root/logopath"/>
	</xsl:variable>
	<xsl:variable name="templateName">
		<xsl:value-of select="$XML/root/templateName"/>
	</xsl:variable>
	<xsl:variable name="themeColor" >
		<xsl:choose>
			<xsl:when test="$XML/root/theme='yellow'">
				<xsl:value-of select="'#ffd11a'"/>
			</xsl:when>
			<xsl:when test="$XML/root/theme='red'">
				<xsl:value-of select="'#dc3545'"/>
			</xsl:when>
			<xsl:when test="$XML/root/theme='blue'">
				<xsl:value-of select="'#234b7d'"/>
			</xsl:when>
			<xsl:when test="$XML/root/theme='green'">
				<xsl:value-of select="'#1B5E20'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'#234b7d'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="/">
		<fo:root xmlns:fo='http://www.w3.org/1999/XSL/Format'>
			<fo:layout-master-set>
				<fo:simple-page-master master-name='PageMaster-Cover' page-height="279mm" page-width="216mm" margin="10mm 25mm 15mm 25mm">
					<fo:region-body margin="15mm 30mm 10mm 0mm"></fo:region-body>					
				</fo:simple-page-master>
				<fo:simple-page-master master-name='PageMaster' page-height="279mm" page-width="216mm" margin="10mm 25mm 15mm 25mm">
					<fo:region-body margin="15mm 0mm 0mm 0mm"></fo:region-body>
					<fo:region-before region-name="header" extent="5mm" display-align="after"/>
					<fo:region-after region-name="footer" extent="5mm" display-align="before"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name='PageMaster-Content' page-height="279mm" page-width="216mm" margin="10mm 25mm 15mm 25mm">
					<fo:region-body margin="20mm 0mm 0mm 0mm"></fo:region-body>
					<fo:region-before region-name="header" extent="5mm" display-align="after"/>
					<fo:region-after region-name="footer" extent="5mm" display-align="before"/>
				</fo:simple-page-master>
				<fo:simple-page-master margin="10mm 25mm 15mm 25mm" master-name="PageMaster-TOC" page-height="279mm" page-width="216mm">
					<fo:region-body margin="15mm 0mm 0mm 0mm"/>
					<fo:region-before region-name="header" extent="5mm" display-align="after"/>
					<fo:region-after region-name="footer" extent="5mm" display-align="before"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			<xsl:call-template name="showCoverPage"/>
			<xsl:call-template name="showTOF"/>			
			<xsl:call-template name="showCandidateInfo"/>
			<xsl:call-template name="showOpportunityForDev"/>
			<xsl:call-template name="showSignatures"/>
			<xsl:apply-templates select="$XML/root/assessment/corecompetencies/corecompetency" mode="showContent" />
			<fo:page-sequence master-reference="PageMaster" format="1">
				<fo:flow flow-name="xsl-region-body">
					<fo:block id="last-page" text-align="center" font-size="9pt" keep-together="always" keep-with-next="0" break-before="page">End of the Document.</fo:block>
				</fo:flow>
			</fo:page-sequence>	
	  </fo:root>
	</xsl:template>
	<xsl:template name="showTOF">
		<fo:page-sequence master-reference="PageMaster-TOC" initial-page-number="1">
			<xsl:call-template name="showHeader"/>
			<xsl:call-template name="showFooter"/>
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container text-align="left" font-size="12pt" font-family="Helvetica" >
					<fo:block font-weight="bold" font-size="14pt" space-before="14pt" space-after="5pt" keep-with-next.within-page="always">Table of Contents</fo:block>
					<fo:block text-align-last="justify">
						<fo:block padding="1mm">
							<fo:basic-link internal-destination="showcandidateinfo">Candidate Information</fo:basic-link>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="showcandidateinfo"/>
						</fo:block>
						<fo:block padding="1mm">
							<fo:basic-link internal-destination="showopportunityfordev">Opportunity for Development</fo:basic-link>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="showopportunityfordev"/>
						</fo:block>
						<fo:block padding="1mm">
							<fo:basic-link internal-destination="showsignatures">Signatures</fo:basic-link>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation ref-id="showsignatures"/>
						</fo:block>
						<xsl:apply-templates select="$XML/root/assessment/corecompetencies/corecompetency" mode="showCoreCompetencyTOF" />
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template mode="showCoreCompetencyTOF" match="corecompetency">
		<fo:block padding="1mm">
			<fo:basic-link>
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:value-of select="./description" />
			</fo:basic-link>
				<fo:leader leader-pattern="dots"/>
				<fo:page-number-citation>
					<xsl:attribute name="ref-id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
				</fo:page-number-citation>
			</fo:block>	
			<xsl:for-each select="./tasks/*">
				<xsl:variable name="isTaskNA">
					<xsl:value-of select="./isNA"/>
				</xsl:variable>			
				<xsl:if test="name(.) = 'task'">
					<xsl:if test="($templateName='regenerate' and $isTaskNA=0) or ($templateName='generate')">
						<fo:block margin-left="5mm" padding="1mm">				
							<fo:basic-link>
								<xsl:attribute name="internal-destination">
									<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
								</xsl:attribute>							
								<xsl:text> </xsl:text>
								<xsl:value-of select="./description" />
							</fo:basic-link>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation>
								<xsl:attribute name="ref-id">
									<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
								</xsl:attribute>
							</fo:page-number-citation>
						</fo:block>
					</xsl:if>  
				</xsl:if> 
				
				<xsl:if test="name(.) = 'taskgroup'">
					<xsl:if test="($templateName='regenerate' and count(./tasks/task/isNA[text()=0]) > 0) or ($templateName='generate')">	
						<fo:block margin-left="5mm" padding="1mm">
							<xsl:text>Group: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="internal-destination">
									<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
								</xsl:attribute>
								<xsl:value-of select="./description" />								
							</fo:basic-link>
							<fo:leader leader-pattern="dots"/>
							<fo:page-number-citation>
								<xsl:attribute name="ref-id">
									<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
								</xsl:attribute>
							</fo:page-number-citation>
						</fo:block>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>			
	</xsl:template>
	<!--<xsl:template mode="showTaskTOF" >
		<xsl:if test="name(.) = 'task'">
			<fo:block margin-left="5mm" padding="1mm">				
				<fo:basic-link>
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:value-of select="./description" />
				</fo:basic-link>
				<fo:leader leader-pattern="dots"/>
				<fo:page-number-citation>
					<xsl:attribute name="ref-id">
						<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
					</xsl:attribute>
				</fo:page-number-citation>
			</fo:block>	
		</xsl:if>
		<xsl:if test="name(.) = 'taskgroup'">
			<fo:block margin-left="5mm" padding="1mm">
				<xsl:text>Group: </xsl:text>
				<fo:basic-link>
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:value-of select="./description" />
				</fo:basic-link>
				<fo:leader leader-pattern="dots"/>
				<fo:page-number-citation>
					<xsl:attribute name="ref-id">
						<xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/>
					</xsl:attribute>
				</fo:page-number-citation>
			</fo:block>	
		</xsl:if>		
	</xsl:template>-->
	<xsl:template name="showCoverPage">
		<fo:page-sequence master-reference="PageMaster-Cover" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body">
				<fo:block width="100%" font-family="Helvetica" margin-left="15mm" margin-top="15mm" border-left-style="solid" border-left-color="{$themeColor}" border-left-width="0.5pt" space-before="5mm" space-after="5mm">
					<fo:block margin-left="2mm">
								<fo:external-graphic>
									<xsl:attribute name="src">url('file:<xsl:value-of select="$LogoPath"/>')</xsl:attribute>
									<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
									<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
									<xsl:attribute name="width">30mm</xsl:attribute>
									<xsl:attribute name="height">15mm</xsl:attribute>
									<xsl:attribute name="scaling">uniform</xsl:attribute>
								</fo:external-graphic>
							</fo:block>
					<fo:block margin-left="2mm" text-align="left" color="{$themeColor}" font-size="36pt"  >
						Assessor Package
					</fo:block>
					<fo:block margin-left="2mm" font-weight="bold"  text-align="left" font-size="12pt" space-before="5mm" space-after="5mm" >
						<fo:inline><xsl:value-of select="$XML/root/assessment/jobprofile" /> - <xsl:value-of select="$XML/root/assessment/orgcode" /></fo:inline>
					</fo:block>
					<fo:block ></fo:block>
				</fo:block>
				<fo:block-container font-family="Helvetica" >
					<fo:table width="100%" space-before="10mm" margin-left="8mm">
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell padding="2mm">
									<fo:block text-align="left" font-size="12pt" space-before="5mm" space-after="5mm" >
										<fo:inline>Assessor: <xsl:value-of select="$XML/root/assessment/assessor" /></fo:inline>
									</fo:block>
								</fo:table-cell>								
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding="2mm">
									<fo:block text-align="left" font-size="12pt" space-before="5mm" space-after="5mm" >
										<fo:inline>Candidate: <xsl:value-of select="$XML/root/assessment/candidate" /></fo:inline>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding="2mm">
									<fo:block text-align="left" font-size="12pt" space-before="5mm" space-after="5mm" >
										<fo:inline>Scheduled Assessment Date: <xsl:value-of select="$XML/root/assessment/scheduleassessmentdate" /></fo:inline>
									</fo:block>
								</fo:table-cell>								
							</fo:table-row>
						</fo:table-body>
					</fo:table>					
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template name="showCandidateInfo">
		<fo:page-sequence master-reference="PageMaster" >
			<xsl:call-template name="showHeader"/>
			<xsl:call-template name="showFooter"/>
			<fo:flow flow-name='xsl-region-body'>
			<fo:block-container>
				<fo:block id="showcandidateinfo" border-bottom-style="solid" border-bottom-width="0.5mm" border-bottom-color="{$themeColor}" font-family="Helvetica" font-size="14pt" font-weight="bold" space-after="5mm">Candidate Information</fo:block>
				<fo:table space-before="2mm">
					<fo:table-column column-width="40mm"/>
					<fo:table-column column-width="120mm"/>
					<fo:table-body>
						<fo:table-row padding="1mm">
							<fo:table-cell>
								<fo:block font-family="Helvetica" font-weight="bold">Name</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block text-align="left"><xsl:value-of select="$XML/root/assessment/candidate" /></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row  padding="1mm">
							<fo:table-cell>
								<fo:block font-family="Helvetica" font-weight="bold">Email</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block><xsl:value-of select="$XML/root/assessment/email" /></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row padding="1mm">
							<fo:table-cell>
								<fo:block font-family="Helvetica" font-weight="bold">Job Profile</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block><xsl:value-of select="$XML/root/assessment/jobprofile" /></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row padding="1mm">
							<fo:table-cell>
								<fo:block font-family="Helvetica" font-weight="bold">Discipline</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block><xsl:value-of select="$XML/root/assessment/discipline" /></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row padding="1mm">
							<fo:table-cell>
								<fo:block font-family="Helvetica" font-weight="bold">Organization</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block><xsl:value-of select="$XML/root/assessment/orgcode" /></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell>
								<fo:block font-family="Helvetica" font-weight="bold">Supervisor</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block><xsl:value-of select="$XML/root/assessment/supervisor" /></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				<fo:table space-before="10mm" >
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell  border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}">
								<fo:block font-family="Helvetica" font-weight="bold">Candidate Strengths</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<xsl:call-template name="repeatableRow" >
							<xsl:with-param name="index" select="1" />
							<xsl:with-param name="total" select="30" />
						</xsl:call-template>		
					</fo:table-body>
				</fo:table>
				
			</fo:block-container>	     
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template name="repeatableRow">
   	<xsl:param name="index" />
      <xsl:param name="total" />
      <fo:table-row>
			<fo:table-cell   border-bottom-style="solid" border-bottom-width="0.3mm"  border-bottom-color="{$themeColor}" padding="2.5mm">
				<fo:block><xsl:text></xsl:text></fo:block>
			</fo:table-cell>
		</fo:table-row>
    	<xsl:if test="not($index = $total)">
        	<xsl:call-template name="repeatableRow">
            <xsl:with-param name="index" select="$index + 1" />
				<xsl:with-param name="total" select="$total" />
        	</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="showOpportunityForDev">
		<fo:page-sequence master-reference="PageMaster" >
			<xsl:call-template name="showHeader"/>
			<xsl:call-template name="showFooter"/>
			<fo:flow flow-name='xsl-region-body'>
			<fo:block-container>
				<fo:block id="showopportunityfordev" font-family="Helvetica" font-size="12pt" font-weight="bold" space-after="10mm">Opportunity for Development</fo:block>
				<fo:table>
					<fo:table-column column-width="25mm"/>
					<fo:table-column column-width="25mm"/>
					<fo:table-column column-width="25mm"/>
					<fo:table-column column-width="25mm"/>
					<fo:table-column column-width="60mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell  text-align="center" border-right-style="solid" border-right-width="0.5mm" border-right-color="{$themeColor}" >
								<fo:block  font-family="Helvetica" font-size="11pt">HSEQ</fo:block>
							</fo:table-cell>
							<fo:table-cell  text-align="center" border-right-style="solid" border-right-width="0.5mm" border-right-color="{$themeColor}" >
								<fo:block font-family="Helvetica" font-size="11pt">Regularity</fo:block>
							</fo:table-cell>
							<fo:table-cell  text-align="center" border-right-style="solid" border-right-width="0.5mm" border-right-color="{$themeColor}" >
								<fo:block font-family="Helvetica" font-size="11pt">Technical</fo:block>
							</fo:table-cell>
							<fo:table-cell  text-align="center" border-right-style="solid" border-right-width="0.5mm" border-right-color="{$themeColor}" >
								<fo:block font-family="Helvetica" font-size="11pt">Behavioral</fo:block>
							</fo:table-cell>
							<fo:table-cell  text-align="center" >
								<fo:block font-family="Helvetica" font-size="11pt">Facility/Company Related</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>				
				<fo:table space-before="15mm" >
					<fo:table-column column-width="30mm"/>
					<fo:table-column />
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding-left="5mm" border-top-style="solid"  border-top-width="0.5mm" border-top-color="{$themeColor}"   border-bottom-style="solid"  border-bottom-width="0.5mm" border-bottom-color="{$themeColor}" >
								<fo:block font-family="Helvetica" font-weight="bold">Category </fo:block>
							</fo:table-cell>
							<fo:table-cell padding-left="5mm"  border-top-style="solid" border-top-width="0.5mm" border-top-color="{$themeColor}"   border-bottom-style="solid"  border-bottom-width="0.5mm" border-bottom-color="{$themeColor}">
								<fo:block font-family="Helvetica" font-weight="bold">Task / Opportunity </fo:block>
							</fo:table-cell>
						</fo:table-row>
						<xsl:call-template name="repeatable" >
							<xsl:with-param name="index" select="1" />
							<xsl:with-param name="total" select="35" />
						</xsl:call-template>
					</fo:table-body>
				</fo:table>				
			</fo:block-container>	     
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template name="repeatable">
   	<xsl:param name="index" />
      <xsl:param name="total" />
      <fo:table-row>
			<fo:table-cell   border-right-style="solid" border-right-width="0.2mm" border-bottom-style="solid" border-bottom-width="0.3mm"  border-bottom-color="{$themeColor}" padding="2.5mm">
				<fo:block><xsl:text></xsl:text></fo:block>
			</fo:table-cell>
			<fo:table-cell   border-bottom-style="solid" border-bottom-width="0.3mm"  border-bottom-color="{$themeColor}" padding="2.5mm">
				<fo:block><xsl:text></xsl:text></fo:block>
			</fo:table-cell>
		</fo:table-row>
    	<xsl:if test="not($index = $total)">
        	<xsl:call-template name="repeatable">
            <xsl:with-param name="index" select="$index + 1" />
				<xsl:with-param name="total" select="$total" />
        	</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="showSignatures">
		<fo:page-sequence master-reference="PageMaster" >
			<xsl:call-template name="showHeader"/>
			<xsl:call-template name="showFooter"/>
			<fo:flow flow-name='xsl-region-body'>
				<fo:block-container>
					<fo:block id="showsignatures" font-family="Helvetica" font-size="13pt" font-weight="bold" space-after="10mm">Signatures</fo:block>
					<fo:table font-size="12pt">
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell  border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}" padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Assessor</fo:block>
								</fo:table-cell>
								<fo:table-cell border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}" padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}" padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Name</fo:block>
								</fo:table-cell>
								<fo:table-cell padding-top="2.5mm">
									<fo:block font-family="Helvetica" ><xsl:value-of select="$XML/root/assessment/assessor" /></fo:block>
								</fo:table-cell>
								<fo:table-cell padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Assessor Certification</fo:block>
								</fo:table-cell>
								<fo:table-cell border-bottom-style="solid" border-bottom-width="0.3mm" padding-left="2.5mm" padding-top="2.5mm">
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Assessment Date</fo:block>
								</fo:table-cell>
								<fo:table-cell border-bottom-style="solid" border-bottom-width="0.3mm" padding-left="2.5mm" padding-top="2.5mm">
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica"  font-weight="bold">Assessor Signature</fo:block>
								</fo:table-cell>
								<fo:table-cell border-bottom-style="solid" border-bottom-width="0.3mm" padding-left="2.5mm" padding-top="2.5mm">
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
					<fo:table font-size="12pt" space-before="10mm">
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell  border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}" padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Candidate</fo:block>
								</fo:table-cell>
								<fo:table-cell border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}" padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell border-top-style="solid" border-bottom-style="solid" border-top-width="0.5mm" border-bottom-width="0.5mm"  border-top-color="{$themeColor}" border-bottom-color="{$themeColor}" padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Name</fo:block>
								</fo:table-cell>
								<fo:table-cell padding-top="2.5mm">
									<fo:block font-family="Helvetica" ><xsl:value-of select="$XML/root/assessment/candidate" /></fo:block>
								</fo:table-cell>
								<fo:table-cell padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell padding-left="2mm" padding-top="2.5mm">
									<fo:block font-family="Helvetica" font-weight="bold">Signature</fo:block>
								</fo:table-cell>
								<fo:table-cell border-bottom-style="solid" border-bottom-width="0.3mm" padding-left="2.5mm" padding-top="2.5mm">
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell padding="2.5mm">
									<fo:block/>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template mode="showContent" match="corecompetency">
		<xsl:call-template name="showCoreCompCover"/>
		<fo:page-sequence master-reference="PageMaster-Content" >
			<xsl:call-template name="showContentHeader"/>
			<xsl:call-template name="showFooter"/>
			<fo:flow flow-name='xsl-region-body'>				
				<fo:marker marker-class-name="section.head.corecomp">					
					<xsl:value-of select="./description"/>																						
				</fo:marker>	
				<xsl:for-each select="./tasks/*">
					<xsl:variable name="isTaskNA">
						<xsl:value-of select="./isNA"/>
					</xsl:variable>	
					<xsl:if test="name(.) = 'task'">						
						<xsl:if test="($templateName='regenerate' and $isTaskNA=0) or ($templateName='generate')">
							<xsl:apply-templates select="." mode="showTask" />
						</xsl:if>
					</xsl:if> 
					<xsl:if test="name(.) = 'taskgroup'">
						<xsl:if test="($templateName='regenerate' and count(./tasks/task/isNA[text()=0]) > 0) or ($templateName='generate')">	
							<fo:block background-color="#dbd9d9" font-weight="bold" font-family="Helvetica" font-size="14pt" text-align="left" space-after="5mm">
								<xsl:attribute name="id"><xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/></xsl:attribute>		
								<fo:block margin-left="1mm"><xsl:value-of select="./description" /></fo:block>
							</fo:block>
							<xsl:apply-templates select="./tasks/task" mode="showTGTask" />
						</xsl:if> 
					</xsl:if>         		
       		</xsl:for-each>			
				<!--<xsl:apply-templates select="./tasks/task" mode="showTask" />-->
				<fo:block></fo:block>				
			</fo:flow>			
		</fo:page-sequence>
	</xsl:template>
	<xsl:template name="showCoreCompCover">
		<fo:page-sequence master-reference="PageMaster" force-page-count="no-force">
			<xsl:call-template name="showHeader"/>
			<xsl:call-template name="showFooter"/>
			<fo:flow flow-name="xsl-region-body">
				<fo:block width="100%" font-family="Helvetica" margin-top="60mm" space-before="5mm" space-after="5mm">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
					<fo:block color="{$themeColor}" font-size="32pt"><xsl:value-of select="./description" /> </fo:block>
					<fo:block font-size="24pt" space-before="3mm">Performance Assessment</fo:block>
				</fo:block>
			</fo:flow>			
		</fo:page-sequence>
	</xsl:template>
	<xsl:template mode="showTask" match="task">		
		<fo:block font-weight="bold" font-family="Helvetica" font-size="14pt" text-align="left" >
			<xsl:attribute name="id"><xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/></xsl:attribute>	
			<xsl:if test="count(./regulatoryAgencies/regulatoryAgency) = 0">
				<xsl:attribute name="space-after">5mm</xsl:attribute>	
			</xsl:if>
			<xsl:call-template name="showCriticalityValue" >
				<xsl:with-param name="criticality" select="@criticality" />
			</xsl:call-template>	
			<xsl:text> </xsl:text>
			<xsl:value-of select="./description" />			
		</fo:block>	
		<xsl:if test="count(./regulatoryAgencies/regulatoryAgency) > 0">
			<fo:block space-after="5mm">
				<xsl:apply-templates select="./regulatoryAgencies/regulatoryAgency" mode="showRegulatoryAgency" />
			</fo:block>
		</xsl:if>
		<xsl:if test="count(./knowledges/knowledge[@istestquestion=0]) > 0">
			<fo:block border-bottom-style="solid" border-bottom-width="0.25mm" margin-left="5mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" space-after="5mm">			
			Knowledge 
			</fo:block>
			<xsl:apply-templates select="./knowledges/knowledge[@istestquestion=0]" mode="showKnowledge" />
		</xsl:if>
		<xsl:if test="count(./performances/performance) > 0">
			<fo:block border-bottom-style="solid" border-bottom-width="0.25mm" margin-left="5mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" space-after="5mm">			
			Performance 
			</fo:block>
			<xsl:apply-templates select="./performances/performance" mode="showPerformance" />
		</xsl:if>		
	</xsl:template>
	<xsl:template mode="showTGTask" match="task">
		<xsl:variable name="isTaskNA">
			<xsl:value-of select="./isNA"/>
		</xsl:variable>	
		<xsl:if test="($templateName='regenerate' and $isTaskNA=0) or ($templateName='generate')">	
			<fo:block font-weight="bold" font-family="Helvetica" margin-left="5mm" font-size="13pt" text-align="left">
				<xsl:attribute name="id"><xsl:value-of select="../../@id"/><xsl:text>-</xsl:text><xsl:value-of select="@id"/></xsl:attribute>
				<xsl:if test="count(./regulatoryAgencies/regulatoryAgency) = 0">
					<xsl:attribute name="space-after">5mm</xsl:attribute>	
				</xsl:if>
				<xsl:call-template name="showCriticalityValue" >
					<xsl:with-param name="criticality" select="@criticality" />
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:value-of select="./description" />				
			</fo:block>	
			<xsl:if test="count(./regulatoryAgencies/regulatoryAgency) > 0">
				<fo:block space-after="5mm" margin-left="5mm">
					<xsl:apply-templates select="./regulatoryAgencies/regulatoryAgency" mode="showRegulatoryAgency" />
				</fo:block>
			</xsl:if>
			<xsl:if test="count(./knowledges/knowledge[@istestquestion=0]) > 0">
				<fo:block border-bottom-style="solid" border-bottom-width="0.25mm" margin-left="10mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" space-after="5mm">			
				Knowledge 
				</fo:block>
				<xsl:apply-templates select="./knowledges/knowledge[@istestquestion=0]" mode="showTGKnowledge" />
			</xsl:if>
			<xsl:if test="count(./performances/performance) > 0">
				<fo:block border-bottom-style="solid" border-bottom-width="0.25mm" margin-left="10mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" space-after="5mm">			
				Performance 
				</fo:block>
				<xsl:apply-templates select="./performances/performance" mode="showTGPerformance" />
			</xsl:if>
		</xsl:if>		
	</xsl:template>
	<xsl:template name="showCriticalityValue">
   	<xsl:param name="criticality" />      
    	<xsl:if test="$criticality = 1">
        	<fo:inline padding-left="0.75mm" padding-right="0.75mm" padding-top="0.75mm" font-size="10pt" border-width="thin"  color="white" font-weight="normal"  background-color = "#00C851">LOW</fo:inline>
		</xsl:if>
		<xsl:if test="$criticality = 2">
        	<fo:inline padding-left="0.75mm" padding-right="0.75mm" padding-top="0.75mm" font-size="10pt" border-width="thin"  color="white" font-weight="normal" background-color = "#ffbb33">MEDIUM</fo:inline>
		</xsl:if>
		<xsl:if test="$criticality = 3">
        	<fo:inline padding-left="0.75mm" padding-right="0.75mm" padding-top="0.75mm" font-size="10pt" border-width="thin"  color="white" font-weight="normal"  background-color = "#ff4444">HIGH</fo:inline>
		</xsl:if>
	</xsl:template>
	<xsl:template mode="showRegulatoryAgency" match="regulatoryAgency">   	
       <fo:inline padding-left="0.6mm" padding-right="0.6mm" padding-top="0.6mm" font-size="8pt" border-width="thin"  color="white" font-weight="normal"  background-color = "#563F7A"><xsl:value-of select="./description" /></fo:inline><xsl:text> </xsl:text>		
	</xsl:template>
	<xsl:template mode="showKnowledge" match="knowledge">
		<fo:table width="100%" space-after="5mm">
			<fo:table-column column-width="95%"/>
			<fo:table-column column-width="5%"/>
			<fo:table-body>		
				<fo:table-row>
					<fo:table-cell>
						<fo:block margin-left="5mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" >		
							<xsl:value-of select="position()" /><xsl:text>. </xsl:text><xsl:value-of select="./description" />
						</fo:block>	
					</fo:table-cell>
					<fo:table-cell padding="2mm" border-bottom-style="solid" border-bottom-width="0.25mm">
						<fo:block></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>	
		<!--<fo:block-container margin-left="10mm" space-before="5mm" space-after="7mm" border-style="solid" border-color="{$themeColor}" border-width="0.25mm" height="30mm">
			<fo:block padding-top="2mm" margin-left="-6mm" font-size="8pt" text-align="left">Note:</fo:block>		
		</fo:block-container>-->
		<fo:block font-size="8pt" margin-left="10mm">Note:</fo:block>	
		<fo:table margin-left="10mm" space-after="7mm">
			<fo:table-body>
				<xsl:call-template name="repeatableRow" >
					<xsl:with-param name="index" select="1" />
					<xsl:with-param name="total" select="2" />
				</xsl:call-template>
			</fo:table-body>
		</fo:table>		
	</xsl:template>
	<xsl:template mode="showPerformance" match="performance">
		<fo:table width="100%" space-after="5mm">
			<fo:table-column column-width="95%"/>
			<fo:table-column column-width="5%"/>
			<fo:table-body>		
				<fo:table-row>
					<fo:table-cell>
						<fo:block margin-left="5mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" >		
							<xsl:value-of select="position()" /><xsl:text>. </xsl:text><xsl:value-of select="./description" />
						</fo:block>	
					</fo:table-cell>
					<fo:table-cell padding="2mm" border-bottom-style="solid" border-bottom-width="0.25mm">
						<fo:block></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>					
		<xsl:apply-templates select="./checklists/checklist" mode="showChecklist" />
		<!--<fo:block-container margin-left="10mm" space-before="5mm" space-after="7mm" border-style="solid" border-color="{$themeColor}" border-width="0.25mm" height="30mm">
			<fo:block padding-top="2mm" margin-left="-6mm" font-size="8pt" text-align="left">Note:</fo:block>			
		</fo:block-container>-->
		<fo:block font-size="8pt" space-before="5mm" space-before="5mm" margin-left="10mm">Note:</fo:block>	
		<fo:table margin-left="10mm" space-after="7mm">
			<fo:table-body>
				<xsl:call-template name="repeatableRow" >
					<xsl:with-param name="index" select="1" />
					<xsl:with-param name="total" select="2" />
				</xsl:call-template>
			</fo:table-body>
		</fo:table>	
	</xsl:template>
	<xsl:template mode="showChecklist" match="checklist">
		<fo:table width="100%">
			<fo:table-column column-width="95%"/>
			<fo:table-column column-width="5%"/>
			<fo:table-body>		
				<fo:table-row>
					<fo:table-cell padding-top="1mm" padding-bottom="1mm">
						<fo:block margin-left="10mm" font-family="Helvetica" font-size="12pt" text-align="left" >		
							<xsl:value-of select="./description" />
						</fo:block>	
					</fo:table-cell>
					<fo:table-cell padding="2mm" border-bottom-style="solid" border-bottom-width="0.25mm">
						<fo:block></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>					
	</xsl:template>
	<xsl:template mode="showTGKnowledge" match="knowledge">
		<fo:table width="100%" space-after="5mm">
			<fo:table-column column-width="95%"/>
			<fo:table-column column-width="5%"/>
			<fo:table-body>		
				<fo:table-row>
					<fo:table-cell>
						<fo:block margin-left="10mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" >		
							<xsl:value-of select="position()" /><xsl:text>. </xsl:text><xsl:value-of select="./description" />
						</fo:block>	
					</fo:table-cell>
					<fo:table-cell padding="2mm" border-bottom-style="solid" border-bottom-width="0.25mm">
						<fo:block></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>	
		<!--<fo:block-container margin-left="15mm" space-before="5mm" space-after="7mm" border-style="solid" border-color="{$themeColor}" border-width="0.25mm" height="30mm">
			<fo:block padding-top="2mm" margin-left="-11mm" font-size="8pt" text-align="left">Note:</fo:block>		
		</fo:block-container>-->
		<fo:block font-size="8pt" margin-left="15mm">Note:</fo:block>	
		<fo:table margin-left="15mm" space-after="7mm">
			<fo:table-body>
				<xsl:call-template name="repeatableRow" >
					<xsl:with-param name="index" select="1" />
					<xsl:with-param name="total" select="2" />
				</xsl:call-template>
			</fo:table-body>
		</fo:table>	
	</xsl:template>
	<xsl:template mode="showTGPerformance" match="performance">
		<fo:table width="100%" space-after="5mm">
			<fo:table-column column-width="95%"/>
			<fo:table-column column-width="5%"/>
			<fo:table-body>		
				<fo:table-row>
					<fo:table-cell>
						<fo:block margin-left="10mm" font-weight="bold" font-family="Helvetica" font-size="12pt" text-align="left" >		
							<xsl:value-of select="position()" /><xsl:text>. </xsl:text><xsl:value-of select="./description" />
						</fo:block>	
					</fo:table-cell>
					<fo:table-cell padding="2mm" border-bottom-style="solid" border-bottom-width="0.25mm">
						<fo:block></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>					
		<xsl:apply-templates select="./checklists/checklist" mode="showTGChecklist" />
		<!--<fo:block-container margin-left="15mm" space-before="5mm" space-after="7mm" border-style="solid" border-color="{$themeColor}" border-width="0.25mm" height="30mm">
			<fo:block padding-top="2mm" margin-left="-11mm" font-size="8pt" text-align="left">Note:</fo:block>				
		</fo:block-container>-->
		<fo:block font-size="8pt" space-before="5mm" margin-left="15mm">Note:</fo:block>	
		<fo:table margin-left="15mm" space-after="7mm">
			<fo:table-body>
				<xsl:call-template name="repeatableRow" >
					<xsl:with-param name="index" select="1" />
					<xsl:with-param name="total" select="2" />
				</xsl:call-template>
			</fo:table-body>
		</fo:table>	
	</xsl:template>
	<xsl:template mode="showTGChecklist" match="checklist">
		<fo:table width="100%">
			<fo:table-column column-width="95%"/>
			<fo:table-column column-width="5%"/>
			<fo:table-body>		
				<fo:table-row>
					<fo:table-cell padding-top="1mm" padding-bottom="1mm">
						<fo:block margin-left="15mm" font-family="Helvetica" font-size="12pt" text-align="left" >		
							<xsl:value-of select="./description" />
						</fo:block>	
					</fo:table-cell>
					<fo:table-cell padding="2mm" border-bottom-style="solid" border-bottom-width="0.25mm">
						<fo:block></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>					
	</xsl:template>
	<xsl:template name="showFooter">
		<fo:static-content flow-name="footer">
			<fo:block-container font-size="8pt" font-weight="bold">
				<fo:block font-family="Helvetica"  text-align="right" padding-top="10mm">
					Page
					<fo:page-number/>
					of
					<fo:page-number-citation ref-id="last-page"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="showHeader">
		<fo:static-content flow-name="header">
			<fo:block-container>
				<fo:table border-style="solid" border-width="0.25mm">
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell text-align="center" >
							<fo:block>
								<fo:external-graphic>
									<xsl:attribute name="src">url('file:<xsl:value-of select="$LogoPath"/>')</xsl:attribute>
									<!--<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>-->
									<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
									<!--<xsl:attribute name="width">40mm</xsl:attribute>-->
									<xsl:attribute name="height">7mm</xsl:attribute>
									<!--<xsl:attribute name="scaling">uniform</xsl:attribute>-->
								</fo:external-graphic>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="center"  border-style="solid" border-width="0.25mm" padding-top="2.5mm">
							<fo:block font-family="Helvetica" font-weight="bold"  text-align="center" font-size="9pt">Assessor Package</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="center"  border-style="solid" border-width="0.25mm" padding-top="2.5mm">
							<fo:block font-family="Helvetica" font-weight="bold"  text-align="center" font-size="9pt">
								<fo:inline><xsl:value-of select="$XML/root/assessment/jobprofile" /> - <xsl:value-of select="$XML/root/assessment/orgcode" /></fo:inline>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="showContentHeader">
		<fo:static-content flow-name="header">
			<fo:block-container>
				<fo:table border-style="solid" border-width="0.25mm">
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell text-align="center">
							<fo:block>
								<fo:external-graphic>
									<xsl:attribute name="src">url('file:<xsl:value-of select="$LogoPath"/>')</xsl:attribute>
									<!--<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>-->
									<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
									<!--<xsl:attribute name="width">40mm</xsl:attribute>-->
									<xsl:attribute name="height">7mm</xsl:attribute>
									<!--<xsl:attribute name="scaling">uniform</xsl:attribute>-->
								</fo:external-graphic>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="center"  border-style="solid" border-width="0.25mm" padding-top="2.5mm">
							<fo:block font-family="Helvetica" font-weight="bold"  text-align="center" font-size="9pt">Assessor Package</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="center"  border-style="solid" border-width="0.25mm" padding-top="2.5mm">
							<fo:block font-family="Helvetica" font-weight="bold"  text-align="center" font-size="9pt">
								<fo:inline><xsl:value-of select="$XML/root/assessment/jobprofile" /> - <xsl:value-of select="$XML/root/assessment/orgcode" /></fo:inline>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<fo:table border-style="solid" border-width="0.25mm">				
				<fo:table-column column-width="20%"/>
				<fo:table-column column-width="80%"/>
				<fo:table-body>
					<fo:table-row>						
						<fo:table-cell text-align="left"  border-style="solid" border-width="0.25mm" padding="1mm">
							<fo:block font-size="9pt" margin-left="1mm">Competency</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="left"  border-style="solid" border-width="0.25mm" padding="1mm">
							<fo:block font-size="9pt" margin-left="1mm"><fo:retrieve-marker retrieve-class-name="section.head.corecomp" retrieve-position="first-including-carryover" retrieve-boundary="page-sequence"/></fo:block>
						</fo:table-cell>
					</fo:table-row>					
				</fo:table-body>
			</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
</xsl:stylesheet>