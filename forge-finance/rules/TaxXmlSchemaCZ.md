The DPFDP7 XML schema has strict attribute validation. EPO rejects any attribute not defined in the XSD for a given Veta element.

The XSD is cached at `docs/dpfdp7_epo2.xsd`. Before adding an attribute to a Veta element, verify it exists:

```sh
grep -i "attribute_name" Modules/forge-finance/docs/dpfdp7_epo2.xsd
```

Confirmed VetaO attributes for §6 employment income:

| Attribute      | Row | Description                                  |
| -------------- | --- | -------------------------------------------- |
| `kc_prij6`     | 31  | Total employment income from all employers   |
| `kc_zd6p`      | 34  | §6 partial tax base (computed)               |
| `kc_zd6`       | 36  | §6 partial tax base (transfer from row 34)   |
| `kc_zd7`       | 37  | §7 partial tax base                          |
| `kc_uhrn`      | 41  | Sum of §7+§8+§9+§10 (excludes §6)           |
| `kc_zakldan23` | 42  | §6 + positive(row 41) = aggregate tax base   |
| `kc_zakldan`   | 45  | Row 42 minus row 44 (after loss deductions)  |

Confirmed VetaD payment attributes:

| Attribute      | Row | Description                                  |
| -------------- | --- | -------------------------------------------- |
| `kc_zalzavc`   | 84  | Employer-withheld §6 advances                |
| `kc_zalpred`   | 85  | Taxpayer's own advance payments              |
| `kc_konkurs`   | 90  | Tax already paid (misleading name, §38gb)    |
| `kc_zbyvpred`  | 91  | Remaining to pay (+) or overpayment (-)      |

Optional attributes with no value should be **omitted entirely**, not set to `"0"`. EPO validation may reject zero where empty is expected (e.g., `kc_dazvyhod` row 72).

When generating XML, set values only for attributes confirmed in the XSD. After every edit, validate with `xmllint --noout`.
