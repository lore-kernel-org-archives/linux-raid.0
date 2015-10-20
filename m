From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] md/raid1: submit_bio_wait() returns 0 on success
Date: Tue, 20 Oct 2015 12:09:12 -0400
Message-ID: <1445357353-19906-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, kent.overstreet@gmail.com, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This was introduced with 9e882242c6193ae6f416f2d8d8db0d9126bd996b
which changed the return value of submit_bio_wait() to return != 0 on
error, but didn't update the caller accordingly.

Fixes: 9e882242c6 ("block: Add submit_bio_wait(), remove from md")
Reported-by: Bill Kuzeja <William.Kuzeja@stratus.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ddd8a5f..905f167 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2195,7 +2195,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) == 0)
+		if (submit_bio_wait(WRITE, wbio))
 			/* failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
-- 
2.4.3

