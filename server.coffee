express = require "express"

app = express()

# Accept JSON as req.body
bodyParser = require "body-parser"
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.set('view engine', 'ejs')

router = require('./routes')();
app.use '/', router

# Add an explicit no-cache to 404 responses
# Since this is the last handler it will only be hit when all other handlers miss
app.use (req, res, next) ->
  res.header("Cache-Control", "no-cache, no-store, must-revalidate")
  next()

# Listen on App port
listener = app.listen process.env.PORT, ->
  console.log('Your app is listening on port ' + listener.address().port)
