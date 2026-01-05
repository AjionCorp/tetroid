# 🚨 START HERE - AI Agent Quick Reference

> **This is your FIRST STOP before writing any code!**

## ⚠️ CRITICAL REQUIREMENTS

### 1. Godot Version: 4.5+ ONLY

**This project uses Godot 4.x syntax exclusively.**

### 2. NEVER Use These (Godot 3.x - DEPRECATED):

```gdscript
❌ emit_signal("signal_name", args)  // WRONG
❌ yield(timer, "timeout")           // WRONG
❌ var file = File.new()              // WRONG
❌ OS.get_ticks_msec()                // WRONG
```

### 3. ALWAYS Use These (Godot 4.x - CORRECT):

```gdscript
✅ signal_name.emit(args)             // CORRECT
✅ await timer.timeout                // CORRECT
✅ var file = FileAccess.open(...)    // CORRECT
✅ Time.get_ticks_msec()              // CORRECT
```

## 📚 Required Reading (In Order)

**Before writing ANY code, read these:**

1. **[CODING_STANDARDS.md](docs/CODING_STANDARDS.md#-godot-4x-best-practices)** ⚠️ **CRITICAL**
   - Godot 4.x syntax requirements
   - Signal emission (`.emit()`)
   - Type hints requirements
   - Common migration issues

2. **[AGENT_GUIDELINES.md](docs/AGENT_GUIDELINES.md)** 
   - Your role and responsibilities
   - Workflow protocol
   - Collaboration rules

3. **[CURRENT_STATE.md](docs/CURRENT_STATE.md)**
   - What's been done
   - What's in progress
   - What's available

4. **[CODE_DRIVEN_DEVELOPMENT.md](docs/CODE_DRIVEN_DEVELOPMENT.md)**
   - Development approach
   - Asset strategy

## ✅ Pre-Code Checklist

Before writing code, verify:

- [ ] I've read CODING_STANDARDS.md Godot 4.x section
- [ ] I know the difference between Godot 3.x and 4.x syntax
- [ ] I understand signal emission uses `.emit()` not `emit_signal()`
- [ ] I will add type hints to all functions and variables
- [ ] I've checked CURRENT_STATE.md for conflicts
- [ ] I've claimed my task in CURRENT_STATE.md
- [ ] I understand my role's responsibilities

## 🚫 Common Mistakes to Avoid

### Signal Emission
```gdscript
// ❌ WRONG (Godot 3.x)
emit_signal("player_hit", damage)

// ✅ CORRECT (Godot 4.x)
player_hit.emit(damage)
```

### File Access
```gdscript
// ❌ WRONG (Godot 3.x)
var file = File.new()
file.open(path, File.READ)

// ✅ CORRECT (Godot 4.x)
var file = FileAccess.open(path, FileAccess.READ)
```

### Async Operations
```gdscript
// ❌ WRONG (Godot 3.x)
yield(get_tree().create_timer(1.0), "timeout")

// ✅ CORRECT (Godot 4.x)
await get_tree().create_timer(1.0).timeout
```

### Type Hints (REQUIRED)
```gdscript
// ❌ BAD (No type hints)
func create_block(type, pos):
    var block = Block.new()
    return block

// ✅ GOOD (Full type hints)
func create_block(type: String, pos: Vector2i) -> Block:
    var block: Block = Block.new()
    return block
```

## 📖 Quick Links

- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - 📋 Godot 4.x syntax cheat sheet
- **[Godot 4.x Migration Table](docs/CODING_STANDARDS.md#common-migration-issues)** - Old vs New syntax
- **[Game Design](docs/GAME_DESIGN.md)** - What we're building
- **[Architecture](docs/ARCHITECTURE.md)** - System design
- **[Networking](docs/NETWORKING.md)** - Multiplayer implementation
- **[AI System](docs/AI_SYSTEM.md)** - Bot opponents

## 🎯 Workflow Summary

1. **Read** CODING_STANDARDS.md (Godot 4.x section)
2. **Check** CURRENT_STATE.md
3. **Claim** your task
4. **Write** code following standards
5. **Test** thoroughly
6. **Update** documentation
7. **Self-review** checklist
8. **Mark** complete

## 🆘 When In Doubt

1. Check existing code for patterns
2. Search CODING_STANDARDS.md
3. Look at Godot 4.x official docs: https://docs.godotengine.org/en/stable/
4. Ask in your task update

---

**Remember**: Using Godot 3.x syntax will break the project. Always use Godot 4.x!

**Last Updated**: 2026-01-05  
**Godot Version**: 4.5+  
**Status**: Active Development
