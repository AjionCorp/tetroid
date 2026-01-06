# Tetroid - Debugging Guide

## 🐛 Where to Find Godot Error Logs

### **1. Godot Editor Output Panel** (Primary)

**Location**: Bottom of Godot Editor

**Tabs to Check**:
- **Output** - All print() statements and errors
- **Debugger** - Runtime errors with stack traces
- **Errors** - List of all errors
- **Profiler** - Performance issues

**How to View**:
1. Open Godot Editor
2. Look at bottom panel
3. Click "Output" tab
4. Run game (F5)
5. Watch errors appear in real-time

**Error Types**:
- ❌ **Parse Error** - Syntax errors (before running)
- ⚠️ **Warning** - Type safety warnings
- 🔴 **Runtime Error** - Errors while game is running
- 💬 **Print** - Debug messages (print(), push_warning())

### **2. Debugger Panel** (For Crashes)

**When to Use**: Game crashes or freezes

**Features**:
- Stack trace (where error occurred)
- Variable inspection
- Breakpoints
- Step-through debugging

**How to Access**:
1. Click "Debugger" tab (bottom panel)
2. Shows call stack when error occurs
3. Click on stack frames to see code

### **3. Log Files** (Our Custom Logger)

**Location**: 
```
Windows: C:\Users\[YourName]\AppData\Roaming\Godot\app_userdata\Tetroid\tetroid_debug.log
Linux: ~/.local/share/godot/app_userdata/Tetroid/tetroid_debug.log
Mac: ~/Library/Application Support/Godot/app_userdata/Tetroid/tetroid_debug.log
```

**Access**:
```gdscript
// In game console, we print it on startup:
DebugLogger.print_log_location()
```

**What's Logged**:
- All game events
- State changes
- Errors and warnings
- Timestamped entries

### **4. Console Log (When Running Standalone)**

**Command Line**:
```bash
cd D:\RetroEpicEmpire\Games\Tetroid
godot --verbose res://main.tscn 2>&1 | tee game_output.log
```

This saves ALL output to `game_output.log`.

### **5. Export Build Logs**

When exporting builds:
```bash
godot --export "Windows Desktop" builds/tetroid.exe --verbose
```

Logs appear in terminal.

## 🔍 Common Issues & How to Debug

### **Parse Errors (Before Game Runs)**

**Symptom**: Red errors in "Errors" tab, game won't start

**How to Fix**:
1. Read error message carefully
2. Click on error → jumps to line
3. Fix syntax issue
4. Project → Reload Current Project

**Common Causes**:
- Type mismatches
- Undefined variables
- Missing semicolons/colons
- Incorrect indentation

### **Runtime Errors (During Game)**

**Symptom**: Game crashes or behaves wrong

**How to Debug**:
1. Check "Debugger" tab for stack trace
2. Look at "Output" for error messages
3. Add print() statements:
   ```gdscript
   print("DEBUG: Variable value = " + str(my_var))
   ```
4. Use breakpoints (click left margin in script)

### **Performance Issues**

**Symptom**: Low FPS, stuttering

**How to Debug**:
1. Open "Profiler" tab
2. Run game
3. Check which functions take most time
4. Optimize those functions

### **Visual Issues (Nothing Showing)**

**Symptom**: Blank screen, missing elements

**How to Debug**:
1. Check "Remote" scene tree (while game running)
2. Verify nodes are being added
3. Check z_index values
4. Print position values:
   ```gdscript
   print("Block position: " + str(position))
   ```

## 🛠️ Debug Commands

### **In Game Code**

```gdscript
// State dump
DebugLogger.dump_game_state(game_state)

// Log events
DebugLogger.log_game_event("BLOCK_PLACED", {"type": "I_PIECE", "pos": Vector2i(10, 5)})

// Errors
DebugLogger.log_error("Failed to create block!", "FACTORY")

// Warnings
DebugLogger.log_warning("Low HP!", "GAMESTATE")
```

### **Console Commands**

Press **F6** in Godot to open console, then type:
```python
# Check FPS
Engine.get_frames_per_second()

# Get game node
get_node("/root/Main/Game")

# Dump scene tree
get_tree().print_tree_pretty()
```

## 🎯 Current Debugging Tools

### **Enabled in Project**:
- ✅ Type safety warnings
- ✅ Untyped declaration warnings
- ✅ Unsafe method access warnings
- ✅ Custom debug logger
- ✅ Print statements throughout code

### **How to Use**:

**1. Watch Output Panel**:
```
=== Tetroid Starting ===
✓ Constants initialized
✓ Block data loaded: 7 piece types
✓ Game state initialized
✓ Board created
✓ Paddles created
```

**2. Check for Errors**:
```
ERROR: Cannot create block: invalid piece type INVALID
At: src/factories/block_factory.gd:13
```

**3. Use Debug Shortcuts**:
- **F5** - Run game
- **F6** - Run with debug
- **F7** - Step into
- **F8** - Break
- **Ctrl+F5** - Run without debug

## 📋 Debugging Checklist

When something goes wrong:

- [ ] Check "Output" panel for print statements
- [ ] Check "Errors" panel for error list
- [ ] Check "Debugger" for stack trace
- [ ] Look at our log file (DebugLogger.print_log_location())
- [ ] Add more print() statements
- [ ] Use breakpoints
- [ ] Check "Remote" scene tree

## 💡 Pro Tips

**1. Add Debug Overlays**:
```gdscript
# Show FPS always
var fps_label = Label.new()
# Update with: str(Engine.get_frames_per_second())
```

**2. Press F3 in Running Game**:
- Shows memory usage
- Shows FPS
- Shows draw calls

**3. Use Print Debugging**:
```gdscript
print("Before function call")
my_function()
print("After function call - result: " + str(result))
```

## 🎮 Try It Now

**In Godot Editor**:
1. Look at **bottom panel** → **Output** tab
2. Press **F5** to run
3. Watch messages appear
4. Any errors will show in **red**

The log location will be printed on startup!

---

**Current Log Location** will be printed when you run the game. Look for:
```
=== DEBUG LOG LOCATION ===
Log file: C:\Users\alesh\AppData\Roaming\Godot\app_userdata\Tetroid\tetroid_debug.log
==========================
```

Let me know what errors you see! 🔍
