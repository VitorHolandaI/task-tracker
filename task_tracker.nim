import std/[os,dirs]
import std/json
import std/strutils

var
  arguments = commandLineParams()
sleep(500) # Replace this with something to be timed


proc load_task(): string =
   let result = if not fileExists("./tasks.json"): "false" else: readFile("tasks.json")
   result

proc add_task(task_name:string) =
  if not fileExists("./tasks.json"):
    var jsonTemplate = %*{
       task_name: { "task_descp": "","task_due_date": false,"daily":false,"class":"general","done":false }
      }
    writeFile("tasks.json", $jsonTemplate)
  else:
    echo "hello"
    var jsonFile = readFile("tasks.json")
    var jsonNode = parseJson(jsonFile)
    jsonNode[task_name] = %*{"task_desc":"","task_due_date":false,"daily":false,"class":"general","done":false}
    writeFile("tasks.json",$jsonNode)

#type does not matter to overwrite in the json either way its translated to json object.....
#need a proc modifyTask(task_name,variable,valuetoput)
proc add_desc(task_name: string, descp: string) =
  var jsonFile = load_task()
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["task_descp"] = %descp
  JsonNode[task_name] = node
  writeFile("tasks.json", $JsonNode)

proc set_due(task_name:string,date:string) =
  var jsonFile = load_task()
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["task_due_date"] = %date
  JsonNode[task_name] = node
  writeFile("tasks.json", $JsonNode)

proc set_daily(task_name:string) =
  var jsonFile = load_task()
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["daily"] = %true
  JsonNode[task_name] = node
  writeFile("tasks.json", $JsonNode)


 
proc cli() =
 for arg in arguments:
   echo len(arguments)
   case arg:
     of "--add-task":
       echo("add a task")
       let task_name = arguments[1]
       add_task(task_name)
     of "--add-desc":
       echo("add a task")
       let task_name = arguments[1]
       #let task_des = arg
       let task_desc = arguments[2 .. len(arguments) - 1]
       var descp = task_desc.join(" ")
       add_desc(task_name,descp)
     of "--add-due-date":
      echo("add a task")
      let task_name = arguments[1]
      let date = arguments[2]
      set_due(task_name,date)
      echo arguments[1]
     of "--set-daily":
      let task_name = arguments[1]
      set_daily(task_name)
      echo("add a task")
      echo arguments[1]
     else:
       echo "Unrecognized letter"
 

cli()

#why not just load every thing in a struck the tasks and go with it ......
#why use the whole file if just modifying one task for example...
