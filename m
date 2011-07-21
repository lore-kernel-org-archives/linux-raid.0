From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/36] md: add 'write_error' flag to component devices.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.63231.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a device has ever seen a write error, we will want to handle
known-bad-blocks differently.
So create an appropriate state flag and export it via sysfs.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   12 ++++++++++++
 drivers/md/md.h |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 430bc8b..aa96ead 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2520,6 +2520,10 @@ state_show(mdk_rdev_t *rdev, char *page)
 		len += sprintf(page+len, "%sspare", sep);
 		sep = ",";
 	}
+	if (test_bit(WriteErrorSeen, &rdev->flags)) {
+		len += sprintf(page+len, "%swrite_error", sep);
+		sep = ",";
+	}
 	return len+sprintf(page+len, "\n");
 }
 
@@ -2534,6 +2538,8 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	 *  blocked - sets the Blocked flag
 	 *  -blocked - clears the Blocked flag
 	 *  insync - sets Insync providing device isn't active
+	 *  write_error - sets WriteErrorSeen
+	 *  -write_error - clears WriteErrorSeen
 	 */
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
@@ -2569,6 +2575,12 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "insync") && rdev->raid_disk == -1) {
 		set_bit(In_sync, &rdev->flags);
 		err = 0;
+	} else if (cmd_match(buf, "write_error")) {
+		set_bit(WriteErrorSeen, &rdev->flags);
+		err = 0;
+	} else if (cmd_match(buf, "-write_error")) {
+		clear_bit(WriteErrorSeen, &rdev->flags);
+		err = 0;
 	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index eb11449..723c0cd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -84,6 +84,9 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occurred on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
+#define WriteErrorSeen	9		/* A write error has been seen on this
+					 * device
+					 */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */


