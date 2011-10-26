From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/16] md: create externally visible flags for supporting
 hot-replace.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014300.21110.35849.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hot-replace is a feature being added to md which will allow a
device to be replaced without removing it from the array first.

With hot-replace a spare can be activated and recovery can start while
the original device is still in place, thus allowing a transition from
an unreliable device to a reliable device without leaving the array
degraded during the transition.  It can also be use when the original
device is still reliable but it not wanted for some reason.

This will eventually be supported in RAID4/5/6 and RAID10.

This patch adds a super-block flag to distinguish the replacement
device.  If an old kernel sees this flag it will reject the device.

It also adds two per-device flags which are viewable and settable via
sysfs.
   "replaceable" can be set to request that a device be replaced.
   "replacement" is set to show that this device is replacing another
   device.

The "rd%d" links in /sys/block/mdXx/md only apply to the original
device, not the replacement.  We currently don't make links for the
replacement - there doesn't seem to be a need.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 Documentation/md.txt      |   22 ++++++++++--
 drivers/md/md.c           |   64 +++++++++++++++++++++++++++++++++++-
 drivers/md/md.h           |   80 +++++++++++++++++++++++++++------------------
 include/linux/raid/md_p.h |    7 +++-
 4 files changed, 134 insertions(+), 39 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index fc94770..9c47a1f 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -357,14 +357,14 @@ Each directory contains:
         written to, that device.
 
       state
-        A file recording the current state of the device in the array
+	A file recording the current state of the device in the array
 	which can be a comma separated list of
 	      faulty   - device has been kicked from active use due to
-                         a detected fault or it has unacknowledged bad
-                         blocks
+			 a detected fault, or it has unacknowledged bad
+			 blocks
 	      in_sync  - device is a fully in-sync member of the array
 	      writemostly - device will only be subject to read
-		         requests if there are no other options.
+			 requests if there are no other options.
 			 This applies only to raid1 arrays.
 	      blocked  - device has failed, and the failure hasn't been
 			 acknowledged yet by the metadata handler.
@@ -374,6 +374,13 @@ Each directory contains:
 			 This includes spares that are in the process
 			 of being recovered to
 	      write_error - device has ever seen a write error.
+	      replaceable - device is (mostly) working but probably
+			 should be replaced, either due to errors or
+			 due to user request.
+	      replacement - device is a replacement for another active
+			 device with same raid_disk.
+
+
 	This list may grow in future.
 	This can be written to.
 	Writing "faulty"  simulates a failure on the device.
@@ -386,6 +393,13 @@ Each directory contains:
 	Writing "in_sync" sets the in_sync flag.
 	Writing "write_error" sets writeerrorseen flag.
 	Writing "-write_error" clears writeerrorseen flag.
+	Writing "replaceable" is allowed at any time except to a
+		replacement device.  It sets the flag.
+	Writing "-replaceable" is allowed at any time.  It clears
+		the flag.
+	Writing "replacement" or "-replacement" is only allowed before
+		starting the array.  It sets or clears the flag.
+
 
 	This file responds to select/poll. Any change to 'faulty'
 	or 'blocked' causes an event.
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 182056a..72a07d0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1717,6 +1717,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		}
 		if (sb->devflags & WriteMostly1)
 			set_bit(WriteMostly, &rdev->flags);
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_REPLACEMENT)
+			set_bit(Replacement, &rdev->flags);
 	} else /* MULTIPATH are always insync */
 		set_bit(In_sync, &rdev->flags);
 
@@ -1770,6 +1772,9 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->recovery_offset =
 			cpu_to_le64(rdev->recovery_offset);
 	}
+	if (test_bit(Replacement, &rdev->flags))
+		sb->feature_map |=
+			cpu_to_le32(MD_FEATURE_REPLACEMENT);
 
 	if (mddev->reshape_position != MaxSector) {
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_RESHAPE_ACTIVE);
@@ -2562,6 +2567,15 @@ state_show(struct md_rdev *rdev, char *page)
 		len += sprintf(page+len, "%swrite_error", sep);
 		sep = ",";
 	}
