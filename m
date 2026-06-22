Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD2838E8CB
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 08:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782115659; cv=none; b=DXwpnkcxf4Fs4PSAh9qbZXPg/U+7TERYVGwU893O25xqyTZO8IJNHh+DSYh/T8aLFNWf7HaoJU8OmT+i+Eh09RwR2kgybHc6KcO5nnr6kgpuhAR8Rk+l76dk3SN3mAwZFGKXLmrz+LbgRQvXEuve4hGPQjvvsK38nLC+Y94YT+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782115659; c=relaxed/simple;
	bh=ixZklIegwP1IHDJlid6jVapKS2KVUPy7cX75DC99+MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uP10QNVwSQdXBagNATjT1FKNeSi8tat+PNTt0THPjjhaxRAsNFLYWvB2PObIoGW5/6dzg5Uyacfa6FSmxWhz8VI/0LD2yQrE5NMCodRvG/43x44I+calbjM+HIh4MI1R+hidfadzekCO2lEEhJNRI+f866gRkL7WNYTlQbkBuXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oCM52UFa; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oCM52UFa"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8422871b42dso2428296b3a.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 01:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782115658; x=1782720458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rlV3+D4ZZRALKldfUDeeoVyJTWnvlXeJCAWh7uoewIg=;
        b=oCM52UFawNeEMZYI/0BorHH7HfKTcvM5P5VJkM9C1S3cjZ+x/0Pp/X0cuVQWXUzyk4
         rCeCkwPxT7romuvZdjmHkGFtI/alx66sbLR1ablAelRZJhvqKtL9PhgEb62HbXtKpWdI
         ZwkuoScw4ZZ/ytgkG+VCSoRiap0YffRFVZcM87y3KUtc4ND2YUsZxhQRMdz5J1XalXML
         GwwdI7llo+tobqACtwv6DRxE2KZ+Z9SIyZWtr9Qtg56dUbdUsj7goMTFikw/2d+mHu18
         Ueo+7abiFUkj43WYHPZ4bigimF8ldZoteAb8MM1ThJZoQFythdPLjiGSnMLOQ2G8oggA
         d+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782115658; x=1782720458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlV3+D4ZZRALKldfUDeeoVyJTWnvlXeJCAWh7uoewIg=;
        b=cKbyqUr0g84anW6yxnS++QejpEMWrPPAx6tpac4vQtabTU205zKrh6ExsAPJH9JzyZ
         VqNx5DJCdpr4qYw/7qrxMMHAhuJ7BMzKynNWggr8geA1QSyDDVocjiwOYHqzQxdsXsPe
         Wz5K8K1nk+N9h3j4/wcFMvxHYZ2JhR31uQmdKXjHddfB15E+mBr8/GIe/ttmameHBhZ4
         5tXsJfd2FeRgKdughYx1oBYb+keK5dmZQFg5jY8fDw4qjktRgxR6YOlIaUwU4C/Snqi5
         V0P3wW0NSWTyQRT1pHGfOqdlu8LWhC/5usIYEiBSSJEEbILK8vLkVVJqgMIUVjgBaI7f
         hHGQ==
X-Gm-Message-State: AOJu0YyfWkq+FkYfMQqyXFe9DxaGjghvxeZLsbjoft92s+ibwSAvCIFI
	VkMdKHKSgBVP2MTIPW/FVvPEvC9HNn6obZFy6YIZbHsUY1OmQDIpr575tjZobyzWuGo=
X-Gm-Gg: AfdE7ckR8Mrx9qtYB344NRvpxmnJ9Yb/R3MgpXVZdML1maH2p7zZ4LzRHGbR7pAj0M4
	xkem5I2MMQqS9NqiKikeMOMSKCERCJS54zwCmZamH2+lQjIzUga5oRfRhW+JkFST0P5H0NceHvW
	QoEEyzAGYAr9XjFUyz/q6qp0YCRc3jMQbL9V7gQz2XQCLFfUQTCM2zQplvcAindu2bktRQ0F9er
	v3C78m2ON/LgkAvcKRg3rX5/13zVub+INYg212iIt5LpgyhlfY52n2VnzwPKPJ9G/Q2O5ZuQL2d
	W8F5WXwG/qC559jMbbcSfEXLiLhz0zg6kMWKIG062Jkt09YkryzBoJKGWNYuAYtAy8EjGjT9l9j
	WOmRtdA1EVfeiInVebGb/LG5udHUcbOp9recWd1IGOwYKT5UHQ9icq7uAuZTvuuo4xqhdR+9Pqy
	7vNHElefepI4ki4tHUUbXRvwvy
