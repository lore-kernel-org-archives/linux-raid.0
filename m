From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/md/raid1.c: make a function static
Date: Mon, 22 Aug 2005 22:10:43 +0200
Message-ID: <20050822201043.GG9927@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This patch makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.13-rc6-mm1-full/drivers/md/raid1.c.old	2005-08-22 02:50:14.000000000 +0200
+++ linux-2.6.13-rc6-mm1-full/drivers/md/raid1.c	2005-08-22 02:50:31.000000000 +0200
@@ -1703,7 +1703,7 @@
 	return 0;
 }
 
-void raid1_quiesce(mddev_t *mddev, int state)
+static void raid1_quiesce(mddev_t *mddev, int state)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 

