import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class DayFifteen {
  private static HashMap<Integer, Integer> memory = new HashMap<Integer, Integer>();

  private static int addNumber(int number, int turn) {
    var lastTurn = memory.get(number);
    memory.put(number, turn);
    return lastTurn == null ? 0 : turn - lastTurn;
  }

  private static int addAll(List<Integer> numbers) {
    int last = 0;
    for (int i = 0; i < numbers.size(); ++i) {
      last = addNumber(numbers.get(i), i);
    }
    return last;
  }

  public static void main (String[] args) {
    List<Integer> input = new ArrayList<Integer>();
    try (BufferedReader br = new BufferedReader(new FileReader(args[0]))) {
      Arrays.asList(br.readLine().split(",")).stream().map(Integer::parseInt).forEach(input::add);
    } catch (FileNotFoundException e) {
      System.out.println(String.format("File '%s' not found.", args[0]));
    } catch (IOException e) {
      System.out.println(String.format("Could not read file '%s'.", args[0]));
    }

    // part 1
    int nextNumber = addAll(input);
    for (int i = input.size(); i < 2019; ++i) {
      nextNumber = addNumber(nextNumber, i);
    }
    System.out.println(String.format("Part 1: %d", nextNumber));

    // part 2
    for (int i = 2019; i < 30000000 - 1; ++i) {
      nextNumber = addNumber(nextNumber, i);
    }
    System.out.println(String.format("Part 2: %d", nextNumber));
  }
}
