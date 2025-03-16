import std/[times, os]
# Simple benchmarking
let time = cpuTime()
sleep(100) # Replace this with something to be timed
echo "Time taken: ", cpuTime() - time

# Current date & time
let now1 = now()     # Current timestamp as a DateTime in local time
let now2 = now().utc # Current timestamp as a DateTime in UTC
let now3 = getTime() # Current timestamp as a Time

let now5 = now()
let set_date = parse("18-03-2025","dd-MM-yyyy")
# Arithmetic using Duration
echo "One hour from now      : ", format(now5, "dd")
# Arithmetic using TimeInterval
echo "One year from now      : ", now() + 1.days
echo "One year from now      : ", set_date + 1.days
echo "One month from now     : ", now() + 1.months
