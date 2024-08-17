## General Commands
`zip -r zip/output.zip index.js node_modules`

`unzip -l zip/output.zip > zip/zip.txt`

`rm zip/output.zip zip/zip.txt`

## Staging Changes
`cp -r node_modules zip/stage/node_modules`

## Creating the zip file
`cd zip/stage`
`zip -r ../layer.zip nodejs`
`cd ../..`

## Viewing the new zip file contents
`unzip -l zip/layer.zip > zip/zip.txt`