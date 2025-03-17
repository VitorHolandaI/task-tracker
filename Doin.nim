import std/[os,dirs,json,sequtils,times]
import std/strutils
import std/strformat

let home = getHomeDir()

var
  arguments = commandLineParams()
sleep(500) # Replace this with something to be timed

proc yellow*(s: string): string = "\e[33m" & s & "\e[0m"
proc load_task(task_name:string): string =
   let home = getHomeDir()
   let result = if not fileExists(fmt"{home}.tasks/tasks/{task_name}.json"): "false" else: readFile(fmt"{home}.tasks/tasks/{task_name}.json")
   result


proc writeTask(task_name:string,node:string) =
  let home = getHomeDir()
  writeFile(fmt"{home}.tasks/tasks/{task_name}.json", $node)
 
proc writeTaskDone(task_name:string,node:JsonNode) =
  let home = getHomeDir()
  writeFile(fmt"{home}.tasks/done/{task_name}.json", $node)
 
proc writeTaskOverdue(task_name:string,node:JsonNode) =
  let home = getHomeDir()
  writeFile(fmt"{home}.tasks/overdue/{task_name}.json", $node)
 
proc excludeTask(task_name:string) =
  let home = getHomeDir()
  removeFile(fmt"{home}.tasks/tasks/{task_name}.json")
 

proc setDone(task_name:string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["done"] = %true
  JsonNode[task_name] = node
  if node["daily"].getBool() == true:
     echo "is this even true"
     let task_date = parse(node["task_due_date"].getStr(),"dd-MM-yyyy")
     if (format(now(),"dd") > format(task_date,"dd")):
        node["notDoneCount"] = %(node["notDoneCount"].getInt() + 1)
        var now = format(now() + 1.days,"dd-MM-YYYY")
        node["task_due_date"] = %now
        writeTask(task_name,$JsonNode)

     else:
        node["DoneCount"] = %(node["DoneCount"].getInt() + 1)
        var now = format(now() + 1.days,"dd-MM-YYYY")
        node["task_due_date"] = %now
        writeTaskDone(task_name,JsonNode)
        writeTask(task_name,$JsonNode)
     
  else:
    if node["task_due_date"].getStr() != "":
       let now = now()
       let set_date = parse(node["task_due_date"].getStr(),"dd-MM-yyyy")
       if (now >= set_date):
          writeTaskOverdue(task_name,JsonNode)
          excludeTask(task_name)
       else:
          writeTaskDone(task_name,JsonNode)
          excludeTask(task_name)
    else:
       writeTaskDone(task_name,JsonNode)
       excludeTask(task_name)

proc list_close(time:string) =
   let home = getHomeDir()
   let time = parseInt(time) - 1
   for file in walkFiles(fmt"{home}.tasks/tasks/*.json"):
      var task_name = file.split("/")[5].split(".json")[0]
      var jsonFile = load_task(task_name)
      var JsonNode = parseJson(jsonFile)
      var node = JsonNode[task_name]
      if (node["task_due_date"].getStr() != ""):
          let task_date = parse(node["task_due_date"].getStr(),"dd-MM-yyyy")
          let now = now() + time.days
          if (now <= task_date):
             var daily = node["daily"].getBool()
             var due_date = node["task_due_date"]
             var class = node["class"]
             var descp = node["task_descp"]
             var done = node["done"]
             echo ("---------------------------")
             echo (fmt"task name: {task_name}".yellow)

             echo (fmt"task due date: {due_date}")
             echo (fmt"task daily: {daily}")
             echo (fmt"task class: {class}")
             echo (fmt"task description: {descp}")
             echo (fmt"Done? {done}")
             if (daily == true):
                var doneCount = node["DoneCount"]
                var notdoneCount = node["notDoneCount"]
                echo (fmt"Done count.... {doneCount}")
                echo (fmt"Not Done count.... {notdoneCount}")
             echo ("---------------------------")
 
proc add_task(task_name:string) =
   let home = getHomeDir()
   var jsonTemplate = %*{
       task_name: { "task_descp": "","task_due_date": "","daily":false,"class":"general","done":false,"count":0 }
   }
   writeFile(fmt"{home}.tasks/tasks/{task_name}.json", $jsonTemplate)

proc add_desc(task_name: string, descp: string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["task_descp"] = %descp
  JsonNode[task_name] = node
  writeTask(task_name,$JsonNode)

proc set_due(task_name:string,date:string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  node["task_due_date"] = %date
  JsonNode[task_name] = node
  writeTask(task_name,$JsonNode)

proc set_daily(task_name:string) =
  var jsonFile = load_task(task_name)
  var JsonNode = parseJson(jsonFile)
  var node = JsonNode[task_name]
  var now = format(now(),"dd-MM-YYYY")
  node["task_due_date"] = %now
  node["daily"] = %true
  node["DoneCount"] = %0
  node["notDoneCount"] = %0
  JsonNode[task_name] = node
  writeTask(task_name,$JsonNode)
proc list() =
   let home = getHomeDir()
   for file in walkFiles(fmt"{home}.tasks/tasks/*.json"):
      var task_name = file.split("/")[5].split(".json")[0]
      var jsonFile = load_task(task_name)
      var JsonNode = parseJson(jsonFile)
      var node = JsonNode[task_name]
      var daily = node["daily"].getBool()
      var due_date = node["task_due_date"]
      var class = node["class"]
      var descp = node["task_descp"]
      var done = node["done"]
      echo ("---------------------------")
      echo (fmt"task name: {task_name}".yellow)

      echo (fmt"task due date: {due_date}")
      echo (fmt"task daily: {daily}")
      echo (fmt"task class: {class}")
      echo (fmt"task description: {descp}")
      echo (fmt"Done? {done}")
      if (daily == true):
         var doneCount = node["DoneCount"]
         var notdoneCount = node["notDoneCount"]
         echo (fmt"Done count.... {doneCount}")
         echo (fmt"Not Done count.... {notdoneCount}")
      echo ("---------------------------")
      #var node = JsonNode[task_name]


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
  if not existsOrCreateDir(fmt"{home}/.tasks/overdue"):
     echo "overdue does not exist creating..."


proc cli() =
 for arg in arguments:
   case arg:
     of "--help":
       echo("--add-task taskName")
       echo("--add-desc taskName taskDescrp")
       echo("--due-date taskName dd-MM-yyyy")
       echo("--daily taskName")
       echo("--done taskName")
       echo("--list")
       break
     of "--add-task":
       let task_name = arguments[1]
       add_task(task_name)
       if (arguments.len > 2):
          let date = arguments[2]
          set_due(task_name,date)
       break
     of "--add-desc":
       let task_name = arguments[1]
       let task_desc = arguments[2 .. len(arguments) - 1]
       var descp = task_desc.join(" ")
       add_desc(task_name,descp)
       break
     of "--due-date":
      let task_name = arguments[1]
      let date = arguments[2]
      set_due(task_name,date)
      break
     of "--daily":
      let task_name = arguments[1]
      set_daily(task_name)
      break
     of "--list":
      list()
      break
     of "--list-close":
      list_close(arguments[1])
      break

     of "--done":
      setDone(arguments[1])
      break
     else:
      echo "Not a command"
      break
 

syncro()
#move_failed()
cli()

#why not just load every thing in a struck the tasks and go with it ......
#why use the whole file if just modifying one task for example...
