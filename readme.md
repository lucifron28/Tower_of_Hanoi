# 🗼 Tower of Hanoi (Terminal Version)

A colorful and interactive Tower of Hanoi puzzle built with **Dart**, playable in both manual and auto-solve modes directly from the terminal. Disks are displayed with unique colors using the `ansicolor` package.

---

## 📦 Features

- ANSI-colored disk rendering for clear visual distinction.
- Manual mode for players to move disks between towers.
- Auto-solve mode using a recursive solution.
- Console-clearing between moves for an animated experience.
- Input validation with helpful prompts.
- Move counter to track performance.

---

## 🧱 Requirements

- Dart SDK ^3.7.0 or higher.
- Linux (recommended), macOS, or Windows with a terminal that supports ANSI escape codes.

---

## 📁 Project Structure

```
tower_of_hanoi/
├── bin/
│   └── main.dart
├── pubspec.yaml
```

---

## 🔧 Installation & Setup

### 1. Install Dart SDK

Follow the official guide for your platform:  
👉 [Dart Installation Guide](https://dart.dev/get-dart)

Or for Ubuntu:
```bash
sudo apt update
sudo apt install dart
```

Check the installation with:
```bash
dart --version
```

### 2. Clone or Download the Project

```bash
git clone https://github.com/your-username/tower_of_hanoi.git
cd tower_of_hanoi
```

### 3. Install Dependencies

Run this inside your project root:
```bash
dart pub get
```

---

## 🚀 Running the Program

To launch the game:
```bash
dart run
```

You'll be prompted to:

1. Enter the number of disks.
2. Choose between:
    - Auto-solve mode (enter `a`).
    - Manual play mode (enter `m`).

---

## 🎮 Gameplay (Manual Mode)

- Move disks by typing commands like: `1 3` (to move from Tower 1 to Tower 3).
- You cannot place a larger disk on a smaller one.
- You win when all disks are stacked correctly on Tower 3.

---

## ✨ Sample Terminal Output

```
Enter the number of disks: 3
Do you want to solve the puzzle automatically (a) or play manually (m)? m

Tower 1:
   |
   |
  <o>
 <ooo>
<ooooo>

Tower 2:
   |
   |
   |
   |

Tower 3:
   |
   |
   |
   |

Move count: 0
Enter move (e.g., 1 3 to move from Tower 1 to Tower 3):
```

---

## 📚 Concepts Used

This project demonstrates the following Dart concepts:

- ✅ Variables.
- ✅ Input/Output with `dart:io`.
- ✅ Control Flow: `if`, `else if`, `else`.
- ✅ Loops: `for`, `while`.
- ✅ Lists.
- ✅ User-defined functions.
- ✅ Recursion (in `solveHanoi`).

---

## 🧪 Test Your Brain!

Try solving with:

- 3 disks (easy).
- 4 disks (moderate).
- 5+ disks (challenging!).