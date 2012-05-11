From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [mdadm PATCH] bcache: add bcache superblock
Date: Fri, 11 May 2012 13:39:24 -0700
Message-ID: <20120511203835.26301.1937.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

This is a hybrid proposal for supporting bcache as a md device.
Somewhat similar to the v1.x metadata format, where array assembly is
handled in userspace, but managed in the kernel.  In the bcache case it
is an "external" metadata format, but then the expectation is that the
kernel "bcache" personality takes over runtime maintenance of the
metadata.

The container id for bcache is the "cache_set".  The subvolume is the
backing device identifier.

This initial version only supports the runtime static portion of the
superblock, it will need to grow the ability to read the journal to
report the backing devices associated with a given cache set (i.e. in
the superblock backing devices know their cache_set container, but cache
devices need to look elsewhere to find their backing devices).

Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Assemble.c     |    1 
 Makefile       |   11 +
 bcache.h       |   98 +++++++++
 crc64.c        |  129 +++++++++++
 maps.c         |    2 
 mdadm.h        |    2 
 super-bcache.c |  634 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util.c         |    2 
 8 files changed, 873 insertions(+), 6 deletions(-)
 create mode 100644 bcache.h
 create mode 100644 crc64.c
 create mode 100644 super-bcache.c

diff --git a/Assemble.c b/Assemble.c
index fd94461..267a2ce 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1594,6 +1594,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		} else switch(content->array.level) {
 		case LEVEL_LINEAR:
 		case LEVEL_MULTIPATH:
+		case LEVEL_BCACHE:
 		case 0:
 			err = sysfs_set_str(content, NULL, "array_state",
 					    "active");
diff --git a/Makefile b/Makefile
index b8d363f..7886d13 100644
--- a/Makefile
+++ b/Makefile
@@ -103,8 +103,8 @@ OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o \
 	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
 	Incremental.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
-	super-mbr.o super-gpt.o \
-	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
+	super-mbr.o super-gpt.o super-bcache.o \
+	restripe.o sysfs.o sha1.o mapfile.o crc32.o crc64.o sg_io.o msg.o \
 	platform-intel.o probe_roms.o
 
 CHECK_OBJS = restripe.o sysfs.o maps.o lib.o
@@ -116,8 +116,8 @@ INCL = mdadm.h part.h bitmap.h
 MON_OBJS = mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o \
 	config.o policy.o lib.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
-	super-mbr.o super-gpt.o \
-	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
+	super-mbr.o super-gpt.o super-bcache.o \
+	super-ddf.o sha1.o crc32.o crc64.o msg.o bitmap.o \
 	platform-intel.o probe_roms.o
 
 MON_SRCS = $(patsubst %.o,%.c,$(MON_OBJS))
@@ -128,7 +128,8 @@ STATICOBJS = pwgr.o
 ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c policy.c dlink.c util.c \
 	maps.c lib.c \
 	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
-	platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c
+	platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c \
+	super-bcache.c crc64.c
 ASSEMBLE_AUTO_SRCS := mdopen.c
 ASSEMBLE_FLAGS:= $(CFLAGS) -DMDASSEMBLE
 ifdef MDASSEMBLE_AUTO
diff --git a/bcache.h b/bcache.h
new file mode 100644
index 0000000..765e369
--- /dev/null
+++ b/bcache.h
@@ -0,0 +1,98 @@
+#ifndef _BCACHE_H
+#define _BCACHE_H
+
+#include <stdint.h>
+
+#define BITMASK(name, type, field, offset, size)		\
+static inline uint64_t name(const type *k)			\
+{								\
+	uint64_t field = __le64_to_cpu(k->field);		\
+	return (field >> offset) & ~(((uint64_t) ~0) << size);	\
+}								\
+								\
+static inline void SET_##name(type *k, uint64_t v)		\
+{								\
+	uint64_t field = __le64_to_cpu(k->field);		\
+	field &= ~(~((uint64_t) ~0 << size) << offset);		\
+	field |= v << offset;					\
+	k->field = __cpu_to_le64(field);			\
+}
+
+static const char bcache_magic[] = {
+	0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
+	0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };
+
+/* Version 1: Backing dev
+ * Version 2: Seed pointer into btree node checksum
+ * Version 3: Backing dev superblock has offset of start of data
+ */
+
+#define BCACHE_SB_BDEV_VERSION	3
+#define BCACHE_SB_MAX_VERSION	3
+
+#define SB_SECTOR		8
+#define SB_SIZE			16 /* default data_offset in bcache-tools (?) */
+#define SB_LABEL_SIZE		32
+
+struct cache_sb {
+	uint64_t		csum;
+	uint64_t		offset;	/* sector where this sb was written */
+	uint64_t		version;
+#define CACHE_BACKING_DEV	1
+
+	uint8_t			magic[16];
+
+	uint8_t			uuid[16];
+	union {
+		uint8_t		set_uuid[16];
+		uint64_t	set_magic;
+	};
+	uint8_t			label[SB_LABEL_SIZE];
+
+	uint64_t		flags;
+	uint64_t		seq;
+	uint64_t		pad[8];
+
+	uint64_t		nbuckets;	/* device size */
+	uint16_t		block_size;	/* sectors */
+	uint16_t		bucket_size;	/* sectors */
+
+	uint16_t		nr_in_set;
+	uint16_t		nr_this_dev;
+
+	uint32_t		last_mount;	/* time_t */
+
+	uint16_t		first_bucket;
+	uint16_t		keys;		/* number of journal buckets */
+	uint64_t		d[];		/* journal buckets */
+};
+
+static inline int SB_BDEV(struct cache_sb *c)
+{
+	return __le64_to_cpu(c->version) == CACHE_BACKING_DEV;
+}
+
+BITMASK(CACHE_SYNC,     struct cache_sb, flags, 0, 1);
+BITMASK(CACHE_DISCARD,	struct cache_sb, flags, 1, 1);
+BITMASK(CACHE_REPLACEMENT, struct cache_sb, flags, 2, 3);
+
+BITMASK(BDEV_CACHE_MODE,        struct cache_sb, flags, 0, 4);
+#define CACHE_MODE_WRITETHROUGH 0U
+#define CACHE_MODE_WRITEBACK    1U
+#define CACHE_MODE_WRITEAROUND  2U
+#define CACHE_MODE_NONE         3U
+BITMASK(BDEV_STATE,             struct cache_sb, flags, 61, 2);
+#define BDEV_STATE_NONE         0U
+#define BDEV_STATE_CLEAN        1U
+#define BDEV_STATE_DIRTY        2U
+#define BDEV_STATE_STALE        3U
+
+inline uint64_t crc64(const void *_data, size_t len);
+
+#define node(i, j)		((void *) ((i)->d + (j)))
+#define end(i)			node(i, (i)->keys)
+
+#define csum_set(i)							\
+	crc64(((void *) (i)) + 8, ((void *) end(i)) - (((void *) (i)) + 8))
+
+#endif
diff --git a/crc64.c b/crc64.c
new file mode 100644
index 0000000..8f37445
--- /dev/null
+++ b/crc64.c
@@ -0,0 +1,129 @@
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <unistd.h>
+
+/*
+ * Portions Copyright (c) 1996-2001, PostgreSQL Global Development Group (Any
+ * use permitted, subject to terms of PostgreSQL license; see.)
+
+ * If we have a 64-bit integer type, then a 64-bit CRC looks just like the
+ * usual sort of implementation. (See Ross Williams' excellent introduction
+ * A PAINLESS GUIDE TO CRC ERROR DETECTION ALGORITHMS, available from
+ * ftp://ftp.rocksoft.com/papers/crc_v3.txt or several other net sites.)
+ * If we have no working 64-bit type, then fake it with two 32-bit registers.
+ *
+ * The present implementation is a normal (not "reflected", in Williams'
+ * terms) 64-bit CRC, using initial all-ones register contents and a final
+ * bit inversion. The chosen polynomial is borrowed from the DLT1 spec
+ * (ECMA-182, available from http://www.ecma.ch/ecma1/STAND/ECMA-182.HTM):
+ *
+ * x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + x^45 +
+ * x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + x^29 + x^27 +
+ * x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
+ * x^7 + x^4 + x + 1
+*/
+
+static const uint64_t crc_table[256] = {
+	0x0000000000000000ULL, 0x42F0E1EBA9EA3693ULL, 0x85E1C3D753D46D26ULL,
+	0xC711223CFA3E5BB5ULL, 0x493366450E42ECDFULL, 0x0BC387AEA7A8DA4CULL,
+	0xCCD2A5925D9681F9ULL, 0x8E224479F47CB76AULL, 0x9266CC8A1C85D9BEULL,
+	0xD0962D61B56FEF2DULL, 0x17870F5D4F51B498ULL, 0x5577EEB6E6BB820BULL,
+	0xDB55AACF12C73561ULL, 0x99A54B24BB2D03F2ULL, 0x5EB4691841135847ULL,
+	0x1C4488F3E8F96ED4ULL, 0x663D78FF90E185EFULL, 0x24CD9914390BB37CULL,
+	0xE3DCBB28C335E8C9ULL, 0xA12C5AC36ADFDE5AULL, 0x2F0E1EBA9EA36930ULL,
+	0x6DFEFF5137495FA3ULL, 0xAAEFDD6DCD770416ULL, 0xE81F3C86649D3285ULL,
+	0xF45BB4758C645C51ULL, 0xB6AB559E258E6AC2ULL, 0x71BA77A2DFB03177ULL,
+	0x334A9649765A07E4ULL, 0xBD68D2308226B08EULL, 0xFF9833DB2BCC861DULL,
+	0x388911E7D1F2DDA8ULL, 0x7A79F00C7818EB3BULL, 0xCC7AF1FF21C30BDEULL,
+	0x8E8A101488293D4DULL, 0x499B3228721766F8ULL, 0x0B6BD3C3DBFD506BULL,
+	0x854997BA2F81E701ULL, 0xC7B97651866BD192ULL, 0x00A8546D7C558A27ULL,
+	0x4258B586D5BFBCB4ULL, 0x5E1C3D753D46D260ULL, 0x1CECDC9E94ACE4F3ULL,
+	0xDBFDFEA26E92BF46ULL, 0x990D1F49C77889D5ULL, 0x172F5B3033043EBFULL,
+	0x55DFBADB9AEE082CULL, 0x92CE98E760D05399ULL, 0xD03E790CC93A650AULL,
+	0xAA478900B1228E31ULL, 0xE8B768EB18C8B8A2ULL, 0x2FA64AD7E2F6E317ULL,
+	0x6D56AB3C4B1CD584ULL, 0xE374EF45BF6062EEULL, 0xA1840EAE168A547DULL,
+	0x66952C92ECB40FC8ULL, 0x2465CD79455E395BULL, 0x3821458AADA7578FULL,
+	0x7AD1A461044D611CULL, 0xBDC0865DFE733AA9ULL, 0xFF3067B657990C3AULL,
+	0x711223CFA3E5BB50ULL, 0x33E2C2240A0F8DC3ULL, 0xF4F3E018F031D676ULL,
+	0xB60301F359DBE0E5ULL, 0xDA050215EA6C212FULL, 0x98F5E3FE438617BCULL,
+	0x5FE4C1C2B9B84C09ULL, 0x1D14202910527A9AULL, 0x93366450E42ECDF0ULL,
+	0xD1C685BB4DC4FB63ULL, 0x16D7A787B7FAA0D6ULL, 0x5427466C1E109645ULL,
+	0x4863CE9FF6E9F891ULL, 0x0A932F745F03CE02ULL, 0xCD820D48A53D95B7ULL,
+	0x8F72ECA30CD7A324ULL, 0x0150A8DAF8AB144EULL, 0x43A04931514122DDULL,
+	0x84B16B0DAB7F7968ULL, 0xC6418AE602954FFBULL, 0xBC387AEA7A8DA4C0ULL,
+	0xFEC89B01D3679253ULL, 0x39D9B93D2959C9E6ULL, 0x7B2958D680B3FF75ULL,
+	0xF50B1CAF74CF481FULL, 0xB7FBFD44DD257E8CULL, 0x70EADF78271B2539ULL,
+	0x321A3E938EF113AAULL, 0x2E5EB66066087D7EULL, 0x6CAE578BCFE24BEDULL,
+	0xABBF75B735DC1058ULL, 0xE94F945C9C3626CBULL, 0x676DD025684A91A1ULL,
+	0x259D31CEC1A0A732ULL, 0xE28C13F23B9EFC87ULL, 0xA07CF2199274CA14ULL,
+	0x167FF3EACBAF2AF1ULL, 0x548F120162451C62ULL, 0x939E303D987B47D7ULL,
+	0xD16ED1D631917144ULL, 0x5F4C95AFC5EDC62EULL, 0x1DBC74446C07F0BDULL,
+	0xDAAD56789639AB08ULL, 0x985DB7933FD39D9BULL, 0x84193F60D72AF34FULL,
+	0xC6E9DE8B7EC0C5DCULL, 0x01F8FCB784FE9E69ULL, 0x43081D5C2D14A8FAULL,
+	0xCD2A5925D9681F90ULL, 0x8FDAB8CE70822903ULL, 0x48CB9AF28ABC72B6ULL,
+	0x0A3B7B1923564425ULL, 0x70428B155B4EAF1EULL, 0x32B26AFEF2A4998DULL,
+	0xF5A348C2089AC238ULL, 0xB753A929A170F4ABULL, 0x3971ED50550C43C1ULL,
+	0x7B810CBBFCE67552ULL, 0xBC902E8706D82EE7ULL, 0xFE60CF6CAF321874ULL,
+	0xE224479F47CB76A0ULL, 0xA0D4A674EE214033ULL, 0x67C58448141F1B86ULL,
+	0x253565A3BDF52D15ULL, 0xAB1721DA49899A7FULL, 0xE9E7C031E063ACECULL,
+	0x2EF6E20D1A5DF759ULL, 0x6C0603E6B3B7C1CAULL, 0xF6FAE5C07D3274CDULL,
+	0xB40A042BD4D8425EULL, 0x731B26172EE619EBULL, 0x31EBC7FC870C2F78ULL,
+	0xBFC9838573709812ULL, 0xFD39626EDA9AAE81ULL, 0x3A28405220A4F534ULL,
+	0x78D8A1B9894EC3A7ULL, 0x649C294A61B7AD73ULL, 0x266CC8A1C85D9BE0ULL,
+	0xE17DEA9D3263C055ULL, 0xA38D0B769B89F6C6ULL, 0x2DAF4F0F6FF541ACULL,
+	0x6F5FAEE4C61F773FULL, 0xA84E8CD83C212C8AULL, 0xEABE6D3395CB1A19ULL,
+	0x90C79D3FEDD3F122ULL, 0xD2377CD44439C7B1ULL, 0x15265EE8BE079C04ULL,
+	0x57D6BF0317EDAA97ULL, 0xD9F4FB7AE3911DFDULL, 0x9B041A914A7B2B6EULL,
+	0x5C1538ADB04570DBULL, 0x1EE5D94619AF4648ULL, 0x02A151B5F156289CULL,
+	0x4051B05E58BC1E0FULL, 0x87409262A28245BAULL, 0xC5B073890B687329ULL,
+	0x4B9237F0FF14C443ULL, 0x0962D61B56FEF2D0ULL, 0xCE73F427ACC0A965ULL,
+	0x8C8315CC052A9FF6ULL, 0x3A80143F5CF17F13ULL, 0x7870F5D4F51B4980ULL,
+	0xBF61D7E80F251235ULL, 0xFD913603A6CF24A6ULL, 0x73B3727A52B393CCULL,
+	0x31439391FB59A55FULL, 0xF652B1AD0167FEEAULL, 0xB4A25046A88DC879ULL,
+	0xA8E6D8B54074A6ADULL, 0xEA16395EE99E903EULL, 0x2D071B6213A0CB8BULL,
+	0x6FF7FA89BA4AFD18ULL, 0xE1D5BEF04E364A72ULL, 0xA3255F1BE7DC7CE1ULL,
+	0x64347D271DE22754ULL, 0x26C49CCCB40811C7ULL, 0x5CBD6CC0CC10FAFCULL,
+	0x1E4D8D2B65FACC6FULL, 0xD95CAF179FC497DAULL, 0x9BAC4EFC362EA149ULL,
+	0x158E0A85C2521623ULL, 0x577EEB6E6BB820B0ULL, 0x906FC95291867B05ULL,
+	0xD29F28B9386C4D96ULL, 0xCEDBA04AD0952342ULL, 0x8C2B41A1797F15D1ULL,
+	0x4B3A639D83414E64ULL, 0x09CA82762AAB78F7ULL, 0x87E8C60FDED7CF9DULL,
+	0xC51827E4773DF90EULL, 0x020905D88D03A2BBULL, 0x40F9E43324E99428ULL,
+	0x2CFFE7D5975E55E2ULL, 0x6E0F063E3EB46371ULL, 0xA91E2402C48A38C4ULL,
+	0xEBEEC5E96D600E57ULL, 0x65CC8190991CB93DULL, 0x273C607B30F68FAEULL,
+	0xE02D4247CAC8D41BULL, 0xA2DDA3AC6322E288ULL, 0xBE992B5F8BDB8C5CULL,
+	0xFC69CAB42231BACFULL, 0x3B78E888D80FE17AULL, 0x7988096371E5D7E9ULL,
+	0xF7AA4D1A85996083ULL, 0xB55AACF12C735610ULL, 0x724B8ECDD64D0DA5ULL,
+	0x30BB6F267FA73B36ULL, 0x4AC29F2A07BFD00DULL, 0x08327EC1AE55E69EULL,
+	0xCF235CFD546BBD2BULL, 0x8DD3BD16FD818BB8ULL, 0x03F1F96F09FD3CD2ULL,
+	0x41011884A0170A41ULL, 0x86103AB85A2951F4ULL, 0xC4E0DB53F3C36767ULL,
+	0xD8A453A01B3A09B3ULL, 0x9A54B24BB2D03F20ULL, 0x5D45907748EE6495ULL,
+	0x1FB5719CE1045206ULL, 0x919735E51578E56CULL, 0xD367D40EBC92D3FFULL,
+	0x1476F63246AC884AULL, 0x568617D9EF46BED9ULL, 0xE085162AB69D5E3CULL,
+	0xA275F7C11F7768AFULL, 0x6564D5FDE549331AULL, 0x279434164CA30589ULL,
+	0xA9B6706FB8DFB2E3ULL, 0xEB46918411358470ULL, 0x2C57B3B8EB0BDFC5ULL,
+	0x6EA7525342E1E956ULL, 0x72E3DAA0AA188782ULL, 0x30133B4B03F2B111ULL,
+	0xF7021977F9CCEAA4ULL, 0xB5F2F89C5026DC37ULL, 0x3BD0BCE5A45A6B5DULL,
+	0x79205D0E0DB05DCEULL, 0xBE317F32F78E067BULL, 0xFCC19ED95E6430E8ULL,
+	0x86B86ED5267CDBD3ULL, 0xC4488F3E8F96ED40ULL, 0x0359AD0275A8B6F5ULL,
+	0x41A94CE9DC428066ULL, 0xCF8B0890283E370CULL, 0x8D7BE97B81D4019FULL,
+	0x4A6ACB477BEA5A2AULL, 0x089A2AACD2006CB9ULL, 0x14DEA25F3AF9026DULL,
+	0x562E43B4931334FEULL, 0x913F6188692D6F4BULL, 0xD3CF8063C0C759D8ULL,
+	0x5DEDC41A34BBEEB2ULL, 0x1F1D25F19D51D821ULL, 0xD80C07CD676F8394ULL,
+	0x9AFCE626CE85B507ULL
+};
+
+inline uint64_t crc64(const void *_data, size_t len)
+{
+	uint64_t crc = 0xFFFFFFFFFFFFFFFFULL;
+	const unsigned char *data = _data;
+
+	while (len--) {
+		int i = ((int) (crc >> 56) ^ *data++) & 0xFF;
+		crc = crc_table[i] ^ (crc << 8);
+	}
+
+	return crc ^ 0xFFFFFFFFFFFFFFFFULL;
+}
diff --git a/maps.c b/maps.c
index f2ba9a7..cedf548 100644
--- a/maps.c
+++ b/maps.c
@@ -94,6 +94,8 @@ mapping_t pers[] = {
 	{ "10", 10},
 	{ "faulty", LEVEL_FAULTY},
 	{ "container", LEVEL_CONTAINER},
+	{ "bcache", LEVEL_BCACHE},
+	{ "11", LEVEL_BCACHE},
 	{ NULL, 0}
 };
 
diff --git a/mdadm.h b/mdadm.h
index 3bcd052..a0ccff6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -816,6 +816,7 @@ extern struct superswitch {
 extern struct superswitch super0, super1;
 extern struct superswitch super_imsm, super_ddf;
 extern struct superswitch mbr, gpt;
+extern struct superswitch super_bcache;
 
 struct metadata_update {
 	int	len;
@@ -1296,6 +1297,7 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 #define	LEVEL_MULTIPATH		(-4)
 #define	LEVEL_LINEAR		(-1)
 #define	LEVEL_FAULTY		(-5)
+#define LEVEL_BCACHE		(0xb)
 
 /* kernel module doesn't know about these */
 #define LEVEL_CONTAINER		(-100)
diff --git a/super-bcache.c b/super-bcache.c
new file mode 100644
index 0000000..ec8f3db
--- /dev/null
+++ b/super-bcache.c
@@ -0,0 +1,634 @@
+/*
+ * mdadm - bcache support
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * bcache definitions copied from bcache-tools:
+ * git://evilpiepirate.org/~kent/bcache-tools.git
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#define HAVE_STDINT_H 1
+#include "mdadm.h"
+#include "bcache.h"
+
+struct bcache_super {
+	union {
+		struct cache_sb *sb;
+		void *buf;
+	};
+	struct dl {
+		int major, minor;
+		char *devname;
+		int fd;
+	} *disk;
+	int vol;
+	struct bcache_super *next;
+};
+
+enum {
+	/* FIXME this is a function of the bucket size */
+	BCACHE_MAX_DEVICES = 2,
+};
+
+static int load_cache_sb(struct bcache_super *super, int keep_fd)
+{
+	struct dl *d = super->disk;
+	int rc, fd = d->fd;
+	struct cache_sb *c;
+	struct stat s;
+
+	if (!keep_fd)
+		d->fd = -1;
+
+	rc = fstat(fd, &s);
+	if (rc)
+		return rc;
+	d->major = major(s.st_rdev);
+	d->minor = minor(s.st_rdev);
+
+	rc = posix_memalign(&super->buf, 4096, 4096);
+	if (rc)
+		return rc;
+	c = super->sb;
+
+	if (pread(fd, c, 4096, SB_SECTOR << 9) != 4096)
+		return errno;
+
+	if (csum_set(c) != __le64_to_cpu(c->csum))
+		return ENODEV;
+
+	if (memcmp(c->magic, bcache_magic, sizeof(bcache_magic)) != 0)
+		return ENODEV;
+
+	return 0;
+}
+
+static void __free_bcache(struct bcache_super *super)
+{
+	if (!super)
+		return;
+
+	while (super) {
+		struct bcache_super *next = super->next;
+		struct dl *d = super->disk;
+
+		d = super->disk;
+		if (d->fd >= 0)
+			close(d->fd);
+		free(d->devname);
+		free(d);
+		free(super->sb);
+		free(super);
+		super = next;
+	}
+}
+
+static void free_bcache(struct supertype *st)
+{
+	struct bcache_super *super = st->sb;
+
+	__free_bcache(super);
+	st->sb = NULL;
+}
+
+#ifndef MDASSEMBLE
+static void examine_bcache(struct supertype *st, char *homehost)
+{
+	const char *const cache_policies[] = { "lru", "fifo", "random", "" };
+	const char *const bdev_states[] = { "none", "clean", "dirty", "stale" };
+	const char *const bdev_modes[16] = { "writethrough", "writeback", "writearound", "none" };
+	struct bcache_super *super = st->sb;
+	uint16_t first_bucket, bucket_size;
+	struct cache_sb *c = super->sb;
+	uint64_t nbuckets, csum;
+	unsigned long long sz;
+	char nbuf[64];
+
+	printf("       Magic : %s\n",
+	       memcmp(bcache_magic, c->magic, 16) ? "<unknown>" : "<bcache>");
+	printf("     Version : %d\n", (int) c->version);
+	printf("        Role : %s\n", SB_BDEV(c) ? "backing-device" : "cache");
+	__fname_from_uuid((int *) c->set_uuid, 0, nbuf, ':');
+	printf("    Set UUID : %s\n", nbuf + 5);
+	__fname_from_uuid((int *) c->uuid, 0, nbuf, ':');
+	printf("  Cache Devs : %u\n", c->nr_in_set);
+	/* FIXME: list all cache dev uuids in the load_container case */
+	printf(" Device UUID : %s\n", nbuf + 5);
+	printf("       Flags :%s%s\n", CACHE_DISCARD(c) ? " discard" : "",
+				       CACHE_SYNC(c) ? " sync" : "");
+	if (SB_BDEV(c)) {
+		printf("       State : %s\n", bdev_states[BDEV_STATE(c)]);
+		printf("        Mode : %s\n", bdev_modes[BDEV_CACHE_MODE(c)]);
+	} else {
+		printf("      Policy : %s\n", cache_policies[CACHE_REPLACEMENT(c)]);
+		/* FIXME: add reporting of backing device uuids in the cache caase */
+	}
+	printf("       Label : %.32s\n", c->label);
+	csum = __le64_to_cpu(c->csum);
+	nbuckets = __le64_to_cpu(c->nbuckets);
+	bucket_size = __le16_to_cpu(c->bucket_size);
+	first_bucket = __le16_to_cpu(c->first_bucket);
+	sz = (nbuckets - first_bucket) * bucket_size;
+	printf(" Device Size : %llu%s\n", sz, human_size(sz * 512));
+	printf(" Bucket Size : %u\n", bucket_size);
+	printf(" Num Buckets : %llu\n", (unsigned long long) nbuckets);
+	printf("    this dev : %u\n", __le16_to_cpu(c->nr_this_dev));
+	printf("First Bucket : %u\n", first_bucket);
+	printf("    Checksum : %llx %s\n", (unsigned long long) csum,
+	       csum == csum_set(c) ? "correct" : "incorrect");
+}
+
+static void brief_examine_bcache(struct supertype *st, int verbose)
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+	char nbuf[64];
+
+	__fname_from_uuid((int *) c->set_uuid, 0, nbuf, ':');
+	printf("ARRAY metadata=bcache UUID=%s\n", nbuf + 5);
+}
+
+static void brief_examine_subarrays_bcache(struct supertype *st, int verbose)
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+	char nbuf[64], nbuf1[64];
+
+	/* FIXME this needs to parse the cache device journal to find
+	 * and report the backing dev uuid list
+	 */
+	if (!SB_BDEV(c))
+		return;
+
+	__fname_from_uuid((int *) c->set_uuid, 0, nbuf, ':');
+	__fname_from_uuid((int *) c->uuid, 0, nbuf1, ':');
+
+	printf("ARRAY container=%s UUID=%s\n", nbuf + 5, nbuf1 + 5);
+}
+
+static void export_examine_bcache(struct supertype *st)
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+	char nbuf[64];
+
+	__fname_from_uuid((int *) c->set_uuid, 0, nbuf, ':');
+	printf("MD_METADATA=bcache\n");
+	printf("MD_LEVEL=container\n");
+	printf("MD_UUID=%s\n", nbuf+5);
+	printf("MD_DEVICES=%d\n", __le16_to_cpu(c->nr_in_set) + 1);
+}
+
+static void detail_bcache(struct supertype *st, char *homehost)
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+	char nbuf[64];
+
+	__fname_from_uuid((int *) c->set_uuid, 0, nbuf, ':');
+	printf("\n           UUID : %s\n", nbuf + 5);
+}
+
+static void brief_detail_bcache(struct supertype *st)
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+	char nbuf[64];
+
+	__fname_from_uuid((int *) c->set_uuid, 0, nbuf, ':');
+	printf(" UUID=%s", nbuf + 5);
+}
+
+static struct bcache_super *alloc_super(const char *func)
+{
+	struct bcache_super *super = calloc(1, sizeof(*super));
+	struct dl *d = calloc(1, sizeof(*d));
+
+	if (!super || !d) {
+		fprintf(stderr, Name "%s: %s failed\n", func, __func__);
+		free(super);
+		free(d);
+		return NULL;
+	}
+
+	super->vol = -1;
+	super->disk = d;
+
+	return super;
+}
+
+static int load_container_bcache(struct supertype *st, int fd, char *devname)
+{
+	struct bcache_super *list = NULL;
+	int rc, i, cdev = 0, bdev = 0;
+	int devnum = fd2devnum(fd);
+	struct mdinfo *sra, *sd;
+
+	sra = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+	if (!sra)
+		return 1;
+
+	if (sra->array.major_version != -1 ||
+	    sra->array.minor_version != -2 ||
+	    strcmp(sra->text_version, "bcache") != 0) {
+		rc = 1;
+		goto error;
+	}
+
+	for (sd = sra->devs, i = 0; sd; sd = sd->next, i++) {
+		struct bcache_super *super = alloc_super(__func__);
+		struct cache_sb *c;
+		char nm[32];
+		int fd;
+
+		rc = 1;
+		if (!super)
+			goto error;
+		super->next = list;
+		list = super;
+
+		rc = 2;
+		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+		fd = dev_open(nm, O_RDWR);
+		if (fd < 0)
+			goto error;
+
+		super->disk->fd = fd;
+		rc = load_cache_sb(super, 1);
+		if (rc)
+			goto error;
+		c = super->sb;
+		if (SB_BDEV(c))
+			bdev++;
+		else
+			cdev++;
+	}
+	rc = 0;
+
+	/* FIXME disambiguate multiple bdevs per set, support multiple
+	 * cache devices
+	 */
+	if (bdev > 1) {
+		fprintf(stderr, Name ": %d backing devices detected\n", bdev);
+		rc = 3;
+	}
+	if (cdev > 1) {
+		fprintf(stderr, Name ": %d cache devices detected\n", cdev);
+		rc = 3;
+	}
+	if (rc)
+		goto error;
+	st->sb = list;
+	list = NULL;
+
+error:
+	if (list)
+		__free_bcache(list);
+	sysfs_free(sra);
+
+	st->container_dev = devnum;
+	if (rc == 0 && st->ss == NULL) {
+		st->ss = &super_bcache;
+		st->minor_version = 0;
+		st->max_devs = BCACHE_MAX_DEVICES;
+	}
+	return rc;
+}
+#endif
+
+static int load_bcache(struct supertype *st, int fd, char *devname)
+{
+	struct bcache_super *super;
+	struct dl *d;
+	int rc;
+
+	free_bcache(st);
+
+	super = alloc_super(__func__);
+	if (!super)
+		return 1;
+
+	st->sb = super;
+	d = super->disk;
+	d->devname = devname ? strdup(devname) : NULL;
+	d->fd = fd;
+	rc = load_cache_sb(super, 0);
+	if (rc) {
+		free_bcache(st);
+		if (!devname)
+			return rc;
+		fprintf(stderr, Name ": %s failed on %s (%s)\n", __func__,
+			devname, strerror(rc));
+		return rc;
+	}
+
+	if (st->ss == NULL) {
+		st->ss = &super_bcache;
+		st->minor_version = 0;
+		st->max_devs = BCACHE_MAX_DEVICES;
+	}
+
+	return 0;
+}
+
+static int store_bcache(struct supertype *st, int fd)
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+
+	if (!c)
+		return 1;
+
+	if (pwrite(fd, c, sizeof(*c), SB_SECTOR << 9) != sizeof(*c))
+		return 1;
+
+	return 0;
+}
+
+static int compare_bcache(struct supertype *st, struct supertype *tst)
+{
+	struct bcache_super *a = st->sb;
+	struct bcache_super *b = tst->sb;
+
+        if (!st->sb) {
+                st->sb = tst->sb;
+                tst->sb = NULL;
+                return 0;
+        }
+
+	if (memcmp(a->sb->set_uuid, b->sb->set_uuid, sizeof(b->sb->set_uuid)) != 0)
+		return 2;
+
+	return 0;
+}
+
+static __u64 avail_size_bcache(struct supertype *st, __u64 devsize)
+{
+	/* 4k from start, 8k min data offset */
+	const uint32_t reserved_sectors = (4+8) * 2; 
+
+	if (devsize < reserved_sectors)
+		return 0;
+
+	return devsize - reserved_sectors;
+}
+
+static struct supertype *match_metadata_desc_bcache(char *arg)
+{
+	struct supertype *st;
+
+	if (strcmp(arg, "bcache") != 0 &&
+	    strcmp(arg, "default") != 0)
+		return NULL;
+
+	st = calloc(1, sizeof(*st));
+	if (!st)
+		return NULL;
+	st->container_dev = NoMdDev;
+	st->ss = &super_bcache;
+	st->max_devs = BCACHE_MAX_DEVICES;
+	st->minor_version = 0;
+	st->sb = NULL;
+
+	return st;
+}
+
+static int match_home_bcache(struct supertype *st, char *homehost)
+{
+	/* the bcache superblock does not specify any host
+	 * identification information.  maybe it should...
+	 */
+
+	return -1;
+}
+
+static void uuid_from_bcache(struct supertype *st, int uuid[4])
+{
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+
+	memcpy(uuid, c->set_uuid, sizeof(c->set_uuid));
+}
+
+static void getinfo_bcache_volume(struct supertype *st, struct mdinfo *info, int map_disks, char *dmap)
+{
+	char *name = devnum2devname(st->container_dev);
+	struct bcache_super *super = st->sb;
+	uint16_t bucket_size, first_bucket;
+	struct cache_sb *c = super->sb;
+	unsigned long long sz;
+	uint64_t nbuckets;
+
+	nbuckets = __le64_to_cpu(c->nbuckets);
+	bucket_size = __le16_to_cpu(c->bucket_size);
+	first_bucket = __le16_to_cpu(c->first_bucket);
+	sz = (nbuckets - first_bucket) * bucket_size;
+
+	info->container_member	  = super->vol;
+	info->custom_array_size   = sz;
+	info->component_size	  = sz;
+	info->recovery_start	  = MaxSector;
+	info->data_offset	  = SB_SECTOR + SB_SIZE;
+	sprintf(info->text_version, "/%s/%d", name, super->vol);
+	snprintf(info->name, sizeof(info->name), "%s", c->label);
+	memcpy(info->uuid, c->uuid, sizeof(c->uuid));
+
+	info->array.raid_disks    = __le16_to_cpu(c->nr_in_set) + 1;
+	info->array.level         = LEVEL_BCACHE;
+	info->array.layout        = 0;
+	info->array.md_minor      = -1;
+	info->array.ctime         = 0;
+	info->array.utime         = 0;
+	info->array.chunk_size    = bucket_size * 512;
+	info->array.major_version = -1;
+	info->array.minor_version = -2;
+
+	info->disk.major = 0;
+	info->disk.minor = 0;
+	info->disk.raid_disk = SB_BDEV(c);
+	info->disk.number = SB_BDEV(c);
+	info->disk.state = 1 << MD_DISK_ACTIVE | 1 << MD_DISK_SYNC;
+}
+
+static void getinfo_bcache(struct supertype *st, struct mdinfo *info, char *dmap)
+{
+	int i, cset, bdev, map_disks = info->array.raid_disks;
+	struct bcache_super *super = st->sb;
+	struct cache_sb *c = super->sb;
+
+	memset(info, 0, sizeof(*info));
+
+	if (super->vol >= 0)
+		return getinfo_bcache_volume(st, info, map_disks, dmap);
+
+	/* make Assemble choose the cache target */
+	info->events = SB_BDEV(c);
+	info->recovery_start = MaxSector;
+	info->data_offset = SB_SECTOR;
+	info->component_size = SB_SIZE;
+	strcpy(info->text_version, "bcache");
+	memcpy(info->uuid, c->set_uuid, sizeof(c->set_uuid));
+
+	info->array.raid_disks    = __le16_to_cpu(c->nr_in_set) + 1;
+	info->array.level         = LEVEL_CONTAINER;
+	info->array.layout        = 0;
+	info->array.md_minor      = -1;
+	info->array.ctime         = 0;
+	info->array.utime         = 0;
+	info->array.chunk_size    = __le16_to_cpu(c->bucket_size) * 512;
+	info->array.major_version = -1;
+	info->array.minor_version = -2;
+
+	info->disk.major = 0;
+	info->disk.minor = 0;
+	info->disk.raid_disk = SB_BDEV(c);
+	info->disk.number = SB_BDEV(c);
+	/* FIXME: need bcache superblock to identify failed devices */
+	info->disk.state = 1 << MD_DISK_ACTIVE | 1 << MD_DISK_SYNC;
+
+	/* FIXME need to parse the journal uuid_bucket to understand
+	 * which cache devs are consistent with the set
+	 */
+	for (i = 0; dmap && i < map_disks; i++)
+		dmap[i] = 1;
+
+	cset = 0;
+	bdev = 0;
+	while (super) {
+		c = super->sb;
+
+		/* FIXME filter out-of-sync devices */
+		if (SB_BDEV(c))
+			bdev++;
+		else
+			cset++;
+		super = super->next;
+	}
+
+	if (cset + bdev == __le16_to_cpu(c->nr_in_set) + 1)
+		info->container_enough = 1;
+	else
+		info->container_enough = -1;
+}
+
+static int update_bcache(struct supertype *st, struct mdinfo *i, char *update,
+			 char *devname, int verbose, int uuid_set, char *homehost)
+{
+	/* FIXME */
+	if (strcmp(update, "grow") == 0) {
+		return 0;
+	} else if (strcmp(update, "resync") == 0) {
+		return 0;
+	} else if (strcmp(update, "homehost") == 0) {
+		return -1;
+	} else if (strcmp(update, "name") == 0) {
+		return -1;
+	} else if (strcmp(update, "_reshape_progress") == 0) {
+		return 0;
+	} else if (strcmp(update, "assemble") == 0 ) {
+		return 0;
+	} else {
+		return -1;
+	}
+}
+
+static struct mdinfo *container_content_bcache(struct supertype *st, char *subarray)
+{
+	struct bcache_super *super = st->sb;
+	struct mdinfo *info, *disk = NULL;
+	char *ep;
+
+	info = calloc(1, sizeof(*info));
+	if (!info) {
+		fprintf(stderr, Name ": failed to allocate %zu bytes\n",
+			sizeof(*info));
+		return NULL;
+	}
+
+	/* don't support multiple backing disks per cache set */
+	if (subarray && (strtoul(subarray, &ep, 10) > 0 || *ep != '\0'))
+		goto error;
+
+	super->vol = 0;
+	getinfo_bcache(st, info, NULL);
+
+	for (; super; super = super->next) {
+		struct dl *d = super->disk;
+		struct cache_sb *c = super->sb;
+
+		disk = calloc(1, sizeof(*disk));
+		if (!disk) {
+			fprintf(stderr, Name ": failed to allocate disk\n");
+			goto error;
+		}
+		disk->next = info->devs;
+		info->devs = disk;
+
+		disk->disk.number = SB_BDEV(c);
+		disk->disk.raid_disk = SB_BDEV(c);
+		disk->disk.major = d->major;
+		disk->disk.minor = d->minor;
+		disk->recovery_start = MaxSector;
+		disk->disk.state = 1 << MD_DISK_ACTIVE;
+		disk->data_offset = info->data_offset;
+		disk->component_size = info->component_size;
+
+		info->array.working_disks++;
+	}
+
+	return info;
+
+ error:
+	disk = info->devs;
+	while (disk) {
+		struct mdinfo *next = disk->next;
+
+		free(disk);
+		disk = next;
+	}
+
+	free(info);
+	return NULL;
+}
+
+
+struct superswitch super_bcache = {
+#ifndef	MDASSEMBLE
+	.examine_super	         = examine_bcache,
+	.brief_examine_super     = brief_examine_bcache,
+	.brief_examine_subarrays = brief_examine_subarrays_bcache,
+	.export_examine_super    = export_examine_bcache,
+	.detail_super	         = detail_bcache,
+	.brief_detail_super      = brief_detail_bcache,
+	.load_container	         = load_container_bcache,
+#endif
+	.match_home              = match_home_bcache,
+	.uuid_from_super         = uuid_from_bcache,
+	.getinfo_super           = getinfo_bcache,
+	.update_super		 = update_bcache,
+
+	.avail_size              = avail_size_bcache,
+
+	.compare_super           = compare_bcache,
+
+	.load_super	         = load_bcache,
+	.store_super	         = store_bcache,
+	.free_super	         = free_bcache,
+	.match_metadata_desc     = match_metadata_desc_bcache,
+	.container_content       = container_content_bcache,
+
+	.external                = 1,
+	.name		         = "bcache",
+};
diff --git a/util.c b/util.c
index 6985a70..d9e49cf 100644
--- a/util.c
+++ b/util.c
@@ -919,7 +919,7 @@ struct superswitch *superlist[] =
 {
 	&super0, &super1,
 	&super_ddf, &super_imsm,
-	&mbr, &gpt,
+	&mbr, &gpt, &super_bcache,
 	NULL };
 
 #if !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO)
