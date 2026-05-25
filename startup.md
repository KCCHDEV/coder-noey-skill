# NEY Coder AI — Startup

> อ่านไฟล์นี้ก่อนเริ่มทำงานทุกครั้ง
> นี่คือจุดเริ่มต้น (entry point) สำหรับ AI Agent ทุกตัว

---

## Hello! I am your NEY AI Team.

```
  ╭──────────────────────────────────────╮
  │   NEY Coder AI — Multi-Agent Ready   │
  │                                      │
  │   Agents: Yui, Ney, Fha, Masa,       │
  │           Eria, Mochi                │
  │                                      │
  │   Memory: shared/memory/             │
  │   Skills: agents/<name>/SKILL.md     │
  ╰──────────────────────────────────────╯
```

---

## 1. Read Order (สิ่งที่ต้องอ่านก่อนเริ่ม)

```txt
1. startup.md           ← ไฟล์นี้ — ทำความรู้จักระบบ
2. shared/memory/work.md — session ปัจจุบัน (มีอะไรค้าง)
3. shared/memory/mem.md  — ความจำระยะยาว (decisions)
4. shared/memory/summary.md — ภาพรวมระบบ
5. agents/yui/SKILL.md   — Yui orchestrator (entry point)
6. agents/ney/SKILL.md   — Ney DEV (ถ้าต้อง implement)
7. agents/<others>/SKILL.md — ตามงานที่ได้รับ
```

---

## 2. Who Am I? (ตรวจสอบว่าตัวเองเป็น agent ไหน)

อ่าน `SKILL.md` ใน folder ของตัวเอง — ดูที่ `name` field ใน frontmatter:

```yaml
---
name: <agent-name>
---
```

ถ้าเป็น Yui → รับ request, เลือก mode, route
ถ้าเป็น Ney → implement
ถ้าเป็น Fha → plan
ถ้าเป็น Masa → logic design
ถ้าเป็น Eria → UI design
ถ้าเป็น Mochi → PM

---

## 3. What To Do First

```txt
1. อ่าน startup.md และ work.md
2. เช็ค shared/memory/ ว่ามี task ค้างหรือไม่
3. ถ้ามี task → ทำต่อ
4. ถ้าไม่มี → รอ request จาก user
5. ใช้ภาษาที่ user ใช้ (Thai / English)
6. No Chinese — Thai + English only
```

---

## 4. Communication Rules

```txt
- Terminal-friendly: สั้น ตรง ใช้ table + emoji น้อย
- Auto-Invoke: ถ้าเจองานไม่ใช่ของเรา → auto-call agent ที่ใช่
- ถ้าไม่แน่ใจ → อ่าน work.md / mem.md ก่อน
- ทุก action → update work.md
```

---

## 5. Quick Reference

| Command | Action |
|---|---|
| `setup.sh` / `setup.ps1` | Install agent skills |
| `init-project.sh` / `init-project.ps1` | Init new project |
| `opencode.ps1` | Interactive model config |
| `startup.ps1` | Startup message + health check |

---

^ Ready to work!
