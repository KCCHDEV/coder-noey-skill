# 🚀 NEY Coder Ai skill

> ระบบ Skill สำหรับ AI Coding Agent ระดับ Startup / Production  
> ออกแบบมาเพื่อ Codex, Claude Code, Cursor, OpenCode, Cline, Roo Code, Windsurf และ AI Agent รุ่นใหม่

---

# 🌌 NEY Coder Ai skill คืออะไร?

NEY Coder Ai skill คือระบบ Skill + Workflow สำหรับเปลี่ยน AI Coding Agent ให้กลายเป็น:

- AI Engineering Teammate
- Reflective Coding Agent
- Production-Aware AI
- Devin-style Workflow System
- Startup-grade Engineering Assistant

แทนที่ AI จะทำงานแบบ:

```txt
รับคำสั่ง → เขียนโค้ด
```

เนย จะทำงานแบบ:

```txt
อ่าน
→ วิเคราะห์
→ ตรวจสอบ assumption
→ คิดหลายแนวทาง
→ เถียงตัวเอง
→ ประเมินความเสี่ยง
→ วาง rollback
→ แล้วค่อย implement
```

---

# 🧠 แนวคิดหลักของระบบ

NEY Coder Ai skill ถูกออกแบบภายใต้แนวคิด:

> “Move fast carefully.”

หรือ:

```txt
เร็วได้
แต่ต้องไม่พัง production
```

AI จะถูกสอนให้:
- คิดก่อนแก้
- รักษา architecture เดิม
- ไม่ hallucinate
- ไม่ rewrite มั่ว
- ป้องกัน regression
- มี rollback plan
- ตรวจสอบตัวเองก่อน final

---

# ⚔️ จุดเด่นของ NEY Coder Ai skill

---

## 🧠 Reflective Reasoning System

AI จะ:
- คิดหลายแนวทาง
- วิเคราะห์ tradeoff
- จำลองความเสี่ยง
- ทำนาย failure
- challenge ความคิดตัวเองก่อนแก้

แทนที่จะรีบเขียนโค้ดทันที

---

## 🔥 Internal Debate Protocol

ก่อนแก้ระบบใหญ่ AI จะ:

1. สร้างหลาย approach
2. เปรียบเทียบข้อดีข้อเสีย
3. วิเคราะห์ rollback difficulty
4. ประเมินความเสี่ยง
5. เลือกทางที่ปลอดภัยที่สุด

ตัวอย่าง:

```txt
Approach A:
rewrite ทั้ง component

Approach B:
patch เฉพาะ logic

Result:
เลือก B เพราะปลอดภัยกว่า
และ user ไม่ได้ขอ rewrite
```

---

## 🛡️ Anti-Hallucination System

ป้องกัน AI มั่ว

AI ห้ามเดา:
- route
- API
- package
- database field
- env variable
- architecture

ก่อนใช้งานต้อง inspect จริงก่อนเสมอ

---

## 🚑 Root Cause Engineering

NEY OS ไม่ให้ AI patch แค่อาการ

แต่ต้องหา:
- root cause
- trigger condition
- propagation path
- hidden dependency

เพื่อแก้ “ต้นเหตุจริง”

---

## ⚡ Risk Classification System

ระบบแบ่งระดับความเสี่ยง:

| ระดับ | ตัวอย่าง |
|---|---|
| Low | docs, styling |
| Medium | API, hooks |
| High | auth, database, payments |

ถ้าเป็น High Risk:
- AI ต้องช้าลง
- inspect มากขึ้น
- archive ก่อนแก้
- วาง rollback plan
- test มากขึ้น

---

## 🗂️ work.md Memory System

ระบบ memory สำหรับ AI

ช่วยให้:
- ทำงานต่อได้แม้ context หลุด
- AI หลายตัวทำงานต่อกันได้
- ลด token
- จำ architecture/project state ได้

เหมาะมากกับ:
- โปรเจกต์ยาว
- startup
- autonomous workflow
- multi-session development

---

## 🔄 Archive-First Workflow

ห้ามลบโค้ดสำคัญทันที

ก่อน replace:
1. archive ของเดิม
2. log การเปลี่ยน
3. เก็บ rollback path
4. verify recovery

---

## 🛰️ Production Safety System

NEY OS ถูกออกแบบสำหรับ production จริง

ระบบจะป้องกัน:
- destructive DB commands
- blind infrastructure rewrites
- secret leakage
- unsafe migrations
- massive regressions

---

# 🚀 รองรับ AI Agent อะไรบ้าง?

ใช้ได้กับ:

- Codex
- Claude Code
- Cursor
- OpenCode
- Cline
- Roo Code
- Windsurf
- Gemini CLI
- AI Coding Agent อื่น ๆ

---

# 📦 วิธีติดตั้ง

---

## Codex

```txt
.agents/
  skills/
    ney-os-ultra/
      SKILL.md
```

---

## Claude Code

```txt
CLAUDE.md
```

หรือ:

```txt
SKILL.md
```

---

## Cursor

```txt
.cursor/rules/ney-os-ultra.mdc
```

---

## Cline / Roo Code

```txt
.clinerules
.roorules
```

---

# 🧬 Recommended Project Structure

