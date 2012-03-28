From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid1:Remove unnecessary  rcu_dereference(conf->mirrors[i].rdev). Because  rde->nr_pending > 0,so can not remove this disk.
Date: Wed, 28 Mar 2012 19:46:56 +0800
Message-ID: <201203281935226256403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 2d433ec2d351119afac6b57caa6cdec2197c0396 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 28 Mar 2012 19:30:36 +0800
Subject: [PATCH] md/raid1:Remove unnecessary  rcu_dereference(conf->mirrors[i].rdev). Because
 rde->nr_pending > 0,so can not remove this disk.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..f112782 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2386,8 +2386,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		int ok = 1;
 		for (i = 0 ; i < conf->raid_disks * 2 ; i++)
 			if (r1_bio->bios[i]->bi_end_io == end_sync_write) {
-				struct md_rdev *rdev =
-					rcu_dereference(conf->mirrors[i].rdev);
+				struct md_rdev *rdev = conf->mirrors[i].rdev;
 				ok = rdev_set_badblocks(rdev, sector_nr,
 							min_bad, 0
 					) && ok;
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-28

