From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 03/16] md/bitmap: Delete an unnecessary variable
 initialisation in bitmap_storage_alloc()
Date: Tue, 27 Sep 2016 18:49:14 +0200
Message-ID: <dbf966a0-1c5a-1565-7657-3ad94f849ac1@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 13:20:23 +0200

The local variable "offset" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 78512c6..9b3f723 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -750,7 +750,7 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 				unsigned long chunks, int with_super,
 				int slot_number)
 {
-	int pnum, offset = 0;
+	int pnum, offset;
 	unsigned long num_pages;
 	unsigned long bytes;
 
-- 
2.10.0

