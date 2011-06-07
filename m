From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 8] MD:  no sync IO while suspended
Date: Tue, 07 Jun 2011 17:47:49 -0500
Message-ID: <1307486869.31279.7.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Disallow resync I/O while the RAID array is suspended.

Recovery, resync, and metadata I/O should not be allowed while a device is
suspended.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -7045,7 +7045,6 @@ void md_do_sync(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_do_sync);
 
-
 static int remove_and_add_spares(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
@@ -7157,6 +7156,9 @@ static void reap_sync_thread(mddev_t *md
  */
 void md_check_recovery(mddev_t *mddev)
 {
+	if (mddev->suspended)
+		return;
+
 	if (mddev->bitmap)
 		bitmap_daemon_work(mddev);
 


