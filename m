From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 2/3] md: bitmap: improve bitmap maintenance code.
Date: Mon, 25 May 2009 14:33:52 +1000
Message-ID: <20090525043352.3758.44520.stgit@notabene.brown>
References: <20090525042538.3758.7928.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090525042538.3758.7928.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

The code for checking which bits in the bitmap can be cleared
has 2 problems:
 1/ it repeatedly takes and drops a spinlock, where it would make
    more sense to just hold on to it most of the time.
 2/ it doesn't make use of some opportunities to skip large sections
    of the bitmap

This patch fixes those.  It will only affect CPU consumption, not
correctness.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 47c68bc..56df1ce 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1097,14 +1097,12 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 	}
 	bitmap->allclean = 1;
 
+	spin_lock_irqsave(&bitmap->lock, flags);
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
-		spin_lock_irqsave(&bitmap->lock, flags);
-		if (!bitmap->filemap) {
+		if (!bitmap->filemap)
 			/* error or shutdown */
-			spin_unlock_irqrestore(&bitmap->lock, flags);
 			break;
-		}
 
 		page = filemap_get_page(bitmap, j);
 
@@ -1121,6 +1119,8 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 					write_page(bitmap, page, 0);
 					bitmap->allclean = 0;
 				}
+				spin_lock_irqsave(&bitmap->lock, flags);
+				j |= (PAGE_BITS - 1);
 				continue;
 			}
 
@@ -1181,9 +1181,10 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 					ext2_clear_bit(file_page_offset(j), paddr);
 				kunmap_atomic(paddr, KM_USER0);
 			}
-		}
-		spin_unlock_irqrestore(&bitmap->lock, flags);
+		} else
+			j |= PAGE_COUNTER_MASK;
 	}
+	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	/* now sync the final page */
 	if (lastpage != NULL) {


