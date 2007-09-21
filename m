From: maximilian attems <max@stro.at>
Subject: [PATCH] [mdadm] Add klibc support to mdadm.h
Date: Fri, 21 Sep 2007 19:32:17 +0200
Message-ID: <11903959391007-git-send-email-max@stro.at>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, maximilian attems <max@stro.at>
List-Id: linux-raid.ids

klibc still misses a lot functionality to let mdadm link against,
this small step helps to get to the real trouble.. :)

Signed-off-by: maximilian attems <max@stro.at>
---
 mdadm.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index ac7d4b4..dba09f0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -29,7 +29,7 @@
 
 #define	_GNU_SOURCE
 #include	<unistd.h>
-#ifndef __dietlibc__
+#if !defined(__dietlibc__) && !defined(__KLIBC__)
 extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #else
 # if defined(__NO_STAT64) || __WORDSIZE != 32
@@ -97,6 +97,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 		     ((x) & 0x00000000ff000000ULL) << 8 | \
 		     ((x) & 0x000000ff00000000ULL) >> 8)
 
+#if !defined(__KLIBC__)
 #if BYTE_ORDER == LITTLE_ENDIAN
 #define	__cpu_to_le16(_x) (_x)
 #define __cpu_to_le32(_x) (_x)
@@ -114,6 +115,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #else
 #  error "unknown endianness."
 #endif
+#endif /* __KLIBC__ */
 
 
 
@@ -398,6 +400,11 @@ struct stat64;
 # undef HAVE_NFTW
 #endif
 
+#if defined(__KLIBC__)
+# undef HAVE_NFTW
+# undef HAVE_FTW
+#endif
+
 #ifndef HAVE_NFTW
 # define FTW_PHYS 1
 # ifndef HAVE_FTW
-- 
1.5.2.4

