package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
)

func readInput(filename string) (int, []string) {
    f, err := os.Open(filename)
    if err != nil {
         log.Fatal("could not open input file")
    }
    defer f.Close()

    scanner := bufio.NewScanner(f)

    scanner.Scan()
    timestamp, err := strconv.Atoi(scanner.Text())
    if err != nil {
        log.Fatal("first line in input file was no integer")
    }

    scanner.Scan()
    notes := scanner.Text()
    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
    return timestamp, strings.Split(notes, ",")
}

func part1(timestamp int, notes []string) (int) {
    min := timestamp
    busLine := -1
    for _, id := range notes {
        if id != "x" {
            interval, _ := strconv.Atoi(id)
            arrivesIn := interval - (timestamp % interval)
            if arrivesIn < min {
                min = arrivesIn
                busLine = interval
            }
        }
    }
    return busLine * min
}

func part2(notes []string) (int) {
    type bus struct {
        Id int
        Pos int
    }
    buses := []bus{}
    for i, id := range notes {
        if id != "x" {
            interval, _ := strconv.Atoi(id)
            buses = append(buses, bus{interval, i})
        }
    }

    time := 0
    step := buses[0].Id
    for _, b := range buses[1:] {
        for (time + b.Pos) % b.Id != 0 {
            time += step
        }
        step *= b.Id
    }
    return time
}

func main() {
    timestamp, notes := readInput("input.txt")

    fmt.Printf("Part 1: %v\n", part1(timestamp, notes))
    fmt.Printf("Part 2: %v\n", part2(notes))
}
