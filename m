From: maxin.john@gmail.com
Subject: [PATCH 2/3] mdadm.h: include sys/sysmacros.h for major/minor defintions
Date: Fri, 21 Jul 2017 16:25:59 +0300
Message-ID: <1500643560-21322-2-git-send-email-maxin.john@gmail.com>
References: <1500643560-21322-1-git-send-email-maxin.john@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500643560-21322-1-git-send-email-maxin.john@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

From: Khem Raj <raj.khem@gmail.com>

glibc 2.25 is warning about it if applications depend on
sys/types.h for these macros, it expects to be included
from <sys/sysmacros.h>

Fixes
| Grow.c:3534:13: error: In the GNU C Library, "minor" is defined
|  by <sys/sysmacros.h>. For historical compatibility, it is
|  currently defined by <sys/types.h> as well, but we plan to
|  remove this soon. To use "minor", include <sys/sysmacros.h>
|  directly. If you did not intend to use a system-defined macro
|  "minor", you should undefine it after including <sys/types.h>. [-Werror]
| Query.c: In function 'Query':
| Query.c:105:13: error: In the GNU C Library, "makedev" is defined
|  by <sys/sysmacros.h>. For historical compatibility, it is
|  currently defined by <sys/types.h> as well, but we plan to
|  remove this soon. To use "makedev", include <sys/sysmacros.h>
|  directly. If you did not intend to use a system-defined macro
|  "makedev", you should undefine it after including <sys/types.h>. [-Werror]
|           makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
|              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Maxin B. John <maxin.john@intel.com>
---
 mdadm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mdadm.h b/mdadm.h
index 55c707a..dce5f82 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -34,6 +34,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #endif
 
 #include	<sys/types.h>
+#include	<sys/sysmacros.h>
 #include	<sys/stat.h>
 #include	<stdint.h>
 #include	<stdlib.h>
-- 
2.4.0

