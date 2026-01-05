# Frequently Asked Questions (FAQ)

## 🎮 Game Design

### Q: Why combine Tetris, Arkanoid, and Mechabellum?
**A**: Each game brings unique mechanics:
- **Tetris**: Strategic piece placement and territory control
- **Arkanoid**: Skill-based ball deflection and timing
- **Mechabellum**: Auto-battler strategy where placement matters

The combination creates a unique competitive experience balancing strategy and skill.

### Q: How does the block ability system work?
**A**: Each Tetris piece (I, O, T, S, Z, J, L) has a unique ability that activates when the ball hits it. Abilities have cooldowns and their effectiveness depends on whether the block is placed in friendly or enemy territory.

### Q: What's the neutral zone for?
**A**: The 2-block neutral zone in the middle serves as:
1. Clear boundary between territories
2. Forces strategic placement around it
3. Creates "no-man's land" for tactical considerations
4. Prevents cheap placements right at the boundary

### Q: How is damage calculated when ball is missed?
**A**: Damage depends on the ball type:
- Normal ball: -10 HP
- Fire ball: -20 HP + burning DOT
- Ice ball: -10 HP + slow debuff
- Heavy ball: -30 HP
- Ghost ball: -15 HP
- Multi balls: -10 HP per ball

### Q: Can blocks be destroyed?
**A**: Yes! Blocks have HP and take damage when hit by the ball. When HP reaches 0, the block is destroyed. Blocks in enemy territory have less HP than those in friendly territory.

## 🎯 Gameplay

### Q: How do I win?
**A**: Reduce opponent's HP to 0 by:
1. Making them miss balls
2. Using offensive abilities
3. Placing blocks strategically in their territory
4. Managing your defense to keep your HP up

### Q: What happens if both players reach 0 HP simultaneously?
**A**: It's a draw. In tournaments, specific tiebreaker rules apply (usually score-based).

### Q: Can I rotate pieces before placing?
**A**: Yes! Use rotation controls (Q/E keys or shoulder buttons) to rotate pieces before placement. The game uses Super Rotation System (SRS) for wall kicks.

### Q: How many pieces ahead can I see?
**A**: You can see your next 3 pieces in the preview queue. This allows for strategic planning.

### Q: Can I hold a piece for later?
**A**: Yes! You can hold one piece to swap with your current piece (standard Tetris mechanic).

## 🌐 Multiplayer

### Q: What game modes are available?
**A**:
- **1v1**: Classic one-on-one
- **2v2**: Team-based with shared HP
- **4-Player FFA**: Free-for-all, last player standing
- **Ranked**: ELO-based competitive
- **Casual**: Unranked matches
- **Custom**: Host with custom rules

### Q: How does matchmaking work?
**A**: 
- **Ranked**: ELO-based matching (±100 ELO initially, expands after 30s)
- **Casual**: Loose skill-based matching, prioritizes connection quality
- **Max wait time**: 2 minutes before expanding search

### Q: What if someone disconnects?
**A**:
- **Ranked**: Disconnect = automatic loss (to prevent abuse)
- **Casual**: AI can take over or match ends
- **Grace period**: 30 seconds to reconnect before loss

### Q: Is there a penalty for leaving matches?
**A**:
- **Ranked**: Yes, ELO loss and temporary matchmaking ban (escalates)
- **Casual**: No penalty, but tracked for player reputation

## 🤖 AI Opponents

### Q: How many AI difficulty levels are there?
**A**: Four levels:
- **Easy**: 30% accuracy, slow reactions (300ms)
- **Normal**: 50% accuracy, moderate reactions (150ms)
- **Hard**: 70% accuracy, fast reactions (80ms)
- **Expert**: 85% accuracy, very fast reactions (30ms)

### Q: Does AI cheat?
**A**: No! AI follows same rules as players:
- Same physics
- Same information (sees what players see)
- Reaction time delays
- Makes mistakes based on difficulty
- No perfect knowledge of future events

### Q: Can AI use all abilities?
**A**: Yes, AI understands and uses all block and paddle abilities. Higher difficulties use them more strategically.

## 🏆 Progression

### Q: Is there a progression system?
**A**: Yes:
- **Player Level**: Earn XP from matches, level up
- **ELO Rating**: Ranked competitive rating
- **Achievements**: 15+ achievements to unlock
- **Cosmetics**: Unlockable skins, trails, paddles
- **Titles**: Earned through achievements

### Q: Does progression give gameplay advantages?
**A**: **No!** All unlocks are purely cosmetic. Tetroid is skill-based with no pay-to-win or grind-to-win mechanics.

### Q: How does the ELO system work?
**A**:
- Start at 1000 ELO
- Win: Gain 15-30 ELO (depends on opponent)
- Loss: Lose 10-25 ELO
- Separate ELO per game mode
- Season resets (soft reset)

## ⚙️ Technical

### Q: What platforms is Tetroid available on?
**A**: Steam (PC) - Windows, Linux, Mac (planned)

### Q: What are the system requirements?
**A**:
**Minimum**:
- OS: Windows 10 / Ubuntu 20.04
- CPU: Dual-core 2.0 GHz
- RAM: 2 GB
- GPU: Intel HD Graphics 4000
- Storage: 500 MB
- Network: Broadband Internet

**Recommended**:
- OS: Windows 11 / Ubuntu 22.04
- CPU: Quad-core 3.0 GHz
- RAM: 4 GB
- GPU: GTX 750 / AMD equivalent
- Storage: 1 GB SSD
- Network: Broadband Internet

### Q: What's the target framerate?
**A**: Locked 60 FPS. The game is designed around 60 Hz physics and input.

### Q: Is controller support available?
**A**: Yes! Full support for:
- Xbox controllers
- PlayStation controllers
- Steam Controller
- Generic USB controllers

### Q: Does the game support Steam features?
**A**: Yes:
- Steam achievements
- Steam leaderboards
- Steam friends integration
- Steam Cloud saves
- Steam Networking
- Steam Workshop (planned post-launch)

### Q: What about cheating/hacking?
**A**: Anti-cheat measures:
- Server-authoritative gameplay
- Input validation
- Behavior analysis
- Anomaly detection
- Steam VAC integration
- Report system

## 🎨 Customization

### Q: Can I customize my blocks?
**A**: Yes! Unlockable cosmetics:
- Block skins (visual only)
- Paddle designs
- Ball trails
- Victory animations
- Emotes

### Q: Will there be more content post-launch?
**A**: Yes! Planned post-launch:
- **Season 1** (Months 2-3): New abilities, balance patches
- **Season 2** (Months 4-6): New game modes, cosmetics
- **Long-term**: Possible mobile version, custom game modes, map editor

### Q: Can I suggest features?
**A**: Absolutely! We welcome feedback:
- Steam Community Hub
- Discord server
- Reddit community
- In-game feedback form

## 🐛 Troubleshooting

### Q: Game won't launch
**A**: Try:
1. Verify game files (Steam)
2. Update graphics drivers
3. Restart Steam
4. Check system requirements
5. Disable antivirus temporarily
6. Run as administrator

### Q: Experiencing lag/high latency
**A**: 
1. Check your internet connection
2. Close bandwidth-heavy applications
3. Try wired connection instead of WiFi
4. Check server region selection
5. Lower graphics settings (reduces CPU load)

### Q: Audio issues
**A**:
1. Check audio device settings
2. Update audio drivers
3. Verify game audio settings
4. Check Windows/system audio mixer
5. Restart game

### Q: Graphical glitches
**A**:
1. Update graphics drivers
2. Verify game files
3. Try different graphics settings
4. Check GPU temperatures
5. Disable overlays (Discord, etc.)

### Q: Can't find matches
**A**:
1. Check your region selection
2. Try different game modes
3. Check matchmaking restrictions (e.g., skill range)
4. Play during peak hours
5. Check server status

## 📧 Support

### Q: How do I report a bug?
**A**: Multiple ways:
1. In-game bug report tool
2. Steam Community Hub → Bug Reports
3. Discord #bug-reports channel
4. Email: bugs@tetroid.game (if available)

Include:
- Detailed description
- Steps to reproduce
- Screenshots/video
- System specifications
- Log files

### Q: How do I report toxic players?
**A**:
1. Use in-game report system
2. Provide player SteamID
3. Include screenshot evidence
4. Describe violation

We take reports seriously and review all submissions.

### Q: Where can I get help?
**A**:
- Steam Community Hub (fastest)
- Discord server (#support channel)
- Reddit community
- Email support (if available)
- FAQ (this document)

## 🎓 Learning

### Q: Is there a tutorial?
**A**: Yes! The game includes:
- Interactive tutorial (covers all mechanics)
- Practice mode (vs Easy AI)
- Tips during loading screens
- Ability tooltips
- Video tutorials (community-made)

### Q: Where can I learn advanced strategies?
**A**:
- Watch high-level players on Twitch/YouTube
- Join Discord strategy discussions
- Read Steam guides
- Analyze replays
- Practice vs Hard/Expert AI

### Q: What's the best starting strategy?
**A**: For beginners:
1. Focus on paddle defense first
2. Place blocks in your own territory initially
3. Learn each piece's ability
4. Practice ball trajectory prediction
5. Gradually try enemy territory placement

## 💰 Pricing & DLC

### Q: How much does Tetroid cost?
**A**: TBD (Price not yet set)
Planned: Affordable price point ($10-15 USD range)

### Q: Are there microtransactions?
**A**: **Cosmetic only**:
- Optional cosmetic DLC packs
- No gameplay advantages
- All core content included in base game
- No loot boxes

### Q: Will there be DLC?
**A**: Planned:
- **Free DLC**: New game modes, balance updates, features
- **Paid DLC**: Cosmetic packs (optional)
- **Seasons**: Free content drops

## 🌍 Community

### Q: Is there a competitive scene?
**A**: We support competitive play:
- Ranked mode with ELO
- Leaderboards (global, regional, friends)
- Tournament system built-in
- Spectator mode
- Replay system (planned)

### Q: Can I host tournaments?
**A**: Yes! Features:
- In-game tournament creation
- Multiple formats (single/double elimination, round robin)
- Spectator support
- Bracket generation
- Statistics tracking

### Q: Where can I find the community?
**A**:
- Discord: [Link TBD]
- Reddit: r/Tetroid [TBD]
- Twitter: @TetroidGame [TBD]
- Steam Community Hub
- Twitch streamers

---

## 📝 Didn't Find Your Answer?

If your question isn't answered here:
1. Check the full documentation in `/docs/`
2. Search Steam Community Hub
3. Ask in Discord
4. Create a discussion thread

**Last Updated**: 2026-01-05
**Version**: 1.0.0
