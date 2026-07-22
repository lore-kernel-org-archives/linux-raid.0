Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72A739903B
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746765; cv=none; b=oy8zPz7kRbnu4FVGiXa0RslaEkRzOgWyKURcAZ5FueEteulDpVtIjZdNfp9K+hiqX9cu0hol2jVVYO0J2pDMNdSS9LIMURq7C3SF+NNV7QO8fsXNSMGV+ws6LUNCU8ZzQIqTyye7S34RQjXpo8nmQdCihFIoFrGWusgRMTBQMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746765; c=relaxed/simple;
	bh=n8GgQxWkHVm/KdGafTPsIHfxiB0IxGBQX22H0tLv/oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+NINrFfFG4F1g5pEG0gHpu7xlsuPQWoQdohew7mlnyQnSFUSSy9Kt5wRw+7K51si2eVKDVpt8/XO/F6svciNl4VOlCXoKa80MMxEOKk/Gh+UHmtbZmH9VIxwA9v7ycxabv4AEzl4FBo0imdDmPmQ/r9FP0GkKvbcuIpq3AUmBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=BUD9EGMP; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="BUD9EGMP"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so69842275e9.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746756; x=1785351556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MJ1SD6Cu8vcIcr/kUuDg+vlUw58q6JfkUpXNh8eryGw=;
        b=BUD9EGMP/1U+a0nwK74clxQtwB3Fm+sF+M1EXzUJE5EBTXRCP8t/YTnJJL2fiL3DaU
         RGtm0KUneztislxIlc1Q+0tEucU5M0v56RHyBl0zuvRRuv1WDOINASAaw1ePnYxBHh2X
         yzHHdOgc6q9ZyWd+T7b9/jdCU/okasOSi02zqUIpGd4dYSA3cCJIHJPMroCbo2P/2CKF
         M+Z0bF0YoyByOp9jyResJ4jJUtJN3fultJElB5c6/k7p3M1BBRC3mQ0YUAjPYFBBFDOj
         QxCoC9mCOrsuI67i0dUaZbkkjIBb3auJio1hYn8hzbdhmR6cz2WgS5QfFyeXrYVixWba
         sk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746756; x=1785351556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MJ1SD6Cu8vcIcr/kUuDg+vlUw58q6JfkUpXNh8eryGw=;
        b=MQEkqB1Eeb7KrNQPfKrEah6n4UULvOb4srz2HKX7wdZcKIeKvzVZHK/ro5PskD/Pl6
         1zMJ6dmBv1b2kyV7uPXdw4rxgg8hJ2OS0r4jiH/0usom5dDsRtA5xW6CXBzHRQGJPS0d
         L3pVwfiJU7p+PB+Q7xHWn6pZ5ZM7uLSSIGm5K/hXoN4aXFbPiCFnHqXsaV0JnqKfM0F9
         5oziGonIs3BFMRwFQSlt1uZhveF+KbMqIUr6BvhS3YLZWrldwBsQeDYMi3SlV6sIKeKF
         M3SxFwr+AkWkCoFWaFQguT98zXP88mAYJzZhHq1PBxsxZD/BOTRmGxYVYtHT1sNyUckm
         mtMg==
X-Forwarded-Encrypted: i=1; AHgh+Rrc4vXLTCb6Y15YijVDUcT0t/FlhOIberATVy10liBkdsDLWJi1d5TAtoCOIS4gXwHF4mIHgAc829Un@vger.kernel.org
X-Gm-Message-State: AOJu0YwOiSjRlxPmVcX8V3xMGF83+X8Wls2LO+Da++pKJtOejd7daKkd
	08pwImryMzhIw9c4vwIV2Eyn0iNc8z6eOw8w4t1Psyja93wcsbsGPQ7rDKMTermjlg==
X-Gm-Gg: AR+sD10a68scqExBaxpK+D3dq2zgk0ao7hvK2wZnZ1haMtKchA9VBZexVmUOJyl6oZZ
	glZWS4O3kZa7XLDZCPE3HRSrGh00MkQj8Gqkj9SP1VgoImf2CIV+OGXVwbXeRU6f186zCIihc44
	CdQIdpUuk+LFtdXDWmoLBjxY7mKhOzQuW028KyppwOSWZgXbCT2fxfUiQd8t7anEerIc6CVl09z
	PuOjVg32ya0Y1NP4r3AoONFFXSS1kUKhpw4XelLPGS5uuJ2gcwk5P/0EM54qL1rTTHecF67WMsD
	acVwUPJWVOUBtgbqLck4/z84i3e2R1RuwWqynMfh4i9zuABMfPO2a14xYu90tje+cpcP0h+xhuH
	YvowdcbjDefg+E5jh/RigsSJe1bF4cqhHOWTExke8k9QKhzSn+iWUWA3JM5IP/8BjwlQrt+dapl
	q7gE9Uzg1QWEfG0oWvmfS4LX/KgH6sBBX1YSJRXlHkD8HGRJI=
X-Received: by 2002:a05:600c:4f92:b0:495:f31:7340 with SMTP id 5b1f17b1804b1-4954a3d06e4mr270795875e9.5.1784746756410;
        Wed, 22 Jul 2026 11:59:16 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:15 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
Date: Wed, 22 Jul 2026 20:58:40 +0200
Message-ID: <20260722185841.449934-9-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722185841.449934-1-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Logan Gunthorpe <logang@deltatee.com>

A read that fails with BLK_STS_P2PDMA cannot succeed against that
member, so mark the leg IO_BLOCKED and let the retry redirect elsewhere.
Skip the read-error machinery: there is nothing on the medium to fix,
fix_read_error()'s probe reads into host pages and would "succeed", and
charging the read-error budget would evict a healthy member under a P2P
read workload.  FailFast eviction is skipped for the same reason -- the
request never reached the wire.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Co-developed-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c  | 4 +++-
 drivers/md/raid10.c | 5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 917d694ef401..76a1426e64f0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2658,6 +2658,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
+	/* evaluate before the bio_put() below */
+	bool p2pdma_error = bio->bi_status == BLK_STS_P2PDMA;
 	struct mddev *mddev = conf->mddev;
 	sector_t sector;
 
@@ -2675,7 +2677,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * read error.  This is all done synchronously while the array is
 	 * frozen.
 	 */
-	if (mddev->ro) {
+	if (mddev->ro || p2pdma_error) {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	} else if (test_bit(FailFast, &rdev->flags)) {
 		md_error(mddev, rdev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9045a3f02dae..e35aeac29f06 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2848,6 +2848,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	int slot = r10_bio->read_slot;
 	struct bio *bio;
+	bool p2pdma_error;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
 
@@ -2860,10 +2861,12 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * frozen.
 	 */
 	bio = r10_bio->devs[slot].bio;
+	/* evaluate before the bio_put() below */
+	p2pdma_error = bio->bi_status == BLK_STS_P2PDMA;
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
-	if (mddev->ro)
+	if (mddev->ro || p2pdma_error)
 		r10_bio->devs[slot].bio = IO_BLOCKED;
 	else if (!test_bit(FailFast, &rdev->flags)) {
 		freeze_array(conf, 1);
-- 
2.52.0

