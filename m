From: Terje Rosten <terjeros@phys.ntnu.no>
Subject: [PATCH][TRIVIAL] fix typo in md.c
Date: Tue, 21 Sep 2004 20:15:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yojllf3zdxi.fsf@bohm.phys.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Fix typo in drivers/md/md.c

 - Terje


diff -u -r1.215 md.c
--- drivers/md/md.c	14 Sep 2004 14:47:27 -0000	1.215
+++ drivers/md/md.c	16 Sep 2004 11:19:09 -0000
@@ -1846,7 +1846,7 @@
 
 	err = do_md_run (mddev);
 	if (err) {
-		printk(KERN_WARNING "md :do_md_run() returned %d\n", err);
+		printk(KERN_WARNING "md: do_md_run() returned %d\n", err);
 		do_md_stop (mddev, 0);
 	}
 }

