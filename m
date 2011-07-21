From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 32/36] md/raid10: attempt to fix read errors during
 resync/check
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.12545.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We already attempt to fix read errors found during normal IO
and a 'repair' process.
It is best to try to repair them at any time they are found,
so move a test so that during sync and check a read error will
be corrected by over-writing with good data.

If both (all) devices have known bad blocks in the sync section we
won't try to fix even though the bad blocks might not overlap.  That
should be considered later.

Also if we hit a read error during recovery we don't try to fix it.
It would only be possible to fix if there were at least three copies
of data, which is not very common with RAID10.  But it should still
be considered later.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 428db23..dfea30e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1541,11 +1541,12 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 			if (j == vcnt)
 				continue;
 			mddev->resync_mismatches += r10_bio->sectors;
+			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+				/* Don't fix anything. */
+				continue;
 		}
-		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
-			/* Don't fix anything. */
-			continue;
-		/* Ok, we need to write this bio
+		/* Ok, we need to write this bio, either to correct an
+		 * inconsistency or to correct an unreadable block.
 		 * First we need to fixup bv_offset, bv_len and
 		 * bi_vecs, as the read request might have corrupted these
 		 */


