# mem.md — Eria's Long-Term Memory

> ความจำระยะยาวของ Eria UI/UX Designer
> ใช้เก็บ design decisions, color palette, component patterns

---

## Decisions

### Decision: Design output เป็น markdown + pseudo-code
- Date: 2026-05-25
- Context: ต้องการ design doc ที่ AI implementer (Ney) อ่านแล้วทำตามได้
- Decision: ใช้ markdown พร้อม component tree + props interface
- Reason: Ney อ่าน markdown แล้ว implement ได้ทันที

### Preference: Clean cute direction
- Date: 2026-05-25
- Context: Default design language
- Preference: rounded, pastel, soft shadow, mobile-first

## Constraints

- ออกแบบให้ implement ได้จริง — ไม่ over-design
- ต้องมีทุก state: loading, empty, error, success
- responsive mobile-first

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| `SKILL.md` | Eria's skill |
| `memory/mem.md` | ไฟล์นี้ |
| `../../../shared/memory/work.md` | shared session memory |
| `../../../shared/memory/mem.md` | shared long-term memory |
