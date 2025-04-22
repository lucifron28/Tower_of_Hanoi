import 'dart:io';
import 'package:ansicolor/ansicolor.dart';

// Setup Ansicolor pens for various text elements.
final AnsiPen headerPen = AnsiPen()..blue(bold: true);
final AnsiPen towerPen  = AnsiPen()..yellow(bold: true);
final AnsiPen errorPen  = AnsiPen()..red(bold: true);
final AnsiPen movePen   = AnsiPen()..magenta(bold: true);
final AnsiPen winPen    = AnsiPen()..green(bold: true);

// Define a list of pens for disks.
// These pens will be reused such that each disk gets a unique color.
final List<AnsiPen> diskPens = [
  AnsiPen()..red(bold: true),
  AnsiPen()..green(bold: true),
  AnsiPen()..blue(bold: true),
  AnsiPen()..magenta(bold: true),
  AnsiPen()..cyan(bold: true),
  AnsiPen()..yellow(bold: true),
  AnsiPen()..white(bold: true),
];

/// Clears the console screen by printing the ANSI escape code.
void clearScreen() {
  stdout.write("\x1B[2J\x1B[H");
}

/// Prints one tower (stack) in a formatted manner.
/// [tower] is a list of disks (integers) and [maxDisks] tells how many rows to print.
void printStack(List<int> tower, int maxDisks) {
  // Create a copy of the tower.
  List<int> stackCopy = List.from(tower);
  
  // Collect disk values from bottom-to-top.
  List<int> elements = [];
  while (stackCopy.isNotEmpty) {
    elements.add(stackCopy.removeLast());
  }
  
  // Print empty rows if the stack has fewer items than maxDisks.
  for (int i = elements.length; i < maxDisks; i++) {
    stdout.writeln("".padLeft(maxDisks) + "|" + "".padLeft(maxDisks));
  }
  
  // Print each disk.
  for (int disk in elements) {
    int spaces = maxDisks - disk;
    stdout.write("".padLeft(spaces) + "<");
    
    // Determine the disk's color pen.
    AnsiPen diskPen = diskPens[(disk - 1) % diskPens.length];
    String diskStr = "o" * (disk * 2 - 1);
    stdout.write(diskPen(diskStr));
    
    stdout.writeln(">" + "".padLeft(spaces));
  }
}

/// Prints all towers with labels.
void printTowers(List<List<int>> towers, int maxDisks) {
  stdout.writeln(headerPen("Current Towers:\n"));
  for (int i = 0; i < towers.length; i++) {
    stdout.writeln(towerPen("Tower ${i + 1}:"));
    printStack(towers[i], maxDisks);
  }
  stdout.writeln("");
}

/// Moves the top disk from [source] to [destination] if valid.
bool moveDisk(List<int> source, List<int> destination) {
  if (source.isEmpty) {
    stdout.writeln(errorPen("Invalid move: Source tower is empty!\n"));
    return false;
  } else if (destination.isNotEmpty && source.last > destination.last) {
    stdout.writeln(errorPen("Invalid move: Cannot place larger disk on smaller disk!\n"));
    return false;
  } else {
    destination.add(source.removeLast());
    return true;
  }
}

/// Checks if the target tower (1-indexed) has all [numDisks] disks.
bool checkWin(List<List<int>> towers, int numDisks, int targetTower) {
  return towers[targetTower - 1].length == numDisks;
}

/// Recursively solves the puzzle.
/// [n]: number of disks; [source], [target], [aux] are tower indices (0-indexed).
/// [towers]: list of three towers; [numDisks]: for display formatting; [moveCount]: counts moves.
void solveHanoi(int n, int source, int target, int aux,
    List<List<int>> towers, int numDisks, List<int> moveCount) {
  if (n == 0) return;
  
  clearScreen();
  printTowers(towers, numDisks);
  
  solveHanoi(n - 1, source, aux, target, towers, numDisks, moveCount);
  
  // Move disk from source to target.
  moveDisk(towers[source], towers[target]);
  moveCount[0]++;
  
  clearScreen();
  printTowers(towers, numDisks);
  stdout.writeln(movePen("Move count: ${moveCount[0]}"));
  sleep(Duration(seconds: 1));
  
  solveHanoi(n - 1, aux, target, source, towers, numDisks, moveCount);
}

void main() {
  stdout.write(headerPen("Enter the number of disks: "));
  int? numDisks = int.tryParse(stdin.readLineSync() ?? "");
  if (numDisks == null || numDisks <= 0) {
    stdout.writeln(errorPen("Invalid number of disks."));
    return;
  }
  
  // Create three towers represented as lists.
  List<List<int>> towers = List.generate(3, (_) => <int>[]);
  
  // Initialize the first tower with disks (largest disk has the highest integer).
  for (int i = numDisks; i >= 1; i--) {
    towers[0].add(i);
  }
  
  stdout.write(headerPen("Solve automatically (a) or play manually (m)? "));
  String? choice = stdin.readLineSync();
  
  List<int> moveCount = [0]; // Use a list to pass move count by reference.
  
  if (choice != null && choice.toLowerCase() == 'a') {
    // Solve automatically.
    solveHanoi(numDisks, 0, 2, 1, towers, numDisks, moveCount);
    
    clearScreen();
    printTowers(towers, numDisks);
    stdout.writeln(winPen("Solved the puzzle in ${moveCount[0]} moves!"));
  } else if (choice != null && choice.toLowerCase() == 'm') {
    int? source;
    int? destination;
    
    while (true) {
      clearScreen();
      printTowers(towers, numDisks);
      stdout.writeln(movePen("Move count: ${moveCount[0]}"));
      stdout.write(headerPen("Enter move (e.g., 1 3 to move from Tower 1 to Tower 3): "));
      
      List<String> input = (stdin.readLineSync() ?? "").split(" ");
      if (input.length < 2) {
        stdout.writeln(errorPen("Invalid input! Please enter two numbers separated by a space."));
        continue;
      }
      
      source = int.tryParse(input[0]);
      destination = int.tryParse(input[1]);
      
      if (source == null || destination == null ||
          source < 1 || source > 3 || destination < 1 || destination > 3) {
        stdout.writeln(errorPen("Invalid input! Towers are numbered 1 to 3."));
        sleep(Duration(seconds: 1));
        continue;
      }
      
      // Attempt to move the disk.
      if (moveDisk(towers[source - 1], towers[destination - 1])) {
        moveCount[0]++;
        if (checkWin(towers, numDisks, 3)) {
          clearScreen();
          printTowers(towers, numDisks);
          stdout.writeln(winPen(
              "Congratulations! You solved the Tower of Hanoi puzzle in ${moveCount[0]} moves!"));
          break;
        }
      }
      
      sleep(Duration(milliseconds: 500));
    }
  } else {
    stdout.writeln(errorPen("Invalid choice! Exiting..."));
  }
}