def walk(f):
  . as $in
  | if type == "object" then
      reduce keys[] as $key
        ( {}; . + { ($key): ($in[$key] | walk(f)) } )
    | f
  elif type == "array" then map(walk(f)) | f
  else f
  end;

walk(
  if type == "object" and (.guid? and .id?) then
    if (.guid | test("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$") | not)
    then .guid = (.guid[0:36]) | .id = (.id[0:36])
    else .
    end
  else .
  end
)
| .runs[].results |= map(
    .codeFlows |= (
      map(
        # En cada codeFlow, quitamos los threadFlows con locations vacías
        .threadFlows |= (map(select(.locations | length > 0)))
        # Y solo mantenemos los codeFlows que sigan teniendo al menos un threadFlow
      | select(.threadFlows | length > 0)
      )
    )
  )