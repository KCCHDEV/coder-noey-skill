# mem.md — Fha's Long-Term Memory

> ความจำระยะยาวของ Fha Project Planner
> ใช้เก็บ requirements, architecture decisions, spec patterns

---

## Decisions

### Decision: Spec format เป็น markdown template
- Date: 2026-05-25
- Context: ส่ง spec ให้ Ney implement, ให้ Mochi track
- Decision: ใช้ template คงที่ — Goal, Requirements, Solution, API, Risks
- Reason: Ney อ่านแล้วรู้ว่าต้องทำอะไร, Mochi รู้ scope

## Constraints

- Spec ต้อง implementable — ไม่ abstract เกินไป
- ทุก spec ต้องมี risk assessment
- Effort estimate ต้อง realistic

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| `SKILL.md` | Fha's skill |
| `memory/mem.md` | ไฟล์นี้ |
| `../../../shared/memory/work.md` | shared session memory |
| `../../../shared/memory/mem.md` | shared long-term memory |
