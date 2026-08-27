Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3499A286D60
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817414; cv=none; b=qUHV9gm12CXwtnSGs0LBbqtA59HpYi/te4xO215J9n2jOjCgQkf+rc5lzfET8ZOakvPHznbBiryGpH0P2f1STkwrM+W8NoSGlBM/GIr0TL3V6pVekm286Wofz2E20bb1Kn4sTnSQmXeJIREABBcHgVxqmHZJVOMutTSMjzzzi3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817414; c=relaxed/simple;
	bh=qc+goRpWbo3XTRmowRvm/VhDq+TXB607r7aKX2//sDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eDqzNxyUg3lJeU39/yMFDCi5nQXfi08K/02ldIWpHWmb4AzJUVEWPVxNXFkEJDFfzD/wgMti3w8eQuTMsTZ4iSs/orDH3mhj8kCvy5FDDE4WTsRSLc4CNMdvzG2QViI8r8ZRQiupGIuVvOKAoWzH1Atf3UFGYGBl6V2jJygsEog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=N2ytjc6d; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="N2ytjc6d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ny
	AUfmghyrAfFY5cHSzB1Xh0Nsj1k5ZBQY4JxhsTfRQ=; b=N2ytjc6d/0blKt/Hpe
	gZOS6Pid5gv5DEKC01SCTVeaOfUiVSeOfxMvGA8m5efPXJ1U2bZXI6RuieY724qx
	xIzYM7d0kj/EtnVIFy+hvPOfr8RAZDYyHxUxlFigXrNOENPFtmJhj2JsRGuKzHEC
	S++XWGh1U5e5hu95gbO5v2IGQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnY4im7Y9qjfSOSQ--.19943S3;
	Thu, 27 Aug 2026 15:56:25 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH 1/3] md: add rdev_record_write_error() helper
Date: Thu, 27 Aug 2026 15:56:18 +0800
Message-Id: <20260827075620.3599227-2-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260827075620.3599227-1-dayou5941@163.com>
References: <20260827075620.3599227-1-dayou5941@163.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnY4im7Y9qjfSOSQ--.19943S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxKFWDur15ZFWrJr4DGFyUZFb_yoW7Ww17pa
	y3Wasak3y7G3yUJF4DJas8Za4Svw17trZFkry7u34xWa4YyrW5GF1DWFyktw4kXrZY9r4r
	tF1UWw4UZF12gFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UNzVnUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+gkk0mqP7ale0gAA3o

From: Li Youhong <liyouhong@kylinos.cn>

The WriteErrorSeen + WantReplacement + MD_RECOVERY_NEEDED sequence is
duplicated across raid1, raid10 and raid5. Factor it into a small
inline helper for readability. No functional change.

Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 drivers/md/md.h     |  7 +++++++
 drivers/md/raid1.c  | 16 +++-------------
 drivers/md/raid10.c | 21 ++++-----------------
 drivers/md/raid5.c  |  5 +----
 4 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..6440da292105 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -989,6 +989,13 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
 	}
 }
 
+static inline void rdev_record_write_error(struct md_rdev *rdev)
+{
+	set_bit(WriteErrorSeen, &rdev->flags);
+	if (!test_and_set_bit(WantReplacement, &rdev->flags))
+		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
+}
+
 static inline int mddev_is_clustered(struct mddev *mddev)
 {
 	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..9d8441348f14 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -483,10 +483,7 @@ static void raid1_end_write_request(struct bio *bio)
 	 * 'one mirror IO has finished' event handler:
 	 */
 	if (bio->bi_status && !ignore_error) {
-		set_bit(WriteErrorSeen,	&rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED, &
-				conf->mddev->recovery);
+		rdev_record_write_error(rdev);
 
 		if (test_bit(FailFast, &rdev->flags) &&
 		    (bio->bi_opf & MD_FAILFAST) &&
@@ -2067,10 +2064,7 @@ static void end_sync_write(struct bio *bio)
 
 	if (bio->bi_status) {
 		abort_sync_write(mddev, r1_bio);
-		set_bit(WriteErrorSeen, &rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED, &
-				mddev->recovery);
+		rdev_record_write_error(rdev);
 		set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
 		   !rdev_has_badblock(conf->mirrors[r1_bio->read_disk].rdev,
@@ -2088,11 +2082,7 @@ static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
 		/* success */
 		return 1;
 	if (rw == REQ_OP_WRITE) {
-		set_bit(WriteErrorSeen, &rdev->flags);
-		if (!test_and_set_bit(WantReplacement,
-				      &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED, &
-				rdev->mddev->recovery);
+		rdev_record_write_error(rdev);
 	}
 	/* need to record an error - either for the block or the device */
 	rdev_set_badblocks(rdev, sector, sectors, 0);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..c4218d6483ed 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -496,10 +496,7 @@ static void raid10_end_write_request(struct bio *bio)
 			 */
 			md_error(rdev->mddev, rdev);
 		else {
-			set_bit(WriteErrorSeen,	&rdev->flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-				set_bit(MD_RECOVERY_NEEDED,
-					&rdev->mddev->recovery);
+			rdev_record_write_error(rdev);
 
 			dec_rdev = 0;
 			if (test_bit(FailFast, &rdev->flags) &&
@@ -2299,10 +2296,7 @@ static void end_sync_write(struct bio *bio)
 		if (repl)
 			md_error(mddev, rdev);
 		else {
-			set_bit(WriteErrorSeen, &rdev->flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-				set_bit(MD_RECOVERY_NEEDED,
-					&rdev->mddev->recovery);
+			rdev_record_write_error(rdev);
 			set_bit(R10BIO_WriteError, &r10_bio->state);
 		}
 	} else if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
@@ -2500,11 +2494,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 					  pages[idx],
 					  REQ_OP_WRITE, false);
 			if (!ok) {
-				set_bit(WriteErrorSeen, &rdev->flags);
-				if (!test_and_set_bit(WantReplacement,
-						      &rdev->flags))
-					set_bit(MD_RECOVERY_NEEDED,
-						&rdev->mddev->recovery);
+				rdev_record_write_error(rdev);
 			}
 		}
 		if (!ok) {
@@ -2585,10 +2575,7 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
 		/* success */
 		return 1;
 	if (op == REQ_OP_WRITE) {
-		set_bit(WriteErrorSeen, &rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED,
-				&rdev->mddev->recovery);
+		rdev_record_write_error(rdev);
 	}
 	/* need to record an error - either for the block or the device */
 	rdev_set_badblocks(rdev, sector, sectors, 0);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..caacc06c52c5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2888,11 +2888,8 @@ static void raid5_end_write_request(struct bio *bi)
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
 		if (bi->bi_status) {
-			set_bit(WriteErrorSeen, &rdev->flags);
+			rdev_record_write_error(rdev);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-				set_bit(MD_RECOVERY_NEEDED,
-					&rdev->mddev->recovery);
 		} else if (rdev_has_badblock(rdev, sh->sector,
 					     RAID5_STRIPE_SECTORS(conf))) {
 			set_bit(R5_MadeGood, &sh->dev[i].flags);
-- 
2.25.1

