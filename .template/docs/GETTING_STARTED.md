# Getting Started with Tetroid Development

> **⚠️ CRITICAL**: This project uses **Godot 4.5+** exclusively.  
> All code must follow Godot 4.x syntax. See [Godot 4.x Best Practices](CODING_STANDARDS.md#-godot-4x-best-practices).

## 👋 Welcome!

This guide will help you get started with the Tetroid project, whether you're a new AI agent joining development or reviewing the project structure.

## 🎯 Quick Start (5 Minutes)

### Step 1: Understand the Project (2 min)
Read these in order:
1. **[Main README](../../README.md)** - Project overview
2. **[Code-Driven Development](CODE_DRIVEN_DEVELOPMENT.md)** - ⭐ Our approach
3. **[Game Design](GAME_DESIGN.md)** - What we're building

### Step 2: Know Your Role (1 min)
Review **[Agent Guidelines](AGENT_GUIDELINES.md)** and find your role:
- System Architect
- Gameplay Programmer
- Network Engineer
- AI Developer
- UI/UX Developer
- Graphics Programmer
- Audio Engineer
- Integration Specialist
- QA & Testing
- DevOps

### Step 3: Check Status (1 min)
Read **[Current State](CURRENT_STATE.md)** to see:
- What's been done
- What's in progress
- What's available to work on

### Step 4: Review Standards (1 min)
Skim **[Coding Standards](CODING_STANDARDS.md)** for:
- **Godot 4.x syntax requirements** ⚠️
- Naming conventions
- Code structure
- Testing requirements

## 📚 Essential Reading

### Must Read (Everyone)
1. **[Agent Guidelines](AGENT_GUIDELINES.md)** - How to collaborate ⭐
2. **[Current State](CURRENT_STATE.md)** - Project status ⭐
3. **[Coding Standards](CODING_STANDARDS.md)** - Code quality ⭐

### Role-Specific Reading

**System Architect**:
- [Architecture](ARCHITECTURE.md)
- [Decisions](DECISIONS.md)

**Gameplay Programmer**:
- [Game Design](GAME_DESIGN.md)
- [Architecture](ARCHITECTURE.md)

**Network Engineer**:
- [Networking](NETWORKING.md)
- [Architecture](ARCHITECTURE.md)

**AI Developer**:
- [AI System](AI_SYSTEM.md)
- [Game Design](GAME_DESIGN.md)

**UI/UX Developer**:
- [Art Guide](ART_GUIDE.md)
- [Game Design](GAME_DESIGN.md)

**Graphics Programmer**:
- [Art Guide](ART_GUIDE.md)
- [Architecture](ARCHITECTURE.md)

**Audio Engineer**:
- [Audio Guide](AUDIO_GUIDE.md)
- [Game Design](GAME_DESIGN.md)

**Integration Specialist**:
- [Steam Integration](STEAM_INTEGRATION.md)
- [Architecture](ARCHITECTURE.md)

**QA & Testing**:
- [Testing](TESTING.md) (to be created)
- [Coding Standards](CODING_STANDARDS.md)

**DevOps**:
- [Architecture](ARCHITECTURE.md)
- [Development Roadmap](../plans/DEVELOPMENT_ROADMAP.md)

## 🚀 Your First Task

### Before You Start
- [ ] Read your role's essential docs
- [ ] Check [Current State](CURRENT_STATE.md) for available tasks
- [ ] Understand current project phase
- [ ] Review recent changes in [Changelog](CHANGELOG.md)

### Starting Work

1. **Claim a Task**
   ```markdown
   Update CURRENT_STATE.md:
   
   ## Active Tasks
   
   ### [Your Role] - [Task Name]
   - **Started**: 2026-01-05 15:00 UTC
   - **Agent**: [Your Role]
   - **Estimated Completion**: [Time]
   - **Files Affected**: [List]
   ```

2. **Implement**
   - Follow coding standards
   - Write tests
   - Comment complex logic
   - Update documentation

3. **Complete**
   ```markdown
   Move task to Completed section:
   
   ## Completed Tasks
   
   ### [Task Name]
   - **Completed**: 2026-01-05 17:30 UTC
   - **Duration**: 2.5 hours
   - **Outcome**: [Brief description]
   - **Files Changed**: [List]
   ```

## 🔍 Common Questions

### "Where do I start coding?"
Check [Current State](CURRENT_STATE.md) → "Upcoming Work" section for prioritized tasks.

### "The engine isn't chosen yet?"
Correct! We're in template stage. First decision is choosing between Godot and Unity.

### "Can I work on something not listed?"
Yes, but:
1. Check if it's truly needed now
2. Discuss in [Decisions](DECISIONS.md)
3. Don't block other work
4. Document your reasoning

### "I found a mistake in the docs"
Excellent! Fix it immediately and note in [Changelog](CHANGELOG.md).

### "Two agents want the same task?"
1. Check timestamps in CURRENT_STATE.md
2. First to claim gets it
3. Use file locks for critical systems
4. Communicate via document updates

### "My task is blocked"
1. Log blocker in CURRENT_STATE.md
2. Work on different task
3. Help unblock if possible
4. Update status regularly

## 📝 Document Templates

### Quick Task Update
```markdown
## [Task Name]
- Status: [In Progress/Completed/Blocked]
- Agent: [Your Role]
- Progress: [X/Y subtasks]
- Notes: [Important info]
```

### Bug Report
```markdown
## Bug: [Title]
- **Severity**: [Critical/High/Medium/Low]
- **Found**: 2026-01-05
- **Found By**: [Agent]
- **Description**: [What's wrong]
- **Steps to Reproduce**: [How to trigger]
```

### Feature Proposal
```markdown
## Feature: [Title]
- **Proposed By**: [Agent]
- **Date**: 2026-01-05
- **Why**: [Justification]
- **How**: [Implementation idea]
- **Cost**: [Time estimate]
- **Priority**: [High/Medium/Low]
```

## 🎯 Current Phase: Foundation (Week 1-3)

### Priority Tasks
1. **Choose Engine** (Critical)
2. **Setup Project Structure** (High)
3. **Implement Game Loop** (High)
4. **Create Placeholder Assets** (Medium)

### What Not To Do Yet
- ❌ Don't implement complex features
- ❌ Don't optimize prematurely
- ❌ Don't polish visuals
- ❌ Don't add extra features

Focus on **getting basics working first**.

## 🛠️ Development Environment

### Required Tools
- Git (version control)
- Game engine (Godot/Unity - TBD)
- Code editor (VS Code recommended)
- Steam SDK (for testing)

### Recommended Tools
- Discord (community - TBD)
- Graphics editor (Aseprite for pixel art)
- Audio editor (Audacity/FL Studio)
- Profiler (engine-specific)

### Setup Steps (After Engine Choice)
```bash
# 1. Clone repository (when ready)
git clone [repo-url]

# 2. Install engine
# [Engine-specific instructions]

# 3. Open project
# [Engine-specific]

# 4. Run tests
# [Test command]

# 5. Run game
# [Run command]
```

## 📊 Progress Tracking

### Daily
- Update CURRENT_STATE.md with your progress
- Log any issues or blockers
- Mark completed tasks

### Weekly
- Review Development Roadmap
- Update Weekly Summary (to be created)
- Assess overall progress

### Monthly
- Major milestone reviews
- Roadmap adjustments
- Documentation updates

## 💡 Tips for Success

### Do's ✅
- Read documentation first
- Claim tasks before starting
- Update status frequently
- Write tests immediately
- Ask questions via documents
- Keep commits focused
- Comment complex code

### Don'ts ❌
- Don't skip reading docs
- Don't work in isolation
- Don't ignore standards
- Don't skip tests
- Don't commit broken code
- Don't add features randomly
- Don't forget to document

## 🎓 Learning Path

### Week 1: Understanding
- Read all essential docs
- Understand game concept
- Review architecture
- Familiarize with tools

### Week 2: Contributing
- Claim first task
- Make first commit
- Write first tests
- Update documentation

### Week 3: Collaborating
- Work with other agents
- Review code patterns
- Improve processes
- Share knowledge

## 🔗 Quick Links

### Documentation
- [README](../../README.md)
- [Architecture](ARCHITECTURE.md)
- [Game Design](GAME_DESIGN.md)
- [Current State](CURRENT_STATE.md)

### Guides
- [Agent Guidelines](AGENT_GUIDELINES.md)
- [Coding Standards](CODING_STANDARDS.md)
- [Art Guide](ART_GUIDE.md)
- [Audio Guide](AUDIO_GUIDE.md)

### Planning
- [Roadmap](../plans/DEVELOPMENT_ROADMAP.md)
- [Decisions](DECISIONS.md)
- [Changelog](CHANGELOG.md)

### Reference
- [FAQ](FAQ.md)
- [API Docs](API.md) (to be created)
- [Testing Guide](TESTING.md) (to be created)

## 📞 Need Help?

### Check These First
1. [FAQ](FAQ.md)
2. [Current State](CURRENT_STATE.md)
3. [Agent Guidelines](AGENT_GUIDELINES.md)
4. [Architecture](ARCHITECTURE.md)

### Still Stuck?
- Log question in CURRENT_STATE.md
- Check recent Decisions
- Review similar code
- Propose solution in docs

## 🎉 Ready to Begin!

You now have everything needed to start contributing to Tetroid!

**Next steps**:
1. Choose your role
2. Read role-specific docs
3. Check CURRENT_STATE.md
4. Claim a task
5. Start building!

Good luck! 🚀

---

**Last Updated**: 2026-01-05
**Version**: 1.0.0
