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
      std::bitset<7>(bits, 0, 7, 'F', 'B').to_ulong(),
      std::bitset<3>(bits, 7, 3, 'L', 'R').to_ulong()) {}

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

std::vector<std::string> read_seat_codes(const std::string &filename) {
  std::vector<std::string> seatCodes;
  std::ifstream file(filename);
  std::copy(
    std::istream_iterator<std::string>(file),std::istream_iterator<std::string>(),
    std::back_inserter(seatCodes));
  return seatCodes;
}

std::vector<BoardingPass> parse_boarding_passes(const std::vector<std::string> &seatCodes) {
  std::vector<BoardingPass> boardingPasses;
  boardingPasses.reserve(seatCodes.size());
  std::transform(
    seatCodes.begin(), seatCodes.end(),
    std::back_inserter(boardingPasses),
    [](const auto &code) { return BoardingPass(code); });
  return boardingPasses;
}

unsigned int part2(const std::vector<BoardingPass> &boardingPasses) {
  for (unsigned int i = 0, id = boardingPasses[0].id; i < boardingPasses.size(); ++i, ++id) {
    if (id != boardingPasses[i].id) return id;
  }
  return 0;
}

int main() {
  auto boardingPasses = parse_boarding_passes(
    read_seat_codes("input.txt"));
  std::sort(boardingPasses.begin(), boardingPasses.end());
  std::cout << "Part 1: " << boardingPasses.back().id << "\n";
  std::cout << "Part 2: " << part2(boardingPasses) << "\n";
  return 0;
}
