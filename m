From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 13 of 14 - Remove dependance on MD_SB_DISKS in linear personality
Date: Tue, 27 May 2003 13:01:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUiA-0003Hf-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Linear uses one array sized by MD_SB_DISKS inside a structure.
We move it to the end of the structure, declare it as size 0,
and arrange for approprate extra space to be allocated on 
structure allocation.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c         |    3 ++-
 ./include/linux/raid/linear.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-05-27 12:01:31.000000000 +1000
+++ ./drivers/md/linear.c	2003-05-27 12:01:35.000000000 +1000
@@ -89,7 +89,8 @@ static int linear_run (mddev_t *mddev)
 	unsigned int curr_offset;
 	struct list_head *tmp;
 
-	conf = kmalloc (sizeof (*conf), GFP_KERNEL);
+	conf = kmalloc (sizeof (*conf) + mddev->raid_disks*sizeof(dev_info_t),
+			GFP_KERNEL);
 	if (!conf)
 		goto out;
 	memset(conf, 0, sizeof(*conf));

diff ./include/linux/raid/linear.h~current~ ./include/linux/raid/linear.h
--- ./include/linux/raid/linear.h~current~	2003-05-27 12:01:31.000000000 +1000
+++ ./include/linux/raid/linear.h	2003-05-27 12:01:35.000000000 +1000
@@ -19,9 +19,9 @@ struct linear_hash
 struct linear_private_data
 {
 	struct linear_hash	*hash_table;
-	dev_info_t		disks[MD_SB_DISKS];
 	dev_info_t		*smallest;
 	int			nr_zones;
+	dev_info_t		disks[0];
 };
 
 