X-Received: by 2002:a05:6a00:1d8c:b0:842:2ddb:e303 with SMTP id d2e1a72fcca58-845560736bbmr13315970b3a.12.1782115657543;
        Mon, 22 Jun 2026 01:07:37 -0700 (PDT)
Received: from fedora ([106.219.196.189])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564ed9516sm6688804b3a.57.2026.06.22.01.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 01:07:37 -0700 (PDT)
From: Sajal Gupta <sajal2005gupta@gmail.com>
To: linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	tomasz.majchrzak@intel.com,
	linux-kernel@vger.kernel.org,
	error27@gmail.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev,
	Sajal Gupta <sajal2005gupta@gmail.com>
Subject: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to refcount_t
Date: Mon, 22 Jun 2026 13:34:32 +0530
Message-ID: <20260622080656.22786-1-sajal2005gupta@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old atomic_t based counter allowed ppl_do_flush() to continue using io
after it could already have been freed by ppl_io_unit_finished(), leading
to a use-after-free.

Convert pending_flushes from atomic_t to refcount_t with a proper ownership
model. The creator holds a reference for the duration of ppl_do_flush(),
and each submitted flush bio holds a reference until its endio callback
runs. This makes the io lifetime explicit and removes the need for the
second loop in ppl_do_flush().

Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back cache enabled")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
---
 drivers/md/raid5-ppl.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index a70cbec12ed0..157a89edd9c8 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -145,7 +145,7 @@ struct ppl_io_unit {

 	struct list_head stripe_list;	/* stripes added to the io_unit */
 	atomic_t pending_stripes;	/* how many stripes not written to raid */
-	atomic_t pending_flushes;	/* how many disk flushes are in progress */
+	refcount_t pending_flushes;	/* how many disk flushes are in progress */

 	bool submitted;			/* true if write to log started */

@@ -249,7 +249,7 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
 	atomic_set(&io->pending_stripes, 0);
-	atomic_set(&io->pending_flushes, 0);
+	refcount_set(&io->pending_flushes, 1);
 	bio_init(&io->bio, log->rdev->bdev, io->biovec, PPL_IO_INLINE_BVECS,
 		 REQ_OP_WRITE | REQ_FUA);

@@ -599,7 +599,7 @@ static void ppl_flush_endio(struct bio *bio)

 	bio_put(bio);

-	if (atomic_dec_and_test(&io->pending_flushes)) {
+	if (refcount_dec_and_test(&io->pending_flushes)) {
 		ppl_io_unit_finished(io);
 		md_wakeup_thread(conf->mddev->thread);
 	}
@@ -611,11 +611,8 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 	struct ppl_conf *ppl_conf = log->ppl_conf;
 	struct r5conf *conf = ppl_conf->mddev->private;
 	int raid_disks = conf->raid_disks;
-	int flushed_disks = 0;
 	int i;

-	atomic_set(&io->pending_flushes, raid_disks);
-
 	for_each_set_bit(i, &log->disk_flush_bitmap, raid_disks) {
 		struct md_rdev *rdev;
 		struct block_device *bdev = NULL;
@@ -632,20 +629,18 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 					       GFP_NOIO, &ppl_conf->flush_bs);
 			bio->bi_private = io;
 			bio->bi_end_io = ppl_flush_endio;
+			refcount_inc(&io->pending_flushes);

 			pr_debug("%s: dev: %ps\n", __func__, bio->bi_bdev);

 			submit_bio(bio);
-			flushed_disks++;
 		}
 	}

 	log->disk_flush_bitmap = 0;

-	for (i = flushed_disks ; i < raid_disks; i++) {
-		if (atomic_dec_and_test(&io->pending_flushes))
-			ppl_io_unit_finished(io);
-	}
+	if (refcount_dec_and_test(&io->pending_flushes))
+		ppl_io_unit_finished(io);
 }

 static inline bool ppl_no_io_unit_submitted(struct r5conf *conf,
--
2.54.0

