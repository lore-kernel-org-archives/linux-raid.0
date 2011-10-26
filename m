From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/16] md/raid5: Mark device replaceable when we see a
 write error.
Date: Wed, 26 Oct 2011 12:43:02 +1100
Message-ID: <20111026014302.21110.22612.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that Replaceable drives are replaced cleanly, mark a drive
as replaceable when we see a write error.  It might get failed soon so
the Replaceable flag is irrelevant, but if the write error is recorded
in the bad block log, we still want to activate any spare that might
be available.

Signed-off-by:  NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3f55bef..0ec48d0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1782,6 +1782,9 @@ static void raid5_end_write_request(struct bio *bi, int error)
 		if (!uptodate) {
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
+			if (!test_and_set_bit(Replaceable, &rdev->flags))
+				set_bit(MD_RECOVERY_NEEDED,
+					&rdev->mddev->recovery);
 		} else if (is_badblock(rdev, sh->sector,
 				       STRIPE_SECTORS,
 				       &first_bad, &bad_sectors))


