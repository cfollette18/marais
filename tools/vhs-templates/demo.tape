# Marais demo tape template.
# Copy this file into the target repo, replace the {{PLACEHOLDERS}}, then run:
#   vhs demo.tape
# Outputs land in docs/ per the demo-reel skill.

Output docs/demo.gif
Output docs/demo.mp4

Set FontSize 16
Set Width 1200
Set Height 675
Set Theme "Catppuccin Mocha"
Set TypingSpeed 60ms

# One line of context, then the payoff command. Keep it under 60 seconds.
Type "$ {{SETUP_COMMAND}}"
Enter
Sleep 2s

Type "$ {{HERO_COMMAND}}"
Enter
Sleep 5s

# Let the output sit long enough to read.
Sleep 3s
