#include <algorithm>
#include <bitset>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

std::vector<std::string> read_seat_codes(const std::string &filename) {
  std::vector<std::string> codes;
  std::ifstream file(filename);
  std::copy(
    std::istream_iterator<std::string>(file),std::istream_iterator<std::string>(),
    std::back_inserter(codes));
  return codes;
}

std::vector<unsigned int> parse_boarding_passes(const std::vector<std::string> &codes) {
  std::vector<unsigned int> ids;
  ids.reserve(codes.size());
  std::transform(
    codes.begin(), codes.end(),
    std::back_inserter(ids),
    [](const auto &code) {
      return std::bitset<7>(code, 0, 7, 'F', 'B').to_ulong() * 8 + std::bitset<3>(code, 7, 3, 'L', 'R').to_ulong();
    });
  return ids;
}

unsigned int part2(const std::vector<unsigned int> &ids) {
  for (unsigned int i = 0, id = ids[0]; i < ids.size(); ++i, ++id) {
    if (id != ids[i]) return id;
  }
  return 0;
}

int main() {
  auto ids = parse_boarding_passes(
    read_seat_codes("input.txt"));
  std::sort(ids.begin(), ids.end());
  std::cout << "Part 1: " << ids.back() << "\n";
  std::cout << "Part 2: " << part2(ids) << "\n";
  return 0;
}
