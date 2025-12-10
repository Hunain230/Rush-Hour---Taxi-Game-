🚖 Rush Hour - Taxi Game

A taxi simulation game in Assembly (MASM) using Irvine32. Navigate streets, pick up passengers, avoid obstacles, and compete for high scores.

📋 Features

Three modes: Career, Endless, Timed

Taxi customization: Red or Yellow

22×22 dynamic grid with roads, barriers, and NPC cars

Real-time collision detection

Persistent top-5 leaderboard

Pause & interactive menus

🎮 Game Modes

Career: Deliver 5 passengers per level

Endless: Deliver as many as possible; NPCs speed up

Timed: Deliver 2 passengers in 30s

🎯 Controls
Key	Action
Arrow Keys	Move taxi
SPACEBAR	Pick up/drop passenger
P	Pause
ESC	Main menu
W/S	Menu navigation
ENTER	Select option
B	Go back
⚙️ Installation

Install MASM and Irvine32 library

Clone/download repo

Add RushHour.asm, Irvine32.inc, Irvine32.lib to project

Set entry point: main, subsystem: Console

Build & run in Visual Studio

🚕 How to Play

Enter player name

Select taxi (Red: slower, low penalty; Yellow: faster, higher penalty)

Navigate grid, pick up passengers (P) and deliver to destinations (D)

Avoid obstacles (X), NPC cars (C), and hitting passengers

📊 Scoring

Red Taxi: Obstacle -2, Car -3, Person -5, Delivery +10
Yellow Taxi: Obstacle -4, Car -2, Person -5, Delivery +10

📁 File Structure
RushHour/
├── RushHour.asm       # Game code
├── Irvine32.inc       # Irvine32 header
├── Irvine32.lib       # Irvine32 library
├── Leaderboard.txt    # High scores
└── README.md

🔧 Technical Details

Grid: 22×22 cells (0=boundary, 1=road, 2=barrier)

NPC pathfinding: random with obstacle avoidance

Leaderboard: top 5 scores, persistent

🏆 Leaderboard

Stored in Leaderboard.txt

Auto-updated & sorted descending

Displays in menu

🤝 Contributing

Fork → feature branch → commit → push → pull request

Suggested improvements: sounds, power-ups, advanced AI, graphics

📝 License

Educational use. Modify freely for learning.
