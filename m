From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 12 - C99 initiailzers for xor.h
Date: Wed, 12 Mar 2003 14:59:36 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOy-0004pm-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

From: Art Haas <ahaas@airmail.net>

This patch converts the file to use C99 initializers. 

 ----------- Diffstat output ------------
 ./include/asm-generic/xor.h |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff ./include/asm-generic/xor.h~current~ ./include/asm-generic/xor.h
--- ./include/asm-generic/xor.h~current~	2003-03-12 09:49:53.000000000 +1100
+++ ./include/asm-generic/xor.h	2003-03-12 09:49:53.000000000 +1100
@@ -678,35 +678,35 @@ xor_32regs_p_5(unsigned long bytes, unsi
 }
 
 static struct xor_block_template xor_block_8regs = {
-	name: "8regs",
-	do_2: xor_8regs_2,
-	do_3: xor_8regs_3,
-	do_4: xor_8regs_4,
-	do_5: xor_8regs_5,
+	.name = "8regs",
+	.do_2 = xor_8regs_2,
+	.do_3 = xor_8regs_3,
+	.do_4 = xor_8regs_4,
+	.do_5 = xor_8regs_5,
 };
 
 static struct xor_block_template xor_block_32regs = {
-	name: "32regs",
-	do_2: xor_32regs_2,
-	do_3: xor_32regs_3,
-	do_4: xor_32regs_4,
-	do_5: xor_32regs_5,
+	.name = "32regs",
+	.do_2 = xor_32regs_2,
+	.do_3 = xor_32regs_3,
+	.do_4 = xor_32regs_4,
+	.do_5 = xor_32regs_5,
 };
 
 static struct xor_block_template xor_block_8regs_p = {
-	name: "8regs_prefetch",
-	do_2: xor_8regs_p_2,
-	do_3: xor_8regs_p_3,
-	do_4: xor_8regs_p_4,
-	do_5: xor_8regs_p_5,
+	.name = "8regs_prefetch",
+	.do_2 = xor_8regs_p_2,
+	.do_3 = xor_8regs_p_3,
+	.do_4 = xor_8regs_p_4,
+	.do_5 = xor_8regs_p_5,
 };
 
 static struct xor_block_template xor_block_32regs_p = {
-	name: "32regs_prefetch",
-	do_2: xor_32regs_p_2,
-	do_3: xor_32regs_p_3,
-	do_4: xor_32regs_p_4,
-	do_5: xor_32regs_p_5,
+	.name = "32regs_prefetch",
+	.do_2 = xor_32regs_p_2,
+	.do_3 = xor_32regs_p_3,
+	.do_4 = xor_32regs_p_4,
+	.do_5 = xor_32regs_p_5,
 };
 
 #define XOR_TRY_TEMPLATES			\
