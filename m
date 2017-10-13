From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] md/bitmap: clear BITMAP_WRITE_ERROR bit after reading it from sb
Date: Fri, 13 Oct 2017 18:36:31 +0800
Message-ID: <1507890991-27425-1-git-send-email-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com
List-Id: linux-raid.ids

For a RAID1 device using a file-based bitmap, if a bitmap write error
occurs and the later writes succeed, it's possible both BITMAP_STALE
and BITMAP_WRITE_ERROR bit will be written to the bitmap super block,
and the BITMAP_WRITE_ERROR bit in sb->flags will make bitmap_create()
to fail.

So clear it to protect against the write failure-success case.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/bitmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d212163..97c423a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -688,8 +688,13 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		}
 	}
 
-	/* assign fields using values from superblock */
-	bitmap->flags |= le32_to_cpu(sb->state);
+	/*
+	 * assign fields using values from superblock
+	 * clear BITMAP_WRITE_ERROR bit to protect against the case that
+	 * a bitmap write error had occurred and the later writes had
+	 * succeeded.
+	 */
+	bitmap->flags |= (le32_to_cpu(sb->state) & ~BIT(BITMAP_WRITE_ERROR));
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
-- 
2.5.0

