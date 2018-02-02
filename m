From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/2] md: only allow remove_and_add_spares when no
 sync_thread running.
Date: Sat, 03 Feb 2018 09:19:30 +1100
Message-ID: <151760997028.5944.10292479373004611829.stgit@noble>
References: <151760990726.5944.15903931975424856346.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <151760990726.5944.15903931975424856346.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, yuyufen <yuyufen@huawei.com>, colyli@suse.de
List-Id: linux-raid.ids

The locking protocols in md assume that a device will
never be removed from an array during resync/recovery/reshape.
When that isn't happening, rcu or reconfig_mutex is needed
to protect an rdev pointer while taking a refcount.  When
it is happening, that protection isn't needed.

Unfortunately there are cases were remove_and_add_spares() is
called when recovery might be happening: is state_store(),
slot_store() and hot_remove_disk().
In each case, this is just an optimization, to try to expedite
removal from the personality so the device can be removed from
the array.  If resync etc is happening, we just have to wait
for md_check_recover to find a suitable time to call
remove_and_add_spares().

This optimization and not essential so it doesn't
matter if it fails.
So change remove_and_add_spares() to abort early if
resync/recovery/reshape is happening, unless it is called
from md_check_recovery() as part of a newly started recovery.
The parameter "this" is only NULL when called from
md_check_recovery() so when it is NULL, there is no need to abort.

As this can result in a NULL dereference, the fix is suitable
for -stable.

cc: yuyufen <yuyufen@huawei.com>
Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Fixes: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
Cc: stable@ver.kernel.org (v4.8+)
Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c    |    4 ++++
 drivers/md/raid5.c |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e4dee0ec2de..926542fbc892 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8554,6 +8554,10 @@ static int remove_and_add_spares(struct mddev *mddev,
 	int removed = 0;
 	bool remove_some = false;
 
+	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		/* Mustn't remove devices when resync thread is running */
+		return 0;
+
 	rdev_for_each(rdev, mddev) {
 		if ((this == NULL || rdev == this) &&
 		    rdev->raid_disk >= 0 &&
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 98ce4272ace9..3fa97dad3837 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4448,12 +4448,12 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		else if (is_bad) {
 			/* also not in-sync */
 			if (!test_bit(WriteErrorSeen, &rdev->flags) &&
-			    test_bit(R5_UPTODATE, &dev->flags)) {
+			    (test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_OVERWRITE, &dev->flags))) {
 				/* treat as in-sync, but with a read error
 				 * which we can now try to correct
 				 */
 				set_bit(R5_Insync, &dev->flags);
-				set_bit(R5_ReadError, &dev->flags);
+				//set_bit(R5_ReadError, &dev->flags);
 			}
 		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);


