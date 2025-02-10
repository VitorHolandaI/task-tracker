import os
var
  arguments = commandLineParams()
for arg in arguments:
  if arg == "--my-arg":
    echo("Yay")
  elif arg == "--multiple-args":
    echo("We can use and check multiple arguments")
  else:
    discard
