From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 3] DM RAID: Add rebuild capability for RAID10
Date: Fri, 24 Aug 2012 13:18:49 -0500
Message-ID: <1345832329.25206.18.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID:  Add code to validate replacement slots for RAID10 arrays

RAID10 can handle 'copies - 1' failures for each mirror group.  This code
ensures the user has provided a valid array - one whose devices specified for
rebuild do not exceed the amount of redundancy available.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -349,6 +349,7 @@ static int validate_region_size(struct r
 static int validate_rebuild_devices(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt = 0;
+	unsigned rebuilds_per_group, copies, d;
 
 	if (!(rs->print_flags & DMPF_REBUILD))
 		return 0;
@@ -369,6 +370,37 @@ static int validate_rebuild_devices(stru
 			goto too_many;
 		break;
 	case 10:
+		copies = raid10_md_layout_to_copies(rs->md.layout);
+		if (rebuild_cnt < copies)
+			break;
+
+		/*
+		 * It is possible to have a higher rebuild count for RAID10,
+		 * as long as the failed devices occur in different mirror
+		 * groups (i.e. different stripes).
+		 *
+		 * Right now, we only allow for "near" copies.  When other
+		 * formats are added, we will have to check those too.
+		 *
+		 * When checking "near" format, make sure no adjacent devices
+		 * have failed beyond what can be handled.  In addition to the
+		 * simple case where the number of devices is a multiple of the
+		 * number of copies, we must also handle cases where the number
+		 * of devices is not a multiple of the number of copies.
+		 * E.g.    dev1 dev2 dev3 dev4 dev5
+		 *          A    A    B    B    C
+		 *          C    D    D    E    E
+		 */
+		rebuilds_per_group = 0;
+		for (i = 0; i < rs->md.raid_disks * copies; i++) {
+			d = i % rs->md.raid_disks;
+			if (!test_bit(In_sync, &rs->dev[d].rdev.flags) &&
+			    (++rebuilds_per_group >= copies))
+				goto too_many;
+			if (!((i + 1) % copies))
+				rebuilds_per_group = 0;
+		}
+		break;
 	default:
 		DMERR("The rebuild parameter is not supported for %s",
 		      rs->raid_type->name);
@@ -1389,7 +1421,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 3, 0},
+	.version = {1, 3, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -132,3 +132,12 @@ Here we can see the RAID type is raid4,
 which are 'A'live, and the array is 2/490221568 complete with recovery.
 Faulty or missing devices are marked 'D'.  Devices that are out-of-sync
 are marked 'a'.
+
+
+Version History
+---------------
+1.0.0	Initial version.  Support for RAID 4/5/6
+1.1.0	Added support for RAID 1
+1.2.0	Handle creation of arrays that contain failed devices.
+1.3.0	Added support for RAID 10
+1.3.1	Allow device replacement/rebuild for RAID 10


