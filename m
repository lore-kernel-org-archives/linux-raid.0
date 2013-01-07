From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 4 - v2] DM RAID:  Add support for MD's RAID10 "far" and
 "offset" algorithms
Date: Mon, 07 Jan 2013 16:09:41 -0600
Message-ID: <1357596581.11183.4.camel@f16>
References: <1355769688.15326.26.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355769688.15326.26.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com
List-Id: linux-raid.ids

DM RAID:  Add support for MD's RAID10 "far" and "offset" algorithms

Until now, dm-raid.c only supported the "near" algorthm of MD's RAID10
implementation.  This patch adds support for the "far" and "offset"
algorithms, but only with the improved redundancy that is brought with
the introduction of the 'use_far_sets' bit, which shifts copied stripes
according to smaller sets vs the entire array.  That is, the 17th bit
of the 'layout' variable that defines the RAID10 implementation will
always be set.   (More information on how the 'layout' variable selects
the RAID10 algorithm can be found in the opening comments of
drivers/md/raid10.c.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -30,6 +30,7 @@ The target is named "raid" and it accept
   raid10        Various RAID10 inspired algorithms chosen by additional params
 		- RAID10: Striped Mirrors (aka 'Striping on top of mirrors')
 		- RAID1E: Integrated Adjacent Stripe Mirroring
+		- RAID1E: Integrated Offset Stripe Mirroring
 		-  and other similar RAID10 variants
 
   Reference: Chapter 4 of
@@ -64,15 +65,15 @@ The target is named "raid" and it accept
 		synchronisation state for each region.
 
         [raid10_copies   <# copies>]
-        [raid10_format   near]
+        [raid10_format   <near|far|offset>]
 		These two options are used to alter the default layout of
 		a RAID10 configuration.  The number of copies is can be
-		specified, but the default is 2.  There are other variations
-		to how the copies are laid down - the default and only current
-		option is "near".  Near copies are what most people think of
-		with respect to mirroring.  If these options are left
-		unspecified, or 'raid10_copies 2' and/or 'raid10_format near'
-		are given, then the layouts for 2, 3 and 4 devices are:
+		specified, but the default is 2.  There are also three
+		variations to how the copies are laid down - the default
+		is "near".  Near copies are what most people think of with
+		respect to mirroring.  If these options are left unspecified,
+		or 'raid10_copies 2' and/or 'raid10_format near' are given,
+		then the layouts for 2, 3 and 4 devices	are:
 		2 drives         3 drives          4 drives
 		--------         ----------        --------------
 		A1  A1           A1  A1  A2        A1  A1  A2  A2
@@ -85,6 +86,33 @@ The target is named "raid" and it accept
 		3-device layout is what might be called a 'RAID1E - Integrated
 		Adjacent Stripe Mirroring'.
 
+		If 'raid10_copies 2' and 'raid10_format far', then the layouts
+		for 2, 3 and 4 devices are:
+		2 drives             3 drives             4 drives
+		--------             --------------       --------------------
+		A1  A2               A1   A2   A3         A1   A2   A3   A4
+		A3  A4               A4   A5   A6         A5   A6   A7   A8
+		A5  A6               A7   A8   A9         A9   A10  A11  A12
+		..  ..               ..   ..   ..         ..   ..   ..   ..
+		A2  A1               A3   A1   A2         A2   A1   A4   A3
+		A4  A3               A6   A4   A5         A6   A5   A8   A7
+		A6  A5               A9   A7   A8         A10  A9   A12  A11
+		..  ..               ..   ..   ..         ..   ..   ..   ..
+
+		If 'raid10_copies 2' and 'raid10_format offset', then the
+		layouts for 2, 3 and 4 devices are:
+		2 drives       3 drives           4 drives
+		--------       ------------       -----------------
+		A1  A2         A1  A2  A3         A1  A2  A3  A4
+		A2  A1         A3  A1  A2         A2  A1  A4  A3
+		A3  A4         A4  A5  A6         A5  A6  A7  A8
+		A4  A3         A6  A4  A5         A6  A5  A8  A7
+		A5  A6         A7  A8  A9         A9  A10 A11 A12
+		A6  A5         A9  A7  A8         A10 A9  A12 A11
+		..  ..         ..  ..  ..         ..  ..  ..  ..
+		Here we see layouts closely akin to 'RAID1E - Integrated
+		Offset Stripe Mirroring'.
+
 <#raid_devs>: The number of devices composing the array.
 	Each device consists of two entries.  The first is the device
 	containing the metadata (if any); the second is the one containing the
@@ -141,3 +169,5 @@ Version History
 1.2.0	Handle creation of arrays that contain failed devices.
 1.3.0	Added support for RAID 10
 1.3.1	Allow device replacement/rebuild for RAID 10
+1.4.0	Non-functional change.  Removes arg from mapping function.
+1.4.1   Add RAID10 "far" and "offset" algorithm support.
Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -91,15 +91,44 @@ static struct raid_type {
 	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
 };
 
+static char *raid10_md_layout_to_format(int layout)
+{
+	/*
+	 * Bit 16 and 17 stand for "offset" and "use_far_sets"
+	 * Refer to MD's raid10.c for details
+	 */
+	if ((layout & 0x10000) && (layout & 0x20000))
+		return "offset";
+
+	if ((layout & 0xFF) > 1)
+		return "near";
+
+	return "far";
+}
+
 static unsigned raid10_md_layout_to_copies(int layout)
 {
-	return layout & 0xFF;
+	if ((layout & 0xFF) > 1)
+		return layout & 0xFF;
+	return (layout >> 8) & 0xFF;
 }
 
 static int raid10_format_to_md_layout(char *format, unsigned copies)
 {
-	/* 1 "far" copy, and 'copies' "near" copies */
-	return (1 << 8) | (copies & 0xFF);
+	unsigned n = 1, f = 1;
+
+	if (!strcmp("near", format))
+		n = copies;
+	else
+		f = copies;
+
+	if (!strcmp("offset", format))
+		return 0x30000 | (f << 8) | n;
+
+	if (!strcmp("far", format))
+		return 0x20000 | (f << 8) | n;
+
+	return (f << 8) | n;
 }
 
 static struct raid_type *get_raid_type(char *name)
@@ -352,6 +381,7 @@ static int validate_rebuild_devices(stru
 {
 	unsigned i, rebuild_cnt = 0;
 	unsigned rebuilds_per_group, copies, d;
+	unsigned group_size, last_group_start;
 
 	if (!(rs->print_flags & DMPF_REBUILD))
 		return 0;
@@ -381,9 +411,6 @@ static int validate_rebuild_devices(stru
 		 * as long as the failed devices occur in different mirror
 		 * groups (i.e. different stripes).
 		 *
-		 * Right now, we only allow for "near" copies.  When other
-		 * formats are added, we will have to check those too.
-		 *
 		 * When checking "near" format, make sure no adjacent devices
 		 * have failed beyond what can be handled.  In addition to the
 		 * simple case where the number of devices is a multiple of the
@@ -394,13 +421,39 @@ static int validate_rebuild_devices(stru
 		 *          C    D    D    E    E
 		 */
 		rebuilds_per_group = 0;
-		for (i = 0; i < rs->md.raid_disks * copies; i++) {
-			d = i % rs->md.raid_disks;
-			if (!test_bit(In_sync, &rs->dev[d].rdev.flags) &&
-			    (++rebuilds_per_group >= copies))
-				goto too_many;
-			if (!((i + 1) % copies))
+		if (!strcmp("near", raid10_md_layout_to_format(rs->md.layout))) {
+			for (i = 0; i < rs->md.raid_disks * copies; i++) {
+				d = i % rs->md.raid_disks;
+				if (!test_bit(In_sync, &rs->dev[d].rdev.flags) &&
+				    (++rebuilds_per_group >= copies))
+					goto too_many;
+				if (!((i + 1) % copies))
+					rebuilds_per_group = 0;
+			}
+			break;
+		}
+
+		/*
+		 * When checking "far" and "offset" formats, we need to ensure
+		 * that the device that holds its copy is not also dead or
+		 * being rebuilt.  (Note that "far" and "offset" formats only
+		 * support two copies right now.  These formats also only ever
+		 * use the 'use_far_sets' variant.)
+		 *
+		 * This check is somewhat complicated by the need to account
+		 * for arrays that are not a multiple of (far) copies.  This
+		 * results in the need to treat the last (potentially larger)
+		 * set differently.
+		 */
+		group_size = (rs->md.raid_disks / copies);
+		last_group_start = (rs->md.raid_disks / group_size) - 1;
+		last_group_start *= group_size;
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
+			if (!test_bit(In_sync, &rs->dev[i].rdev.flags) &&
+			    (++rebuilds_per_group >= copies))
+					goto too_many;
 		}
 		break;
 	default:
@@ -438,7 +491,7 @@ too_many:
  *
  * RAID10-only options:
  *    [raid10_copies <# copies>]        Number of copies.  (Default: 2)
- *    [raid10_format <near>]            Layout algorithm.  (Default: near)
+ *    [raid10_format <near|far|offset>] Layout algorithm.  (Default: near)
  */
 static int parse_raid_params(struct raid_set *rs, char **argv,
 			     unsigned num_raid_params)
@@ -525,7 +578,9 @@ static int parse_raid_params(struct raid
 				rs->ti->error = "'raid10_format' is an invalid parameter for this RAID type";
 				return -EINVAL;
 			}
-			if (strcmp("near", argv[i])) {
+			if (strcmp("near", argv[i]) &&
+			    strcmp("far", argv[i]) &&
+			    strcmp("offset", argv[i])) {
 				rs->ti->error = "Invalid 'raid10_format' value given";
 				return -EINVAL;
 			}
@@ -649,6 +704,15 @@ static int parse_raid_params(struct raid
 			return -EINVAL;
 		}
 
+		/*
+		 * If the format is not "near", we only support
+		 * two copies at the moment.
+		 */
+		if (strcmp("near", raid10_format) && (raid10_copies > 2)) {
+			rs->ti->error = "Too many copies for given RAID10 format.";
+			return -EINVAL;
+		}
+
 		/* (Len * #mirrors) / #devices */
 		sectors_per_dev = rs->ti->len * raid10_copies;
 		sector_div(sectors_per_dev, rs->md.raid_disks);
@@ -862,17 +926,30 @@ static int super_init_validation(struct
 	/*
 	 * Reshaping is not currently allowed
 	 */
-	if ((le32_to_cpu(sb->level) != mddev->level) ||
-	    (le32_to_cpu(sb->layout) != mddev->layout) ||
-	    (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors)) {
-		DMERR("Reshaping arrays not yet supported.");
+	if (le32_to_cpu(sb->level) != mddev->level) {
+		DMERR("Reshaping arrays not yet supported. (RAID level change)");
+		return -EINVAL;
+	}
+	if (le32_to_cpu(sb->layout) != mddev->layout) {
+		DMERR("Reshaping arrays not yet supported. (RAID layout change)");
+		DMERR("  0x%X vs 0x%X", le32_to_cpu(sb->layout), mddev->layout);
+		DMERR("  Old layout: %s w/ %d copies",
+		      raid10_md_layout_to_format(le32_to_cpu(sb->layout)),
+		      raid10_md_layout_to_copies(le32_to_cpu(sb->layout)));
+		DMERR("  New layout: %s w/ %d copies",
+		      raid10_md_layout_to_format(mddev->layout),
+		      raid10_md_layout_to_copies(mddev->layout));
+		return -EINVAL;
+	}
+	if (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) {
+		DMERR("Reshaping arrays not yet supported. (stripe sectors change)");
 		return -EINVAL;
 	}
 
 	/* We can only change the number of devices in RAID1 right now */
 	if ((rs->raid_type->level != 1) &&
 	    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
-		DMERR("Reshaping arrays not yet supported.");
+		DMERR("Reshaping arrays not yet supported. (device count change)");
 		return -EINVAL;
 	}
 
@@ -1356,7 +1433,8 @@ static int raid_status(struct dm_target
 			       raid10_md_layout_to_copies(rs->md.layout));
 
 		if (rs->print_flags & DMPF_RAID10_FORMAT)
-			DMEMIT(" raid10_format near");
+			DMEMIT(" raid10_format %s",
+			       raid10_md_layout_to_format(rs->md.layout));
 
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
@@ -1432,7 +1510,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 4, 0},
+	.version = {1, 4, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
@@ -1447,6 +1525,10 @@ static struct target_type raid_target =
 
 static int __init dm_raid_init(void)
 {
+	DMINFO("Loading target version %u.%u.%u",
+	       raid_target.version[0],
+	       raid_target.version[1],
+	       raid_target.version[2]);
 	return dm_register_target(&raid_target);
 }
 


