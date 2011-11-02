From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/17] md/raid1: Replace use of mddev->raid_disks with
 conf->raid_disks.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.93951.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In general mddev->raid_disks can change unexpectedly while
conf->raid_disks will only change in a very controlled way.  So change
some uses of one to the other.

The use of mddev->raid_disks will not cause actually problems but
this way is more consistent and safer in the long term.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a52979b..74d4ce5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -276,7 +276,8 @@ static inline void update_head_pos(int disk, struct r1bio *r1_bio)
 static int find_bio_disk(struct r1bio *r1_bio, struct bio *bio)
 {
 	int mirror;
-	int raid_disks = r1_bio->mddev->raid_disks;
+	struct r1conf *conf = r1_bio->mddev->private;
+	int raid_disks = conf->raid_disks;
 
 	for (mirror = 0; mirror < raid_disks; mirror++)
 		if (r1_bio->bios[mirror] == bio)
@@ -608,7 +609,7 @@ int md_raid1_congested(struct mddev *mddev, int bits)
 		return 1;
 
 	rcu_read_lock();
-	for (i = 0; i < mddev->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -1287,7 +1288,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int mirror = 0;
 	struct mirror_info *p;
 	int first = 0;
-	int last = mddev->raid_disks - 1;
+	int last = conf->raid_disks - 1;
 
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;


