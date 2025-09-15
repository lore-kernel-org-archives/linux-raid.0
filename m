Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13021270569
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907830; cv=none; b=shXBlj1N6II5kspSO1O0+/gdO5Hfcy/T2MlNaAGL5Bm1tkMQ812K52Sum3br3x2GnnB5TiFdxx5mqI3OBrHV++LmYlYcSdzmEKor1zvO3H1Doz/TnNbh0EkFT7mITyguXHfL+NDCVVs51JwPNOvrwcqhcVdpNCgblAougTpLoOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907830; c=relaxed/simple;
	bh=4CLcBBkjK36gEeYIZwEui/NZjEwFgXh9aYprXRLtRug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UY1yMYlGpRJwSq3y8QusZPuc7/tvYKI3k2GIJzYsAK0mCoZMi51S/BMxyROX+dxshLE0nQQQfdOx9+LRfx5sQWbyzbuFxMjDFqjg0yvjHznCMtv68cYHrK2/yD1NU1U22P+I/8NFzxt5PwwDUES3J+jyrzYFqXLhhFhczXVbboM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=slVGW7LA; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="slVGW7LA"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZn004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:16 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=RJxV4KK8ZU7rxaRBtg/Q1j5+pT7wrtjDTMfXC7sU52Y=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907796; v=1;
        b=slVGW7LATuFQMqYfeezIbLpXf/DneP0VulPE6a+NXMHbI1uOJLXpDr2pXpXvzuno
         sg3gyxQfLhJ1Y5aXGeuOpJMc1la/9WUAtGPHq0JXMcHcOevaJ/ELxV75y3LisNJW
         q/966omQdWkIBMgYtRgKYvva/PNOlDg5T/R0UhgG2Xf8c7UVbdgPZFnopWFwmnHF
         EghZJm5OmNTEtvbo7E1J3jfIMfpNO480OgJVlcC8OLe3B/XCSIz5WQgQUfvkIgyQ
         CYcvdYcGmxvoVrbjIJit8zzh9qSwyEOF0QtcACwWMW8sOZWt573jowHhvJSgBnyB
         PDG8v0FasebMymovhzfwAg==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 6/9] md/raid1,raid10: Fix missing retries Failfast write bios on no-bbl rdevs
Date: Mon, 15 Sep 2025 12:42:07 +0900
Message-ID: <20250915034210.8533-7-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915034210.8533-1-k@mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the current implementation, write failures are not retried on rdevs
with badblocks disabled. This is because narrow_write_error, which issues
retry bios, immediately returns when badblocks are disabled. As a result,
a single write failure on such an rdev will immediately mark it as Faulty.

The retry mechanism appears to have been implemented under the assumption
that a bad block is involved in the failure. However, the retry after
MD_FAILFAST write failure depend on this code, and a Failfast write request
may fail for reasons unrelated to bad blocks.

Consequently, if failfast is enabled and badblocks are disabled on all
rdevs, and all rdevs encounter a failfast write bio failure at the same
time, no retries will occur and the entire array can be lost.

This commit adds a path in narrow_write_error to retry writes even on rdevs
where bad blocks are disabled, and failed bios marked with MD_FAILFAST will
use this path. For non-failfast cases, the behavior remains unchanged: no
retry writes are attempted to rdevs with bad blocks disabled.

Fixes: 1919cbb23bf1 ("md/raid10: add failfast handling for writes.")
Fixes: 212e7eb7a340 ("md/raid1: add failfast handling for writes.")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c  | 44 +++++++++++++++++++++++++++++---------------
 drivers/md/raid10.c | 37 ++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 806f5cb33a8e..55213bcd82f4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2521,18 +2521,19 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
  * narrow_write_error() - Retry write and set badblock
  * @r1_bio:	the r1bio containing the write error
  * @i:		which device to retry
+ * @force:	Retry writing even if badblock is disabled
  *
  * Rewrites the bio, splitting it at the least common multiple of the logical
  * block size and the badblock size. Blocks that fail to be written are marked
- * as bad. If badblocks are disabled, no write is attempted and false is
- * returned immediately.
+ * as bad. If bbl disabled and @force is not set, no retry is attempted.
+ * If bbl disabled and @force is set, the write is retried in the same way.
  *
  * Return:
  * * %true	- all blocks were written or marked bad successfully
  * * %false	- bbl disabled or
  *		  one or more blocks write failed and could not be marked bad
  */
