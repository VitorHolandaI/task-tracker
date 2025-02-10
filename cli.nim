import parseopt
import strformat
import os
from strutils import parseint

proc writeVersion() =
  echo getAppFilename().extractFilename(), "0.1.0"

proc writeHelp() =
  writeVersion()
  echo """

  -h, --help        : show help
  -v, --version     : show version
  -m, --message STR : Message
  -t, --times INT   : Repeat message INT times
  """
  quit()

proc cli() =
  # Directly accessing the app name and parameters
  echo "# Program name: ", getAppFilename().extractFilename()
  echo "# Number of Parameters: ", paramCount()

  # Print all the parameters by index
  for paramIndex in 1 .. paramCount():    
    echo "# Raw param: ", paramIndex, ": ", paramStr(paramIndex)

  echo "---"

  var
    argCtr : int
    message: string
    times = 1
    i = 0

  # Loop trough all arguments
  for kind, key, value in getOpt():
    echo fmt"this is the kind {kind}"
    echo key
    echo value
    case kind

    # Positional arguments
    of cmdArgument:
      echo "# Positional argument ", argCtr, ": \"", key, "\""
      argCtr.inc

    # Switches
    of cmdLongOption, cmdShortOption:
      case key
      of "v", "version":
        writeVersion()
        quit()
      of "h", "help":
        writeHelp()
      of "m", "message":
        message = value
      of "t", "times":
        times = parseInt(value)
      else:
        echo "Unknown option: ", key

    of cmdEnd:
      discard

  if len(message) == 0:
    echo "No message specified :("

  while i < times:
    echo message
    i += 1

when isMainModule:
  cli()

