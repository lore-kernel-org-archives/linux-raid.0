From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] [mdadm] add crc32c and use it for r5l checksum
Date: Wed, 28 Oct 2015 12:06:06 -0700
Message-ID: <1446059166-1376285-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In kernel space, r5l checksum will use crc32c:
http://marc.info/?l=linux-raid&m=144598970529191
mdadm need to change too.

This patch ports a simplified crc32c algorithm from kernel code,
and used in super1.c:write_empty_r5l_meta_block();

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Makefile |   2 +-
 crc32c.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 super1.c |  11 +++----
 3 files changed, 109 insertions(+), 8 deletions(-)
 create mode 100644 crc32c.c

diff --git a/Makefile b/Makefile
index 544e6cb..fde2e63 100644
--- a/Makefile
+++ b/Makefile
@@ -133,7 +133,7 @@ OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
 	super-mbr.o super-gpt.o \
 	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
-	platform-intel.o probe_roms.o
+	platform-intel.o probe_roms.o crc32c.o
 
 CHECK_OBJS = restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o
 
diff --git a/crc32c.c b/crc32c.c
new file mode 100644
index 0000000..156cba1
--- /dev/null
+++ b/crc32c.c
@@ -0,0 +1,104 @@
+/*
+ * Oct 28, 2015 Song Liu simplified the code and port it to mdadm
+ *
+ * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Spelvin
+ * cleaned up code to current version of sparse and added the slicing-by-8
+ * algorithm to the closely similar existing slicing-by-4 algorithm.
+ *
+ * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
+ * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
+ * Code was from the public domain, copyright abandoned.  Code was
+ * subsequently included in the kernel, thus was re-licensed under the
+ * GNU GPL v2.
+ *
+ * Oct 12, 2000 Matt Domsch <Matt_Domsch@dell.com>
+ * Same crc32 function was used in 5 other places in the kernel.
+ * I made one version, and deleted the others.
+ * There are various incantations of crc32().  Some use a seed of 0 or ~0.
+ * Some xor at the end with ~0.  The generic crc32() function takes
+ * seed as an argument, and doesn't xor at the end.  Then individual
+ * users can do whatever they need.
+ *   drivers/net/smc9194.c uses seed ~0, doesn't xor with ~0.
+ *   fs/jffs2 uses seed 0, doesn't xor with ~0.
+ *   fs/partitions/efi.c uses seed ~0, xor's with ~0.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <sys/types.h>
+#include <asm/types.h>
+#include <stdlib.h>
+
+/*
+ * There are multiple 16-bit CRC polynomials in common use, but this is
+ * *the* standard CRC-32 polynomial, first popularized by Ethernet.
+ * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
+ */
+#define CRCPOLY_LE 0xedb88320
+#define CRCPOLY_BE 0x04c11db7
+
+/*
+ * This is the CRC32c polynomial, as outlined by Castagnoli.
+ * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
+ * x^8+x^6+x^0
+ */
+#define CRC32C_POLY_LE 0x82F63B78
+
+/**
+ * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
+ *			CRC32/CRC32C
+ * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for other
+ *	 uses, or the previous crc32/crc32c value if computing incrementally.
+ * @p: pointer to buffer over which CRC32/CRC32C is run
+ * @len: length of buffer @p
+ * @polynomial: CRC32/CRC32c LE polynomial
+ */
+static inline __u32 crc32_le_generic(__u32 crc, unsigned char const *p,
+				     size_t len, __u32 polynomial)
+{
+	int i;
+	while (len--) {
+		crc ^= *p++;
+		for (i = 0; i < 8; i++)
+			crc = (crc >> 1) ^ ((crc & 1) ? polynomial : 0);
+	}
+	return crc;
+}
+
+__u32 crc32_le(__u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le_generic(crc, p, len, CRCPOLY_LE);
+}
+
+__u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le_generic(crc, p, len, CRC32C_POLY_LE);
+}
+
+/**
+ * crc32_be_generic() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
+ * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
+ *	other uses, or the previous crc32 value if computing incrementally.
+ * @p: pointer to buffer over which CRC32 is run
+ * @len: length of buffer @p
+ * @polynomial: CRC32 BE polynomial
+ */
+static inline __u32 crc32_be_generic(__u32 crc, unsigned char const *p,
+				     size_t len, __u32 polynomial)
+{
+	int i;
+	while (len--) {
+		crc ^= *p++ << 24;
+		for (i = 0; i < 8; i++)
+			crc =
+			    (crc << 1) ^ ((crc & 0x80000000) ? polynomial :
+					  0);
+	}
+	return crc;
+}
+
+__u32 crc32_be(__u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_be_generic(crc, p, len, CRCPOLY_BE);
+}
diff --git a/super1.c b/super1.c
index 58e6f9d..1735c2d 100644
--- a/super1.c
+++ b/super1.c
@@ -1625,10 +1625,7 @@ static unsigned long choose_bm_space(unsigned long devsize)
 static void free_super1(struct supertype *st);
 
 #define META_BLOCK_SIZE 4096
-unsigned long crc32(
-	unsigned long crc,
-	const unsigned char *buf,
-	unsigned len);
+__u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 static int write_empty_r5l_meta_block(struct supertype *st, int fd)
 {
@@ -1652,9 +1649,9 @@ static int write_empty_r5l_meta_block(struct supertype *st, int fd)
 	mb->seq = __cpu_to_le64(random32());
 	mb->position = __cpu_to_le64(0);
 
-	crc = crc32(0xffffffff, sb->set_uuid, sizeof(sb->set_uuid));
-	crc = crc32(crc, (void *)mb, META_BLOCK_SIZE);
-	mb->checksum = __cpu_to_le32(crc);
+	crc = crc32c_le(0xffffffff, sb->set_uuid, sizeof(sb->set_uuid));
+	crc = crc32c_le(crc, (void *)mb, META_BLOCK_SIZE);
+	mb->checksum = crc;
 
 	if (lseek64(fd, (sb->data_offset) * 512, 0) < 0LL) {
 		pr_err("cannot seek to offset of the meta block\n");
-- 
2.4.6

