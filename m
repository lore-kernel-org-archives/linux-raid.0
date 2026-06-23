Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9B43C73D1
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199507; cv=none; b=mOkB6YiFEwf6rSGs4XqKTz+lqBceX9ftcglGlH17/AoPwZhi5B9hp40v0ooQX9VGS29OJnimzpRzQMOs/JO6BG65C0SNMcdobFW271+ZXDxMEcXH+MiSmj8VLzKxIfGF2ZQq3bqLTlOtxZjsPWaalUzMR8g8GQedH04rhhssJaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199507; c=relaxed/simple;
	bh=pi36dSeQOSTozHEmOCspgGzCWBC2YAX8boNyEEQexAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOJT1cRswgMrDg+bbbvlDTvTYvq2qVdHXtIxZfr5O7TPijOgZYzU5jgnFe/sjpjpfh/QabWC52GSnqsHzxwryjqaj2g3gDZAfEKt1NiVl+1CfR4RAZjSxaT05wh+xW8Iv8dmnPfN/XYNRcCFiOLgaFkozuJXjuLhf8pxODBzKG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKkNfuMV; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKkNfuMV"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45fd461e4a5so3930516f8f.0
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199505; x=1782804305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZwDk65SlHZMpofHwuZQxVBN+KnkiDxjqYzIMhpdz0E=;
        b=XKkNfuMVKkNqnvOirhmAo+WqVLRFe0/7fWvBuB56r+8xlnHvayUGPoW1tz/Y7FvdBN
         +hOIHNQltHxi8pK8K9L6OYg10w/Dbv+TinyfVYw8DrGIZTpG9S7E5JmCksX4BFegwWkZ
         L+cdYVvVtEV9yhbCq9JeLjUqLh/qPOSGJG1S67w5/0/sxBaXc4hdzuEBQNWqWUEGJizw
         SV1Rrbxs8yiQkd6ZP+OZZDYAQDxyrqAJJL1YmuQDPCf7XWqqOYl7sWuMlBA/UJCc3aRi
         SHhtnJK4EXc5+a/zRJRk5R9WiL2QA6o38JTBv0cHdNfXqDMhItv2N+W8eGKnbZCtpAvf
         LnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199505; x=1782804305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WZwDk65SlHZMpofHwuZQxVBN+KnkiDxjqYzIMhpdz0E=;
        b=PajMKHGYXMu7ax9GoYLiViCPlBN0Zd5TUathYJNgAX3a46e3yspkaO21M0z9VfsDLX
         ZIWRS+VRsazTZ+F8Aya/b5z+AlvJTgWAM7eJ159oa/gcDKHizRm5MMxzoRqCYiSUshxF
         Dod+4B3ZiYc3xQGLPKsLrphuqIgwciuw917GUqjTH8DidKCgDPd3D2zkq5roQjUJBYKM
         +xDsI4J8us6XeKNmHPglMRBK94oMHgDimVRWuOB0RXaKbuCouaNlvFxX/NIuaLVsi12Z
         Knng22Ra8bzIPPSpgLmQW6f9BwpjF1HPfiaepg1Vg1rUGqAIXLU9+pAD1YVHXb0m0E2o
         XhCw==
X-Gm-Message-State: AOJu0YyDK7rIviGk8fJ5wPHSY/o3iioM8ZxdSpa6hx4Oz7PP1V5V6/7s
	HHEJc8DaPGZcmJb9v25AhBCD4rB0q5NmQ7VT01AAmtiL9vspg1i5d9gh
X-Gm-Gg: AfdE7clZ+9cI8MVU/nIOJm3AM+K5sQxZTeRLXc2DIDQf1L8R3p9s2fRd0AWk+HtqhAT
	+HhEcSFIpgu2nC5/MqWa20KClzF/YPs0Quf1eflleMQcdmYDgXgpz5yr36glopwt1QaGHKUdaeC
	3z/6VXqdEQPkZvv1EI8k1e+ekPiXyXuKTTRjVYO+Mhfy5kWKsizqueeJf2F9sckJnke7o6S/fch
	+v7e1ymB57ZHTTRjIygM887kW2IJuC/9Z3Dgvj/Ng8Xa61jmZ5dy0fNUIMXi3wxvBwzn+TJIu9j
	xOFeHjS3VXMOapSG8rnNLiYbdD0TVEo0a5CxsAQx3enI2v2QQftXN1QAYH52BjMdp1IU3Psd0yZ
	B9W3h6fOtJoQZ36dK6wUtVpeW5urUeH12tRRbhTQsVh4UJOUhcCMDzCLWb0xiszync0+Iqw08yw
	OPIuseahE+QzIkWDLA94/AaDe+CFjVzfZl
X-Received: by 2002:a05:6000:18a9:b0:468:607:e967 with SMTP id ffacd0b85a97d-46ad96ba61dmr2158426f8f.17.1782199504734;
        Tue, 23 Jun 2026 00:25:04 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:04 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
Date: Tue, 23 Jun 2026 07:24:51 +0000
Message-ID: <20260623072456.333437-3-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623072456.333437-1-abd.masalkhi@gmail.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a request already requires splitting when entering
raid1_write_request(), the current code allows it to proceed until it
eventually reaches the split path. Along the way, the bio may instead
fail due to other conditions and return a different status, even though
the request was invalid as an atomic write from the beginning.

Additionally, an otherwise valid atomic write may later require
splitting because bad blocks reduce the writable range or because
write-behind constraints reduce the maximum writable size. In these
cases, the bio currently completes with either EINVAL or ENOTSUPP,
whereas it should complete with EIO instead.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid1.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 86d4f224ffb1..8386d37343a4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1511,9 +1511,15 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int first_clone;
 	bool write_behind = false;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 	bool is_discard = op_is_discard(bio->bi_opf);
 	sector_t sector = bio->bi_iter.bi_sector;
 
+	if (atomic && max_sectors != bio_sectors(bio)) {
+		bio_endio_status(bio, BLK_STS_INVAL);
+		return false;
+	}
+
 	if (mddev_is_clustered(mddev) &&
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE, sector,
 					       bio_end_sector(bio))) {
@@ -1592,20 +1598,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			}
 			if (is_bad) {
 				int good_sectors;
-
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC) {
-					bio->bi_status = BLK_STS_NOTSUPP;
-					bio_endio(bio);
-					goto err_dec_pending;
-				}
-
 				good_sectors = first_bad - sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1626,6 +1618,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		max_sectors = min_t(int, max_sectors,
 				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
 	if (max_sectors < bio_sectors(bio)) {
+		if (atomic) {
+			bio_io_error(bio);
+			goto err_dec_pending;
+		}
+
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
 		if (!bio)
-- 
2.43.0

