From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 4] MD RAID10: Minor non-functional code changes
Date: Mon, 17 Dec 2012 12:33:50 -0600
Message-ID: <1355769230.15326.21.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

MD RAID10: Minor non-functional code changes

Changes include assigning 'addr' from 's' instead of 'sector' to be
consistent with the way the code does it just a few lines later and
using '%=' vs a conditional and subtraction.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -552,14 +552,13 @@ static void __raid10_find_phys(struct ge
 	for (n = 0; n < geo->near_copies; n++) {
 		int d = dev;
 		sector_t s = sector;
-		r10bio->devs[slot].addr = sector;
 		r10bio->devs[slot].devnum = d;
+		r10bio->devs[slot].addr = s;
 		slot++;
 
 		for (f = 1; f < geo->far_copies; f++) {
 			d += geo->near_copies;
-			if (d >= geo->raid_disks)
-				d -= geo->raid_disks;
+			d %= geo->raid_disks;
 			s += geo->stride;
 			r10bio->devs[slot].devnum = d;
 			r10bio->devs[slot].addr = s;


