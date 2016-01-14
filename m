From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH V2 1/2] Define _POSIX_C_SOURCE if undefined
Date: Wed, 13 Jan 2016 22:32:38 -0800
Message-ID: <1452753159-1527-1-git-send-email-raj.khem@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
List-Id: linux-raid.ids

config.c uses _POSIX_C_SOURCE which is defined in features.h when
glibc/uclibc is used, but isn't defined when musl is used.
So provide a reasonable default.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
Changes since v1:
- Improve the commit meesage
- Divide into separate commit

 config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/config.c b/config.c
index c58c8fe..b308b6c 100644
--- a/config.c
+++ b/config.c
@@ -63,6 +63,9 @@
  * but may not wrap over lines
  *
  */
+#ifndef _POSIX_C_SOURCE
+#define _POSIX_C_SOURCE 200809L
+#endif
 
 #ifndef CONFFILE
 #define CONFFILE "/etc/mdadm.conf"
-- 
2.7.0

