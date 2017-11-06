From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v2] md/bitmap: clear BITMAP_WRITE_ERROR bit before writing it to sb
Date: Mon, 6 Nov 2017 10:11:25 +0800
Message-ID: <20171106021125.40619-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com
List-Id: linux-raid.ids

For a RAID1 device using a file-based bitmap, if a bitmap write error
occurs but the later writes succeed, it's possible both BITMAP_STALE
and BITMAP_WRITE_ERROR bits will be written to the bitmap super block,
the BITMAP_STALE bit will be handled properly and be cleared, but the
BITMAP_WRITE_ERROR bit in sb->flags will make bitmap_create() to fail.

So clear it to protect against the write failure-and-then-recovery case.

Signed-off-by: Hou Tao <houtao1@huawei.com>

---
v2:
	* clear the BITMAP_WRITE_ERROR bit before writing sb, not after
	reading sb
v1:
	* http://www.spinics.net/lists/raid/msg59590.html
---
 drivers/md/bitmap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d212163..30e503d 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -459,7 +459,11 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		/* rocking back to read-only */
 		bitmap->events_cleared = bitmap->mddev->events;
 	sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
-	sb->state = cpu_to_le32(bitmap->flags);
+	/*
+	 * clear BITMAP_WRITE_ERROR bit to protect against the case that
+	 * a bitmap write error occurred but the later writes succeeded.
+	 */
+	sb->state = cpu_to_le32(bitmap->flags & ~BIT(BITMAP_WRITE_ERROR));
 	/* Just in case these have been changed via sysfs: */
 	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
 	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
-- 
2.9.5

