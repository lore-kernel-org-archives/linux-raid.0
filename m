From: Art Haas <ahaas@airmail.net>
Subject: [PATCH] C99 initiailzers for xor.h
Date: Thu, 27 Feb 2003 15:38:19 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030227213819.GB8116@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@transmeta.com>
List-Id: linux-raid.ids

Hi.

This patch converts the file to use C99 initializers. It's against the
current BK.

Art Haas

===== include/asm-generic/xor.h 1.2 vs edited =====
--- 1.2/include/asm-generic/xor.h	Mon Oct 21 03:13:10 2002
+++ edited/include/asm-generic/xor.h	Thu Feb 27 10:27:14 2003
@@ -678,35 +678,35 @@
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
-- 
They that can give up essential liberty to obtain a little temporary safety
deserve neither liberty nor safety.
 -- Benjamin Franklin, Historical Review of Pennsylvania, 1759
