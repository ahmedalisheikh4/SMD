import 'dart:io';

void main() {
  final solution = Solution();
  solution.analyzeFile();
  solution.calculateLineWithHighestFrequency();
  solution.printHighestWordFrequencyAcrossLines();
}

class LineInfo {
  final int lineNumber;
  final List<String> mostCommonWords;
  final int highestCount;

  LineInfo(this.lineNumber, this.mostCommonWords, this.highestCount);
}

class Solution {
  List<LineInfo> lineData = [];
  int overallMaxCount = 0;
  List<int> linesWithMaxCount = [];

  void analyzeFile() {
    final file = File('file.txt');
    final lines = file.readAsLinesSync();

    //task1
    for (int lineNum = 0; lineNum < lines.length; lineNum++) {
      final currentLine = lines[lineNum];
      final words =
          currentLine.split(' ').where((word) => word.isNotEmpty).toList();

      // Count word occurrences
      final wordCounter = <String, int>{};
      for (final word in words) {
        if (wordCounter.containsKey(word)) {
          wordCounter[word] = wordCounter[word]! + 1;
        } else {
          wordCounter[word] = 1;
        }
      }

      if (wordCounter.isEmpty) {
        lineData.add(LineInfo(lineNum + 1, [], 0));
        continue;
      }

      // Find maximum count in this line
      int maxInLine = 0;
      for (final count in wordCounter.values) {
        if (count > maxInLine) {
          maxInLine = count;
        }
      }

      // Collect words with maximum count
      final commonWords = wordCounter.entries
          .where((entry) => entry.value == maxInLine)
          .map((entry) => entry.key)
          .toList();

      lineData.add(LineInfo(lineNum + 1, commonWords, maxInLine));
    }
  }

  //task2
  void calculateLineWithHighestFrequency() {
    // Find the highest count across all lines
    for (final info in lineData) {
      if (info.highestCount > overallMaxCount) {
        overallMaxCount = info.highestCount;
      }
    }

    // Find which lines have this maximum count
    linesWithMaxCount = lineData
        .where((info) => info.highestCount == overallMaxCount)
        .map((info) => info.lineNumber)
        .toList();
  }

  void printHighestWordFrequencyAcrossLines() {
    print('\nWords with highest frequency per line:');
    for (final info in lineData) {
      final words = info.mostCommonWords.map((word) => '"$word"').join(', ');
      print(
          '[$words] (appears ${info.highestCount} times) in Line ${info.lineNumber}');
    }

    print('\nLines with highest overall frequency ($overallMaxCount):');
    print(linesWithMaxCount.join(', '));
  }
}
