# NEY Coder AI — Deploy Startup

> ระบบถูก deploy เรียบร้อยแล้ว  
> อ่านไฟล์นี้ก่อนเริ่มใช้ OpenCode

---

## ═══ Team Overview ═══

```
  Agent     Role                  Skill File
  ─────────────────────────────────────────────────
  Yui       Orchestrator          skills/yui/SKILL.md
  Ney       DEV Implementer       skills/ney/SKILL.md
  Fha       Project Planner       skills/fha/SKILL.md
  Masa      Logic Designer        skills/masa/SKILL.md
  Eria      UI/UX Designer        skills/eria/SKILL.md
  Mochi     Project Manager       skills/mochi/SKILL.md
```

---

## ═══ Read Order (สำหรับ AI Agent) ═══

```txt
1. deploy/startup.md    ← ไฟล์นี้
2. startup.md           ← (ถ้ามีที่ root project)
3. work.md              ← session memory
4. memory/mem.md        ← long-term decisions
5. skills/<your>/SKILL.md ← อ่าน skill ของตัวเอง
```

---

## ═══ How To Use ═══

```bash
# เปิด OpenCode
opencode

# AI จะอ่าน startup.md → work.md → skills/ → เริ่มทำงาน
```

หรือ run health check:

```bash
# Windows
.\startup.ps1

# Linux / Mac
./setup.sh
```

---

## ═══ Installed Skills ═══

```
deploy/skills/
├── yui/SKILL.md       (or mini.md)
├── ney/SKILL.md
├── fha/SKILL.md
├── masa/SKILL.md
├── eria/SKILL.md
├── mochi/SKILL.md
└── shared/memory/
    ├── work.md
    ├── mem.md
    └── summary.md
```

---

## ═══ Communication Rules ═══

- Thai + English only — no Chinese
- Terminal-friendly output: tables + minimal emoji
- Auto-Invoke: agents call each other automatically
- Archive before deleting: never hard delete

---

^ Ready to work!
