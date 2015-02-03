From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/26] md: remove need for mddev_lock() in md_seq_show()
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.55762.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The only access in md_seq_show that could suffer from races
not protected by ->lock is walking the rdev list.
This can receive sufficient protection from 'rcu'.

So use rdev_for_each_rcu() and get rid of mddev_lock().

Now reading /proc/mdstat will never block in md_seq_show.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 421d47e2d457..4caa414fe6a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6950,9 +6950,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		return 0;
 	}
 
-	if (mddev_lock(mddev) < 0)
-		return -EINTR;
-
 	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
@@ -6966,7 +6963,8 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		}
 
 		sectors = 0;
-		rdev_for_each(rdev, mddev) {
+		rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev) {
 			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
@@ -6982,6 +6980,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 				seq_printf(seq, "(R)");
 			sectors += rdev->sectors;
 		}
+		rcu_read_unlock();
 
 		if (!list_empty(&mddev->disks)) {
 			if (mddev->pers)
@@ -7025,7 +7024,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\n");
 	}
 	spin_unlock(&mddev->lock);
-	mddev_unlock(mddev);
 
 	return 0;
 }


