(ns day6
  (:require [clojure.string :as str]
            [clojure.set :as set]))

(def example-data
  "abc

a
b
c

ab
ac

a
a
a
a

b")

(def puzzle-input
  (slurp "input.txt"))

(defn count-distinct-chars
  [string]
  (count (distinct (char-array string))))

(defn split-newline
  [string]
  (str/split string #"\n"))

(defn split-double-newline
  [string]
  (str/split string #"\n\n"))

(defn remove-newlines
  [string]
  (str/replace string #"\n" ""))

(defn extract-groups
  [string str->group]
  (map str->group (split-double-newline string)))

(defn groups->distinct-char-counts
  [groups]
  (map count-distinct-chars groups))

(defn string->sets
  [string]
  (map set (split-newline string)))

(defn sets->intersection-count
  [sets]
  (count (reduce set/intersection sets)))

(defn groups->intersection-counts
  [groups]
  (map sets->intersection-count groups))

(defn part1
  [data]
  (reduce + (groups->distinct-char-counts (extract-groups data remove-newlines))))

(defn part2
  [data]
  (reduce + (groups->intersection-counts (extract-groups data string->sets))))

(defn -main
  [& args]
  (println "Part 1 (example):" (part1 example-data))
  (println "Part 2 (example):" (part2 example-data))
  (println "Part 1:" (part1 puzzle-input))
  (println "Part 2:" (part2 puzzle-input)))

