const args = require("minimist")(process.argv.slice(2));

var logpath = args.logpath;
var debuggerURL = args.debuggerURL;
var dbgsProxyPort = args.dbgsProxyPort;

var app = require("express")();

var httpProxy = require("http-proxy").createProxyServer();
var log = require("intel");
var xml2js = require("xml-js");

var path = require("path");

var fs = require("fs");
fs.promises.mkdir(logpath, { recursive: true }).catch(console.error);

var dateformat = require("dateformat");

app.all("/*", function(req, res) {
  const bodyBuffer = [];
  req.on("data", function(data) {
    bodyBuffer.push(data);
  });

  req.on("end", () => {
    var bodyString = Buffer.concat(bodyBuffer).toString();
    // log.info(bodyString);
    var bodyJSONstring = xml2js.xml2json(bodyString, {
      compact: true,
      spaces: 4
    });

    var body = JSON.parse(bodyJSONstring);

    if (
      body.hasOwnProperty("request") &&
      body.request.hasOwnProperty("_attributes") &&
      body.request._attributes.hasOwnProperty("xmlns:debugRTEFilter") &&
      body.request.hasOwnProperty("debugRDBGRequestResponse:idOfDebuggerUI") &&
      !body.request.hasOwnProperty(
        "debugRDBGRequestResponse:measureModeSeanceID"
      )
    ) {
      if (isFirstMeasureStopCommand) {
        isFirstMeasureStopCommand = false;
      } else {
        waitForMeasureData = true;
        console.log("captured measure stop command");
      }
    }

    if (
      waitForMeasureData &&
      body.hasOwnProperty("request") &&
      body.request.hasOwnProperty(
        "dbgtgtRemoteRequestResponse:commandToDbgServer"
      )
    ) {
      finishedCapturingMeasureData = false;
      console.log("started capturing measure data");
      log.info(body);
    }

    if (
      waitForMeasureData &&
      !finishedCapturingMeasureData &&
      !body.hasOwnProperty("request")
    ) {
      waitForMeasureData = false;
      finishedCapturingMeasureData = true;
      console.log("finished capturing measure data");
      switchLogFile();
    }
  });

  httpProxy.web(req, res, { target: debuggerURL });
});

function switchLogFile() {
  log.removeAllHandlers();

  var fileName = path.join(
    logpath,
    dateformat(new Date(), "yyyymmddHHMMssl") + ".log"
  );
  console.log("current log: " + fileName);
  log.addHandler(new log.handlers.File(fileName));
}

var waitForMeasureData = false;
var finishedCapturingMeasureData = false;
var isFirstMeasureStopCommand = true;

switchLogFile();

app.listen(dbgsProxyPort);
