From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 3] md: Calculate correct array size for raid10 in new offset mode.
Date: Tue, 16 May 2006 11:13:12 +1000
Message-ID: <1060516011312.2735@suse.de>
References: <20060516111036.2649.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


The size calculation made assumtion which the new offset mode
didn't follow.  This gets the size right in all cases.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2006-05-16 11:09:25.000000000 +1000
+++ ./drivers/md/raid10.c	2006-05-16 11:09:42.000000000 +1000
@@ -2060,7 +2060,13 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	size = conf->stride * conf->raid_disks;
+	if (conf->far_offset) {
+		size = mddev->size >> (conf->chunk_shift-1);
+		size *= conf->raid_disks;
+		size <<= conf->chunk_shift;
+		sector_div(size, conf->far_copies);
+	} else
+		size = conf->stride * conf->raid_disks;
 	sector_div(size, conf->near_copies);
 	mddev->array_size = size/2;
 	mddev->resync_max_sectors = size;
