From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD RAID10:  Fix compiler warning.
Date: Tue, 26 Jun 2012 03:40:13 -0500
Message-ID: <1340700013.19015.7.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MD RAID10:  Fix compiler warning.

Initialize variable to prevent compiler warning.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -717,7 +717,7 @@ static struct md_rdev *read_balance(stru
 	int sectors = r10_bio->sectors;
 	int best_good_sectors;
 	sector_t new_distance, best_dist;
-	struct md_rdev *rdev, *best_rdev;
+	struct md_rdev *best_rdev, *rdev = NULL;
 	int do_balance;
 	int best_slot;
 	struct geom *geo = &conf->geo;


