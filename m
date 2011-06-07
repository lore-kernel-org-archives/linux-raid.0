From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 8] MD:  possible typo
Date: Tue, 07 Jun 2011 17:48:35 -0500
Message-ID: <1307486915.31279.9.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Make message a bit clearer by s/blocks/k/

I chose 'k' vs 'kiB' or 'kB' because it is what is used earlier in the
message.  'k' may be a bit ambigous, but I think it's better than "blocks"
which normally means 512, but means 1024 in MD.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -6866,8 +6866,8 @@ void md_do_sync(mddev_t *mddev)
 	 * Tune reconstruction:
 	 */
 	window = 32*(PAGE_SIZE/512);
-	printk(KERN_INFO "md: using %dk window, over a total of %llu blocks.\n",
-		window/2,(unsigned long long) max_sectors/2);
+	printk(KERN_INFO "md: using %dk window, over a total of %lluk.\n",
+		window/2, (unsigned long long)max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
 	last_check = 0;


