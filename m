From: mwilck@arcor.de
Subject: [PATCH 1/6] DDF: add endian-safe typedefs
Date: Sun, 21 Jul 2013 19:28:19 +0200
Message-ID: <1374427704-7903-2-git-send-email-mwilck@arcor.de>
References: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This adds typedefs for big-endian numbers. This will hopefully
reduce the number of endianness bugs I make.
---
 super-ddf.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index d7da4c1..7f28d84 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -58,6 +58,42 @@ unsigned long crc32(
  *
  */
 
+typedef struct __be16 {
+	__u16 _v16;
+} be16;
+#define be16_eq(x, y) ((x)._v16 == (y)._v16)
+
+typedef struct __be32 {
+	__u32 _v32;
+} be32;
+#define be32_eq(x, y) ((x)._v32 == (y)._v32)
+
+typedef struct __be64 {
+	__u64 _v64;
+} be64;
+#define be64_eq(x, y) ((x)._v64 == (y)._v64)
+
+#define be16_to_cpu(be) __be16_to_cpu((be)._v16)
+static inline be16 cpu_to_be16(__u16 x)
+{
+	be16 be = { ._v16 = __cpu_to_be16(x) };
+	return be;
+}
+
+#define be32_to_cpu(be) __be32_to_cpu((be)._v32)
+static inline be32 cpu_to_be32(__u32 x)
+{
+	be32 be = { ._v32 = __cpu_to_be32(x) };
+	return be;
+}
+
+#define be64_to_cpu(be) __be64_to_cpu((be)._v64)
+static inline be64 cpu_to_be64(__u64 x)
+{
+	be64 be = { ._v64 = __cpu_to_be64(x) };
+	return be;
+}
+
 /* Primary Raid Level (PRL) */
 #define	DDF_RAID0	0x00
 #define	DDF_RAID1	0x01
-- 
1.7.1
