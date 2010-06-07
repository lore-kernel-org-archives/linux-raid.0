From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/16] md: add 'write_error' flag to component devices.
Date: Mon, 07 Jun 2010 10:07:55 +1000
Message-ID: <20100607000755.13302.4029.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
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
index 8a888d5..20c6792 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2430,6 +2430,10 @@ state_show(mdk_rdev_t *rdev, char *page)
 		len += sprintf(page+len, "%sspare", sep);
 		sep = ",";
 	}
+	if (test_bit(WriteErrorSeen, &rdev->flags)) {
+		len += sprintf(page+len, "%swrite_error", sep);
+		sep = ",";
+	}
 	return len+sprintf(page+len, "\n");
 }
 
@@ -2444,6 +2448,8 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	 *  blocked - sets the Blocked flag
 	 *  -blocked - clears the Blocked flag
 	 *  insync - sets Insync providing device isn't active
+	 *  write_error - sets WriteErrorSeen
+	 *  -write_error - clears WriteErrorSeen
 	 */
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
@@ -2479,6 +2485,12 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
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
index 087764b..a085df5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -100,6 +100,9 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occured on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
+#define WriteErrorSeen	9		/* A write error has been seen on this
+					 * device
+					 */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */


