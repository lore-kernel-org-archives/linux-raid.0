From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/24] md/bitmap: remove bitmap_mask_state
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084340.6433.26662.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This function isn't really needed.  It sets or clears a flag in both
bitmap->flags and sb->state.
However both times it is called, bitmap_update_sb is called soon
afterwards which copies bitmap->flags to sb->state.
So just make changes to bitmap->flags, and open-code those rather than
hiding in a function.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 79dafff..f5f0ec5 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -638,38 +638,6 @@ out_no_sb:
 	return err;
 }
 
-enum bitmap_mask_op {
-	MASK_SET,
-	MASK_UNSET
-};
-
-/* record the state of the bitmap in the superblock.  Return the old value */
-static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
-			     enum bitmap_mask_op op)
-{
-	bitmap_super_t *sb;
-	int old;
-
-	if (!bitmap->storage.sb_page) /* can't set the state */
-		return 0;
-	sb = kmap_atomic(bitmap->storage.sb_page);
-	old = le32_to_cpu(sb->state) & bits;
-	switch (op) {
-	case MASK_SET:
-		sb->state |= cpu_to_le32(bits);
-		bitmap->flags |= bits;
-		break;
-	case MASK_UNSET:
-		sb->state &= cpu_to_le32(~bits);
-		bitmap->flags &= ~bits;
-		break;
-	default:
-		BUG();
-	}
-	kunmap_atomic(sb);
-	return old;
-}
-
 /*
  * general bitmap file operations
  */
@@ -826,7 +794,8 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 {
 	char *path, *ptr = NULL;
 
-	if (bitmap_mask_state(bitmap, BITMAP_STALE, MASK_SET) == 0) {
+	if (!(bitmap->flags & BITMAP_STALE)) {
+		bitmap->flags |= BITMAP_STALE;
 		bitmap_update_sb(bitmap);
 
 		if (bitmap->storage.file) {
@@ -1829,7 +1798,7 @@ int bitmap_load(struct mddev *mddev)
 
 	if (err)
 		goto out;
-	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_UNSET);
+	bitmap->flags &= ~BITMAP_STALE;
 
 	/* Kick recovery in case any bits were set */
 	set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);


