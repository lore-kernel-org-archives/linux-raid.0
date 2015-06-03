From: Shaohua Li <shli@fb.com>
Subject: [PATCH v3 1/8] MD: add a new disk role to present cache device
Date: Wed, 3 Jun 2015 15:48:36 -0700
Message-ID: <d93a4bc7511c04c39914eebe70816ca671a362ea.1433356864.git.shli@fb.com>
References: <cover.1433356864.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1433356864.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

Next patches will use a disk as raid5/6 caching. We need a new disk role
to present the cache device

Not sure if we should bump up the MD superblock version for the disk
role.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c                | 14 +++++++++++++-
 drivers/md/md.h                |  4 ++++
 include/uapi/linux/raid/md_p.h |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2750630..6297087 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1656,6 +1656,9 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		case 0xfffe: /* faulty */
 			set_bit(Faulty, &rdev->flags);
 			break;
+		case 0xfffd: /* cache device */
+			set_bit(WriteCache, &rdev->flags);
+			break;
 		default:
 			rdev->saved_raid_disk = role;
 			if ((le32_to_cpu(sb->feature_map) &
@@ -1811,6 +1814,8 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
+		else if (test_bit(WriteCache, &rdev2->flags))
+			sb->dev_roles[i] = cpu_to_le16(0xfffd);
 		else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
@@ -5780,7 +5785,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 		else if (test_bit(In_sync, &rdev->flags)) {
 			info.state |= (1<<MD_DISK_ACTIVE);
 			info.state |= (1<<MD_DISK_SYNC);
-		}
+		} else if (test_bit(WriteCache, &rdev->flags))
+			info.state |= (1<<MD_DISK_WRITECACHE);
 		if (test_bit(WriteMostly, &rdev->flags))
 			info.state |= (1<<MD_DISK_WRITEMOSTLY);
 	} else {
@@ -5895,6 +5901,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		else
 			clear_bit(WriteMostly, &rdev->flags);
 
+		if (info->state & (1<<MD_DISK_WRITECACHE))
+			set_bit(WriteCache, &rdev->flags);
 		/*
 		 * check whether the device shows up in other nodes
 		 */
@@ -7263,6 +7271,10 @@ static int md_seq_show(struct seq_file *seq, void *v)
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
index 2ae6131..9d36b91 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -89,6 +89,7 @@
 				   * read requests will only be sent here in
 				   * dire need
 				   */
+#define MD_DISK_WRITECACHE      18 /* disk is used as the write cache in RAID-5/6 */
 
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
-- 
1.8.1

