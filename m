From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 21 of 27 - nr_disks is gone from multipath/raid1
Date: Thu, 18 Jul 2002 23:34:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133410.5005@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
nr_disks is gone from multipath/raid1

Never used.



 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |    7 ++-----
 ./drivers/md/raid1.c             |    7 ++-----
 ./include/linux/raid/multipath.h |    1 -
 ./include/linux/raid/raid1.h     |    1 -
 4 files changed, 4 insertions(+), 12 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 12:06:48	1.12
+++ ./drivers/md/multipath.c	2002/07/18 12:07:31	1.13
@@ -274,8 +274,8 @@ static void print_multipath_conf (multip
 		printk("(conf==NULL)\n");
 		return;
 	}
-	printk(" --- wd:%d rd:%d nd:%d\n", conf->working_disks,
-			 conf->raid_disks, conf->nr_disks);
+	printk(" --- wd:%d rd:%d\n", conf->working_disks,
+			 conf->raid_disks);
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->multipaths + i;
@@ -303,7 +303,6 @@ static int multipath_add_disk(mddev_t *m
 		p->bdev = rdev->bdev;
 		p->operational = 1;
 		p->used_slot = 1;
-		conf->nr_disks++;
 		conf->working_disks++;
 		err = 0;
 	}
@@ -332,7 +331,6 @@ static int multipath_remove_disk(mddev_t
 		}
 		p->bdev = NULL;
 		p->used_slot = 0;
-		conf->nr_disks--;
 		err = 0;
 	}
 	if (err)
@@ -500,7 +498,6 @@ static int multipath_run (mddev_t *mddev
 	}
 
 	conf->raid_disks = sb->raid_disks = num_rdevs;
-	conf->nr_disks = num_rdevs;
 	mddev->sb_dirty = 1;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
--- ./drivers/md/raid1.c	2002/07/18 12:06:48	1.9
+++ ./drivers/md/raid1.c	2002/07/18 12:07:31	1.10
@@ -625,8 +625,8 @@ static void print_conf(conf_t *conf)
 		printk("(!conf)\n");
 		return;
 	}
-	printk(" --- wd:%d rd:%d nd:%d\n", conf->working_disks,
-			conf->raid_disks, conf->nr_disks);
+	printk(" --- wd:%d rd:%d\n", conf->working_disks,
+			conf->raid_disks);
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->mirrors + i;
@@ -803,7 +803,6 @@ static int raid1_add_disk(mddev_t *mddev
 		p->spare = 1;
 		p->used_slot = 1;
 		p->head_position = 0;
-		conf->nr_disks++;
 		err = 0;
 	}
 	if (err)
@@ -829,7 +828,6 @@ static int raid1_remove_disk(mddev_t *md
 		}
 		p->bdev = NULL;
 		p->used_slot = 0;
-		conf->nr_disks--;
 		err = 0;
 	}
 	if (err)
@@ -1279,7 +1277,6 @@ static int run(mddev_t *mddev)
 		}
 	}
 	conf->raid_disks = sb->raid_disks;
-	conf->nr_disks = sb->nr_disks;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
 
--- ./include/linux/raid/multipath.h	2002/07/18 12:02:21	1.6
+++ ./include/linux/raid/multipath.h	2002/07/18 12:07:32	1.7
@@ -20,7 +20,6 @@ struct multipath_info {
 struct multipath_private_data {
 	mddev_t			*mddev;
 	struct multipath_info	multipaths[MD_SB_DISKS];
-	int			nr_disks;
 	int			raid_disks;
 	int			working_disks;
 	mdk_thread_t		*thread;
--- ./include/linux/raid/raid1.h	2002/07/18 12:07:28	1.1
+++ ./include/linux/raid/raid1.h	2002/07/18 12:07:32	1.2
@@ -27,7 +27,6 @@ typedef struct r1bio_s r1bio_t;
 struct r1_private_data_s {
 	mddev_t			*mddev;
 	mirror_info_t		mirrors[MD_SB_DISKS];
-	int			nr_disks;
 	int			raid_disks;
 	int			working_disks;
 	int			last_used;
