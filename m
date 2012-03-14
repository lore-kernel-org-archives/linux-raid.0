From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.64156.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It seems that with recent kernel, writeback can still be happening
while shutdown is happening, and consequently data can be written
after the md reboot notifier switches all arrays to read-only.
This causes a BUG.

So don't switch them to read-only - just mark them clean and
set 'safemode' to '2' which mean that immediately after any
write the array will be switch back to 'clean'.

This could result in the shutdown happening when array is marked
dirty, thus forcing a resync on reboot.  However if you reboot
without performing a "sync" first, you get to keep both halves.

This is suitable for any stable kernel (though there might be some
conflicts with obvious fixes in earlier kernels).

Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ca53c6..f494e79 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8157,30 +8157,23 @@ static int md_notify_reboot(struct notifier_block *this,
 	struct mddev *mddev;
 	int need_delay = 0;
 
-	if ((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) {
-
-		printk(KERN_INFO "md: stopping all md devices.\n");
-
-		for_each_mddev(mddev, tmp) {
-			if (mddev_trylock(mddev)) {
-				/* Force a switch to readonly even array
-				 * appears to still be in use.  Hence
-				 * the '100'.
-				 */
-				md_set_readonly(mddev, 100);
-				mddev_unlock(mddev);
-			}
-			need_delay = 1;
+	for_each_mddev(mddev, tmp) {
+		if (mddev_trylock(mddev)) {
+			__md_stop_writes(mddev);
+			mddev->safemode = 2;
+			mddev_unlock(mddev);
 		}
-		/*
-		 * certain more exotic SCSI devices are known to be
-		 * volatile wrt too early system reboots. While the
-		 * right place to handle this issue is the given
-		 * driver, we do want to have a safe RAID driver ...
-		 */
-		if (need_delay)
-			mdelay(1000*1);
+		need_delay = 1;
 	}
+	/*
+	 * certain more exotic SCSI devices are known to be
+	 * volatile wrt too early system reboots. While the
+	 * right place to handle this issue is the given
+	 * driver, we do want to have a safe RAID driver ...
+	 */
+	if (need_delay)
+		mdelay(1000*1);
+
 	return NOTIFY_DONE;
 }
 


