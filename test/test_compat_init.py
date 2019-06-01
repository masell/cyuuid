import itertools
import unittest
from uuid import UUID as _UUID
from cyuuid import UUID

class TestUUIDCompatInit(unittest.TestCase):
    def test_int(self):
        _int=223359875637754765292326297443183672862
        uuid = _UUID(int=_int)
        cyuuid = UUID(int=_int)
        self.assertEqual(uuid, cyuuid)

    def test_hex(self):
        hex = "a8098c1a-f86e-11da-bd1a-00112444be1e"
        uuid = _UUID(hex=hex)
        cyuuid = UUID(hex=hex)
        self.assertEqual(uuid, cyuuid)

    def test_bytes(self):
        _bytes = b'\xa8\t\x8c\x1a\xf8n\x11\xda\xbd\x1a\x00\x11$D\xbe\x1e'
        uuid = _UUID(bytes=_bytes)
        cyuuid = UUID(bytes=_bytes)
        self.assertEqual(uuid, cyuuid)

    def test_bytes_le(self):
        bytes_le = b'\x1a\x8c\t\xa8n\xf8\xda\x11\xbd\x1a\x00\x11$D\xbe\x1e'
        uuid = _UUID(bytes_le=bytes_le)
        cyuuid = UUID(bytes_le=bytes_le)
        self.assertEqual(uuid, cyuuid)

    def test_fields(self):
        fields=(0x12345678, 0x1234, 0x5678, 0x12, 0x34, 0x567812345678)
        uuid = _UUID(fields=fields)
        cyuuid = UUID(fields=fields)
        self.assertEqual(uuid, cyuuid)

    def test_version(self):
        hex = "a8098c1a-f86e-11da-bd1a-00112444be1e"
        for version in range(1, 5):
            with self.subTest(version=version):
                uuid = _UUID(hex=hex, version=version)
                cyuuid = UUID(hex=hex, version=version)
                self.assertEqual(uuid, cyuuid)

    def test_multiple_inputs(self):
        hex = "a8098c1a-f86e-11da-bd1a-00112444be1e"
        fields=(0x12345678, 0x1234, 0x5678, 0x12, 0x34, 0x567812345678)
        bytes_le = b'\x1a\x8c\t\xa8n\xf8\xda\x11\xbd\x1a\x00\x11$D\xbe\x1e'
        _bytes = b'\xa8\t\x8c\x1a\xf8n\x11\xda\xbd\x1a\x00\x11$D\xbe\x1e'
        _int=223359875637754765292326297443183672862

        for x in [
                (hex, fields, bytes_le, _bytes, _int),
                (hex, fields, bytes_le, _bytes, None),
                (hex, fields, bytes_le, None, None),
                (hex, fields, None, None, None),
                (hex, None, None, None, None),
                (None, fields, bytes_le, _bytes, _int),
                (hex, None, bytes_le, _bytes, _int),
                (hex, fields, None, _bytes, _int),
                (hex, fields, bytes_le, None, _int),
                (hex, fields, bytes_le, _bytes, None),
                (None, None, None, _bytes, _int),
            ]:

            with self.subTest(params=x):
                msg = "one of the hex, bytes, bytes_le, fields, or int arguments must be given"
                with self.assertRaisesRegex(TypeError, msg):
                    UUID(hex=x[0], bytes=[1], bytes_le=x[2], fields=x[3], int=x[4])
