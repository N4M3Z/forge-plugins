---
name: SocialFiling
version: 0.1.0
description: "ČSSZ social security filing — generate and correct Přehled OSVČ for social insurance. USE WHEN ČSSZ, social security, přehled OSVČ, social insurance, důchodové pojištění, OSSZ."
---

Generate or correct the ČSSZ `Přehled o příjmech a výdajích OSVČ` (social security overview) derived from DPFO data.

## Context

Every self-employed person (`OSVČ`) must file a `Přehled` with their local OSSZ (district social security administration) after filing DPFO. When the DPFO is corrected (`opravné`/`dodatečné`), the `Přehled` must be updated within **8 days** of the correction filing ([zákon 589/1992 Sb.][1]).

## Input

Requires from the DPFO (provided by TaxReturn or TaxFiling):
- §7 tax base (`základ daně z příjmů ze samostatné činnosti`)
- Number of months of self-employment activity
- Whether self-employment is the primary (`hlavní`) or secondary (`vedlejší`) activity

## Instructions

### 1. Parse existing filing

If a ČSSZ XML exists (e.g., `CSSZ-2025.xml`), parse it and extract:
- Declared §7 income (`pri` attribute in `pvv` element)
- Months of activity (`mesv` element)
- Advance payments (`zal` element)
- Activity type (`hlavc`/`vedc` elements)

### 2. Compute updated values

From the corrected DPFO §7 base:
- `vyměřovací základ` = 50% of §7 tax base (2025 rate, [§5b][2])
- Annual social insurance = `vyměřovací základ` × 29.2% ([§7(1a)][3])
- Monthly advance = annual ÷ 12, rounded up to whole CZK
- Minimum `vyměřovací základ` for `hlavní` activity: check against the annual minimum ([§5b(3)][2])

### 3. Diff against prior filing

Present changes:

```markdown
| Field                    | Filed    | Corrected | Delta    |
| ------------------------ | -------- | --------- | -------- |
| §7 tax base              | X CZK    | Y CZK     | +Z CZK  |
| Vyměřovací základ (50%)  | A CZK    | B CZK     | +C CZK  |
| Annual insurance (29.2%) | D CZK    | E CZK     | +F CZK  |
| Monthly advance          | G CZK    | H CZK     | +I CZK  |
```

### 4. Submission

File via [ePortál ČSSZ][4] or deliver to the local OSSZ. Deadline: 8 days after corrected DPFO submission for corrections, or one month after the DPFO filing deadline for regular filings.

## Constraints

- Always present the diff for user confirmation before generating output
- Flag if the correction changes activity type (hlavní ↔ vedlejší)
- Flag if the corrected advance payment differs from what's currently being paid

[1]: https://www.zakonyprolidi.cz/cs/1992-589
[2]: https://www.zakonyprolidi.cz/cs/1992-589#p5b
[3]: https://www.zakonyprolidi.cz/cs/1992-589#p7
[4]: https://eportal.cssz.cz/
