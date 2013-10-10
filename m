From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] Be consistent in return types from byteswap macros
Date: Thu, 10 Oct 2013 09:42:05 +0200
Message-ID: <1381390925-9033-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1381390925-9033-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1381390925-9033-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, karsten@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The bswap_*() macros return int values. Make sure we return the
equivalent types in same byteorder pass-through functions to avoid
problems with the original type leaking through to printf() etc.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdadm.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index c90fe10..cb207c9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -129,12 +129,12 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 
 #if !defined(__KLIBC__)
 #if BYTE_ORDER == LITTLE_ENDIAN
-#define	__cpu_to_le16(_x) (_x)
-#define __cpu_to_le32(_x) (_x)
-#define __cpu_to_le64(_x) (_x)
-#define	__le16_to_cpu(_x) (_x)
-#define __le32_to_cpu(_x) (_x)
-#define __le64_to_cpu(_x) (_x)
+#define	__cpu_to_le16(_x) (unsigned int)(_x)
+#define __cpu_to_le32(_x) (unsigned int)(_x)
+#define __cpu_to_le64(_x) (unsigned long long)(_x)
+#define	__le16_to_cpu(_x) (unsigned int)(_x)
+#define __le32_to_cpu(_x) (unsigned int)(_x)
+#define __le64_to_cpu(_x) (unsigned long long)(_x)
 
 #define	__cpu_to_be16(_x) bswap_16(_x)
 #define __cpu_to_be32(_x) bswap_32(_x)
@@ -150,12 +150,12 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #define __le32_to_cpu(_x) bswap_32(_x)
 #define __le64_to_cpu(_x) bswap_64(_x)
 
-#define	__cpu_to_be16(_x) (_x)
-#define __cpu_to_be32(_x) (_x)
-#define __cpu_to_be64(_x) (_x)
-#define	__be16_to_cpu(_x) (_x)
-#define __be32_to_cpu(_x) (_x)
-#define __be64_to_cpu(_x) (_x)
+#define	__cpu_to_be16(_x) (unsigned int)(_x)
+#define __cpu_to_be32(_x) (unsigned int)(_x)
+#define __cpu_to_be64(_x) (unsigned long long)(_x)
+#define	__be16_to_cpu(_x) (unsigned int)(_x)
+#define __be32_to_cpu(_x) (unsigned int)(_x)
+#define __be64_to_cpu(_x) (unsigned long long)(_x)
 #else
 #  error "unknown endianness."
 #endif
-- 
1.8.3.1

