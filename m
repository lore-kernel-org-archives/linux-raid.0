From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 14/16] md/bitmap: Delete unnecessary braces in bitmap_resize()
Date: Tue, 27 Sep 2016 19:02:14 +0200
Message-ID: <c6726cd1-76e6-bd83-0ac2-00cd39473a8c@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 17:53:07 +0200

Do not use curly brackets at one source code place
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index f8900cc..9d77f16 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2075,9 +2075,8 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				unsigned long k;
 
 				/* deallocate the page memory */
-				for (k = 0; k < page; k++) {
+				for (k = 0; k < page; k++)
 					kfree(new_bp[k].map);
-				}
 
 				/* restore some fields from old_counts */
 				bitmap->counts.bp = old_counts.bp;
-- 
2.10.0

