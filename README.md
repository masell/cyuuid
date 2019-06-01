There is __0__ speedup for this module.

Clone of built in uuid module.

run tests:
`python -m unittest discover`

Build:
`python setup.py build_ext`

Install:
`pip install cyuuid`

Upload to pypi:
```
python setup.py sdist
twine upload -u<USERNAME> -p<PASSWORD> dist/cyuuid-<VERSION>.tar.gz
```


Usage:

Construct from Hexadecimal:
```
from cyuuid import UUID
uuid = UUID('a8098c1a-f86e-11da-bd1a-00112444be1e')
```

Construct from python built in uuid:
```
from uuid import UUID as PY_UUID
py_uuid = PY_UUID('a8098c1a-f86e-11da-bd1a-00112444be1e')
cy_uuid = UUID(uuid=PY_UUID)
```
