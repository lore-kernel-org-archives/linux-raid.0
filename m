From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md/linear: shutup lockdep warnning
Date: Tue, 21 Feb 2017 13:55:19 -0800
Message-ID: <6ceac5d5f76023fe2b76dc053041c50f81775b12.1487714093.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

Commit 03a9e24(md linear: fix a race between linear_add() and
linear_congested()) introduces the warnning.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/linear.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 789008b..5b06b0d 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -224,7 +224,8 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	 * oldconf until no one uses it anymore.
 	 */
 	mddev_suspend(mddev);
-	oldconf = rcu_dereference(mddev->private);
+	oldconf = rcu_dereference_protected(mddev->private,
+			lockdep_is_held(&mddev->reconfig_mutex));
 	mddev->raid_disks++;
 	WARN_ONCE(mddev->raid_disks != newconf->raid_disks,
 		"copied raid_disks doesn't match mddev->raid_disks");
-- 
2.9.3

