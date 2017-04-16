From: Coly Li <colyli@suse.de>
Subject: [PATCH] mdadm: retire mdassemble in make everything
Date: Sun, 16 Apr 2017 15:01:29 +0800
Message-ID: <20170416070129.26071-1-colyli@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jes Sorensen <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

make everything reports no rule to make mdassemble, because mdassemble
is removed from mdadm. This patch removes mdassemble from "everything"
in Makefile, now there is no failure when compiling a static mdadm binary.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jes Sorensen <jes.sorensen@gmail.com>
---
 Makefile | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index a5d2a0a..5655812 100644
--- a/Makefile
+++ b/Makefile
@@ -169,12 +169,10 @@ check_rundir:
 	fi
 
 everything: all mdadm.static swap_super test_stripe raid6check \
-	mdassemble mdassemble.auto mdassemble.static mdassemble.man \
 	mdadm.Os mdadm.O2 man
 everything-test: all mdadm.static swap_super test_stripe \
-	mdassemble.auto mdassemble.static mdassemble.man \
 	mdadm.Os mdadm.O2 man
-# mdadm.uclibc and mdassemble.uclibc don't work on x86-64
+# mdadm.uclibc doesn't work on x86-64
 # mdadm.tcc doesn't work..
 
 mdadm : $(OBJS) | check_rundir
@@ -226,9 +224,6 @@ md.man : md.4
 mdadm.conf.man : mdadm.conf.5
 	man -l mdadm.conf.5 > mdadm.conf.man
 
-mdassemble.man : mdassemble.8
-	man -l mdassemble.8 > mdassemble.man
-
 raid6check.man : raid6check.8
 	man -l raid6check.8 > raid6check.man
 
@@ -293,9 +288,7 @@ test: mdadm mdmon test_stripe swap_super raid6check
 clean :
 	rm -f mdadm mdmon $(OBJS) $(MON_OBJS) $(STATICOBJS) core *.man \
 	mdadm.tcc mdadm.uclibc mdadm.static *.orig *.porig *.rej *.alt .merge_file_* \
-	mdadm.Os mdadm.O2 mdmon.O2 \
-	mdassemble mdassemble.static mdassemble.auto mdassemble.uclibc \
-	mdassemble.klibc swap_super \
+	mdadm.Os mdadm.O2 mdmon.O2 swap_super \
 	init.cpio.gz mdadm.uclibc.static test_stripe raid6check raid6check.o mdmon \
 	mdadm.8
 
-- 
2.10.2

