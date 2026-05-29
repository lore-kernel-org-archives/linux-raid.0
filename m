Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADB348C62
	for <linux-raid@vger.kernel.org>; Fri, 29 May 2026 05:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033397; cv=none; b=Kf8Pq7g6bi+Rqv9iPsi//mMepaX726F8Mwu3UN/8I0jXn/dN0+wnmAflm8STpcoJgZdzr9jo3/zlcJ1eT/1NsYXkyBAvy5nX9EqkfbXTH2wkDlBqSt2cqW0sursM+2A9XewtoO8VUgjRH4HOu98VBM/3XdtWF2fDzDAAqifheZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033397; c=relaxed/simple;
	bh=3mnMn8kMycRjvIUanNWDZ0ctc8KWogKW44yEkjvzwA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqXGudHpi57nYAcAhIZO8OPt5K0EC5/snFEdKPBXsS9HwEDq73yim92PEB8qB7fvixG82GCb7UFdVwwiyeyImqClTClDsQw4oXuNOMrCHVWHbdd2PAieqUj4Xitdjk0YuaSFtitOJpheyXsrnZvL2qNVxoTPnaQ9DMRElQ9VmSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cf+Cpx3C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cf+Cpx3C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Iaqrwuir8BIycmea89Sohb0GLicKlbItR3P+Ezxwmcs=; b=cf+Cpx3C9ttq9Qe4UrqImf4Kl6
	hMh+wpF7tBvIF6Lj5Me683xYzccnLNNbueYm966D8PmJphQYFDZUI7CWgYZRPb0/A0OcCL0yw0iC+
	UR49aFL2953qlaPCDMX+7+Z5GgT0li3aQgFaB9onYwXHwotkwmKJcKxjyit3+4/5snqCsozs1wAUS
	ShPtsgk0rJzTAVAqUEJNCOLJUSQSGjTsrYtBEsryyjMTnSIbaarSTW8yPOxR3uGkfEEZROBgorMYL
	+qpQNJOlQ/VJ1bB5jTIdupQ1PAo4TaRy00N6Xfs6rlOF8/Kpv9nUQqLuqEyJW3ig1iSbjSWPUVZmz
	2YaqBVNg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSq03-00000006luN-2maS;
	Fri, 29 May 2026 05:43:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md/raid1: cleanup handle_read_error
Date: Fri, 29 May 2026 07:42:59 +0200
Message-ID: <20260529054308.2720300-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529054308.2720300-1-hch@lst.de>
References: <20260529054308.2720300-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unwind the main conditional with duplicate conditions and initialize
variables at initialization time where possible.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 64d970e2ef50..8fad1692cf66 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2627,35 +2627,33 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 
 static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
+	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
+	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
 	struct mddev *mddev = conf->mddev;
-	struct bio *bio;
-	struct md_rdev *rdev;
 	sector_t sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
-	/* we got a read error. Maybe the drive is bad.  Maybe just
-	 * the block and we can fix it.
-	 * We freeze all other IO, and try reading the block from
-	 * other devices.  When we find one, we re-write
-	 * and check it that fixes the read error.
-	 * This is all done synchronously while the array is
-	 * frozen
-	 */
 
-	bio = r1_bio->bios[r1_bio->read_disk];
 	bio_put(bio);
 	r1_bio->bios[r1_bio->read_disk] = NULL;
 
-	rdev = conf->mirrors[r1_bio->read_disk].rdev;
-	if (mddev->ro == 0
-	    && !test_bit(FailFast, &rdev->flags)) {
+	/*
+	 * We got a read error. Maybe the drive is bad.  Maybe just the block
+	 * and we can fix it.
+	 *
+	 * If allowed, freeze all other IO, and try reading the block from other
+	 * devices.  If we find one, we re-write and check it that fixes the
+	 * read error.  This is all done synchronously while the array is
+	 * frozen.
+	 */
+	if (mddev->ro) {
+		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+	} else if (test_bit(FailFast, &rdev->flags)) {
+		md_error(mddev, rdev);
+	} else {
 		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio);
 		unfreeze_array(conf);
-	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
-		md_error(mddev, rdev);
-	} else {
-		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
-- 
2.53.0

