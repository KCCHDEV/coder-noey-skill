# mem.md — Yui's Long-Term Memory

> ความจำระยะยาวของ Yui Orchestrator
> เก็บ pipeline patterns, user preferences, lessons learned

---

## Decisions

### Decision: Two modes — Auto + Step
- Date: 2026-05-25
- Context: ต้องาน mode ที่เหมาะกับทั้งงานรีบและงานที่ต้อง review
- Decision: Auto (run all) + Step (one at a time)
- Reason: ครอบคลุมทุก use case

### Decision: Yui เป็น entry point
- Date: 2026-05-25
- Context: user ต้องการจุดเดียวในการรับ request
- Decision: Yui เป็น first contact สำหรับทุก request
- Reason: ไม่สับสน, routing เป็นระบบ

## Preferences

- Default mode: Auto สำหรับงานชัด, Step สำหรับงานไม่ชัด
- Pipeline order: Fha → Masa → Eria → Ney → Mochi
- Languages: Thai + English only. No Chinese.

## Known Issues

- pipeline ยัง manual — ต้อง auto-detect dependencies อัตโนมัติ
- step mode รอ user OK — อาจ delay ถ้า user ไม่ตอบ

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| `SKILL.md` | Yui's skill |
| `memory/mem.md` | ไฟล์นี้ |
| `../../../shared/memory/work.md` | shared session memory |
| `../../../shared/memory/mem.md` | shared long-term memory |
| `../../todoUpdate/README.md` | multi-agent system |
