From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 4] MD RAID10:  Improve redundancy for 'far' and
 'offset' algorithms (part 1)
Date: Mon, 17 Dec 2012 12:37:58 -0600
Message-ID: <1355769478.15326.23.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms (part 1)

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
one device to the right.  This patch proposes that array be divided into
sets of adjacent devices and when the stripe copies are shifted, they wrap
on set boundaries rather than the array size boundary.  That is, for the
purposes of shifting, the copies are confined to their sets within the
array.  The sets are 'near_copies * far_copies' in size.

The above "far" algorithm example would change to:
	        "far" algorithm
	dev1 dev2 dev3 dev4 dev5 dev6
	==== ==== ==== ==== ==== ====
	 A    B    C    D    E    F
	 G    H    I    J    K    L
	            ...
	 B    A    D    C    F    E  --> Copy of stripe0, shifted 1, 2-dev sets
	 H    G    J    I    L    K      Dev sets are 1-2, 3-4, 5-6
	            ...

This has the affect of improving the redundancy of the array.  We can
always sustain at least one failure, but sometimes more than one can
be handled.  In the first examples, the pairs of devices that CANNOT fail
together are:
	(1,2) (2,3) (3,4) (4,5) (5,6) (1, 6) [40% of possible pairs]
In the example where the copies are confined to sets, the pairs of
devices that cannot fail together are:
	(1,2) (3,4) (5,6)                    [20% of possible pairs]

We cannot simply replace the old algorithms, so the 17th bit of the 'layout'
variable is used to indicate whether we use the old or new method of computing
the shift.  (This is similar to the way the 16th bit indicates whether the
"far" algorithm or the "offset" algorithm is being used.)

This patch only handles the cases where the number of total raid disks is
a multiple of 'far_copies'.  A follow-on patch addresses the condition where
this is not true.


Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -38,21 +38,36 @@
  *    near_copies (stored in low byte of layout)
  *    far_copies (stored in second byte of layout)
  *    far_offset (stored in bit 16 of layout )
+ *    use_far_sets (stored in bit 17 of layout )
  *
- * The data to be stored is divided into chunks using chunksize.
- * Each device is divided into far_copies sections.
- * In each section, chunks are laid out in a style similar to raid0, but
- * near_copies copies of each chunk is stored (each on a different drive).
- * The starting device for each section is offset near_copies from the starting
- * device of the previous section.
- * Thus they are (near_copies*far_copies) of each chunk, and each is on a different
- * drive.
- * near_copies and far_copies must be at least one, and their product is at most
- * raid_disks.
+ * The data to be stored is divided into chunks using chunksize.  Each device
+ * is divided into far_copies sections.   In each section, chunks are laid out
+ * in a style similar to raid0, but near_copies copies of each chunk is stored
+ * (each on a different drive).  The starting device for each section is offset
+ * near_copies from the starting device of the previous section.  Thus there
+ * are (near_copies * far_copies) of each chunk, and each is on a different
+ * drive.  near_copies and far_copies must be at least one, and their product
+ * is at most raid_disks.
  *
  * If far_offset is true, then the far_copies are handled a bit differently.
- * The copies are still in different stripes, but instead of be very far apart
- * on disk, there are adjacent stripes.
+ * The copies are still in different stripes, but instead of being very far
+ * apart on disk, there are adjacent stripes.
+ *
+ * The far and offset algorithms are handled slightly differently if
+ * 'use_far_sets' is true.  In this case, the array's devices are grouped into
+ * sets that are (near_copies * far_copies) in size.  The far copied stripes
+ * are still shifted by 'near_copies' devices, but this shifting stays confined
+ * to the set rather than the entire array.  This is done to improve the number
+ * of device combinations that can fail without causing the array to fail.
+ * Example 'far' algorithm w/o 'use_far_sets' (each letter represents a chunk
+ * on a device):
+ *    A B C D    A B C D E
+ *      ...         ...
+ *    D A B C    E A B C D
+ * Example 'far' algorithm w/ 'use_far_sets' enabled (sets illustrated w/ []'s):
+ *    [A B] [C D]    [A B] [C D E]
+ *    |...| |...|    |...| | ... |
+ *    [B A] [D C]    [B A] [E C D]
  */
 
 /*
@@ -551,14 +566,18 @@ static void __raid10_find_phys(struct ge
 	/* and calculate all the others */
 	for (n = 0; n < geo->near_copies; n++) {
 		int d = dev;
+		int set;
 		sector_t s = sector;
 		r10bio->devs[slot].devnum = d;
 		r10bio->devs[slot].addr = s;
 		slot++;
 
 		for (f = 1; f < geo->far_copies; f++) {
+			set = d / geo->far_set_size;
 			d += geo->near_copies;
-			d %= geo->raid_disks;
+			d %= geo->far_set_size;
+			d += geo->far_set_size * set;
+
 			s += geo->stride;
 			r10bio->devs[slot].devnum = d;
 			r10bio->devs[slot].addr = s;
@@ -594,6 +613,8 @@ static sector_t raid10_find_virt(struct
 	 * or recovery, so reshape isn't happening
 	 */
 	struct geom *geo = &conf->geo;
+	int far_set_start = (dev / geo->far_set_size) * geo->far_set_size;
+	int far_set_size = geo->far_set_size;
 
 	offset = sector & geo->chunk_mask;
 	if (geo->far_offset) {
@@ -601,13 +622,13 @@ static sector_t raid10_find_virt(struct
 		chunk = sector >> geo->chunk_shift;
 		fc = sector_div(chunk, geo->far_copies);
 		dev -= fc * geo->near_copies;
-		if (dev < 0)
-			dev += geo->raid_disks;
+		if (dev < far_set_start)
+			dev += far_set_size;
 	} else {
 		while (sector >= geo->stride) {
 			sector -= geo->stride;
-			if (dev < geo->near_copies)
-				dev += geo->raid_disks - geo->near_copies;
+			if (dev < (geo->near_copies + far_set_start))
+				dev += far_set_size - geo->near_copies;
 			else
 				dev -= geo->near_copies;
 		}
@@ -3436,7 +3457,7 @@ static int setup_geo(struct geom *geo, s
 		disks = mddev->raid_disks + mddev->delta_disks;
 		break;
 	}
-	if (layout >> 17)
+	if (layout >> 18)
 		return -1;
 	if (chunk < (PAGE_SIZE >> 9) ||
 	    !is_power_of_2(chunk))
@@ -3448,6 +3469,7 @@ static int setup_geo(struct geom *geo, s
 	geo->near_copies = nc;
 	geo->far_copies = fc;
 	geo->far_offset = fo;
+	geo->far_set_size = (layout & (1<<17)) ? disks / fc : disks;
 	geo->chunk_mask = chunk - 1;
 	geo->chunk_shift = ffz(~chunk);
 	return nc*fc;
Index: linux-upstream/drivers/md/raid10.h
===================================================================
--- linux-upstream.orig/drivers/md/raid10.h
+++ linux-upstream/drivers/md/raid10.h
@@ -33,6 +33,11 @@ struct r10conf {
 					       * far_offset, in which case it is
 					       * 1 stripe.
 					       */
+		int             far_set_size; /* The number of devices in a set,
+					       * where a 'set' are devices that
+					       * contain far/offset copies of
+					       * each other.
+					       */
 		int		chunk_shift; /* shift from chunks to sectors */
 		sector_t	chunk_mask;
 	} prev, geo;


