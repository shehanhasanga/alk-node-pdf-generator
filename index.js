var fs = require('fs');
var path = require('path')
var jsreport = require('jsreport-core')({
	tasks: {
		timeout: 600000
	}
});
var mkdirp = require('mkdirp');
var xsltProcessor = require('xslt-processor')
var xsltProcess = xsltProcessor.xsltProcess
var xmlParse = xsltProcessor.xmlParse

var pdfGenerator = {

	generatePdf: function (xmlFilePath, xslFilePath, outPutPath, outPutFileName) {

		return new Promise(function (resolve, reject) {
			try {

				fs.access(xmlFilePath, fs.F_OK, (err) => {
					if (err) {
						reject("Xml file is not exist");
					}
					else {
						fs.access(xslFilePath, fs.F_OK, (err) => {
							if (err) {
								reject("Xsl file is not exist");
							} else {
								if(!outPutFileName || outPutFileName.replace(/\s/g, '').length == 0){
									reject("File name is not valid");
								} else {
									if (!fs.existsSync(outPutPath)){
										mkdirp.sync(outPutPath);
									}

									const outXmlString = xsltProcess(
										xmlParse(fs.readFileSync(xmlFilePath).toString()),
										xmlParse(fs.readFileSync(xslFilePath).toString())
									);

									fs.writeFile(path.join(outPutPath, '/' + 'out' + '.fo'), outXmlString, function (err) {
										if (err) {
											reject(err);
										} else {
											jsreport.use(require('jsreport-fop-pdf')({
												maxOutputSize: (1024 * 1000 * 1000)
											}))

											jsreport.init().then(function () {
												jsreport.render({
													template: {
														content: fs.readFileSync(path.join(outPutPath, '/' + 'out' + '.fo')),
														recipe: 'fop-pdf',
														engine: 'none'
													}
												}).then(function (res) {
													console.log("Writing pdf...")
													res.result.pipe(fs.createWriteStream(path.join(outPutPath, '/' + outPutFileName + '.pdf')));
													fs.unlinkSync(path.join(outPutPath, '/' + 'out' + '.fo'))
													resolve(null);
												})
													.catch(function (e) {
														reject(e);
													})

											}).catch(function (e) {
												reject(e);
											})
										}
									});
								}

							}

						})
					}

				})

			} catch (err) {
				console.log(err)
				reject(err);
			}
		});
	}
};
module.exports = pdfGenerator;
