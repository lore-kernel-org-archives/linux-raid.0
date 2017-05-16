From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] super1: fix sb->max_dev when adding a new disk in linear array
Date: Tue, 16 May 2017 12:51:29 +0800
Message-ID: <20170516045129.21815-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com, neilb@suse.com
List-Id: linux-raid.ids

The value of sb->max_dev will always be increased by 1 when adding
a new disk in linear array. It causes an inconsistence between each
disk in the array and the "Array State" value of "mdadm --examine DISK"
is wrong. For example, when adding the first new disk into linear array
it will be:

Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
('A' == active, '.' == missing, 'R' == replacing)

Adding the second disk into linear array it will be

Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
('A' == active, '.' == missing, 'R' == replacing)

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 super1.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 87a74cb..3d49bee 100644
--- a/super1.c
+++ b/super1.c
@@ -1184,8 +1184,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				break;
 		sb->dev_number = __cpu_to_le32(i);
 		info->disk.number = i;
-		if (max >= __le32_to_cpu(sb->max_dev))
+		if (i >= __le32_to_cpu(sb->max_dev)) {
 			sb->max_dev = __cpu_to_le32(max+1);
+			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
+		}
 
 		random_uuid(sb->device_uuid);
 
@@ -1214,6 +1216,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
 		sb->dev_roles[info->disk.number] =
 			__cpu_to_le16(info->disk.raid_disk);
+		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
+			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
+			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
+		}
 	} else if (strcmp(update, "resync") == 0) {
 		/* make sure resync happens */
 		sb->resync_offset = 0ULL;
-- 
2.12.0

