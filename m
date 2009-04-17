From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 2/4] md: allow setting newly added device to 'in_sync' via
	sysfs.
Date: Fri, 17 Apr 2009 12:14:53 +1000
Message-ID: <20090417021453.13390.32772.stgit@notabene.brown>
References: <20090417020953.13390.5371.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417020953.13390.5371.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When adding devices to an active array via sysfs, there is currently
no way to mark a device as 'in-sync' which is useful when
incrementally assembling an array.

So add that option.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed5727c..298731b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2086,6 +2086,7 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	 *  -writemostly - clears write_mostly
 	 *  blocked - sets the Blocked flag
 	 *  -blocked - clears the Blocked flag
+	 *  insync - sets Insync providing device isn't active
 	 */
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
@@ -2118,6 +2119,9 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		md_wakeup_thread(rdev->mddev->thread);
 
 		err = 0;
+	} else if (cmd_match(buf, "insync") && rdev->raid_disk == -1) {
+		set_bit(In_sync, &rdev->flags);
+		err = 0;
 	}
 	if (!err && rdev->sysfs_state)
 		sysfs_notify_dirent(rdev->sysfs_state);
@@ -2190,7 +2194,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	} else if (rdev->mddev->pers) {
 		mdk_rdev_t *rdev2;
 		/* Activating a spare .. or possibly reactivating
-		 * if we every get bitmaps working here.
+		 * if we ever get bitmaps working here.
 		 */
 
 		if (rdev->raid_disk != -1)


