From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] include sys/sysmacros.h for major/minor/makedev prototypes
Date: Tue, 19 Apr 2016 18:12:44 -0400
Message-ID: <1461103964-8922-1-git-send-email-vapier@gentoo.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These funcs are defined in sys/sysmacros.h, so include it for them.
It works today due to an implicit include by sys/types.h, but the
various Linux C libraries are moving away from that.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 mdadm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mdadm.h b/mdadm.h
index d209488..b8767a7 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -33,6 +33,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 # endif
 #endif
 
+#include	<sys/sysmacros.h>
 #include	<sys/types.h>
 #include	<sys/stat.h>
 #include	<stdint.h>
-- 
2.7.4

