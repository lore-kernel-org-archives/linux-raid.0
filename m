From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 5] md: Fix device-size updates in md.
Date: Tue, 24 Jan 2006 14:58:22 +1100
Message-ID: <1060124035822.28811@suse.de>
References: <20060124145516.28734.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


As 'array_size'  is a 'sector_t', it may overflow inappropriately 
when shifted 10 bits. So We should cast it to a loff_t first.

There are two places with this problem, but the second (in update_raid_disks) 
isn't needed so just remove it:
  The only personality that handles ->reshape currently is raid1,
  and it doesn't change the size of the array.
  When added for raid5/6, reshape again won't change the size of the array,
  at least not straight away.
  This code might be need for reshaping 'linear' but linear->shape,
  if implemented, should probably do the i_size_write itself.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-01-24 13:30:25.000000000 +1100
+++ ./drivers/md/md.c	2006-01-24 13:32:25.000000000 +1100
@@ -3466,7 +3466,7 @@ static int update_size(mddev_t *mddev, u
 		bdev = bdget_disk(mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, mddev->array_size << 10);
+			i_size_write(bdev->bd_inode, (loff_t)mddev->array_size << 10);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
@@ -3486,17 +3486,6 @@ static int update_raid_disks(mddev_t *md
 	if (mddev->sync_thread)
 		return -EBUSY;
 	rv = mddev->pers->reshape(mddev, raid_disks);
-	if (!rv) {
-		struct block_device *bdev;
-
-		bdev = bdget_disk(mddev->gendisk, 0);
-		if (bdev) {
-			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, mddev->array_size << 10);
-			mutex_unlock(&bdev->bd_inode->i_mutex);
-			bdput(bdev);
-		}
-	}
 	return rv;
 }
 
