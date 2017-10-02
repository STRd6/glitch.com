#!/bin/bash
set -e

mkdir -p cache

jadelet -d templates -r "require('jadelet')"

coffee --compile --transpile --inline-map .

browserify --debug client.js | exorcist public/client.js.map > public/client.js

if [[ $ENVIRONMENT = 'production' ]]
  then
    (
      echo "💟 environment is in production mode"
      uglifyjs public/client.js \
        --compress \
        --mangle \
        --screw-ie8 \
        --in-source-map public/client.js.map \
        --source-map public/client.min.js.map \
        --source-map-url client.min.js.map \
        --source-map-include-sources \
        > public/client.min.js
    )
  else
    echo "🚒 environment is in development mode"
fi

stylus \
  --use autoprefixer-stylus \
  --sourcemap \
  --compress public/styles.styl \
  --out public/styles.css

coffee server.coffee
