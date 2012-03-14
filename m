From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/23] md/bitmap: remove some pointless locking.
Date: Wed, 14 Mar 2012 15:40:41 +1100
Message-ID: <20120314044041.7978.90036.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is nothing gained by holding a lock while we check if a pointer
is NULL or not.  If there could be a race, then it could become NULL
immediately after the unlock - but there is no race here.

So just remove the locking.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index fcf3c94..e12b515 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -446,18 +446,13 @@ out:
 void bitmap_update_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
-	unsigned long flags;
 
 	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
 		return;
 	if (bitmap->mddev->bitmap_info.external)
 		return;
-	spin_lock_irqsave(&bitmap->lock, flags);
-	if (!bitmap->sb_page) { /* no superblock */
-		spin_unlock_irqrestore(&bitmap->lock, flags);
+	if (!bitmap->sb_page) /* no superblock */
 		return;
-	}
-	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared)
@@ -683,15 +678,10 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 			     enum bitmap_mask_op op)
 {
 	bitmap_super_t *sb;
-	unsigned long flags;
 	int old;
 
-	spin_lock_irqsave(&bitmap->lock, flags);
-	if (!bitmap->sb_page) { /* can't set the state */
-		spin_unlock_irqrestore(&bitmap->lock, flags);
+	if (!bitmap->sb_page) /* can't set the state */
 		return 0;
-	}
-	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {


