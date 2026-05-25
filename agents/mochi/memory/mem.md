# mem.md — Mochi's Long-Term Memory

> ความจำระยะยาวของ Mochi Project Manager
> ใช้เก็บ task history, user PM preferences, deadlines, team notes

---

## Decisions

### Decision: Priority system P0-P3
- Date: 2026-05-25
- Context: ต้องการระบบ priority ที่ชัดเจนสำหรับทุก task
- Decision: P0 (critical), P1 (high), P2 (medium), P3 (low)
- Reason: ทุกคนในทีมเข้าใจตรงกัน

### Decision: Agent assignment rules
- Date: 2026-05-25
- Context: ใครถนัดอะไร
- Decision: Fha→plan, Masa→logic, Eria→UI, Ney→implement
- Reason: แยกตามความถนัด, เพิ่ม productivity

## Preferences

- Status report: terminal-friendly table + emoji
- Task breakdown: ถ้า >1 day → ต้องมี subtask
- Communication: direct, ไม่ต้องเล่นการเมือง

## Known Issues

- Masa กับ Eria ยังใหม่ — SKILL.md เพิ่งสร้าง
- todoUpdate/tasks/ ยังไม่มี structure
- ต้องสร้าง task templates เพิ่ม

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| SKILL.md | Mochi's skill |
| memory/mem.md | ไฟล์นี้ |
| ../../../shared/memory/work.md | shared session memory |
| ../../../shared/memory/mem.md | shared long-term memory |
| ../../yui/SKILL.md | Yui orchestrator |
| ../../todoUpdate/README.md | multi-agent system |
