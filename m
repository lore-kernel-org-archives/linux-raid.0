From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 4] MD RAID10:  Improve redundancy for 'far' and
 'offset' algorithms (part 2)
Date: Mon, 17 Dec 2012 12:40:16 -0600
Message-ID: <1355769616.15326.25.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms (part 2)

This patch addresses raid arrays that have a number of devices that cannot
be evenly divided by 'far_copies'.  (E.g. 5 devices, far_copies = 2)  This
case must be handled differently because it causes that last set to be of
a different size than the rest of the sets.  We must compute a new modulo
for this last set so that copied chunks are properly wrapped around.

Example use_far_sets=1, far_copies=2, near_copies=1, devices=5:
                "far" algorithm
        dev1 dev2 dev3 dev4 dev5
	==== ==== ==== ==== ====
	[ A   B ] [ C    D   E ]
        [ G   H ] [ I    J   K ]
                    ...
        [ B   A ] [ E    C   D ] --> nominal set of 2 and last set of 3
        [ H   G ] [ K    I   J ]     []'s show far/offset sets

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -550,6 +550,13 @@ static void __raid10_find_phys(struct ge
 	sector_t stripe;
 	int dev;
 	int slot = 0;
+	int last_far_set_start, last_far_set_size;
+
+	last_far_set_start = (geo->raid_disks / geo->far_set_size) - 1;
+	last_far_set_start *= geo->far_set_size;
+
+	last_far_set_size = geo->far_set_size;
+	last_far_set_size += (geo->raid_disks % geo->far_set_size);
 
 	/* now calculate first sector/dev */
 	chunk = r10bio->sector >> geo->chunk_shift;
@@ -575,9 +582,16 @@ static void __raid10_find_phys(struct ge
 		for (f = 1; f < geo->far_copies; f++) {
 			set = d / geo->far_set_size;
 			d += geo->near_copies;
-			d %= geo->far_set_size;
-			d += geo->far_set_size * set;
 
+			if ((geo->raid_disks % geo->far_set_size) &&
+			    (d > last_far_set_start)) {
+				d -= last_far_set_start;
+				d %= last_far_set_size;
+				d += last_far_set_start;
+			} else {
+				d %= geo->far_set_size;
+				d += geo->far_set_size * set;
+			}
 			s += geo->stride;
 			r10bio->devs[slot].devnum = d;
 			r10bio->devs[slot].addr = s;
@@ -615,6 +629,18 @@ static sector_t raid10_find_virt(struct
 	struct geom *geo = &conf->geo;
 	int far_set_start = (dev / geo->far_set_size) * geo->far_set_size;
 	int far_set_size = geo->far_set_size;
+	int last_far_set_start;
+
+	if (geo->raid_disks % geo->far_set_size) {
+		last_far_set_start = (geo->raid_disks / geo->far_set_size) - 1;
+		last_far_set_start *= geo->far_set_size;
+
+		if (dev >= last_far_set_start) {
+			far_set_size = geo->far_set_size;
+			far_set_size += (geo->raid_disks % geo->far_set_size);
+			far_set_start = last_far_set_start;
+		}
+	}
 
 	offset = sector & geo->chunk_mask;
 	if (geo->far_offset) {


