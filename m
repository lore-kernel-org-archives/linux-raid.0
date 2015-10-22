From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] md/raid10: Do not clear bitmap bit if submit_bio_wait() fails
Date: Thu, 22 Oct 2015 12:01:32 -0400
Message-ID: <1445529692-5385-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1445529692-5385-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445529692-5385-1-git-send-email-Jes.Sorensen@redhat.com>
In-Reply-To: <wrfjpp06lws6.fsf@redhat.com>
References: <wrfjpp06lws6.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, xni@redhat.com, William.Kuzeja@stratus.com, nate.dailey@stratus.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

If submit_bio_wait fails(), we should always set 'ok' to 0, as this
means the write failed. This way the bitmap bit won't be cleared and
the chunk will eventually be resynced.

This is a slightly modified version of a patch provided by Nate
Dailey for drivers/md/raid1.c.

Reported-by: Nate Dailey <nate.dailey@stratus.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid10.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3afce75..c1adcd3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2470,11 +2470,11 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) < 0)
+		if (submit_bio_wait(WRITE, wbio) < 0) {
 			/* Failure! */
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

