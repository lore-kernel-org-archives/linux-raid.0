From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 9] md: Don't attempt read-balancing for raid10 'far' layouts.
Date: Mon, 3 Mar 2008 11:17:47 +1100
Message-ID: <1080303001747.23669@suse.de>
References: <20080303111240.23302.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Keld Simonsen <keld@dkuug.dk>
List-Id: linux-raid.ids


From: Keld Simonsen <keld@dkuug.dk>

This patch changes the disk to be read for layout "far > 1" to always be
the disk with the lowest block address.

Thus the chunks to be read will always be (for a fully functioning array)
from the first band of stripes, and the raid will then work as a raid0
consisting of the first band of stripes.

Some advantages:

The fastest part which is the outer sectors of the disks involved will be used.
The outer blocks of a disk may be as much as 100 % faster than the inner blocks.

Average seek time will be smaller, as seeks will always be confined to the
first part of the disks.

Mixed disks with different performance characteristics will work better,
as they will work as raid0, the sequential read rate will be number of
disks involved times the IO rate of the slowest disk.

If a disk is malfunctioning, the first disk which is working, and has the lowest
block address for the logical block will be used.

Signed-off-by: Keld Simonsen <keld@dkuug.dk>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-03-03 09:35:29.000000000 +1100
+++ ./drivers/md/raid10.c	2008-03-03 09:35:52.000000000 +1100
@@ -537,7 +537,8 @@ static int read_balance(conf_t *conf, r1
 	current_distance = abs(r10_bio->devs[slot].addr -
 			       conf->mirrors[disk].head_position);
 
-	/* Find the disk whose head is closest */
+	/* Find the disk whose head is closest,
+	 * or - for far > 1 - find the closest to partition beginning */
 
 	for (nslot = slot; nslot < conf->copies; nslot++) {
 		int ndisk = r10_bio->devs[nslot].devnum;
@@ -557,8 +558,13 @@ static int read_balance(conf_t *conf, r1
 			slot = nslot;
 			break;
 		}
-		new_distance = abs(r10_bio->devs[nslot].addr -
-				   conf->mirrors[ndisk].head_position);
+
+		/* for far > 1 always use the lowest address */
+		if (conf->far_copies > 1)
+			new_distance = r10_bio->devs[nslot].addr;
+		else
+			new_distance = abs(r10_bio->devs[nslot].addr -
+					   conf->mirrors[ndisk].head_position);
 		if (new_distance < current_distance) {
 			current_distance = new_distance;
 			disk = ndisk;
