From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 15/16] md/bitmap: Add spaces around three comparison operators
Date: Tue, 27 Sep 2016 19:03:17 +0200
Message-ID: <746915d9-5895-8d39-f50f-6889b7889bab@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 18:08:04 +0200

The script "checkpatch.pl" can point information out like the following.

ERROR: spaces required around that '==' (ctx:VxV)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9d77f16..d029576 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -303,7 +303,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 
 		if (wait)
 			wait_event(bitmap->write_wait,
-				   atomic_read(&bitmap->pending_writes)==0);
+				   atomic_read(&bitmap->pending_writes) == 0);
 	}
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		bitmap_file_kick(bitmap);
@@ -400,7 +400,7 @@ static int read_page(struct file *file, unsigned long index,
 	page->index = index;
 
 	wait_event(bitmap->write_wait,
-		   atomic_read(&bitmap->pending_writes)==0);
+		   atomic_read(&bitmap->pending_writes) == 0);
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags)) {
 		ret = -EIO;
 report_failure:
@@ -1003,7 +1003,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 	}
 	if (bitmap->storage.file)
 		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
+			   atomic_read(&bitmap->pending_writes) == 0);
 	else
 		md_super_wait(bitmap->mddev);
 
-- 
2.10.0

