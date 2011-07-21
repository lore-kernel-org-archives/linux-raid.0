From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/34] md/raid10: factor out common bio handling code
Date: Thu, 21 Jul 2011 12:32:24 +1000
Message-ID: <20110721023224.6728.36785.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

When normal-write and sync-read/write bio completes, we should
find out the disk number the bio belongs to. Factor those common
code out to a separate function.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   44 +++++++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d55ae12..e434f1e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -244,6 +244,23 @@ static inline void update_head_pos(int slot, r10bio_t *r10_bio)
 		r10_bio->devs[slot].addr + (r10_bio->sectors);
 }
 
+/*
+ * Find the disk number which triggered given bio
+ */
+static int find_bio_disk(conf_t *conf, r10bio_t *r10_bio, struct bio *bio)
+{
+	int slot;
+
+	for (slot = 0; slot < conf->copies; slot++)
+		if (r10_bio->devs[slot].bio == bio)
+			break;
+
+	BUG_ON(slot == conf->copies);
+	update_head_pos(slot, r10_bio);
+
+	return r10_bio->devs[slot].devnum;
+}
+
 static void raid10_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -289,13 +306,10 @@ static void raid10_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r10bio_t *r10_bio = bio->bi_private;
-	int slot, dev;
+	int dev;
 	conf_t *conf = r10_bio->mddev->private;
 
-	for (slot = 0; slot < conf->copies; slot++)
-		if (r10_bio->devs[slot].bio == bio)
-			break;
-	dev = r10_bio->devs[slot].devnum;
+	dev = find_bio_disk(conf, r10_bio, bio);
 
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
@@ -316,8 +330,6 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 
-	update_head_pos(slot, r10_bio);
-
 	/*
 	 *
 	 * Let's see if all mirrored write operations have finished
@@ -1173,14 +1185,9 @@ static void end_sync_read(struct bio *bio, int error)
 {
 	r10bio_t *r10_bio = bio->bi_private;
 	conf_t *conf = r10_bio->mddev->private;
-	int i,d;
+	int d;
 
-	for (i=0; i<conf->copies; i++)
-		if (r10_bio->devs[i].bio == bio)
-			break;
-	BUG_ON(i == conf->copies);
-	update_head_pos(i, r10_bio);
-	d = r10_bio->devs[i].devnum;
+	d = find_bio_disk(conf, r10_bio, bio);
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
@@ -1211,18 +1218,13 @@ static void end_sync_write(struct bio *bio, int error)
 	r10bio_t *r10_bio = bio->bi_private;
 	mddev_t *mddev = r10_bio->mddev;
 	conf_t *conf = mddev->private;
-	int i,d;
+	int d;
 
-	for (i = 0; i < conf->copies; i++)
-		if (r10_bio->devs[i].bio == bio)
-			break;
-	d = r10_bio->devs[i].devnum;
+	d = find_bio_disk(conf, r10_bio, bio);
 
 	if (!uptodate)
 		md_error(mddev, conf->mirrors[d].rdev);
 
-	update_head_pos(i, r10_bio);
-
 	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
 		if (r10_bio->master_bio == NULL) {


