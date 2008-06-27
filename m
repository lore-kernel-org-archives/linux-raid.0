From: NeilBrown <neilb@suse.de>
Subject: [PATCH 017 of 29] md: Make sure all changes to md/dev-XX/state are notified
Date: Fri, 27 Jun 2008 16:51:10 +1000
Message-ID: <1080627065110.10579@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


The important state change happens during an interrupt
in md_error.  So just set a flag there and call sysfs_notify
later in process context.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt      |   10 ++++++++++
 ./drivers/md/md.c           |   14 +++++++++++++-
 ./include/linux/raid/md_k.h |    3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff .prev/Documentation/md.txt ./Documentation/md.txt
--- .prev/Documentation/md.txt	2008-06-27 16:22:02.000000000 +1000
+++ ./Documentation/md.txt	2008-06-27 16:22:03.000000000 +1000
@@ -297,6 +297,10 @@ Each directory contains:
 	      writemostly - device will only be subject to read
 		         requests if there are no other options.
 			 This applies only to raid1 arrays.
+	      blocked  - device has failed, metadata is "external",
+	                 and the failure hasn't been acknowledged yet.
+			 Writes that would write to this device if
+			 it were not faulty are blocked.
 	      spare    - device is working, but not a full member.
 			 This includes spares that are in the process
 			 of being recovered to
@@ -306,6 +310,12 @@ Each directory contains:
 	Writing "remove" removes the device from the array.
 	Writing "writemostly" sets the writemostly flag.
 	Writing "-writemostly" clears the writemostly flag.
+	Writing "blocked" sets the "blocked" flag.
+	Writing "-blocked" clear the "blocked" flag and allows writes
+		to complete.
+
+	This file responds to select/poll. Any change to 'faulty'
+	or 'blocked' causes an event.
 
       errors
 	An approximate count of read errors that have been detected on

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:22:02.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:03.000000000 +1000
@@ -1886,6 +1886,8 @@ state_store(mdk_rdev_t *rdev, const char
 
 		err = 0;
 	}
+	if (!err)
+		sysfs_notify(&rdev->kobj, NULL, "state");
 	return err ? err : len;
 }
 static struct rdev_sysfs_entry rdev_state =
@@ -1979,7 +1981,8 @@ slot_store(mdk_rdev_t *rdev, const char 
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
-		}
+		} else
+			sysfs_notify(&rdev->kobj, NULL, "state");
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		if (sysfs_create_link(&rdev->mddev->kobj, &rdev->kobj, nm))
 			printk(KERN_WARNING
@@ -1996,6 +1999,7 @@ slot_store(mdk_rdev_t *rdev, const char 
 		clear_bit(Faulty, &rdev->flags);
 		clear_bit(WriteMostly, &rdev->flags);
 		set_bit(In_sync, &rdev->flags);
+		sysfs_notify(&rdev->kobj, NULL, "state");
 	}
 	return len;
 }
@@ -3525,6 +3529,7 @@ static int do_md_run(mddev_t * mddev)
 				return -EINVAL;
 			}
 		}
+		sysfs_notify(&rdev->kobj, NULL, "state");
 	}
 
 	md_probe(mddev->unit, NULL, NULL);
@@ -4256,6 +4261,8 @@ static int add_new_disk(mddev_t * mddev,
 		}
 		if (err)
 			export_rdev(rdev);
+		else
+			sysfs_notify(&rdev->kobj, NULL, "state");
 
 		md_update_sb(mddev, 1);
 		if (mddev->degraded)
@@ -5115,6 +5122,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	mddev->pers->error_handler(mddev,rdev);
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+	set_bit(StateChanged, &rdev->flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -6037,6 +6045,10 @@ void md_check_recovery(mddev_t *mddev)
 		if (mddev->flags)
 			md_update_sb(mddev, 0);
 
+		rdev_for_each(rdev, rtmp, mddev)
+			if (test_and_clear_bit(StateChanged, &rdev->flags))
+				sysfs_notify(&rdev->kobj, NULL, "state");
+
 
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-06-27 16:22:02.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-06-27 16:22:03.000000000 +1000
@@ -87,6 +87,9 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occured on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
+#define StateChanged	9		/* Faulty or Blocked has changed during
+					 * interrupt, so it needs to be
+					 * notified by the thread */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */
