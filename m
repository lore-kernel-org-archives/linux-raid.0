From: Shaohua Li <shli@fb.com>
Subject: [patch v2 01/11] MD: replace special disk roles with macros
Date: Thu, 13 Aug 2015 14:31:54 -0700
Message-ID: <0c021c87037dcbd0b143adc8827d5a90b330ea62.1439500639.git.shli@fb.com>
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

Add the following two macros for special roles: spare and faulty

MD_DISK_ROLE_SPARE	0xffff
MD_DISK_ROLE_FAULTY	0xfffe

Add MD_DISK_ROLE_MAX	0xff00 as the maximal possible regular role,
and minimal value of special role.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c                | 14 +++++++-------
 include/uapi/linux/raid/md_p.h |  4 ++++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e25f00f..01f9fa0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1626,7 +1626,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		++ev1;
 		if (rdev->desc_nr >= 0 &&
 		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
-		    le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < 0xfffe)
+		    le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX)
 			if (ev1 < mddev->events)
 				return -EINVAL;
 	} else if (mddev->bitmap) {
@@ -1646,14 +1646,14 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		int role;
 		if (rdev->desc_nr < 0 ||
 		    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
-			role = 0xffff;
+			role = MD_DISK_ROLE_SPARE;
 			rdev->desc_nr = -1;
 		} else
 			role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
-		case 0xffff: /* spare */
+		case MD_DISK_ROLE_SPARE: /* spare */
 			break;
-		case 0xfffe: /* faulty */
+		case MD_DISK_ROLE_FAULTY: /* faulty */
 			set_bit(Faulty, &rdev->flags);
 			break;
 		default:
@@ -1803,18 +1803,18 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		max_dev = le32_to_cpu(sb->max_dev);
 
 	for (i=0; i<max_dev;i++)
-		sb->dev_roles[i] = cpu_to_le16(0xfffe);
+		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
 
 	rdev_for_each(rdev2, mddev) {
 		i = rdev2->desc_nr;
 		if (test_bit(Faulty, &rdev2->flags))
-			sb->dev_roles[i] = cpu_to_le16(0xfffe);
+			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
-			sb->dev_roles[i] = cpu_to_le16(0xffff);
+			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
 	}
 
 	sb->sb_csum = calc_sb_1_csum(sb);
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 2ae6131..3105190 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -90,6 +90,10 @@
 				   * dire need
 				   */
 
+#define MD_DISK_ROLE_SPARE	0xffff
+#define MD_DISK_ROLE_FAULTY	0xfffe
+#define MD_DISK_ROLE_MAX	0xff00 /* max value of regular disk role */
+
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
 	__u32 major;		/* 1 Device major number		      */
-- 
1.8.1

