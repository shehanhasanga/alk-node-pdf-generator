"**alk-node-pdf-generator**" 

### Follow these steps to generate PDF

* Step 1 - install the pdf creator package using the following command


        npm i alk-node-pdf-generator
    
* Step 2 - Add required packages


        const pdfGenerator = require ('alk-node-pdf-generator')

        
* Step 3 - Make the xml file and respective xsl file for fo transformation.        
* Step 4 - call generatePdf with xml file path, xsl file path, output file path and file name. All there parameters should valid for the pdf generation

      
            pdfGenerator.generatePdf('File:\\assessment.xml', 'File:\\Sample.xsl', 'D:\\outputDir',"FileName") .then(function () {
                 console.log("pdf generated")
                  })
                  .catch(function (err) {
                      console.log(err)
                  });
* Step 5 - Add Fop library
    * Step 1 - Install Java Runtime Environment(JRE)
    * Download the latest zip file from http://mirrors.gigenet.com/apache/xmlgraphics/fop/binaries/ eg: fop-2.2-bin.zip 
    * Extract the zip file 
    * Modify "Path" OS environment variable to  fop folder eg: C:\Users\Admin\ Downloads\fop-2.2-bin\fop-2.2\fop 
    
* Step 6 - Run with node environment

       node script.js
        

