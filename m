From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/16] md/bitmap: fix saving of events_cleared and other
 state.
Date: Wed, 11 May 2011 16:30:30 +1000
Message-ID: <20110511063030.21263.95271.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a bitmap is found to be 'stale' the events_cleared value
is set to match 'events'.
However if the array is degraded this does not get stored on disk.
This can subsequently lead to incorrect behaviour.

So change bitmap_update_sb to always update events_cleared in the
superblock from the known events_cleared.
For neatness also set ->state from ->flags.
This requires updating ->state whenever we update ->flags, which makes
sense anyway.

This is suitable for any active -stable release.

cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5c93627..70bd738 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -493,11 +493,11 @@ void bitmap_update_sb(struct bitmap *bitmap)
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (bitmap->mddev->events < bitmap->events_cleared) {
+	if (bitmap->mddev->events < bitmap->events_cleared)
 		/* rocking back to read-only */
 		bitmap->events_cleared = bitmap->mddev->events;
-		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
-	}
+	sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
+	sb->state = cpu_to_le32(bitmap->flags);
 	/* Just in case these have been changed via sysfs: */
 	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
 	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
@@ -618,7 +618,7 @@ success:
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		bitmap->flags |= BITMAP_HOSTENDIAN;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
-	if (sb->state & cpu_to_le32(BITMAP_STALE))
+	if (bitmap->flags & BITMAP_STALE)
 		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
@@ -652,9 +652,11 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 	switch (op) {
 	case MASK_SET:
 		sb->state |= cpu_to_le32(bits);
+		bitmap->flags |= bits;
 		break;
 	case MASK_UNSET:
 		sb->state &= cpu_to_le32(~bits);
+		bitmap->flags &= ~bits;
 		break;
 	default:
 		BUG();


