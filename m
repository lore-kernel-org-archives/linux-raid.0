From: maxin.john@gmail.com
Subject: [PATCH 1/3] mdadm.h: Undefine dprintf before redefining
Date: Fri, 21 Jul 2017 16:25:58 +0300
Message-ID: <1500643560-21322-1-git-send-email-maxin.john@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

From: Khem Raj <raj.khem@gmail.com>

dprintf is also defined in libc see
usr/include/bits/stdio2.h, this comes into
play especially when fortify sources is enabled
and compilers like clang reports the override

In file included from policy.c:25:
./mdadm.h:1562:9: error: 'dprintf' macro redefined [-Werror,-Wmacro-redefined]
        ^
/mnt/oe/openembedded-core/build/tmp-glibc/sysroots/qemux86/usr/include/bits/stdio2.h:145:12: note: previous definition is here

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Maxin B. John <maxin.john@intel.com>
---
 mdadm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index ee9b837..55c707a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1647,11 +1647,13 @@ static inline char *to_subarray(struct mdstat_ent *ent, char *container)
 }
 
 #ifdef DEBUG
+#undef dprintf
 #define dprintf(fmt, arg...) \
 	fprintf(stderr, "%s: %s: "fmt, Name, __func__, ##arg)
 #define dprintf_cont(fmt, arg...) \
 	fprintf(stderr, fmt, ##arg)
 #else
+#undef dprintf
 #define dprintf(fmt, arg...) \
         ({ if (0) fprintf(stderr, "%s: %s: " fmt, Name, __func__, ##arg); 0; })
 #define dprintf_cont(fmt, arg...) \
-- 
2.4.0

