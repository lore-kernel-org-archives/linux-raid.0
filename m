From: Shaohua Li <shli@fb.com>
Subject: [patch v2 03/11] md: override md superblock recovery_offset for journal device
Date: Thu, 13 Aug 2015 14:31:56 -0700
Message-ID: <6821811414881fddbd0fa2bfcb2cf25209abefdf.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Journal device stores data in a log structure. We need record the log
start. Here we override md superblock recovery_offset for this purpose.
This field of a journal device is meaningless otherwise.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c                | 6 ++++++
 drivers/md/md.h                | 8 +++++++-
 include/uapi/linux/raid/md_p.h | 5 ++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7667cc1..4775029 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1665,6 +1665,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 				return -EINVAL;
 			}
 			set_bit(Journal, &rdev->flags);
+			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
 			break;
 		default:
 			rdev->saved_raid_disk = role;
@@ -1740,6 +1741,9 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 			sb->feature_map |=
 				cpu_to_le32(MD_FEATURE_RECOVERY_BITMAP);
 	}
+	/* Note: recovery_offset and journal_tail share space  */
+	if (test_bit(Journal, &rdev->flags))
+		sb->journal_tail = cpu_to_le64(rdev->journal_tail);
 	if (test_bit(Replacement, &rdev->flags))
 		sb->feature_map |=
 			cpu_to_le32(MD_FEATURE_REPLACEMENT);
@@ -8045,6 +8049,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 			continue;
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
+		if (test_bit(Journal, &rdev->flags))
+			continue;
 		if (mddev->ro &&
 		    ! (rdev->saved_raid_disk >= 0 &&
 		       !test_bit(Bitmap_sync, &rdev->flags)))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 56a4015..226f4ba 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -87,10 +87,16 @@ struct md_rdev {
 					 * array and could again if we did a partial
 					 * resync from the bitmap
 					 */
-	sector_t	recovery_offset;/* If this device has been partially
+	union {
+		sector_t recovery_offset;/* If this device has been partially
 					 * recovered, this is where we were
 					 * up to.
 					 */
+		sector_t journal_tail;	/* If this device is a journal device,
+					 * this is the journal tail (journal
+					 * recovery start point)
+					 */
+	};
 
 	atomic_t	nr_pending;	/* number of pending requests.
 					 * only maintained for arrays that
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index a6ec473..d66387f 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -258,7 +258,10 @@ struct mdp_superblock_1 {
 	__le64	data_offset;	/* sector start of data, often 0 */
 	__le64	data_size;	/* sectors in this device that can be used for data */
 	__le64	super_offset;	/* sector start of this superblock */
-	__le64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
+	union {
+		__le64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
+		__le64	journal_tail;/* journal tail of journal device (from data_offset) */
+	};
 	__le32	dev_number;	/* permanent identifier of this  device - not role in raid */
 	__le32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
-- 
1.8.1

