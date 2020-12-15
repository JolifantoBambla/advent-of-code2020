use std::collections::HashMap;
use std::collections::HashSet;
use std::env;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path> {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

#[derive(Eq, PartialEq, Debug)]
struct Bag {
    color: String,
    held_by: HashSet<String>,
    holds: HashMap<String, u32>
}

impl Bag {
    fn new(color: &str, held_by: HashSet<String>) -> Bag {
        return Bag { color: color.to_string(), held_by: held_by, holds: HashMap::new() };
    }
}

fn construct_rule_graph<P>(filename: P) -> HashMap<String, Bag>
where P: AsRef<Path> {
    let mut graph: HashMap<String, Bag> = HashMap::new();
    if let Ok(lines) = read_lines(filename) {
        for line in lines {
            if let Ok(rule) = line {
                let mut foo: Vec<&str> = rule.split("contain").collect();

                // vertex
                let mut vertex = String::from(foo.remove(0));
                vertex.retain(|c| !c.is_whitespace());
                vertex.truncate(vertex.len() - 4);
                if !graph.contains_key(&vertex) {
                    graph.insert(vertex.clone(), Bag::new(&vertex, HashSet::new()));
                }
                
                // successors capacities
                let mut held_by: HashSet<String> = HashSet::new();
                held_by.insert(vertex.clone());
                
                let mut outgoing_description = String::from(foo.remove(0));
                outgoing_description.truncate(outgoing_description.len() - 1);
                let successors: Vec<&str> = outgoing_description.split(",").collect();

                for successor_description in successors.into_iter() {
                    let mut successor = String::from(successor_description);
                    successor.retain(|c| !c.is_whitespace());
                    let first_char = successor.remove(0);
                    if first_char != 'n' {
                        let capacity = first_char.to_digit(10).unwrap();
                        successor.truncate(successor.len() - if capacity > 1 { 4 } else { 3 });
                        if graph.contains_key(&successor) {
                            graph.get_mut(&successor).unwrap().held_by.insert(vertex.clone());
                        } else {
                            graph.insert(successor.clone(), Bag::new(&successor, held_by.clone()));
                        }
                        graph.get_mut(&vertex).unwrap().holds.insert(successor.clone(), capacity);
                    }
                }
            }
        }
    }
    return graph;
}

fn find_vertex_in_component (vertex: &str, graph: &HashMap<String, Bag>, mut processed: HashSet<String>) -> HashSet<String> {
    for b in &graph.get(vertex).unwrap().held_by {
        if !processed.contains(b) {
            processed.insert(b.clone());
            processed = find_vertex_in_component(&b, graph, processed);
        }
    }
    return processed;
}

fn sum_capacities(vertex: &str, graph: &HashMap<String, Bag>) -> u32 {
    let mut sum = 0;
    for (v, capacity) in &graph.get(vertex).unwrap().holds {
        sum += capacity + capacity * sum_capacities(&v, graph);
    }
    return sum;
}

fn main() {
    let mut args: Vec<String> = env::args().collect();
    let graph = construct_rule_graph(&args.remove(1));

    println!("Part 1: {}", find_vertex_in_component("shinygold", &graph, HashSet::new()).len());
    println!("Part 2: {}", sum_capacities("shinygold", &graph));
}
