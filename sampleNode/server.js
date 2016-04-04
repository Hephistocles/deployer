var express = require('express');
var statusPage = require('express-status-page');

var app = express();

app.use('/', statusPage);
app.listen(process.env.PORT)
