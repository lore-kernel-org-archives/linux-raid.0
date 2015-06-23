From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 01/13] MD: add a new disk role to present cache device
Date: Tue, 23 Jun 2015 14:37:51 -0700
Message-ID: <5a5ab0755ee640a3e59ce98610e7a346e49052ad.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

Next patches will use a disk as raid5/6 caching. We need a new disk role
to present the cache device and add MD_FEATURE_WRITE_CACHE to
feature_map for backward compability.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c                | 24 ++++++++++++++++++++++--
 drivers/md/md.h                |  4 ++++
 include/uapi/linux/raid/md_p.h |  3 +++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4dbed4a..599525c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1656,6 +1656,16 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		case 0xfffe: /* faulty */
 			set_bit(Faulty, &rdev->flags);
 			break;
+		case 0xfffd: /* cache device */
+			if (!(sb->feature_map & MD_FEATURE_WRITE_CACHE)) {
+				/* cache device without cache feature */
+				printk(KERN_WARNING
+				  "md: cache device provided without write "
+				  "cache feature, ignoring the device\n");
+				return -EINVAL;
+			}
+			set_bit(WriteCache, &rdev->flags);
+			break;
 		default:
 			rdev->saved_raid_disk = role;
 			if ((le32_to_cpu(sb->feature_map) &
@@ -1811,7 +1821,10 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
-		else if (rdev2->raid_disk >= 0)
+		else if (test_bit(WriteCache, &rdev2->flags)) {
+			sb->dev_roles[i] = cpu_to_le16(0xfffd);
+			sb->feature_map |= cpu_to_le32(MD_FEATURE_WRITE_CACHE);
+		} else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(0xffff);
@@ -5781,7 +5794,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 		else if (test_bit(In_sync, &rdev->flags)) {
 			info.state |= (1<<MD_DISK_ACTIVE);
 			info.state |= (1<<MD_DISK_SYNC);
-		}
+		} else if (test_bit(WriteCache, &rdev->flags))
+			info.state |= (1<<MD_DISK_WRITECACHE);
 		if (test_bit(WriteMostly, &rdev->flags))
 			info.state |= (1<<MD_DISK_WRITEMOSTLY);
 	} else {
@@ -5896,6 +5910,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		else
 			clear_bit(WriteMostly, &rdev->flags);
 
+		if (info->state & (1<<MD_DISK_WRITECACHE))
+			set_bit(WriteCache, &rdev->flags);
 		/*
 		 * check whether the device shows up in other nodes
 		 */
@@ -7264,6 +7280,10 @@ static int md_seq_show(struct seq_file *seq, void *v)
 				seq_printf(seq, "(F)");
 				continue;
 			}
+			if (test_bit(WriteCache, &rdev->flags)) {
+				seq_printf(seq, "(C)");
+				continue;
+			}
 			if (rdev->raid_disk < 0)
 				seq_printf(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4046a6c..6857592 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -175,6 +175,10 @@ enum flag_bits {
 				 * This device is seen locally but not
 				 * by the whole cluster
 				 */
+	WriteCache,		/* This device is used as write cache.
+				 * Usually, this device should be faster
+				 * than other devices in the array
+				 */
 };
 
 #define BB_LEN_MASK	(0x00000000000001FFULL)
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 2ae6131..8c8e12c 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -89,6 +89,7 @@
 				   * read requests will only be sent here in
 				   * dire need
 				   */
+#define MD_DISK_WRITECACHE      18 /* disk is used as the write cache in RAID-5/6 */
 
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
@@ -302,6 +303,7 @@ struct mdp_superblock_1 {
 #define	MD_FEATURE_RECOVERY_BITMAP	128 /* recovery that is happening
 					     * is guided by bitmap.
 					     */
+#define	MD_FEATURE_WRITE_CACHE		256 /* support write cache */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -310,6 +312,7 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
 					|MD_FEATURE_RECOVERY_BITMAP	\
+					|MD_FEATURE_WRITE_CACHE		\
 					)
 
 #endif
-- 
1.8.1

