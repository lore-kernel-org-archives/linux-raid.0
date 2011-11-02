From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/17] md/raid1: If there is a spare and a replaceable
 device, start replacement.
Date: Wed, 02 Nov 2011 16:25:45 +1100
Message-ID: <20111102052544.17566.25820.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When attempting to add a spare to a RAID1 array, also consider
adding it as a replacement for a replaceable device.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 01cf420..968428e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1315,8 +1315,9 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
-	for (mirror = first; mirror <= last; mirror++)
-		if ( !(p=conf->mirrors+mirror)->rdev) {
+	for (mirror = first; mirror <= last; mirror++) {
+		p = conf->mirrors+mirror;
+		if (!p->rdev) {
 
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
@@ -1343,6 +1344,18 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
+		if (test_bit(Replaceable, &p->rdev->flags) &&
+		    p[conf->raid_disks].rdev == NULL) {
+			/* Add this device as a replacement */
+			clear_bit(In_sync, &rdev->flags);
+			set_bit(Replacement, &rdev->flags);
+			rdev->raid_disk = mirror;
+			err = 0;
+			conf->fullsync = 1;
+			rcu_assign_pointer(p[conf->raid_disks].rdev, rdev);
+			break;
+		}
+	}
 	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;


