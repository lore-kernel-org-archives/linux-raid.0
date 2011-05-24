From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 1 of 9] MD:  possible typo
Date: Mon, 23 May 2011 22:05:58 -0500
Message-ID: <201105240305.p4O35wmb029220@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-possible-typo.patch

Fix a value printed in kiB but labeled as 'blocks'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -6867,7 +6867,7 @@ void md_do_sync(mddev_t *mddev)
 	 */
 	window = 32*(PAGE_SIZE/512);
 	printk(KERN_INFO "md: using %dk window, over a total of %llu blocks.\n",
-		window/2,(unsigned long long) max_sectors/2);
+		window/2, (unsigned long long) max_sectors);
 
 	atomic_set(&mddev->recovery_active, 0);
 	last_check = 0;
