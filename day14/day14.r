# Oh fuck, R only supports 32-bit integers and we need 36 bit...
# Oh fuck! not only as values but also as keys! fuck fuck fuck - worst day to try out R...
dependencies <- c("bit64","hash")
missing.packages <- dependencies[!(dependencies %in% installed.packages()[,"Package"])]
if(length(missing.packages)) install.packages(missing.packages)
library(bit64)
library(hash)

input <- read.table(
  "input.txt",
  sep="=",
  strip.white=TRUE,
  col.names=c("instruction","value"),
  colClasses="character"
)
groups <- split(input, cumsum(1:nrow(input) %in% which(input$instruction == "mask")))

run_instructions <- function(mem, group) { 
  mask <- strsplit(intToUtf8(rev(utf8ToInt(group[1,2]))), "")
  ones <- which(mask[[1]] == "1")
  zeros <- which(mask[[1]] == "0")

  values <- strsplit(as.bitstring(as.integer64(group[2:nrow(group), 2])), "")
  values <- sapply(values, function (v) {v2=rev(v);v2[ones]=1;v2[zeros]=0;paste(unlist(rev(v2)),collapse='')})
  values <- as.integer64.bitstring(values)

  # yes, I'm really doing it this way!
  eval(parse(text=sprintf("%s <- %s", group[2:nrow(group), 1], format.integer64(values))))

  return(mem)
}

mem <- Reduce(run_instructions, groups, list())
part1 <- Reduce("+", Filter(Negate(function(x) is.null(unlist(x))), mem))
print(sprintf("Part 1: %s", format.integer64(part1)))

run_instructions2 <- function(mem, group) {
  mask <- strsplit(intToUtf8(rev(utf8ToInt(group[1,2]))), "")
  all.my.exes.live.in.texas <- which(mask[[1]] == "X")
  ones <- which(mask[[1]] == "1")
  
  combinations <- do.call(expand.grid, rep(list(0:1), length(all.my.exes.live.in.texas)))
  c_ones <- apply(combinations, 1, function (c) all.my.exes.live.in.texas[which(c == 1)])
  c_zeros <- apply(combinations, 1, function (c) all.my.exes.live.in.texas[which(c == 0)])

  # this is going to be really slow...
  for (j in 2:nrow(group)) {
    address = rev(unlist(rev(strsplit(as.bitstring(as.integer64(gsub("[^0-9]", "",  group[j, 1]))), ""))))
    address[ones] = 1
    val = as.integer64(group[j, 2])
    for (i in 1:length(c_ones)) {
      addr <- address
      addr[unlist(c_zeros[i])] = 0
      addr[unlist(c_ones[i])] = 1
      addr <- as.integer64.bitstring(paste(rev(addr), collapse=''))
      mem[addr] <- val
    }
  }

  return(mem)
}

mem <- Reduce(run_instructions2, groups, hash())
part2 <- Reduce("+", as.list(mem))
print(sprintf("Part 2: %s", format.integer64(part2)))