-static bool narrow_write_error(struct r1bio *r1_bio, int i)
+static bool narrow_write_error(struct r1bio *r1_bio, int i, bool force)
 {
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
@@ -2553,13 +2554,17 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r1_bio->sectors;
-	bool ok = true;
+	bool write_ok = true;
+	bool setbad_ok = true;
+	bool bbl_enabled = !(rdev->badblocks.shift < 0);
 
-	if (rdev->badblocks.shift < 0)
+	if (!force && !bbl_enabled)
 		return false;
 
-	block_sectors = roundup(1 << rdev->badblocks.shift,
-				bdev_logical_block_size(rdev->bdev) >> 9);
+	block_sectors = bdev_logical_block_size(rdev->bdev) >> 9;
+	if (bbl_enabled)
+		block_sectors = roundup(1 << rdev->badblocks.shift,
+					block_sectors);
 	sector = r1_bio->sector;
 	sectors = ((sector + block_sectors)
 		   & ~(sector_t)(block_sectors - 1))
@@ -2587,18 +2592,22 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 
-		if (submit_bio_wait(wbio) < 0)
+		if (submit_bio_wait(wbio) < 0) {
 			/* failure! */
-			ok = rdev_set_badblocks(rdev, sector,
-						sectors, 0)
-				&& ok;
+			write_ok = false;
+			if (bbl_enabled)
+				setbad_ok = rdev_set_badblocks(rdev, sector,
+							       sectors, 0)
+					    && setbad_ok;
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
 		sector += sectors;
 		sectors = block_sectors;
 	}
-	return ok;
+	return (write_ok ||
+		(bbl_enabled && setbad_ok));
 }
 
 static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
@@ -2631,18 +2640,23 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 
 	for (m = 0; m < conf->raid_disks * 2 ; m++) {
 		struct md_rdev *rdev = conf->mirrors[m].rdev;
-		if (r1_bio->bios[m] == IO_MADE_GOOD) {
+		struct bio *bio = r1_bio->bios[m];
+
+		if (bio == IO_MADE_GOOD) {
 			rdev_clear_badblocks(rdev,
 					     r1_bio->sector,
 					     r1_bio->sectors, 0);
 			rdev_dec_pending(rdev, conf->mddev);
-		} else if (r1_bio->bios[m] != NULL) {
+		} else if (bio != NULL) {
 			/* This drive got a write error.  We need to
 			 * narrow down and record precise write
 			 * errors.
 			 */
 			fail = true;
-			if (!narrow_write_error(r1_bio, m))
+			if (!narrow_write_error(
+					r1_bio, m,
+					test_bit(FailFast, &rdev->flags) &&
+					(bio->bi_opf & MD_FAILFAST)))
 				md_error(conf->mddev, rdev);
 				/* an I/O failed, we can't clear the bitmap */
 			else if (test_bit(In_sync, &rdev->flags) &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 21c2821453e1..92cf3047dce6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2813,18 +2813,18 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
  * narrow_write_error() - Retry write and set badblock
  * @r10_bio:	the r10bio containing the write error
  * @i:		which device to retry
+ * @force:	Retry writing even if badblock is disabled
  *
  * Rewrites the bio, splitting it at the least common multiple of the logical
  * block size and the badblock size. Blocks that fail to be written are marked
- * as bad. If badblocks are disabled, no write is attempted and false is
- * returned immediately.
+ * as bad. If bbl disabled and @force is not set, no retry is attempted.
  *
  * Return:
  * * %true	- all blocks were written or marked bad successfully
  * * %false	- bbl disabled or
  *		  one or more blocks write failed and could not be marked bad
  */
-static bool narrow_write_error(struct r10bio *r10_bio, int i)
+static bool narrow_write_error(struct r10bio *r10_bio, int i, bool force)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct mddev *mddev = r10_bio->mddev;
@@ -2845,13 +2845,17 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r10_bio->sectors;
-	bool ok = true;
+	bool write_ok = true;
+	bool setbad_ok = true;
+	bool bbl_enabled = !(rdev->badblocks.shift < 0);
 
-	if (rdev->badblocks.shift < 0)
+	if (!force && !bbl_enabled)
 		return false;
 
-	block_sectors = roundup(1 << rdev->badblocks.shift,
-				bdev_logical_block_size(rdev->bdev) >> 9);
+	block_sectors = bdev_logical_block_size(rdev->bdev) >> 9;
+	if (bbl_enabled)
+		block_sectors = roundup(1 << rdev->badblocks.shift,
+					block_sectors);
 	sector = r10_bio->sector;
 	sectors = ((r10_bio->sector + block_sectors)
 		   & ~(sector_t)(block_sectors - 1))
@@ -2871,18 +2875,22 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
 
-		if (submit_bio_wait(wbio) < 0)
+		if (submit_bio_wait(wbio) < 0) {
 			/* Failure! */
-			ok = rdev_set_badblocks(rdev, wsector,
-						sectors, 0)
-				&& ok;
+			write_ok = false;
+			if (bbl_enabled)
+				setbad_ok = rdev_set_badblocks(rdev, wsector,
+							       sectors, 0)
+					    && setbad_ok;
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
 		sector += sectors;
 		sectors = block_sectors;
 	}
-	return ok;
+	return (write_ok ||
+		(bbl_enabled && setbad_ok));
 }
 
 static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
@@ -2988,7 +2996,10 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				if (!narrow_write_error(r10_bio, m))
+				if (!narrow_write_error(
+						r10_bio, m,
+						test_bit(FailFast, &rdev->flags) &&
+						(bio->bi_opf & MD_FAILFAST)))
 					md_error(conf->mddev, rdev);
 				else if (test_bit(In_sync, &rdev->flags) &&
 					 !test_bit(Faulty, &rdev->flags) &&
-- 
2.50.1

