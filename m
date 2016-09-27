From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 16/16] md/bitmap: Delete an unwanted space in read_sb_page()
Date: Tue, 27 Sep 2016 19:04:13 +0200
Message-ID: <1a74d5fc-af55-e497-1d9f-fa4c79a01864@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 18:18:16 +0200

The script "checkpatch.pl" can point information out like the following.

ERROR: space prohibited after that '!' (ctx:BxW)

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d029576..c6a6d59 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -154,7 +154,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 	sector_t target;
 
 	rdev_for_each(rdev, mddev) {
-		if (! test_bit(In_sync, &rdev->flags)
+		if (!test_bit(In_sync, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
 
-- 
2.10.0

