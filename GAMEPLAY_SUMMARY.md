# Tetroid - Current Gameplay Summary

## 🎮 Game Flow

### **1. Deployment Phase (90 seconds)**

**Starting Setup:**
- Each player gets **5 pre-placed Tetris pieces**
- Composition: **2 of one type + 3 of another** (random)
- Pieces start clustered in your territory

**Controls:**
- **Click** on piece → Select (glows brighter + scales up)
- **Drag** mouse → Move piece anywhere (except neutral zone)
- **Q** → Rotate counter-clockwise
- **E** → Rotate clockwise
- **Release** → Place piece

**Strategy:**
- Rearrange pieces before timer ends
- Place defensively (block enemy ball)
- Place offensively (won't block your ball)
- 90 seconds to plan!

### **2. Battle Phase (Until someone loses)**

**TWO Balls (One Per Player):**
- 🔵 **CYAN ball** = YOUR ball (Player 1)
- 🔴 **RED ball** = ENEMY ball (Player 2/AI)

**Ball Ownership Rules:**
- ✅ Your ball **PASSES THROUGH** your own blocks
- ✅ Your ball **BOUNCES OFF** enemy blocks (damages them!)
- ✅ Enemy ball **PASSES THROUGH** their blocks
- ✅ Enemy ball **BOUNCES OFF** your blocks (damages them!)

**Paddle Controls:**
- **A** → Move left
- **D** → Move right
- Deflect **YOUR ball** (cyan) to attack enemy
- **Enemy paddle won't deflect your ball!**

**Damage:**
- Miss your ball → **You lose 10 HP**
- Enemy misses their ball → **They lose 10 HP**
- First to 0 HP loses!

## 🎯 Strategic Depth

### **Block Placement:**

**Defensive Placement:**
- Place blocks to **stop enemy's ball**
- Blocks take damage when hit
- Protect your HP by blocking enemy ball

**Offensive Placement:**
- Your ball **ignores your blocks**
- Place blocks in enemy territory for territory control
- Doesn't hinder your own attack

**Mixed Strategy:**
- Balance defense and offense
- Some blocks defend, some pressure enemy
- Adapt to enemy's setup

## 🎨 Visual Indicators

- **Cyan blocks** = Player 1 (you)
- **Red blocks** = Player 2 (AI)
- **Cyan ball with trail** = Your ball
- **Red ball with trail** = Enemy ball
- **Cyan paddle** = Your paddle (bottom)
- **Red paddle** = Enemy paddle (top)
- **Magenta lines** = Neutral zone (can't place blocks)

## 🏆 Victory Conditions

- Reduce enemy to **0 HP** = You win!
- Your HP reaches **0** = You lose!
- Time limit (future): Most HP wins

## 📊 Current Features

✅ Pre-placed deployment (Mechabellum style)
✅ Click & drag piece movement
✅ Q/E rotation
✅ 90-second deployment timer
✅ Two-ball system
✅ Ball ownership mechanics
✅ Pass-through own blocks
✅ Damage enemy blocks
✅ Color-coded balls (cyan/red)
✅ AI paddle defense
✅ HP tracking
✅ Win/loss detection

## 🎮 Full Control Reference

### **Deployment Phase:**
| Action | Key |
|--------|-----|
| Select piece | Click |
| Move piece | Drag |
| Rotate CCW | Q |
| Rotate CW | E |
| Place | Release |

### **Battle Phase:**
| Action | Key |
|--------|-----|
| Move paddle left | A |
| Move paddle right | D |

## 🤖 AI Behavior

**Deployment:**
- AI pre-places 5 pieces in top territory
- Hidden from player (fog of war)

**Battle:**
- AI paddle tracks its RED ball
- Moves to intercept and deflect
- Defends against its own ball

---

**Status**: Fully playable prototype!
**Phase 1 Complete**: ✅ (Ahead of schedule!)
