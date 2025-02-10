import std/parseopt, std/strutils

var message: string = ""
var times: int = 1
var varName: string = "defaultValue"

proc writeHelp() =
  echo """
  -h, --help        : show help
  -v, --version     : show version
  -m, --message STR : Message
  -t, --times INT   : Repeat message INT times
  """
  quit()



proc cli() = 
   for kind, key, val in getopt():
     case kind
     of cmdArgument:
       discard
     of cmdLongOption, cmdShortOption:
       case key:
        of "h", "help":
           writeHelp()
     of cmdEnd:
       discard

   let name = readLine(stdin)  
   let test_array = name.split(" ", maxsplit=1)
   case test_array[0]
   of "--add-task":
      echo "enter add task"
      echo test_array[1]
   else:
      writeHelp()

    
when isMainModule:
  cli()

