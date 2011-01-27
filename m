From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] md: do not write resync checkpoint,
	if max_sector has been reached.
Date: Thu, 27 Jan 2011 17:50:15 +0100
Message-ID: <20110127165015.7884.8099.stgit@gklab-128-080.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If disk fails during resync, sync service of personality usually skips the
rest of not synchronized stripes. It finishes sync thread (md_do_sync())
and wakes up the main raid thread. md_recovery_check() starts and
unregisteres sync thread.
In the meanwhile mdmon also services failed disk - removes and replaces it
with a new one (if it was available).
If checkpoint is stored (with value of array's max_sector), next
md_recovery_check() will restart resync. It finishes normally and
activates ALL spares (including the one added recently) what is wrong.
Another md_recovery_check() will not start recovery as all disks are in
sync. If checkpoint is not stored, second resync does not start and
recovery can proceed.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3e40aad..6eda858 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6929,7 +6929,8 @@ void md_do_sync(mddev_t *mddev)
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
+			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+			    mddev->curr_resync < max_sectors) {
 				if (mddev->curr_resync >= mddev->recovery_cp) {
 					printk(KERN_INFO
 					       "md: checkpointing %s of %s.\n",

