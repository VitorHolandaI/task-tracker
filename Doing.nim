import std/[os,dirs,json,sequtils]
import std/strutils
import std/strformat

let home = getHomeDir()

var
  arguments = commandLineParams()
sleep(500) # Replace this with something to be timed


proc writeTask(task_name:string,node:JsonNode) =
  let home = getHomeDir()
  writeFile(fmt"{home}/.tasks/tasks/{task_name}.json", $node)
   
proc load_task(task_name:string): string =
   let home = getHomeDir()
   let result = if not fileExists(fmt"{home}/.tasks/tasks/{task_name}.json"): "false" else: readFile(fmt"{home}/.tasks/tasks/{task_name}.json")
   result

proc add_task(task_name:string) =
   let home = getHomeDir()
   var jsonTemplate = %*{
       task_name: { "task_descp": "","task_due_date": false,"daily":false,"class":"general","done":false }
   }
   writeFile(fmt"{home}/.tasks/tasks/{task_name}.json", $jsonTemplate)

#type does not matter to overwrite in the json either way its translated to json object.....
#need a proc modifyTask(task_name,variable,valuetoput)
proc add_desc(task_name: string, descp: string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["task_descp"] = %descp
  JsonNode[task_name] = node
  writeTask(task_name,JsonNode)

proc set_due(task_name:string,date:string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["task_due_date"] = %date
  JsonNode[task_name] = node
  writeTask(task_name,JsonNode)

proc set_daily(task_name:string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["daily"] = %true
  JsonNode[task_name] = node
  writeTask(task_name,JsonNode)

proc list() =
   let home = getHomeDir()
   for file in walkFiles(fmt"{home}.tasks/tasks/*.json"):
      var task_name = file.split("/")[5].split('.')[0]
      var jsonFile = load_task(task_name)
      var JsonNode = parseJson(jsonFile)
      var node = JsonNode[task_name]
      var daily = node["daily"]
      var due_date = node["task_due_date"]
      var class = node["class"]
      var descp = node["task_descp"]
      echo (fmt"task name: {task_name}")
      echo (fmt"task due date: {due_date}")
      echo (fmt"task daily: {daily}")
      echo (fmt"task class: {class}")
      echo (fmt"task description: {descp}")
      #var node = JsonNode[task_name]



#what is a failed task?
#a dayly task:? can be failed or not depends if u makerd
#needs and can be dayly task, or task with  any due date thats passed...
#need to classify based on current date... daiyly task thtas passed
#daiyly --> yes,dayly tasks have one filed of number of dones...
#proc move_failed () =
#  if not existsOrCreateDir("./tasks"):
#     echo "tasks does not exist creating..."
#  if not existsOrCreateDir("./done"):
#     echo "done does not exist creating..."
#  if not existsOrCreateDir("./failed"):
#     echo "failed does not exist creating..."
# 
proc syncro() =
  let home = getHomeDir()
  if not existsOrCreateDir(fmt"{home}/.tasks"):
     echo "tasks does not exist creating..."
  if not existsOrCreateDir(fmt"{home}/.tasks/tasks"):
     echo "tasks does not exist creating..."
  if not existsOrCreateDir(fmt"{home}/.tasks/done"):
     echo "done does not exist creating..."
  if not existsOrCreateDir(fmt"{home}/.tasks/failed"):
     echo "failed does not exist creating..."
 
proc cli() =
 for arg in arguments:
   case arg:
     of "--help":
       echo("--add-task taskName")
       echo("--add-desc taskName taskDescrp")
       echo("--add-due-date taskName dueDate(xx/xx/xxxx)")
       echo("--set-daily taskName")
       echo("--list")
       break
     of "--add-task":
       let task_name = arguments[1]
       add_task(task_name)
       break
     of "--add-desc":
       let task_name = arguments[1]
       #let task_des = arg
       let task_desc = arguments[2 .. len(arguments) - 1]
       var descp = task_desc.join(" ")
       add_desc(task_name,descp)
       break
     of "--add-due-date":
      let task_name = arguments[1]
      let date = arguments[2]
      set_due(task_name,date)
      break
     of "--set-daily":
      let task_name = arguments[1]
      set_daily(task_name)
      break
     of "--list":
      list()
      break

     else:
       echo "Not a command"
 

syncro()
#move_failed()
cli()

#why not just load every thing in a struck the tasks and go with it ......
#why use the whole file if just modifying one task for example...
