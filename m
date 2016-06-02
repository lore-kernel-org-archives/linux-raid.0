From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 14/18] md/raid5: add rcu protection to rdev accesses in
 want_replace
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.2738.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Being in the middle of resync is no longer protection against failed
rdevs disappearing.  So add rcu protection.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e9ad22d64bd7..7da89ee22a31 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3239,15 +3239,16 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 {
 	struct md_rdev *rdev;
 	int rv = 0;
-	/* Doing recovery so rcu locking not required */
-	rdev = sh->raid_conf->disks[disk_idx].replacement;
+
+	rcu_read_lock();
+	rdev = rcu_dereference(sh->raid_conf->disks[disk_idx].replacement);
 	if (rdev
 	    && !test_bit(Faulty, &rdev->flags)
 	    && !test_bit(In_sync, &rdev->flags)
 	    && (rdev->recovery_offset <= sh->sector
 		|| rdev->mddev->recovery_cp <= sh->sector))
 		rv = 1;
-
+	rcu_read_unlock();
 	return rv;
 }
 


