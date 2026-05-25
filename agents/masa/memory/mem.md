# mem.md — Masa's Long-Term Memory

> ความจำระยะยาวของ Masa Logic Designer
> ใช้เก็บ data flow decisions, logic patterns, และ technical constraints

---

## Decisions

### Decision: Logic design output เป็น markdown
- Date: 2026-05-25
- Context: ต้องการ format ที่ portability กับ AI ตัวอื่น
- Decision: ใช้ markdown diagrams (text-based) แทน image/tool-specific
- Reason: AI ทุกตัวอ่าน markdown ได้

## Constraints

- Logic design ต้อง readable โดยมนุษย์
- ใช้ data flow diagrams แบบ text (Mermaid หรือ markdown table)
- API design ตาม REST convention (REST.md หรือใน spec)

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| `SKILL.md` | Masa's skill |
| `memory/mem.md` | ไฟล์นี้ |
| `../../../shared/memory/work.md` | shared session memory |
| `../../../shared/memory/mem.md` | shared long-term memory |
