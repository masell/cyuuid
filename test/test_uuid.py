from unittest import TestCase
import unittest
from uuid import UUID as _UUID
from cyuuid import UUID, RESERVED_FUTURE, RFC_4122, RESERVED_NCS, RESERVED_MICROSOFT

class TestUUID(TestCase):
    def setUp(self):
        self._uuid = _UUID("a8098c1a-f86e-11da-bd1a-00112444be1e")

    def test_from_uuid(self):
        self.assertEqual(UUID(uuid=self._uuid), self._uuid)

    def test_not_equal(self):
        self.assertNotEqual(UUID('b8098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)

    def test_lt(self):
        self.assertLess(UUID('a7098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)

    def test_gt(self):
        self.assertGreater(UUID('a9098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)

    def test_lte(self):
        self.assertLessEqual(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)
        self.assertLessEqual(UUID('a7098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)

    def test_gte(self):
        self.assertGreaterEqual(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)
        self.assertGreaterEqual(UUID('a9098c1a-f86e-11da-bd1a-00112444be1e'), self._uuid)

    def test_hash(self):
        self.assertEqual(hash(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e')), 2118487228160494877)

    def test_int(self):
        self.assertEqual(int(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e')), 223359875637754765292326297443183672862)

    def test_str(self):
        self.assertEqual(str(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e')), "a8098c1a-f86e-11da-bd1a-00112444be1e")

    def test_hex(self):
        self.assertEqual(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e').hex, "a8098c1af86e11dabd1a00112444be1e")

    def test_variant_NSC(self):
        self.assertEqual(UUID('a8098c1a-f86e-11da-0d1a-00112444be1e').variant, RESERVED_NCS)

    def test_variant_MS(self):
        self.assertEqual(UUID('a8098c1a-f86e-11da-dd1a-00112444be1e').variant, RESERVED_MICROSOFT)

    def test_variant_RFC_4122(self):
        self.assertEqual(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e').variant, RFC_4122)

    def test_variant_FUTURE(self):
        self.assertEqual(UUID('a8098c1a-f86e-11da-ed1a-00112444be1e').variant, RESERVED_FUTURE)

    def test_version(self):
        self.assertEqual(UUID('a8098c1a-f86e-11da-bd1a-00112444be1e').version, 1)
