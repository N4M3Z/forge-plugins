After every XML edit, validate well-formedness before presenting to the user:

```sh
xmllint --noout file.xml 2>&1
```

If `xmllint` is not available:

```sh
python3 -c "import xml.etree.ElementTree as ET; ET.parse('file.xml'); print('valid')"
```

Never present an XML file without running validation first.
