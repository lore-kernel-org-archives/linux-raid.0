From: NeilBrown <neilb@suse.de>
Subject: [PATCH 010 of 12] md: Remove a variable that is now unused.
Date: Tue, 27 Jun 2006 17:05:59 +1000
Message-ID: <1060627070559.26070@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932532AbWF0HGk@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    1 -
 1 file changed, 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-06-27 12:17:33.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-27 12:17:34.000000000 +1000
@@ -2846,7 +2846,6 @@ static inline sector_t sync_request(mdde
 	struct stripe_head *sh;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
-	int data_disks = raid_disks - conf->max_degraded;
 	sector_t max_sector = mddev->size << 1;
 	int sync_blocks;
 	int still_degraded = 0;
