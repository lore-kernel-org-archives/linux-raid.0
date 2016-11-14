From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/4] md: add bio completion tracing for raid1/raid10
Date: Mon, 14 Nov 2016 16:30:21 +1100
Message-ID: <147910142112.27168.16834874155342134173.stgit@noble>
References: <147910131504.27168.6566119701315109161.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147910131504.27168.6566119701315109161.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raid5 already has this, as does dm.
linear and raid0 do no see completions, only bio_chain_end() or bio_endio()
see those.
So just add it for raid1 and raid10.

Between
 Commit: 3a366e614d08 ("block: add missing block_bio_complete() tracepoint")
and
 Commit: 0a82a8d132b2 ("Revert "block: add missing block_bio_complete() tracepoint"")
in the 3.9-rc series, this was done centrally in bio_endio().
Until/unless that is resurected, do the tracing in the md/raid code.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3710a792a149..0674e5a0142e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -257,6 +257,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
 		bio->bi_error = -EIO;
 
 	if (done) {
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio, bio->bi_error);
 		bio_endio(bio);
 		/*
 		 * Wake up any possible resync thread that waits for the device
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d144c3425824..c3036099ff9a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -311,6 +311,7 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		bio->bi_error = -EIO;
 	if (done) {
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio, bio->bi_error);
 		bio_endio(bio);
 		/*
 		 * Wake up any possible resync thread that waits for the device


