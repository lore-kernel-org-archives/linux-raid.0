From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Fix newly introduced read-corruption with raid6.
Date: Tue, 14 Nov 2006 11:22:36 +1100
Message-ID: <1061114002236.31168@suse.de>
References: <20061114111600.31061.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933246AbWKNAXS@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


chunk_aligned_read and retry_aligned_read assume that
    data_disks == raid_disks - 1
which is not true for raid6.
So when an aligned read request bypasses the cache, we can get the wrong data.

Also change the calculate of raid_disks in compute_blocknr to make it
more obviously correct.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-14 10:33:41.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-14 10:34:17.000000000 +1100
@@ -823,7 +823,8 @@ static sector_t raid5_compute_sector(sec
 static sector_t compute_blocknr(struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = sh->disks, data_disks = raid_disks - 1;
+	int raid_disks = sh->disks;
+	int data_disks = raid_disks - conf->max_degraded;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
@@ -859,7 +860,6 @@ static sector_t compute_blocknr(struct s
 		}
 		break;
 	case 6:
-		data_disks = raid_disks - 2;
 		if (i == raid6_next_disk(sh->pd_idx, raid_disks))
 			return 0; /* It is the Q disk */
 		switch (conf->algorithm) {
@@ -2725,7 +2725,7 @@ static int chunk_aligned_read(request_qu
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	const unsigned int raid_disks = conf->raid_disks;
-	const unsigned int data_disks = raid_disks - 1;
+	const unsigned int data_disks = raid_disks - conf->max_degraded;
 	unsigned int dd_idx, pd_idx;
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
@@ -3145,7 +3145,7 @@ static int  retry_aligned_read(raid5_con
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(	logical_sector,
 					conf->raid_disks,
-					conf->raid_disks-1,
+					conf->raid_disks - conf->max_degraded,
 					&dd_idx,
 					&pd_idx,
 					conf);
