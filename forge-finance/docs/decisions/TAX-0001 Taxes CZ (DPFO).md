---
status: Accepted
date: 2026-03-25
---

# Knowledge-First Approach for Czech Personal Income Tax

## Context

Czech personal income tax (DPFO / daňové přiznání fyzických osob) requires annual filing with income from multiple sources, eligible deductions, and supporting documentation. The forge-finance module supports the full lifecycle: gathering documents, understanding tax law, validating data, and preparing the return.

Tax projects use the vault's project note system, named by **tax year** (not filing year).

## Decision

Build Czech tax law rules comprehensively first, then layer workflow skills on top. Rules are reusable across tax years and filing cycles. The upfront investment in knowledge makes every skill and agent more capable from day one.

## Architecture

```text
forge-finance/
    rules/
        CurrencyFormatting.md          # existing
        PersonalTaxIncome.md           # income categories (§6-§10, zákon 586/1992 Sb.)
        PersonalTaxDeductions.md       # nezdanitelné části základu daně (§15)
        PersonalTaxDeadlines.md        # filing deadlines, correction procedures, penalties
        DipPension.md                  # DIP + penzijní spoření specifics
        MortgageInterest.md            # hypoteční úroky deduction
    skills/
        TaxReturn/SKILL.md             # DPFO preparation workflow
        TaxAnalysis/SKILL.md           # PDF/CSV document extraction
    agents/
        TaxAdvisor.md                  # Czech tax law Q&A agent
```

No Rust code. No hooks. Skills-only module.

### Rules — Bilingual, Law-Referenced

Each rule opens with a Czech→English term mapping and zákon section reference. Body captures current law (zákon 586/1992 Sb. as amended). Behavioral guidance that tells the AI how to reason about Czech tax concepts.

| Rule                     | Covers                                                                                      |
| ------------------------ | ------------------------------------------------------------------------------------------- |
| `PersonalTaxIncome`      | §6 employment, §7 self-employment, §8 capital, §9 rental, §10 other. Foreign income, DTTs. |
| `PersonalTaxDeductions`  | §15 deductions: DIP, pension, mortgage, life insurance, donations. Limits and proof docs.   |
| `PersonalTaxDeadlines`   | March 31 / June 30 / July 1 deadlines. Opravné vs dodatečné přiznání. Penalties.           |
| `DipPension`             | DIP + penzijní spoření: contribution limits, employer treatment, 120-month minimum.         |
| `MortgageInterest`       | Hypoteční úroky: contract requirements, annual limit, bytové potřeby qualification.         |

### TaxReturn Skill

Interactive DPFO preparation workflow: inventory source documents, extract data (via TaxAnalysis), validate income categories, compute deductions, cross-check amounts, flag issues, generate filing values, pre-submission checklist.

### TaxAnalysis Skill

Reads financial PDFs and CSVs. Extracts amounts, dates, payer/payee, document type. Classifies by income category or deduction type. Handles Czech-language documents.

### TaxAdvisor Agent

Czech tax law specialist. References zákon sections. Bilingual (Czech terms, English explanations). Conservative approach — recommends daňový poradce when uncertain. Used by TaxReturn for validation and available standalone for Q&A.

### Project Structure

Vault project: `Projects/Taxes YYYY/Taxes YYYY.md` following ProjectConventions. Source documents in `Assets/`. Inbox staging for incoming documents.

## Consequences

- Positive: rules are reusable across tax years and entity types
- Positive: bilingual term mapping makes the module useful for Czech tax law Q&A beyond filing
- Tradeoff: more upfront work before the first filing run, but rules inform every step
