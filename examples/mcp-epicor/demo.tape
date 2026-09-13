# Marais demo tape for mcp-epicor.
# Records a real run of the test suite from /home/cfollette18/mcp-epicor.
# Run with:  vhs demo.tape
# Outputs:   docs/demo.gif and docs/demo.mp4

Output docs/demo.gif
Output docs/demo.mp4

Set FontSize 14
Set Width 1200
Set Height 675
Set Theme "Catppuccin Mocha"
Set TypingSpeed 50ms
Set Padding 20

# One line of context, then the payoff command. Keep it under 60 seconds.
Type "cd /home/cfollette18/mcp-epicor"
Enter
Sleep 1s

Type ".venv/bin/python -m pytest tests/ -q"
Enter
Sleep 4s
