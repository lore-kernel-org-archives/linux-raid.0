Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCD04908BF
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 20:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839403; cv=none; b=qCGttUj+WvjJaEZg7+fN1bC2gBfTWSUx3SjjaIeHMsSk2COD/1vGt/eg/7hq6xjch8sYfwV1N6OLeAGJh+sDTFdaR9sIRBtFpNfGJRrOU4qTnPFAur4Frss7t1OoCCDopAWe9a7uerD3PBZZyb+KvPsr4QCHbhbcw2LKmdZYOOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839403; c=relaxed/simple;
	bh=5VbqgoxnpZ25+DAS/Bu8wOeDLmqQ+TGKyYgc7R7RYZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI9gVxLzft1lWkGIwgQnMt8KCJWTWVTxlEisGmhW+Ba8r0bxewlI3wkw1qrwrDG0xqZ68RRLGDAVx4K7JY2Si9nKrqkRW01xsq6ZPFYusNxQdY8UlnYcDfTtOymFauX4CzEjR7Cpsw/AQWyPh6niy//kMUp9j8X8BLiF7f94LdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=pWUtozAa; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="pWUtozAa"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4955de8797cso7110615e9.3
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 13:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839391; x=1785444191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LVDrwHOShpJST2v1XpPaKOLt9RN1zMUNY9kPyJb4mps=;
        b=pWUtozAaJSTecCwJDXbOMORoINDMoqgo9Qoopb+fRZGbZ+1dCa8zKImQRbnzXgwtS0
         4bxSTGZ+KB3kbLh8dqXEI6NqPkrJ7dpV3qr0Uhy9JLv6EOyCFQ0M7hmPKIX5uGzEwLJu
         WAjRRQS3RtP+TuPh9cC6966bVDVMFSZoQpJk/xLxg7RN7MSzwL9Xz3zp4XNk5qxbTPVa
         Ij7eQdCt2J9dRmBSjFvR0XePkWBYixyUSYzKKC3gd3hdtkBHQgGXcsohxJs9UXrqalVi
         bZytFv3qu5xQpBMWwy/WkbvtM7H6Yoe0LOjSNcckFsOaOnNOdz7TS0TrRWgJa7+N9MT9
         8NkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839391; x=1785444191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LVDrwHOShpJST2v1XpPaKOLt9RN1zMUNY9kPyJb4mps=;
        b=bWEjVVKNQrup64MWL/a7ignXeoROJTjxBQT4Cw8uM70OnCrDTiDCpwkwzAUYu/MjIh
         DUG7NPmS3/2V4OrQxRuuvVZjTedf+KhKNd8aLZHrePKgwt0w3Y6cKJANHu5/JJhIsGnf
         rP8ZzL7T/wKWxc28OE27fNuNtFfIaLNcb49xmqH9zN++VttD6PiDpxUpAqGgtQMLldes
         pTc7NJp6zsE9+QZy4UIBmclyLXypSzlLgQMVejMTHiGW9PlmIRRfH1c0nd5DZ/JDXIn9
         5DfDM7GQxk8EKer9ZvCru8Svx+KR6sgRLz+3SRB+A3EezK3FAqFy4iGNiRveaYrUGCCK
         NH/A==
X-Forwarded-Encrypted: i=1; AHgh+RrQj2JVZQxwkCIi/WW3e1S/nZ8tKliksI2MxsoUwoSV/r8+XnmqGSFVkPPkkT3saf/N8E/FV5nVH8gV@vger.kernel.org
X-Gm-Message-State: AOJu0YxJy0qoNFZGp6apexSp29i32wpPMkQVbLU7lzOFexhDk4drkjZ9
	j++gm+3+fNXF2U//omNsHUdwI93bp35tq/w7nWOtxczhXxH/wjNUleRmq1XB/7f5Pg==
X-Gm-Gg: AR+sD103sWJ+LHqdAimBdoLILqoRYeuFBUuBCEE+ZIBg+UPjsIo5URB47AHIMi07BCu
	kqy57tTCdbdYz6c8p9VsDHwSC1jTQONJddpErAS+j5u859mC9gHrkPlXBBLWVwWbtY0Bg9D2043
	vIKYizoSwEdRxQbV+4o4f/K7MkFl77sh2GIf+QUQ0fltwCGb6pjRtLUeWhQY/bi+ptchjjjY6am
	5lwwRO/3oKBpY9+ZcVObAPkxT2ocKsZGz9nPHfG16Ui3JrSp0BGz1jdXZCGfOmY6Vf5hMWLk1SQ
	xjjBdeRg5KGBnbbqTAVVUKDWw5FSQJEnQSEh0ZUbEyNl5C7arDSCgWHvIPzAoeg2nP/q1tYahp+
	ad0/NKF1XhmMi53tDc0oKKcbP+0wLrNpEPeLK8QUfS47eE6T/65l2Jmc/Q0Dm2ExLSZpk3LVZ1U
	eI1BXjn1hXUN8rXHgwt9dXX+/oYZQT8kxgDCeaZlpyAH0pitA+nfZgR+J3pag0aygM3KGrVie90
	zVhCvjs5zBBGvGaA/UibRdFc5vW2ulgrGl1vCsNyw==
X-Received: by 2002:a05:600c:6a07:b0:493:a613:56b2 with SMTP id 5b1f17b1804b1-49573c8d700mr36854855e9.8.1784839390786;
        Thu, 23 Jul 2026 13:43:10 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:10 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v5 08/10] md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
Date: Thu, 23 Jul 2026 22:42:04 +0200
Message-ID: <20260723204206.76930-9-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723204206.76930-1-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A read that fails with BLK_STS_P2PDMA cannot succeed against that
member, so mark the leg IO_BLOCKED and let the retry redirect elsewhere.
Skip the read-error machinery: there is nothing on the medium to fix,
fix_read_error()'s probe reads into host pages and would "succeed", and
charging the read-error budget would evict a healthy member under a P2P
read workload.  FailFast eviction is skipped for the same reason -- the
request never reached the wire.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-fable-5
Co-developed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c  | 4 +++-
 drivers/md/raid10.c | 7 ++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 83ebf40237d5..16a47568679f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2657,6 +2657,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
+	/* evaluate before the bio_put() below */
+	blk_status_t status = bio->bi_status;
 	struct mddev *mddev = conf->mddev;
 	sector_t sector;
 
@@ -2674,7 +2676,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * read error.  This is all done synchronously while the array is
 	 * frozen.
 	 */
-	if (mddev->ro) {
+	if (mddev->ro || status == BLK_STS_P2PDMA) {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	} else if (test_bit(FailFast, &rdev->flags)) {
 		md_error(mddev, rdev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 77c7d8a59916..462f622556ed 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2847,7 +2847,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	int slot = r10_bio->read_slot;
-	struct bio *bio;
+	struct bio *bio = r10_bio->devs[slot].bio;
+	/* evaluate before the bio_put() below */
+	blk_status_t status = bio->bi_status;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
 
@@ -2859,11 +2861,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * This is all done synchronously while the array is
 	 * frozen.
 	 */
-	bio = r10_bio->devs[slot].bio;
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
-	if (mddev->ro)
+	if (mddev->ro || status == BLK_STS_P2PDMA)
 		r10_bio->devs[slot].bio = IO_BLOCKED;
 	else if (!test_bit(FailFast, &rdev->flags)) {
 		freeze_array(conf, 1);
-- 
2.52.0

