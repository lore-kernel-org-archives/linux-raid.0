From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 3 of 22 - Remove md_maxreadahead
Date: Wed, 19 Jun 2002 10:47:46 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54450.898431.950894@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



..as it is nolonger used.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    3 ---
 1 files changed, 3 deletions(-)

--- ./drivers/md/md.c	2002/06/18 03:26:36	1.3
+++ ./drivers/md/md.c	2002/06/18 03:31:03	1.4
@@ -106,7 +106,6 @@
  * subsystems want to have a pre-defined structure
  */
 struct hd_struct md_hd_struct[MAX_MD_DEVS];
-static int md_maxreadahead[MAX_MD_DEVS];
 static mdk_thread_t *md_recovery_thread;
 
 int md_size[MAX_MD_DEVS];
@@ -1579,7 +1578,6 @@
 		if (sb->level == -3)
 			readahead = 0;
 	}
-	md_maxreadahead[mdidx(mddev)] = readahead;
 
 	printk(KERN_INFO "md%d: max total readahead window set to %ldk\n",
 		mdidx(mddev), readahead*(PAGE_SIZE/1024));
@@ -3614,7 +3612,6 @@
 
 	for(i = 0; i < MAX_MD_DEVS; i++) {
 		md_size[i] = 0;
-		md_maxreadahead[i] = 32;
 	}
 	blk_size[MAJOR_NR] = md_size;
 
