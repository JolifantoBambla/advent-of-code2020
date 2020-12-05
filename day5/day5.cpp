#include <algorithm>
#include <bitset>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

struct BoardingPass {
  unsigned int row;
  unsigned int column;
  unsigned int id;

  constexpr BoardingPass(unsigned int row, unsigned int column) : row(row), column(column), id(row * 8 + column) {}

  explicit BoardingPass(const std::string &bits) :
    BoardingPass(
      std::bitset<7>(bits.substr(0, 7)).to_ulong(),
    std::bitset<3>(bits.substr(7, 3)).to_ulong()) {}

  bool operator==(const BoardingPass &rhs) const {
    return id == rhs.id;
  }

  bool operator!=(const BoardingPass &rhs) const {
    return !(rhs == *this);
  }

  bool operator<(const BoardingPass &rhs) const {
    return id < rhs.id;
  }

  bool operator>(const BoardingPass &rhs) const {
    return rhs < *this;
  }

  bool operator<=(const BoardingPass &rhs) const {
    return !(rhs < *this);
  }

  bool operator>=(const BoardingPass &rhs) const {
    return !(*this < rhs);
  }
};

std::vector<std::string> read_input_file(const std::string &filename) {
  std::vector<std::string> result;
  std::ifstream file(filename);
  std::copy(
    std::istream_iterator<std::string>(file),std::istream_iterator<std::string>(),
    std::back_inserter(result));
  return result;
}

std::vector<BoardingPass> parse_boarding_passes(const std::vector<std::string> &foo) {
  std::vector<BoardingPass> boardingPasses;
  std::transform(
    foo.begin(), foo.end(),
    std::back_inserter(boardingPasses),
    [](std::string seat) {
      std::replace(seat.begin(), seat.end(), 'F', '0');
      std::replace(seat.begin(), seat.end(), 'B', '1');
      std::replace(seat.begin(), seat.end(), 'L', '0');
      std::replace(seat.begin(), seat.end(), 'R', '1');
      return BoardingPass(seat);
    });
  return boardingPasses;
}

unsigned int part2(const std::vector<BoardingPass> &boardingPasses) {
  for (unsigned int i = 0, id = boardingPasses[0].id; id < boardingPasses.back().id - 1; ++i, ++id) {
    if (id != boardingPasses[i].id) return id;
  }
  return 0;
}

int main() {
  auto boardingPasses = parse_boarding_passes(
    read_input_file("input.txt"));
  std::sort(boardingPasses.begin(), boardingPasses.end());
  std::cout << "Part 1: " << boardingPasses.back().id << "\n";
  std::cout << "Part 2: " << part2(boardingPasses) << "\n";
  return 0;
}