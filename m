From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 10 of 14 - Remove dependancy on MD_SB_DISKS from raid5
Date: Tue, 27 May 2003 13:01:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUiA-0003HO-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

One embeded array gets moved to end of structure and
sized dynamically.

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c         |    4 +++-
 ./include/linux/raid/raid5.h |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-05-27 11:58:25.000000000 +1000
+++ ./drivers/md/raid5.c	2003-05-27 11:58:27.000000000 +1000
@@ -1452,7 +1452,9 @@ static int run (mddev_t *mddev)
 		return -EIO;
 	}
 
-	mddev->private = kmalloc (sizeof (raid5_conf_t), GFP_KERNEL);
+	mddev->private = kmalloc (sizeof (raid5_conf_t)
+				  + mddev->raid_disks * sizeof(struct disk_info),
+				  GFP_KERNEL);
 	if ((conf = mddev->private) == NULL)
 		goto abort;
 	memset (conf, 0, sizeof (*conf));

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2003-05-27 11:58:25.000000000 +1000
+++ ./include/linux/raid/raid5.h	2003-05-27 11:58:27.000000000 +1000
@@ -202,7 +202,6 @@ struct disk_info {
 struct raid5_private_data {
 	struct stripe_head	**stripe_hashtbl;
 	mddev_t			*mddev;
-	struct disk_info	disks[MD_SB_DISKS];
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
 	int			raid_disks, working_disks, failed_disks;
@@ -224,6 +223,7 @@ struct raid5_private_data {
 							 * waiting for 25% to be free
 							 */        
 	spinlock_t		device_lock;
+	struct disk_info	disks[0];
 };
 
 typedef struct raid5_private_data raid5_conf_t;
