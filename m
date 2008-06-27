From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 29] md: Ensure interrupted recovery completed properly (v1 metadata plus bitmap)
Date: Fri, 27 Jun 2008 16:49:23 +1000
Message-ID: <1080627064923.10270@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids


If, while assembling an array, we find a device which is not fully
in-sync with the array, it is important to set the "fullsync" flags.
This is an exact analog to the setting of this flag in hot_add_disk
methods.

Currently, only v1.x metadata supports having devices in an array
which are not fully in-sync (it keep track of how in sync they are).
The 'fullsync' flag only makes a difference when a write-intent bitmap
is being used.  In this case it tells recovery to ignore the bitmap
and recovery all blocks.

This fix is already in place for raid1, but not raid5/6 or raid10.

So without this fix, a raid1 ir raid4/5/6 array with version 1.x
metadata and a write intent bitmaps, that is stopped in the middle
of a recovery, will appear to complete the recovery instantly
after it is reassembled, but the recovery will not be correct.

If you might have an array like that, issueing
   echo repair > /sys/block/mdXX/md/sync_action

will make sure recovery completes properly.

Cc: <stable@kernel.org>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    2 ++
 ./drivers/md/raid5.c  |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-06-27 15:14:05.000000000 +1000
+++ ./drivers/md/raid10.c	2008-06-27 15:19:36.000000000 +1000
@@ -2137,6 +2137,8 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
+			if (disk->rdev)
+				conf->fullsync = 1;
 		}
 	}
 

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 15:14:05.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 15:19:36.000000000 +1000
@@ -4305,7 +4305,9 @@ static int run(mddev_t *mddev)
 				" disk %d\n", bdevname(rdev->bdev,b),
 				raid_disk);
 			working_disks++;
-		}
+		} else
+			/* Cannot rely on bitmap to complete recovery */
+			conf->fullsync = 1;
 	}
 
 	/*
