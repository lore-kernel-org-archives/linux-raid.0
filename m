From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/22] md/bitmap: update dirty flag when bitmap bits are
	explicitly set.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.22278.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is a sysfs file which allows bits in the write-intent
bitmap to be explicit set - indicating that the block is thought
to be 'dirty'.
When this happens we should really set recovery_cp backwards
to include the block to reflect this dirtiness.

In particular, a 'resync' process will refuse to start if
recovery_cp is beyond the end of the array, so this is needed
to allow a resync to be triggered.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index aeaa30e..5960bd5 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1568,6 +1568,12 @@ void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
 		sector_t sec = (sector_t)chunk << CHUNK_BLOCK_SHIFT(bitmap);
 		bitmap_set_memory_bits(bitmap, sec, 1);
 		bitmap_file_set_bit(bitmap, sec);
+		if (sec < bitmap->mddev->recovery_cp)
+			/* We are asserting that the array is dirty,
+			 * so move the recovery_cp address back so
+			 * that it is obvious that it is dirty
+			 */
+			bitmap->mddev->recovery_cp = sec;
 	}
 }
 


