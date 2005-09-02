From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/md/raid1.c: make a function static
Date: Fri, 2 Sep 2005 03:23:53 +0200
Message-ID: <20050902012353.GN3657@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This patch makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 22 Aug 2005

--- linux-2.6.13-rc6-mm1-full/drivers/md/raid1.c.old	2005-08-22 02:50:14.000000000 +0200
+++ linux-2.6.13-rc6-mm1-full/drivers/md/raid1.c	2005-08-22 02:50:31.000000000 +0200
@@ -1703,7 +1703,7 @@
 	return 0;
 }
 
-void raid1_quiesce(mddev_t *mddev, int state)
+static void raid1_quiesce(mddev_t *mddev, int state)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 

