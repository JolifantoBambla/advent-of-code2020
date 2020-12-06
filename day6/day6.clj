(require '[clojure.string :as str])
(require '[clojure.set :as set])

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


(defn part1
  [data]
  (reduce + (groups->distinct-char-counts (extract-groups data remove-newlines))))

(def puzzle-input
  (slurp "input.txt"))

(defn string->sets
  [string]
  (map set (split-newline string)))

(defn sets->intersection-counts
  [sets]
  (count (reduce set/intersection sets)))

(defn groups->intersection-counts
  [groups]
  (map sets->intersection-counts groups))

(defn part2
  [data]
  (reduce + (groups->intersection-counts (extract-groups data string->sets))))
