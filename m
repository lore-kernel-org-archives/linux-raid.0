From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] MD RAID10:  Improve redundancy for 'far' and
 'offset' algorithms
Date: Wed, 12 Dec 2012 10:45:05 -0600
Message-ID: <1355330705.26828.14.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms

The MD RAID10 'far' and 'offset' algorithms make copies of entire stripe
widths - copying them to a different location on the same devices after
shifting the stripe.  An example layout of each follows below:

	        "far" algorithm
	dev1 dev2 dev3 dev4 dev5 dev6
	==== ==== ==== ==== ==== ====
	 A    B    C    D    E    F
	 G    H    I    J    K    L
	            ...
	 F    A    B    C    D    E  --> Copy of stripe0, but shifted by 1
	 L    G    H    I    J    K
	            ...

		"offset" algorithm
	dev1 dev2 dev3 dev4 dev5 dev6
	==== ==== ==== ==== ==== ====
	 A    B    C    D    E    F
	 F    A    B    C    D    E  --> Copy of stripe0, but shifted by 1
	 G    H    I    J    K    L
	 L    G    H    I    J    K
	            ...

Redundancy for these algorithms is gained by shifting the copied stripes
a certain number of devices - in this case, 1.  This patch proposes the
number of devices the copy be shifted by be changed from:
	device# + near_copies
to
	device# + raid_disks/far_copies

The above "far" algorithm example would now look like:
	        "far" algorithm
	dev1 dev2 dev3 dev4 dev5 dev6
	==== ==== ==== ==== ==== ====
	 A    B    C    D    E    F
	 G    H    I    J    K    L
	            ...
	 D    E    F    A    B    C  --> Copy of stripe0, but shifted by 3
	 J    K    L    G    H    I
	            ...

This has the affect of improving the redundancy of the array.  We can
always sustain at least one failure, but sometimes more than one can
be handled.  In the first examples, the pairs of devices that CANNOT fail
together are:
	(1,2) (2,3) (3,4) (4,5) (5,6) (1, 6) [40% of possible pairs]
In the example where the copies are instead shifted by 3, the pairs of
devices that cannot fail together are:
	(1,4) (2,5) (3,6)                    [20% of possible pairs]

Performing shifting in this way produces more redundancy and works especially
well when the number of devices is a multiple of the number of copies.

We cannot simply replace the old algorithms, so the 17th bit of the 'layout'
variable is used to indicate whether we use the old or new method of computing
the shift.  (This is similar to the way the 16th bit indicates whether the
"far" algorithm or the "offset" algorithm is being used.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -38,6 +38,7 @@
  *    near_copies (stored in low byte of layout)
  *    far_copies (stored in second byte of layout)
  *    far_offset (stored in bit 16 of layout )
+ *    dev_stride (stored in bit 17 of layout )
  *
  * The data to be stored is divided into chunks using chunksize.
  * Each device is divided into far_copies sections.
@@ -51,8 +52,14 @@
  * raid_disks.
  *
  * If far_offset is true, then the far_copies are handled a bit differently.
- * The copies are still in different stripes, but instead of be very far apart
- * on disk, there are adjacent stripes.
+ * The copies are still in different stripes, but instead of being very far
+ * apart on disk, there are adjacent stripes.
+ *
+ * If dev_stride is true, then the devices on which copies
+ * are placed on for the 'far' and 'offset' algorithms changes from
+ *         'device# + near_copies'
+ * to
+ *         'device# + raid_disks/far_copies'.
  */
 
 /*
@@ -552,14 +559,13 @@ static void __raid10_find_phys(struct ge
 	for (n = 0; n < geo->near_copies; n++) {
 		int d = dev;
 		sector_t s = sector;
-		r10bio->devs[slot].addr = sector;
 		r10bio->devs[slot].devnum = d;
+		r10bio->devs[slot].addr = s;
 		slot++;
 
 		for (f = 1; f < geo->far_copies; f++) {
-			d += geo->near_copies;
-			if (d >= geo->raid_disks)
-				d -= geo->raid_disks;
+			d += geo->dev_stride;
+			d %= geo->raid_disks;
 			s += geo->stride;
 			r10bio->devs[slot].devnum = d;
 			r10bio->devs[slot].addr = s;
@@ -601,16 +607,16 @@ static sector_t raid10_find_virt(struct
 		int fc;
 		chunk = sector >> geo->chunk_shift;
 		fc = sector_div(chunk, geo->far_copies);
-		dev -= fc * geo->near_copies;
+		dev -= fc * geo->dev_stride;
 		if (dev < 0)
 			dev += geo->raid_disks;
 	} else {
 		while (sector >= geo->stride) {
 			sector -= geo->stride;
-			if (dev < geo->near_copies)
-				dev += geo->raid_disks - geo->near_copies;
+			if (dev < geo->dev_stride)
+				dev += geo->raid_disks - geo->dev_stride;
 			else
-				dev -= geo->near_copies;
+				dev -= geo->dev_stride;
 		}
 		chunk = sector >> geo->chunk_shift;
 	}
@@ -3437,7 +3443,7 @@ static int setup_geo(struct geom *geo, s
 		disks = mddev->raid_disks + mddev->delta_disks;
 		break;
 	}
-	if (layout >> 17)
+	if (layout >> 18)
 		return -1;
 	if (chunk < (PAGE_SIZE >> 9) ||
 	    !is_power_of_2(chunk))
@@ -3449,6 +3455,10 @@ static int setup_geo(struct geom *geo, s
 	geo->near_copies = nc;
 	geo->far_copies = fc;
 	geo->far_offset = fo;
+	if (layout & (1<<17))
+		geo->dev_stride = disks / fc;
+	else
+		geo->dev_stride = geo->near_copies;
 	geo->chunk_mask = chunk - 1;
 	geo->chunk_shift = ffz(~chunk);
 	return nc*fc;
Index: linux-upstream/drivers/md/raid10.h
===================================================================
--- linux-upstream.orig/drivers/md/raid10.h
+++ linux-upstream/drivers/md/raid10.h
@@ -33,6 +33,10 @@ struct r10conf {
 					       * far_offset, in which case it is
 					       * 1 stripe.
 					       */
+		int             dev_stride;   /* distance to the next device
+					       * on which a "far" or "offset"
+					       * copy will be placed.
+					       */
 		int		chunk_shift; /* shift from chunks to sectors */
 		sector_t	chunk_mask;
 	} prev, geo;