+	if (test_bit(Replaceable, &rdev->flags)) {
+		len += sprintf(page+len, "%sreplaceable", sep);
+		sep = ",";
+	}
+	if (test_bit(Replacement, &rdev->flags)) {
+		len += sprintf(page+len, "%sreplacement", sep);
+		sep = ",";
+	}
+
 	return len+sprintf(page+len, "\n");
 }
 
@@ -2580,6 +2594,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	 *  -write_error - clears WriteErrorSeen
 	 */
 	int err = -EINVAL;
+	struct md_rdev *rdev2;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
 		if (test_bit(Faulty, &rdev->flags))
@@ -2630,6 +2645,50 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "-write_error")) {
 		clear_bit(WriteErrorSeen, &rdev->flags);
 		err = 0;
+	} else if (cmd_match(buf, "replaceable")) {
+		/* Any device that is not a replacement can become
+		 * replaceable at any time, but we then need to
+		 * check if recovery is needed.
+		 */
+		if (!test_bit(Replacement, &rdev->flags))
+			set_bit(Replaceable, &rdev->flags);
+		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
+		md_wakeup_thread(rdev->mddev->thread);
+		err = 0;
+	} else if (cmd_match(buf, "-replaceable")) {
+		/* Clearing 'replaceable' is only allowed when there
+		 * is no recovery happening, and when there is no
+		 * replacement in place
+		 */
+		err = 0;
+		if (test_bit(MD_RECOVERY_RUNNING, &rdev->mddev->recovery))
+			err = -EBUSY;
+		else list_for_each_entry(rdev2, &rdev->mddev->disks, same_set)
+			     if (rdev2 != rdev &&
+				 rdev2->raid_disk == rdev->raid_disk)
+				     /* Must be a replacement - remove it first */
+				     err = -EBUSY;
+		if (!err)
+			clear_bit(Replaceable, &rdev->flags);
+	} else if (cmd_match(buf, "replacement")) {
+		/* Can only set a device as a replacement when array has not
+		 * yet been started.  Once running, replacement is automatic
+		 * from spares, or by assigning 'slot'.
+		 */
+		if (rdev->mddev->pers)
+			err = -EBUSY;
+		else {
+			set_bit(Replacement, &rdev->flags);
+			err = 0;
+		}
+	} else if (cmd_match(buf, "-replacement")) {
+		/* Similarly, can only clear Replacement before start */
+		if (rdev->mddev->pers)
+			err = -EBUSY;
+		else {
+			clear_bit(Replacement, &rdev->flags);
+			err = 0;
+		}
 	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -6712,8 +6771,11 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			if (test_bit(Faulty, &rdev->flags)) {
 				seq_printf(seq, "(F)");
 				continue;
-			} else if (rdev->raid_disk < 0)
+			}
+			if (rdev->raid_disk < 0)
 				seq_printf(seq, "(S)"); /* spare */