```txt
project/
├── SKILL.md
├── work.md
├── archive/
│   └── ARCHIVE_LOG.md
├── docs/
│   ├── PROJECT_CONTEXT.md
│   ├── API.md
│   └── DECISIONS.md
```

---

# ⚙️ Execution Modes

NEY OS มีหลายโหมดการทำงาน

| Mode | ใช้เมื่อ |
|---|---|
| Fast Mode | แก้เร็ว |
| Careful Mode | งาน shared logic |
| Architect Mode | ระบบใหญ่ |
| Recovery Mode | production พัง |
| Debug Mode | bug ซับซ้อน |

---

# 🧠 ตัวอย่าง Workflow

```txt
1. อ่าน task
2. inspect architecture
3. verify assumptions
4. generate approaches
5. debate tradeoffs
6. simulate failures
7. choose safest solution
8. implement incrementally
9. verify impact
10. re-review changes
11. final summary
```

---

# 🔥 ทำไม NEY OS ต่างจาก Prompt ทั่วไป?

Prompt ทั่วไป:
- เน้น generate code เร็ว

NEY OS:
- เน้น engineering quality
- เน้น production safety
- เน้น reasoning
- เน้น architecture preservation
- เน้น rollback
- เน้น autonomous workflow

---

# 🌌 แรงบันดาลใจ

ระบบนี้ได้รับแรงบันดาลใจจาก:
- Devin-style workflow
- Reflective reasoning systems
- Startup engineering culture
- SWE-agent concepts
- Autonomous coding workflows
- Production-safe deployment practices

---

# 📈 วิสัยทัศน์ระยะยาว

NEY OS มีเป้าหมายเป็น:

> “AI Engineering Operating System”

Framework สำหรับ AI ที่สามารถ:
- ดูแลโปรเจกต์ใหญ่
- คิดแบบ senior engineer
- รักษา architecture
- recover ระบบได้
- ทำงานหลาย session ต่อเนื่อง
- ทำงานแบบ teammate จริง

---

# 🧠 Philosophy

```txt
Think before editing.
Debate before rewriting.
Verify before trusting.
Protect production first.
Move fast carefully.
```

---

# ⭐ เหมาะกับใคร?

เหมาะสำหรับ:
- startup
- AI-native development
- autonomous coding workflow
- โปรเจกต์ production
- ทีมที่ใช้ AI coding agent จริงจัง
- long-term engineering systems

---

# 📄 License

MIT License

---

# 🚀 NEY Coder Ai skill

Reflective AI Engineering สำหรับ AI Coding Agent ยุคใหม่

---

## 📦 Cross-Platform Setup

### Windows (PowerShell 5.1+)

```powershell
.\setup.ps1
```

หรือ setup เฉพาะ OpenCode config:

```powershell
.\opencode.ps1
```

### Linux / macOS / Windows (Git Bash / WSL)

```bash
chmod +x setup.sh
./setup.sh
```

### Manual: .opencode/skills/

```txt
.opencode/
└── skills/
    ├── yui/SKILL.md
    ├── ney/SKILL.md
    ├── fha/SKILL.md
    ├── masa/SKILL.md
    ├── eria/SKILL.md
    ├── mochi/SKILL.md
    └── shared/memory/
```

รัน `setup.sh` หรือ `setup.ps1` เพื่อ auto-install

### Variants

เลือกขนาด skill:

| Mode | ขนาด | เหมาะกับ |
|---|---|---|
| **Full** | ~200-500 lines | Production, real project |
| **Mini** | ~20-40 lines | Quick test, small project |

### Select Specific Agents

```bash
# Only install specific agents
./setup.sh         # interactive selection
./init-project.sh --agents ney,eria,mochi  # only these 3
```

### Auto-Download

ไม่ต้อง clone repo ก็ใช้ได้ — script จะ auto-download จาก GitHub:

```bash
# ใช้ standalone (ไม่มี repo)
curl -sL https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main/setup.sh | bash
```

### Requirements

| Platform | Requirement |
|---|---|
| Windows | PowerShell 5.1+ (built-in) |
| macOS | Bash (built-in) |
| Linux | Bash (built-in) |
| OpenCode | `opencode` CLI installed |

---

## 🏗️ Init New Project

สร้างโปรเจกต์ใหม่พร้อมระบบ NEY Agent:

```bash
# Linux / macOS / Git Bash
./init-project.sh --name "my-project" ../my-project

# Windows PowerShell
.\init-project.ps1 -Name "my-project" -Dir ..\my-project
```

หรือใช้ current directory:

```bash
./init-project.sh
```

### Options

| Flag | Description |
|---|---|
| `--name` / `-Name` | Project name (default: directory name) |
| `--no-git` / `-NoGit` | Skip git init |
| `--copy` / `-Copy` | Copy files instead of symlink |
| `--help` | Show help |

### What it creates

```
my-project/
├── work.md              # session memory
├── AGENTS.md            # agent instructions
├── memory/
│   ├── mem.md           # long-term memory
│   └── summary.md       # project overview
├── archive/
│   └── ARCHIVE_LOG.md   # archive log
├── docs/
│   ├── plans/           # Fha's specs
│   └── designs/         # Masa + Eria designs
└── .opencode/
    ├── opencode.json    # config
    └── skills/          # agent skills (symlink/copy)
```
