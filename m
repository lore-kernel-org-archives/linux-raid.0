From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] md/raid1: Do not clear bitmap bit if submit_bio_wait() fails
Date: Thu, 22 Oct 2015 12:01:31 -0400
Message-ID: <1445529692-5385-1-git-send-email-Jes.Sorensen@redhat.com>
References: <wrfjpp06lws6.fsf@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjpp06lws6.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, xni@redhat.com, William.Kuzeja@stratus.com, nate.dailey@stratus.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

If submit_bio_wait fails(), we should always set 'ok' to 0, as this
means the write failed. This way the bitmap bit won't be cleared and
the chunk will eventually be resynced.

This is a slightly modified version of a patch provided by Nate
Dailey.

Reported-by: Nate Dailey <nate.dailey@stratus.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cfca6ed..80a61a2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2195,11 +2195,11 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) < 0)
+		if (submit_bio_wait(WRITE, wbio) < 0) {
 			/* failure! */
-			ok = rdev_set_badblocks(rdev, sector,
-						sectors, 0)
-				&& ok;
+			ok = 0;
+			rdev_set_badblocks(rdev, sector, sectors, 0);
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
-- 
2.4.3