+			if (test_bit(Replacement, &rdev->flags))
+				seq_printf(seq, "(R)");
 			sectors += rdev->sectors;
 		}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 15a0346..2c59e73 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -72,34 +72,7 @@ struct md_rdev {
 	 * This reduces the burden of testing multiple flags in many cases
 	 */
 
-	unsigned long	flags;
-#define	Faulty		1		/* device is known to have a fault */
-#define	In_sync		2		/* device is in_sync with rest of array */
-#define	WriteMostly	4		/* Avoid reading if at all possible */
-#define	AutoDetected	7		/* added by auto-detect */
-#define Blocked		8		/* An error occurred but has not yet
-					 * been acknowledged by the metadata
-					 * handler, so don't allow writes
-					 * until it is cleared */
-#define WriteErrorSeen	9		/* A write error has been seen on this
-					 * device
-					 */
-#define FaultRecorded	10		/* Intermediate state for clearing
-					 * Blocked.  The Fault is/will-be
-					 * recorded in the metadata, but that
-					 * metadata hasn't been stored safely
-					 * on disk yet.
-					 */
-#define BlockedBadBlocks 11		/* A writer is blocked because they
-					 * found an unacknowledged bad-block.
-					 * This can safely be cleared at any
-					 * time, and the writer will re-check.
-					 * It may be set at any time, and at
-					 * worst the writer will timeout and
-					 * re-check.  So setting it as
-					 * accurately as possible is good, but
-					 * not absolutely critical.
-					 */
+	unsigned long	flags;	/* bit set of 'enum flag_bits' bits. */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */
@@ -152,6 +125,44 @@ struct md_rdev {
 		sector_t size;		/* in sectors */
 	} badblocks;
 };
+enum flag_bits {
+	Faulty,			/* device is known to have a fault */
+	In_sync,		/* device is in_sync with rest of array */
+	WriteMostly,		/* Avoid reading if at all possible */
+	AutoDetected,		/* added by auto-detect */
+	Blocked,		/* An error occurred but has not yet
+				 * been acknowledged by the metadata
+				 * handler, so don't allow writes
+				 * until it is cleared */
+	WriteErrorSeen,		/* A write error has been seen on this
+				 * device
+				 */
+	FaultRecorded,		/* Intermediate state for clearing
+				 * Blocked.  The Fault is/will-be
+				 * recorded in the metadata, but that
+				 * metadata hasn't been stored safely
+				 * on disk yet.
+				 */
+	BlockedBadBlocks,	/* A writer is blocked because they
+				 * found an unacknowledged bad-block.
+				 * This can safely be cleared at any
+				 * time, and the writer will re-check.
+				 * It may be set at any time, and at
+				 * worst the writer will timeout and
+				 * re-check.  So setting it as
+				 * accurately as possible is good, but
+				 * not absolutely critical.
+				 */
+	Replaceable,		/* This device is a candidate to be
+				 * hot-replaced, either because it has
+				 * reported some faults, or because
+				 * of explicit request.
+				 */
+	Replacement,		/* This device is a replacement for
+				 * a replaceable device with same
+				 * raid_disk number.
+				 */
+};
 
 #define BB_LEN_MASK	(0x00000000000001FFULL)
 #define BB_OFFSET_MASK	(0x7FFFFFFFFFFFFE00ULL)
@@ -482,15 +493,20 @@ static inline char * mdname (struct mddev * mddev)
 static inline int sysfs_link_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char nm[20];
-	sprintf(nm, "rd%d", rdev->raid_disk);
-	return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+	if (!test_bit(Replacement, &rdev->flags)) {
+		sprintf(nm, "rd%d", rdev->raid_disk);
+		return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+	} else
+		return 0;
 }
 
 static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char nm[20];
-	sprintf(nm, "rd%d", rdev->raid_disk);
-	sysfs_remove_link(&mddev->kobj, nm);
+	if (!test_bit(Replacement, &rdev->flags)) {
+		sprintf(nm, "rd%d", rdev->raid_disk);
+		sysfs_remove_link(&mddev->kobj, nm);
+	}
 }
 
 /*
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 9e65d9e..6f6df86 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -277,7 +277,10 @@ struct mdp_superblock_1 {
 					   */
 #define	MD_FEATURE_RESHAPE_ACTIVE	4
 #define	MD_FEATURE_BAD_BLOCKS		8 /* badblock list is not empty */
-
-#define	MD_FEATURE_ALL			(1|2|4|8)
+#define	MD_FEATURE_REPLACEMENT		16 /* This device is replacing an
+					    * active device with same 'role'.
+					    * 'recovery_offset' is also set.
+					    */
+#define	MD_FEATURE_ALL			(1|2|4|8|16)
 
 #endif 


