import std/[times, os]
import std/json
import std/files

var
  arguments = commandLineParams()
sleep(500) # Replace this with something to be timed


proc add_task(task_name:string) =
  if not fileExists("./tasks.json"):
    var jsonTemplate = %*{
       task_name: { "task_descp": "","task_due_date": false,"daily":false }
      }
    writeFile("tasks.json", $jsonTemplate)
  else:
    echo "hello"
    var jsonFile = readFile("tasks.json")
    var jsonNode = parseJson(jsonFile)
    jsonNode[task_name] = %*{"task_desc":"","task_due_date":false,"daily":false}
    writeFile("tasks.json",$jsonNode)



proc add_desc(task_name:string,descp:string) =
 echo "hello"


proc set_due(task_name:string,date:string) =
 echo "hello"


proc set_daily(task_name:string) =
 echo "hello"


 
proc cli() = 
 for arg in arguments:
   case arg:
     of "--add-task":
       echo("add a task")
       let task_name = arguments[1]
       add_task(task_name)
     of "--add-desc":
       echo("add a task")
       let task_name = arguments[1]
       let task_desc = arguments[2]
       add_desc(task_name,task_desc)
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
