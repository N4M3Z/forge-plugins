---
name: TaxFiling
version: 0.1.0
description: "Parse, diff, and generate Czech DPFO XML (DPFDP7 schema) for electronic filing via MOJE daně. USE WHEN DPFO XML, parse tax return, correct tax return, opravne priznani, generate XML, tax filing, EPO."
---

Parse existing DPFO filings, compare against computed values, and generate corrected XML for upload to the [MOJE daně portal][1].

## Schema Reference

The DPFDP7 schema (7th generation, tax years 2024+) is published at:
- XSD: [`dpfdp7_epo2.xsd`][2]
- Structure docs: [popis_struktury_detail][3]

All `Veta` elements are flat (attributes only, no child elements). Single-file format — all přílohy in one XML.

## Veta Elements

| Element | Section                                         | Required |
| ------- | ----------------------------------------------- | -------- |
| VetaD   | Header + tax computation (rows 1–91)            | yes      |
| VetaP   | Taxpayer identification, address                | yes      |
| VetaO   | Income totals by category (§6–§10)              | yes      |
| VetaS   | Deductions, tax base, final tax                 | yes      |
| VetaA   | Dependent children (one per child, 0–99)        | no       |
| VetaB   | Attachment declarations                         | no       |
| VetaT   | Příloha 1 — §7 self-employment detail           | if §7    |
| VetaV   | Příloha 2 — §8, §9, §10 detail                 | if §8–10 |
| VetaW   | Příloha 3 — foreign income / tax credit         | if foreign |
| VetaZ   | Příloha 4 — separate tax base §16a              | no       |
| VetaN   | Bank account for refund                         | if refund |

## Filing Types

Controlled by `dap_typ` attribute on VetaD:

| Value | Czech                  | When                                            |
| ----- | ---------------------- | ----------------------------------------------- |
| `B`   | `řádné přiznání`       | first filing for the tax year                   |
| `O`   | `opravné řádné`        | correction before the filing deadline           |
| `D`   | `doplňující přiznání`  | supplementary return after deadline             |
| `E`   | `opravné doplňující`   | correction of a supplementary return            |

For `O` and `D`/`E` types, the `d_zjist` attribute (discovery date) becomes mandatory on VetaD.

## Instructions

### Parse mode

1. Read the XML file. Extract all Veta elements and their attributes.
2. Present a human-readable summary mapping attributes to DPFO form rows.
3. Flag missing Veta elements that the user's income types require (e.g., VetaV missing when §8/§10 income exists, VetaW missing when foreign tax credit applies).

### Diff mode

1. Parse the existing filed XML.
2. Accept computed values from TaxReturn, Fakturoid, Revolut, or TaxAnalysis skills.
3. Present a row-by-row diff of changed values. Highlight:
   - New income categories added
   - Changed deduction amounts
   - Tax computation differences
   - Missing Veta elements that need to be added

### Generate mode

1. Start from the existing filed XML as a base.
2. Apply corrections:
   - Change `dap_typ` from `B` to `O` (or `D` as appropriate per PersonalTaxDeadlinesCZ rule)
   - Set `d_zjist` to the current date
   - Inject or update Veta attributes with corrected values
   - Add missing Veta elements (VetaV, VetaW, etc.)
   - Recompute all derived rows (tax base totals, tax amounts, credits)
3. Omit optional attributes that have no value. Do not set them to `"0"`. EPO rejects zero where empty is expected (child benefit rows, bonus rows).
4. Validate well-formedness and schema compliance:

```sh
xmllint --noout file.xml
xmllint --noout --schema docs/dpfdp7_epo2.xsd file.xml
```

5. Present the corrected XML for user review. **Never write the file without explicit confirmation.**

## Submission

Upload the corrected XML to [MOJE daně][1] via "Načíst ze souboru." The portal validates against the XSD and renders the form for review before submission. Submission requires BankID, eIdentita, or `datová schránka`. The same form is used for all filing types — select řádné/opravné/dodatečné in section 03.

## Constraints

- Never auto-submit to the tax portal
- Always present a diff before generating corrected XML
- Validate against the XSD schema before writing output
- Use UTF-8 encoding
- Preserve all original attributes not affected by the correction

[1]: https://adisspr.mfcr.cz/pmd/epo/formulare/nacist-xml
[2]: https://adisspr.mfcr.cz/adis/jepo/schema/dpfdp7_epo2.xsd
[3]: https://adisspr.mfcr.cz/dpr/adis/idpr_pub/epo2_info/popis_struktury_detail.faces?zkratka=DPFDP7
