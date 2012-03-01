From: "majianpeng" <majianpeng@gmail.com>
Subject: md:Badsector must in valid range of component device.
Date: Thu, 1 Mar 2012 19:11:16 +0800
Message-ID: <201203011906162346140@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 98de4803f7ae4ad49b680db4889bbcd1534c5303 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Thu, 1 Mar 2012 15:49:56 +0800
Subject: [PATCH] md:Badsector must in valid range of component device.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..9e7090c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2969,7 +2969,7 @@ __ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_stor
 static ssize_t
 badblocks_show(struct badblocks *bb, char *page, int unack);
 static ssize_t
-badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack);
+badblocks_store(struct md_rdev *rdev, const char *page, size_t len, int unack);
 
 static ssize_t bb_show(struct md_rdev *rdev, char *page)
 {
@@ -2977,7 +2977,7 @@ static ssize_t bb_show(struct md_rdev *rdev, char *page)
 }
 static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len)
 {
-	int rv = badblocks_store(&rdev->badblocks, page, len, 0);
+	int rv = badblocks_store(rdev, page, len, 0);
 	/* Maybe that ack was all we needed */
 	if (test_and_clear_bit(BlockedBadBlocks, &rdev->flags))
 		wake_up(&rdev->blocked_wait);
@@ -2993,7 +2993,7 @@ static ssize_t ubb_show(struct md_rdev *rdev, char *page)
 }
 static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len)
 {
-	return badblocks_store(&rdev->badblocks, page, len, 1);
+	return badblocks_store(rdev, page, len, 1);
 }
 static struct rdev_sysfs_entry rdev_unack_bad_blocks =
 __ATTR(unacknowledged_bad_blocks, S_IRUGO|S_IWUSR, ubb_show, ubb_store);
@@ -8110,11 +8110,12 @@ retry:
 #define DO_DEBUG 1
 
 static ssize_t
-badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack)
+badblocks_store(struct md_rdev *rdev, const char *page, size_t len, int unack)
 {
 	unsigned long long sector;
 	int length;
 	char newline;
+	struct badblocks *bb = &rdev->badblocks;
 #ifdef DO_DEBUG
 	/* Allow clearing via sysfs *only* for testing/debugging.
 	 * Normally only a successful write may clear a badblock
@@ -8138,6 +8139,10 @@ badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack)
 		return -EINVAL;
 	}
 
+	if (sector < rdev->data_offset)
+		return -EINVAL;
+	if (sector + length > rdev->sectors + rdev->data_offset)
+		return -EINVAL;
 #ifdef DO_DEBUG
 	if (clear) {
 		md_clear_badblocks(bb, sector, length);
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-01

