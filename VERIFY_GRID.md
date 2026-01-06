# Grid Verification

## Expected Layout

**Total Height: 62 BLOCKS (cells)**

```
Row 0-29:   Player 2 Territory (AI at top)     - 30 blocks tall
Row 30-31:  NEUTRAL ZONE                       - 2 blocks tall  
Row 32-61:  Player 1 Territory (You at bottom) - 30 blocks tall
─────────────────────────────────────────────
TOTAL:      30 + 2 + 30 = 62 blocks
```

## Grid Lines Needed

**For 62 rows of blocks, you need 63 horizontal lines:**
- Line 0: Top of row 0
- Line 1: Top of row 1 (bottom of row 0)
- Line 2: Top of row 2 (bottom of row 1)
- ...
- Line 61: Top of row 61 (bottom of row 60)
- Line 62: Bottom of row 61

**Current Code:**
```gdscript
for y in range(board_height + 1):  // range(63)
    // Draws lines at y = 0, 1, 2, ..., 62
    // That's 63 lines ✓ CORRECT
```

## If You're Seeing 64

**Possible causes:**
1. Counting the border (adds 2 extra lines at top/bottom)
2. Neutral zone has 2 extra magenta lines (decorative)
3. Counting something else

## Actual Block Rows

**Should be 62 playable rows:**
- Rows 0-29: 30 rows (AI)
- Rows 30-31: 2 rows (neutral - no placement)
- Rows 32-61: 30 rows (player)

**Total: 62 rows** ✅

## To Verify in Game

Run this in Godot console (F6):
```gdscript
get_node("/root/Main/Game/BoardManager").board_height
// Should return: 62
```

---

**Conclusion**: Grid is CORRECT at 62 blocks tall with 63 grid lines.

If you're seeing 64, it might be visual (borders, neutral zone lines) but the playable grid is definitely 62 blocks tall as designed.
