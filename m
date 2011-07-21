From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/34] md/raid5: rearrange a test in fetch_block6.
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023226.6728.14782.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Next patch will unite fetch_block5 and fetch_block6.
First I want to make the differences a little more clear.

For RAID6 if we are writing at all and there is a failed device, then
we need to load or compute every block so we can do a
reconstruct-write.
This case isn't needed for RAID5 - we will do a read-modify-write in
that case.
So make that test a separate test in fetch_block6 rather than merged
with two other tests.

Make a similar change in fetch_block5 so the one bit that is not
needed for RAID6 is clearly separate.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e41b622..100ac1f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2326,9 +2326,8 @@ static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
 	    (dev->toread ||
 	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 	     s->syncing || s->expanding ||
-	     (s->failed &&
-	      (failed_dev->toread ||
-	       (failed_dev->towrite &&
+	     (s->failed && failed_dev->toread) ||
+	     (s->failed && failed_dev->towrite &&
 		!test_bit(R5_OVERWRITE, &failed_dev->flags)))))) {
 		/* We would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
@@ -2399,10 +2398,9 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
 	    (dev->toread ||
 	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 	     s->syncing || s->expanding ||
-	     (s->failed >= 1 &&
-	      (fdev[0]->toread || s->to_write)) ||
-	     (s->failed >= 2 &&
-	      (fdev[1]->toread || s->to_write)))) {
+	     (s->failed >= 1 && fdev[0]->toread) ||
+	     (s->failed >= 2 && fdev[1]->toread) ||
+	     (s->failed && s->to_write)) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */


