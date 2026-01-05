# Multi-Agent Collaboration Guidelines

## 🤝 Purpose

This document establishes protocols for multiple AI agents to work together effectively on the Tetroid project. Follow these guidelines to ensure smooth collaboration, prevent conflicts, and maintain code quality.

## 🎭 Agent Roles & Responsibilities

### 1. **System Architect Agent**
**Focus**: High-level system design, performance optimization

**Responsibilities**:
- Design overall architecture
- Optimize performance bottlenecks
- Review technical decisions
- Maintain system integrity
- Database schema design

**Files to Update**:
- `/docs/ARCHITECTURE.md`
- `/docs/PERFORMANCE.md`
- `/docs/TECHNICAL_DECISIONS.md`

**Before Working**:
- Check if other agents are modifying core systems
- Review recent architectural changes
- Validate impact on existing systems

### 2. **Gameplay Programmer Agent**
**Focus**: Core game mechanics, rules, balance

**Responsibilities**:
- Implement game rules
- Block ability system
- Ball physics
- Paddle mechanics
- HP system
- Balance adjustments

**Files to Update**:
- `/src/gameplay/*`
- `/docs/GAME_DESIGN.md`
- `/docs/BALANCE.md`

**Before Working**:
- Check gameplay mechanics dependencies
- Verify network replication impact
- Test balance changes

### 3. **Network Engineer Agent**
**Focus**: Multiplayer, netcode, synchronization

**Responsibilities**:
- Client-server communication
- Lag compensation
- State synchronization
- Anti-cheat validation
- Room/lobby system

**Files to Update**:
- `/src/multiplayer/*`
- `/docs/NETWORKING.md`
- `/docs/PROTOCOL.md`

**Before Working**:
- Coordinate with Gameplay for state sync
- Check security implications
- Test with various latencies

### 4. **AI Developer Agent**
**Focus**: AI opponents, bot behavior

**Responsibilities**:
- Bot decision making
- Difficulty scaling
- Behavior trees
- Learning systems
- AI testing

**Files to Update**:
- `/src/ai/*`
- `/docs/AI_SYSTEM.md`
- `/docs/AI_TESTING.md`

**Before Working**:
- Ensure game rules are stable
- Check performance impact
- Validate difficulty progression

### 5. **UI/UX Developer Agent**
**Focus**: User interface, menus, feedback

**Responsibilities**:
- Menu systems
- HUD design
- Visual feedback
- Accessibility
- Responsive design

**Files to Update**:
- `/src/ui/*`
- `/docs/UI_DESIGN.md`
- `/docs/UX_PATTERNS.md`

**Before Working**:
- Check game state integration
- Verify input handling
- Test on different resolutions

### 6. **Graphics Programmer Agent**
**Focus**: Rendering, VFX, animations

**Responsibilities**:
- Sprite rendering
- Particle systems
- Animation system
- Shaders/effects
- Performance optimization

**Files to Update**:
- `/src/rendering/*`
- `/src/vfx/*`
- `/docs/GRAPHICS.md`

**Before Working**:
- Check GPU compatibility
- Profile performance
- Coordinate with UI agent

### 7. **Audio Engineer Agent**
**Focus**: Sound effects, music, audio systems

**Responsibilities**:
- Audio engine integration
- Sound effect implementation
- Music system
- Spatial audio
- Audio mixing

**Files to Update**:
- `/src/audio/*`
- `/docs/AUDIO_GUIDE.md`
- `/assets/audio/*`

**Before Working**:
- Check audio trigger points
- Verify audio pooling
- Test mixing levels

### 8. **Integration Specialist Agent**
**Focus**: Steam, platforms, services

**Responsibilities**:
- Steam API integration
- Achievements
- Leaderboards
- Cloud saves
- Platform-specific features

**Files to Update**:
- `/src/steam/*`
- `/src/platform/*`
- `/docs/STEAM_INTEGRATION.md`

**Before Working**:
- Check Steam SDK version
- Verify achievements list
- Test authentication flow

### 9. **QA & Testing Agent**
**Focus**: Testing, bug finding, quality assurance

**Responsibilities**:
- Write unit tests
- Integration tests
- Load testing
- Bug reporting
- Test automation

**Files to Update**:
- `/tests/*`
- `/docs/TESTING.md`
- `/docs/BUGS.md`

**Before Working**:
- Review recent changes
- Check test coverage
- Identify untested areas

### 10. **DevOps Agent**
**Focus**: Build systems, deployment, infrastructure

**Responsibilities**:
- CI/CD pipeline
- Build scripts
- Deployment automation
- Monitoring setup
- Server infrastructure

**Files to Update**:
- `/.github/workflows/*`
- `/tools/build/*`
- `/docs/DEPLOYMENT.md`

**Before Working**:
- Check build dependencies
- Verify deployment targets
- Test rollback procedures

## 📋 Workflow Protocol

### Step 1: Check Current State

**ALWAYS start by reading**:
```bash
/docs/CURRENT_STATE.md
```

This file contains:
- Active tasks and who's working on them
- Recent changes
- Known issues
- Blocked dependencies

### Step 2: Claim Your Task

**Update CURRENT_STATE.md**:
```markdown
## Active Tasks

### [Agent Role] - [Your Task Name]
- **Started**: 2026-01-05 14:30 UTC
- **Estimated Completion**: 2 hours
- **Dependencies**: None / [List dependencies]
- **Status**: In Progress
- **Files Affected**: [List main files]
```

### Step 3: Implement Changes

**Follow these rules**:
1. Stick to your role's responsibilities
2. Use coding standards from `/docs/CODING_STANDARDS.md`
3. Write tests for new functionality
4. Update relevant documentation
5. Add comments for complex logic

### Step 4: Self-Review

**Before considering work complete**:
- [ ] Code follows coding standards
- [ ] Tests written and passing
- [ ] No new linter errors
- [ ] Documentation updated
- [ ] No merge conflicts
- [ ] Performance acceptable
- [ ] Security considered

### Step 5: Update Documentation

**Update these files**:
1. `/docs/CURRENT_STATE.md` - Mark task complete
2. `/docs/CHANGELOG.md` - Add entry
3. `/docs/DECISIONS.md` - If you made design choices
4. Relevant technical docs - Keep them current

### Step 6: Log Completion

```markdown
## Completed Tasks

### [Agent Role] - [Task Name]
- **Completed**: 2026-01-05 16:45 UTC
- **Duration**: 2.25 hours
- **Outcome**: [Brief description]
- **Files Changed**: [List]
- **Tests Added**: [Count]
- **Issues Found**: [Any problems discovered]
- **Notes**: [Important information for other agents]
```

## 🚫 Conflict Prevention

### File Locking Protocol

**When modifying core systems**:

1. Check `/docs/CURRENT_STATE.md` for locks
2. Add a lock entry if modifying:
   - Core game engine files
   - Network protocol
   - Database schema
   - Build configuration
   - Shared constants

**Lock Format**:
```markdown
## File Locks

### src/core/game_state.py
- **Locked By**: Gameplay Programmer Agent
- **Reason**: Implementing HP system
- **ETA**: 30 minutes
- **Priority**: High
```

### Merge Conflict Resolution

**If you encounter conflicts**:

1. **STOP** - Don't force your changes
2. Read the conflicting code carefully
3. Check `/docs/CURRENT_STATE.md` for context
4. If recent (< 5 minutes), wait for agent to finish
5. If needed, coordinate:
   - Update CURRENT_STATE with conflict note
   - Propose merge strategy
   - Get consensus before proceeding

### Communication Log

**For complex decisions**:

Use `/docs/DECISIONS.md`:
```markdown
## Decision: [Title]
**Date**: 2026-01-05
**Agents Involved**: [Roles]
**Context**: [Why this decision was needed]
**Options Considered**:
1. Option A - [Pros/Cons]
2. Option B - [Pros/Cons]
**Decision**: [Chosen option]
**Rationale**: [Why]
**Implementation**: [How]
**Reviewers**: [Who should verify]
```

## 🔄 Dependency Management

### Before Starting Work

**Check dependencies**:
```python
# Example: Check if dependent system is ready
dependencies = {
    "gameplay_rules": "stable",     # ✓ Ready
    "network_sync": "in_progress",  # ⚠ Wait
    "ui_framework": "not_started"   # ❌ Blocked
}
```

### Dependency States

- **stable**: Safe to use, won't change
- **in_progress**: Being modified, wait or coordinate
- **not_started**: Doesn't exist yet
- **deprecated**: Being removed, don't use
- **breaking_changes**: API changing, update your code

### Managing Your Dependencies

**When you change APIs**:

1. Update `/docs/API.md` with changes
2. Mark old API as deprecated
3. Provide migration guide
4. Update `/docs/BREAKING_CHANGES.md`
5. Notify dependent systems

**Format**:
```markdown
## Breaking Change: Function Renamed

**Date**: 2026-01-05
**Affected**: All agents using `get_block_at(x, y)`
**Change**: Renamed to `get_block_at_position(position: Vector2)`
**Migration**:
```python
# Old
block = get_block_at(5, 10)

# New
block = get_block_at_position(Vector2(5, 10))
```
**Reason**: Consistency with codebase standards
**Deadline**: Migrate by 2026-01-10
```

## 📊 Progress Tracking

### Daily Summary

Each agent should update `/docs/DAILY_LOG.md`:

```markdown
## 2026-01-05

### Gameplay Programmer Agent
**Time Spent**: 4 hours
**Completed**:
- Implemented I-piece laser ability
- Fixed paddle collision bug
- Balanced T-piece shield duration

**In Progress**:
- Ball physics refinement

**Blocked**:
- Need network sync for abilities (waiting on Network Engineer)

**Notes**:
- Found edge case in block placement, logged in BUGS.md
```

### Weekly Review

Every 7 days, update `/docs/WEEKLY_SUMMARY.md`:

- Overall progress percentage
- Major milestones reached
- Blockers and solutions
- Team velocity
- Next week's priorities

## 🧪 Testing Protocol

### Test Before Committing

**Minimum requirements**:
```bash
# 1. Run unit tests
npm test / pytest / etc.

# 2. Run integration tests
npm run test:integration

# 3. Check for errors
npm run lint

# 4. Manual smoke test
# - Start game
# - Test your feature
# - Check for obvious breaks
```

### Test Coverage Goals

- **Core Gameplay**: 90%+ coverage
- **Networking**: 85%+ coverage
- **UI**: 70%+ coverage
- **Utilities**: 95%+ coverage

### Writing Tests

**Test file structure**:
```
tests/
├── unit/              # Individual function tests
├── integration/       # Multi-system tests
├── performance/       # Benchmark tests
└── e2e/              # Full gameplay tests
```

**Naming convention**:
```python
# test_[system]_[feature].py
test_gameplay_block_placement.py
test_network_state_sync.py
test_ui_menu_navigation.py
```

## 🎨 Asset Management

### When Creating Assets

**Follow the guidelines**:
1. Read `/docs/ART_GUIDE.md` for pixel art standards
2. Read `/docs/AUDIO_GUIDE.md` for audio specs
3. Use placeholders first, polish later
4. Name files descriptively

**File naming**:
```
assets/
├── sprites/
│   ├── blocks/
│   │   ├── i_piece_idle.png
│   │   ├── i_piece_hit.png
│   │   └── i_piece_destroyed.png
│   └── ui/
│       ├── button_normal.png
│       └── button_hover.png
└── audio/
    ├── sfx/
    │   ├── block_place.wav
    │   └── ball_hit_paddle.wav
    └── music/
        └── gameplay_theme.ogg
```

### Asset Optimization

**Before adding assets**:
- Compress images (use PNG-8 when possible)
- Optimize audio (OGG for music, WAV for SFX)
- Check file size (keep under 1MB per asset)
- Test in-game performance

## 🔐 Security Guidelines

### Never Commit

- API keys
- Passwords
- Steam API secrets
- Database credentials
- Personal information

**Use environment variables**:
```python
# ❌ Bad
STEAM_API_KEY = "ABCD1234..."

# ✓ Good
STEAM_API_KEY = os.getenv("STEAM_API_KEY")
```

### Input Validation

**Always validate**:
- User input
- Network messages
- File uploads
- Configuration data

**Server is authority**:
- Validate on server, not just client
- Never trust client data
- Double-check critical operations

## 📈 Performance Guidelines

### Performance Budgets

**Per Frame (60 FPS = 16.67ms)**:
- Gameplay logic: 5ms
- Physics: 3ms
- Rendering: 6ms
- Network: 1ms
- Audio: 0.5ms
- Buffer: 1.17ms

**Memory**:
- Max RAM: 512 MB
- GPU VRAM: 256 MB
- Asset streaming preferred

### Optimization Priorities

1. **Measure First**: Profile before optimizing
2. **Algorithm > Micro-optimization**: Big O matters most
3. **Batch Operations**: Group similar work
4. **Cache Wisely**: Don't over-cache
5. **Async I/O**: Never block game loop

## 🐛 Bug Reporting

### When You Find a Bug

**Immediately log in** `/docs/BUGS.md`:

```markdown
## Bug #42: Ball passes through paddle

**Severity**: High
**Found By**: Gameplay Programmer Agent
**Date**: 2026-01-05
**Reproducible**: Yes

**Steps to Reproduce**:
1. Start 1v1 match
2. Paddle at X=300
3. Ball approaches at 800 px/s
4. Ball phases through

**Expected**: Ball bounces
**Actual**: Ball passes through

**Investigation**:
- Collision detection timing issue
- Happens at high speeds only
- Delta time calculation suspect

**Workaround**: Limit max ball speed to 600 px/s

**Assigned To**: Gameplay Programmer Agent
**Priority**: Fix before next release
```

### Bug Severity Levels

- **Critical**: Game crashes, data loss
- **High**: Major feature broken
- **Medium**: Minor feature broken, workaround exists
- **Low**: Visual glitch, typo
- **Enhancement**: Not a bug, future improvement

## 🎯 Code Review Protocol

### Self-Review Checklist

Before marking work complete:

- [ ] Code is readable and commented
- [ ] Follows project style guide
- [ ] No hardcoded values (use constants)
- [ ] Error handling present
- [ ] Edge cases considered
- [ ] Performance acceptable
- [ ] Memory leaks checked
- [ ] Tests written
- [ ] Documentation updated

### Peer Review (Optional)

**When to request review**:
- Major architectural changes
- Security-critical code
- Performance-sensitive sections
- Complex algorithms
- Public API changes

**Review format** in `/docs/REVIEWS.md`:
```markdown
## Review Request: Network Protocol v2

**Submitted By**: Network Engineer Agent
**Date**: 2026-01-05
**Files**: src/multiplayer/protocol.py
**Description**: Complete rewrite of network protocol

**Requested Reviewers**:
- System Architect Agent (architecture)
- Security Specialist (security)

**Questions**:
1. Is the message format efficient?
2. Any security vulnerabilities?
3. Performance implications?

**Status**: Pending Review
```

## 📚 Documentation Standards

### Keep Documentation Updated

**When to update docs**:
- New feature added → Update feature docs
- API changed → Update API.md
- Bug fixed → Update CHANGELOG.md
- Design decision → Update DECISIONS.md
- Config changed → Update README.md

### Documentation Quality

**Good documentation**:
- Clear and concise
- Includes examples
- Explains "why" not just "what"
- Updated regularly
- Easy to find

**Bad documentation**:
- Outdated information
- No examples
- Too verbose or too sparse
- Buried in obscure files

## 🚀 Release Protocol

### Pre-Release Checklist

Before any release:

1. All tests passing
2. No critical bugs
3. Performance benchmarks met
4. Documentation updated
5. CHANGELOG.md updated
6. Version number bumped
7. Steam build tested

### Version Numbering

**Semantic Versioning**: MAJOR.MINOR.PATCH

- **MAJOR**: Breaking changes (1.0.0 → 2.0.0)
- **MINOR**: New features (1.0.0 → 1.1.0)
- **PATCH**: Bug fixes (1.0.0 → 1.0.1)

## 💡 Best Practices

### Do's ✅

- Communicate changes clearly
- Test your code thoroughly
- Write meaningful commit messages
- Keep functions small and focused
- Use descriptive variable names
- Comment complex logic
- Handle errors gracefully
- Optimize after measuring
- Reuse existing code
- Ask when uncertain

### Don'ts ❌

- Don't break working code
- Don't commit broken code
- Don't skip tests
- Don't ignore warnings
- Don't hardcode values
- Don't leave TODO comments unfixed
- Don't optimize prematurely
- Don't duplicate code
- Don't ignore dependencies
- Don't work in isolation

## 🎓 Learning Resources

### For New Agents

**Start here**:
1. `/docs/README.md` - Project overview
2. `/docs/ARCHITECTURE.md` - System design
3. `/docs/GAME_DESIGN.md` - Game mechanics
4. `/docs/CODING_STANDARDS.md` - Code style
5. This file - Collaboration rules

### Reference Materials

- `/docs/API.md` - API documentation
- `/docs/EXAMPLES.md` - Code examples
- `/docs/GLOSSARY.md` - Term definitions
- `/docs/FAQ.md` - Common questions

## 📞 Getting Help

### When Stuck

1. Check documentation first
2. Review existing code
3. Check CURRENT_STATE.md for context
4. Look for similar implementations
5. Create a note in BLOCKERS.md

**Blocker format**:
```markdown
## Blocker: Unsure how to implement feature X

**Blocked Agent**: UI Developer Agent
**Date**: 2026-01-05
**Context**: Need to sync UI with gameplay state
**Question**: What's the proper way to subscribe to game events?
**Attempted**: Looked at docs, found partial info
**Need**: Clear example or pattern to follow
**Urgency**: Medium - can work on other tasks meanwhile
```

---

**Last Updated**: 2026-01-05
**Status**: Complete Guidelines
**Version**: 1.0.0
