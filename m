From: Shaohua Li <shli@fb.com>
Subject: [patch v2 02/11] MD: add a new disk role to present write journal device
Date: Thu, 13 Aug 2015 14:31:55 -0700
Message-ID: <6f058f81eff4fe549f9ecae0b134f637b28fe814.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

Next patches will use a disk as raid5/6 journaling. We need a new disk
role to present the journal device and add MD_FEATURE_JOURNAL to
feature_map for backward compability.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c                | 24 ++++++++++++++++++++++--
 drivers/md/md.h                |  5 +++++
 include/uapi/linux/raid/md_p.h |  3 +++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01f9fa0..7667cc1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1656,6 +1656,16 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		case MD_DISK_ROLE_FAULTY: /* faulty */
 			set_bit(Faulty, &rdev->flags);
 			break;
+		case MD_DISK_ROLE_JOURNAL: /* journal device */
+			if (!(sb->feature_map & MD_FEATURE_JOURNAL)) {
+				/* journal device without journal feature */
+				printk(KERN_WARNING
+				  "md: journal device provided without "
+				  "journal feature, ignoring the device\n");
+				return -EINVAL;
+			}
+			set_bit(Journal, &rdev->flags);
+			break;
 		default:
 			rdev->saved_raid_disk = role;
 			if ((le32_to_cpu(sb->feature_map) &
@@ -1811,7 +1821,10 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
-		else if (rdev2->raid_disk >= 0)
+		else if (test_bit(Journal, &rdev2->flags)) {
+			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_JOURNAL);
+			sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
+		} else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
@@ -5805,7 +5818,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 		else if (test_bit(In_sync, &rdev->flags)) {
 			info.state |= (1<<MD_DISK_ACTIVE);
 			info.state |= (1<<MD_DISK_SYNC);
-		}
+		} else if (test_bit(Journal, &rdev->flags))
+			info.state |= (1<<MD_DISK_JOURNAL);
 		if (test_bit(WriteMostly, &rdev->flags))
 			info.state |= (1<<MD_DISK_WRITEMOSTLY);
 	} else {
@@ -5920,6 +5934,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		else
 			clear_bit(WriteMostly, &rdev->flags);
 
+		if (info->state & (1<<MD_DISK_JOURNAL))
+			set_bit(Journal, &rdev->flags);
 		/*
 		 * check whether the device shows up in other nodes
 		 */
@@ -7288,6 +7304,10 @@ static int md_seq_show(struct seq_file *seq, void *v)
 				seq_printf(seq, "(F)");
 				continue;
 			}
+			if (test_bit(Journal, &rdev->flags)) {
+				seq_printf(seq, "(J)");
+				continue;
+			}
 			if (rdev->raid_disk < 0)
 				seq_printf(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7da6e9c..56a4015 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -176,6 +176,11 @@ enum flag_bits {
 				 * This device is seen locally but not
 				 * by the whole cluster
 				 */
+	Journal,		/* This device is used as journal for
+				 * raid-5/6.
+				 * Usually, this device should be faster
+				 * than other devices in the array
+				 */
 };
 
 #define BB_LEN_MASK	(0x00000000000001FFULL)
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 3105190..a6ec473 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -89,9 +89,11 @@
 				   * read requests will only be sent here in
 				   * dire need
 				   */
+#define MD_DISK_JOURNAL		18 /* disk is used as the write journal in RAID-5/6 */
 
 #define MD_DISK_ROLE_SPARE	0xffff
 #define MD_DISK_ROLE_FAULTY	0xfffe
+#define MD_DISK_ROLE_JOURNAL	0xfffd
 #define MD_DISK_ROLE_MAX	0xff00 /* max value of regular disk role */
 
 typedef struct mdp_device_descriptor_s {
@@ -306,6 +308,7 @@ struct mdp_superblock_1 {
 #define	MD_FEATURE_RECOVERY_BITMAP	128 /* recovery that is happening
 					     * is guided by bitmap.
 					     */
+#define	MD_FEATURE_JOURNAL		256 /* support write cache */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
-- 
1.8.1

