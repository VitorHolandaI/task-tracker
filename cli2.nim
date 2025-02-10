import std/parseopt

var varName: string = "defaultValue"
for kind, key, val in getopt():
  case kind
  of cmdArgument:
    continue
  of cmdLongOption, cmdShortOption:
    case key
    of "v", "version":
      writeVersion()
      quit()
    of "--add-task":
      varName = val
      echo varName
    of "m", "message":
      message = value
    of "t", "times":
      times = parseInt(value)
    else:
      echo "Unknown option: ", key

  of cmdEnd:
    discard
