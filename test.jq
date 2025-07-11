(.. | select(type=="object" and has("guid") and (.guid|type=="string")) | .guid)
  |= .[0:36]
|
(.. | select(type=="object" and has("locations") and (.locations|type=="array") and (.locations|length==0)) | .locations)
  |= [ { "index": 0 } ]