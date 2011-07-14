From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD: generate an event when array sync is complete
Date: Thu, 14 Jul 2011 15:59:25 -0500
Message-ID: <1310677165.2246.12.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I'm not sure this is the best place in the code to put this (even though
I've tested that it works well).  I welcome your corrections.

 brassow

This patch causes MD to generate an event (for device-mapper) once array
synchronization is complete.  This is expected behavior for device-mapper.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -7328,6 +7328,9 @@ void md_check_recovery(mddev_t *mddev)
 	unlock:
 		if (!mddev->sync_thread) {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+			if (mddev->event_work.func && !mddev->recovery &&
+			    (mddev->recovery_cp == MaxSector))
+				queue_work(md_misc_wq, &mddev->event_work);
 			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
 					       &mddev->recovery))
 				if (mddev->sysfs_action)


