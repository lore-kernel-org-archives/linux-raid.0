From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH: remove sti() from calibrate_xor_block()
Date: Thu, 25 Jul 2002 11:35:49 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15679.22005.864496.660604@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: akpm@zip.com.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Inexplicably, xor.c enabled interrupts...  
 thanks to akmp

--- 2.5.28/drivers/md/xor.c~xor-sti	Wed Jul 24 15:35:58 2002
+++ 2.5.28-akpm/drivers/md/xor.c	Wed Jul 24 15:36:02 2002
@@ -109,7 +109,6 @@ calibrate_xor_block(void)
 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
 
 	printk(KERN_INFO "raid5: measuring checksumming speed\n");
-	sti();
 
 #define xor_speed(templ)	do_xor_speed((templ), b1, b2)
 

