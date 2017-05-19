From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH v3] super1: fix sb->max_dev when adding a new disk in linear array
Date: Fri, 19 May 2017 14:06:38 +0800
Message-ID: <20170519060638.4470-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.com
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
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
 super1.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 2fcb814..811923f 100644
--- a/super1.c
+++ b/super1.c
@@ -1267,8 +1267,13 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				break;
 		sb->dev_number = __cpu_to_le32(i);
 		info->disk.number = i;
-		if (max >= __le32_to_cpu(sb->max_dev))
-			sb->max_dev = __cpu_to_le32(max+1);
+		if (i >= max) {
+			while (max <= i) {
+				sb->dev_roles[max] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
+				max += 1;
+			}
+			sb->max_dev = __cpu_to_le32(max);
+		}
 
 		random_uuid(sb->device_uuid);
 
@@ -1296,6 +1301,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
 		sb->dev_roles[info->disk.number] =
 			__cpu_to_le16(info->disk.raid_disk);
+		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
+			sb->dev_roles[sb->raid_disks] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
+			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
+		}
 	} else if (strcmp(update, "resync") == 0) {
 		/* make sure resync happens */
 		sb->resync_offset = 0ULL;
-- 
2.12.0

