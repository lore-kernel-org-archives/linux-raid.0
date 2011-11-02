From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/17] md/raid1: recognise replacements when assembling
 arrays.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.9533.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a Replacement is seen, file it as such.

If we see two replacements (or two normal devices) for the one slot,
abort.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5307e73..01cf420 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2453,14 +2453,20 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
 	conf->poolinfo->mddev = mddev;
 
+	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		int disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
 			continue;
-		disk = conf->mirrors + disk_idx;
+		if (test_bit(Replacement, &rdev->flags))
+			disk = conf->mirrors + conf->raid_disks + disk_idx;
+		else
+			disk = conf->mirrors + disk_idx;
 
+		if (disk->rdev)
+			goto abort;
 		disk->rdev = rdev;
 
 		disk->head_position = 0;
@@ -2476,11 +2482,27 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	conf->pending_count = 0;
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
+	err = -EIO;
 	conf->last_used = -1;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 
 		disk = conf->mirrors + i;
 
+		if (i < conf->raid_disks &&
+		    disk[conf->raid_disks].rdev) {
+			/* This slot has a replacement. */
+			if (!disk->rdev) {
+				/* No original, just make the replacement
+				 * a recovering spare
+				 */
+				disk->rdev =
+					disk[conf->raid_disks].rdev;
+				disk[conf->raid_disks].rdev = NULL;
+			} else if (!test_bit(In_sync, &disk->rdev->flags))
+				/* Original is not in_sync - bad */
+				goto abort;
+		}
+
 		if (!disk->rdev ||
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
@@ -2494,7 +2516,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 			conf->last_used = i;
 	}
 
-	err = -EIO;
 	if (conf->last_used < 0) {
 		printk(KERN_ERR "md/raid1:%s: no operational mirrors\n",
 		       mdname(mddev));


