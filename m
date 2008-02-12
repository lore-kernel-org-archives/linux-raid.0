From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: patch for raid10,f>1 to operate like raid0
Date: Tue, 12 Feb 2008 15:16:40 +0100
Message-ID: <20080212141640.GA4921@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch changes the disk to be read for layout far > 1 to always be
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

--- raid10.c	2008-02-12 00:50:59.000000000 +0100
+++ raid10-ks.c	2008-02-12 00:51:09.000000000 +0100
@@ -537,7 +537,7 @@
 	current_distance = abs(r10_bio->devs[slot].addr -
 			       conf->mirrors[disk].head_position);
 
-	/* Find the disk whose head is closest */
+	/* Find the disk whose head is closest, 
+          or for far > 1 the closest to partition beginning */
 
 	for (nslot = slot; nslot < conf->copies; nslot++) {
 		int ndisk = r10_bio->devs[nslot].devnum;
@@ -557,7 +557,11 @@
 			slot = nslot;
 			break;
 		}
-		new_distance = abs(r10_bio->devs[nslot].addr -
+
+                /* for far > 1 always use the lowest address */
+		if (conf->far_copies > 1) 
+			new_distance = r10_bio->devs[nslot].addr;
+		else new_distance = abs(r10_bio->devs[nslot].addr -
 				   conf->mirrors[ndisk].head_position);
 		if (new_distance < current_distance) {
 			current_distance = new_distance;
