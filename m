From: Lidong Zhong <lzhong@suse.com>
Subject: [Patch v5] super1: fix sb->max_dev when adding a new disk in linear array
Date: Thu, 25 May 2017 17:28:11 +0800
Message-ID: <20170525092811.3868-1-lzhong@suse.com>
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
 super1.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 2fcb814..86ec850 100644
--- a/super1.c
+++ b/super1.c
@@ -1267,8 +1267,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				break;
 		sb->dev_number = __cpu_to_le32(i);
 		info->disk.number = i;
-		if (max >= __le32_to_cpu(sb->max_dev))
+		if (i >= max) {
 			sb->max_dev = __cpu_to_le32(max+1);
+		}
 
 		random_uuid(sb->device_uuid);
 
@@ -1293,7 +1294,11 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			}
 		}
 	} else if (strcmp(update, "linear-grow-update") == 0) {
+		int max = __le32_to_cpu(sb->max_dev);
 		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
+		if (info->array.raid_disks > max) {
+			sb->max_dev = __cpu_to_le32(max+1);
+		}
 		sb->dev_roles[info->disk.number] =
 			__cpu_to_le16(info->disk.raid_disk);
 	} else if (strcmp(update, "resync") == 0) {
-- 
2.12.0

