From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 6 of 12 - Include asm-i386/387.h in asm-i386/xor.h
Date: Wed, 12 Mar 2003 14:59:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOz-0004q2-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

It is needed for kernel_fpu_*

 ----------- Diffstat output ------------
 ./include/asm-i386/xor.h |    1 +
 1 files changed, 1 insertion(+)

diff ./include/asm-i386/xor.h~current~ ./include/asm-i386/xor.h
--- ./include/asm-i386/xor.h~current~	2003-03-12 13:12:19.000000000 +1100
+++ ./include/asm-i386/xor.h	2003-03-12 13:15:03.000000000 +1100
@@ -25,6 +25,7 @@
 #define XO3(x,y)	"       pxor   8*("#x")(%4), %%mm"#y"   ;\n"
 #define XO4(x,y)	"       pxor   8*("#x")(%5), %%mm"#y"   ;\n"
 
+#include <asm/i387.h>
 
 static void
 xor_pII_mmx_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
