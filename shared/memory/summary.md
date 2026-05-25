# Summary — Ney AI Project Builder

> ภาพรวมย่อของระบบ Multi-Agent
> Path: `shared/memory/summary.md`

---

## File Structure

```
agents/
├── ney/          SKILL.md        -> DEV Implementer
├── fha/          SKILL.md        -> Project Planner
├── masa/         SKILL.md        -> Logic Designer
├── eria/         SKILL.md        -> UI/UX Designer
├── yui/          SKILL.md        -> Orchestrator (entry point)
├── mochi/        SKILL.md        -> Project Manager
shared/memory/    work.md + mem.md + summary.md
todoUpdate/       task tracking
```

## Agent Roster

| Agent | Role | Entry | Auto/Step |
|---|---|---|---|
| Yui | Orchestrator | **First contact** | Both modes |
| Ney | DEV Implementer | Via Yui | - |
| Fha | Planner | Via Yui | - |
| Masa | Logic Designer | Via Yui | - |
| Eria | UI Designer | Via Yui | - |
| Mochi | PM | Via Yui | - |

## Core Rules

1. **Archive first** — never hard delete
2. **work.md + mem.md** — always maintain
3. **Auto-Invoke** — agents call each other automatically
4. **No Chinese** — Thai + English only

## Communication

- Thai first, English terms where useful
- Terminal-friendly tables + minimal emoji
