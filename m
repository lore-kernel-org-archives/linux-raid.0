From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 1/1] super1 block data_size should be member disk size
Date: Tue, 30 Jun 2020 17:33:37 +0800
Message-ID: <1593509617-6305-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org, ncroxon@redhat.com
List-Id: linux-raid.ids

Hi all

It's the patch I want to fix this problem. But I'm not sure I'm right or not. So this
is just for review. If it's right, I'll send the patch formally.

Test:
mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 --size=1G (loop0 and loop1 are 8GB)
Result:
rdev->sectors(kernel space) will be 8GB, it's wrong. It should be 1GB-superblock-bitmap-badblock.

During creating super1.0/1.2 raid device, kernel space calls super_1_load, it sets rdev->sectors
with sb->data_size. If the raid device is created with specifying --size, it doesn't use total
space of disk. But rdev->sectors is still set with the total space of disk(decreasing superblock/bitmap/badblock)

So sb->data_size shoule be the raid member size rather than the total disk size.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index e0d80be..d5d022b 100644
--- a/super1.c
+++ b/super1.c
@@ -2029,7 +2029,7 @@ static int write_init_super1(struct supertype *st)
 			sb->super_offset = __cpu_to_le64(sb_offset);
 			if (sb_offset < array_size + bm_space)
 				bm_space = sb_offset - array_size;
-			sb->data_size = __cpu_to_le64(sb_offset - bm_space);
+			sb->data_size = __cpu_to_le64(array_size);
 			if (bm_space >= 8) {
 				sb->bblog_size = __cpu_to_le16(8);
 				sb->bblog_offset = __cpu_to_le32((unsigned)-8);
@@ -2043,7 +2043,7 @@ static int write_init_super1(struct supertype *st)
 				data_offset = sb_offset + 16;
 
 			sb->data_offset = __cpu_to_le64(data_offset);
-			sb->data_size = __cpu_to_le64(dsize - data_offset);
+			sb->data_size = __cpu_to_le64(array_size);
 			if (data_offset >= sb_offset+bm_offset+bm_space+8) {
 				sb->bblog_size = __cpu_to_le16(8);
 				sb->bblog_offset = __cpu_to_le32(bm_offset +
-- 
2.7.5
