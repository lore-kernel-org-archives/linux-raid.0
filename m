Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB0824A066;
	Thu, 12 Jun 2025 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749734865; cv=none; b=jYVbTRHknZIP9+02bvxxvW/DGRlORPSwSImnZy/pt+tsWGjVm7f+qz2Heybk0nVSc5aNZtLATBrhf5crn64Z9ANQb1zUDk5Jke3Uvpt6GJfTfpF+G9zZhoyFIBdqTFekXlnSZ42yVjZHNntP/TUzfDzUUhSkBhSlgnPjs4vpilg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749734865; c=relaxed/simple;
	bh=2axOLzUf30BQP5kOoNmargzDJdFzgivypedmX5gDPFM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PsaS7r1Ybv9Zo/o/zO2zAZXxWCeDq01eXnCC/UDDsLA893sxSg6r/ey5KwaPP0CYqeitD2hmBwWDO2CP3C4dgxKaTBCNI1WOlMkPgz2g38NRTlFSJeDkB5DpeB2XZijXg5oW7svpXQ8NXPNrRLFgrN8ldZ3EBs1p7apPVqFmJn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bJ3HH5VrlzYQv41;
	Thu, 12 Jun 2025 21:27:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BC6C81A0D9E;
	Thu, 12 Jun 2025 21:27:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB321_J1Upo_mswPQ--.39170S4;
	Thu, 12 Jun 2025 21:27:38 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH] md/raid1,raid10: fix IO handle for REQ_NOWAIT
Date: Thu, 12 Jun 2025 21:21:41 +0800
Message-Id: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321_J1Upo_mswPQ--.39170S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGFW8ZF17XFWUtFyUur1xXwb_yoW5Cw18p3
	47Ga9av39rGFWUZ3WDtFWUXa4Fka1Fgay7C3yUJ34xXas09FZ8Aa1DJ34Ygrs8XFWrur12
	q3WrWw4UCFWayFUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8imRUUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

IO with REQ_NOWAIT should not set R1BIO_Uptodate when it fails,
and bad blocks should also be cleared when REQ_NOWAIT IO succeeds.

Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/raid1.c  | 11 ++++++-----
 drivers/md/raid10.c |  9 +++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c5a0ce5a40..a1cddd24b178 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -455,13 +455,13 @@ static void raid1_end_write_request(struct bio *bio)
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
 	sector_t lo = r1_bio->sector;
 	sector_t hi = r1_bio->sector + r1_bio->sectors;
-	bool ignore_error = !raid1_should_handle_error(bio) ||
-		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
+	bool discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
 
 	/*
 	 * 'one mirror IO has finished' event handler:
 	 */
-	if (bio->bi_status && !ignore_error) {
+	if (bio->bi_status && !discard_error &&
+	    raid1_should_handle_error(bio)) {
 		set_bit(WriteErrorSeen,	&rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED, &
@@ -507,12 +507,13 @@ static void raid1_end_write_request(struct bio *bio)
 		 * check this here.
 		 */
 		if (test_bit(In_sync, &rdev->flags) &&
-		    !test_bit(Faulty, &rdev->flags))
+		    !test_bit(Faulty, &rdev->flags) &&
+		    (!bio->bi_status || discard_error))
 			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
-		    !ignore_error) {
+		    !bio->bi_status) {
 			r1_bio->bios[mirror] = IO_MADE_GOOD;
 			set_bit(R1BIO_MadeGood, &r1_bio->state);
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..1848947b0a6d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -458,8 +458,8 @@ static void raid10_end_write_request(struct bio *bio)
 	int slot, repl;
 	struct md_rdev *rdev = NULL;
 	struct bio *to_put = NULL;
-	bool ignore_error = !raid1_should_handle_error(bio) ||
-		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
+	bool discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
+	bool ignore_error = !raid1_should_handle_error(bio) || discard_error;
 
 	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 
@@ -522,13 +522,14 @@ static void raid10_end_write_request(struct bio *bio)
 		 * check this here.
 		 */
 		if (test_bit(In_sync, &rdev->flags) &&
-		    !test_bit(Faulty, &rdev->flags))
+		    !test_bit(Faulty, &rdev->flags) &&
+		    (!bio->bi_status || discard_error))
 			set_bit(R10BIO_Uptodate, &r10_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
 				      r10_bio->sectors) &&
-		    !ignore_error) {
+		    !bio->bi_status) {
 			bio_put(bio);
 			if (repl)
 				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
-- 
2.39.2

