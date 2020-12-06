(ns day6
  (:require [clojure.string :as str]
            [clojure.set :as set]))
            
(def puzzle-input
  (slurp "input.txt"))

(defn day6
  [data func]
  (reduce + (map (fn [g] (count (reduce func (map set (str/split g #"\n"))))) (str/split data #"\n\n"))))

(defn -main
  [& args]
  (println "Part 1:" (day6 puzzle-input set/union))
  (println "Part 2:" (day6 puzzle-input set/intersection)))

