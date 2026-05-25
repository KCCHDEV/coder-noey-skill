# mem.md — Long-Term Memory

> ระบบความจำระยะยาวของ Ney AI Project Builder Skill
> ใช้เก็บสิ่งที่ต้องจำข้าม session, ข้าม AI Agent, ข้าม platform
> อ่าน + เขียนโดย AI หรือมนุษย์ก็ได้
> Path: `shared/memory/mem.md`

---

## Project: Ney Coder AI Skill (skill_md)

### Decision: Skill เป็น subsection แทน monolithic
- **Date**: 2026-05-25
- **Context**: SKILL.md root ใหญ่ 2281+ บรรทัด, skill_md แยกมาเป็น subsystem
- **Decision**: แยก skill_md เป็น standalone skill มี mem.md + summary.md + SKILL.md ของตัวเอง
- **Reason**: ลด complexity, ทำให้ agent โหลดเฉพาะ skill ที่เกี่ยวข้อง
- **Alternatives**: เก็บทุกอย่างใน SKILL.md เดียว → ปฏิเสธเพราะใหญ่เกิน

### Decision: mem.md format เป็น markdown ที่มนุษย์+AI อ่านได้
- **Date**: 2026-05-25
- **Context**: ต้องการ portable memory ที่ย้ายไป AI ตัวอื่นได้
- **Decision**: ใช้ plain markdown ไม่มี syntax พิเศษ
- **Reason**: AI ทุกตัวอ่าน markdown ได้, ไม่ต้องมี parser พิเศษ
- **Consequences**: อาจกิน token มากกว่า binary format แต่ portable กว่า

### Decision: summary.md แยกจาก work.md
- **Date**: 2026-05-25
- **Context**: user ต้องการไฟล์สรุปที่แตกต่างจาก work.md
- **Decision**: summary.md ไว้สำหรับภาพรวมคงที่, work.md ไว้สำหรับ session ปัจจุบัน
- **Reason**: แยก concerns — summary = reference, work.md = active memory

### Decision: memory ทั้งหมดย้ายเข้า `memory/` folder
- **Date**: 2026-05-25
- **Context**: จัดกลุ่มไฟล์พวกเดียวกัน, root ไม่รก
- **Decision**: mem.md, work.md, summary.md อยู่ใต้ `shared/memory/`
- **Reason**: สะอาดกว่า, ย้าย AI ตัวอื่นง่ายกว่า

---

## Technical Constraints

- SKILL.md ต้องไม่เกิน ~3000 บรรทัด
- mem.md ควรไม่เกิน 200 บรรทัด
- summary.md ควรไม่เกิน 100 บรรทัด
- ใช้ markdown ล้วน — ไม่มี HTML, ไม่มี custom syntax
- ไฟล์ทุกไฟล์ commit ใน git

---

## Preferences

- ภาษา: Thai เป็นหลัก, English สำหรับ technical terms
- Response style: terminal-friendly, table, emoji sparingly
- Code safety: archive first, never hard delete
- UI direction: clean, cute, soft, rounded, pastel

---

## Known Issues

1. SKILL.md section numbering ไม่ linear แท้ — มี subsection แทรก
2. `agents/fha/SKILL.md` (Fha) ยัง skeleton — ต้องพัฒนา content ให้สมบูรณ์
3. `MCP/` และ `Multi_agent/` ยังมีแค่ keep.md — placeholder
4. ต้องรีวิว mem.md ทุกครั้งที่ context เต็ม หรือทุก 3 เดือน

---

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| `SKILL.md` | คำสั่งหลักของ Ney |
| `memory/mem.md` | ความจำระยะยาว (ไฟล์นี้) |
| `memory/summary.md` | ภาพรวมย่อ |
| `memory/work.md` | session memory |
| `../../agents/fha/SKILL.md` | Fha planning agent |
| `../../README.md` | ภาพรวมโปรเจกต์ |
