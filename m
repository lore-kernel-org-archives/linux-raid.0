Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92421256C8E
	for <linux-raid@vger.kernel.org>; Wed, 12 Feb 2025 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739380308; cv=none; b=dXsoMTQXDOxqnJEtGOrTaK7rNlnv2IdxIoYZjw65f6SiNEBPHsRu0pAqDhWDFCzqVGdH1ev0lKpmirHMa7qLZzXk7k0Bt8EdALhIKN9I/Us1LCclFlnYZjZWOh0awPtsqvjK2Dv5mVoqYZ5WLBnncSCDUlrZe9XF1d0SIVAn1jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739380308; c=relaxed/simple;
	bh=RQFkE9tsT1RjoSvKdlIkVfNS6rk/2fskLrlIFgTVzcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xe2Oo3sFOzGV0RbGrHVWgtEuJWcJf3v6RfWWFNSxwvxWLgCQftQurzN9QtpzozqY2d+ZJrcqRnxJdTwANukjLR3iVGm9VsUE8rn+2bLN28t9M0Dzp5QB4rdxwuEqyxA5YDaYZOC3AqXNmiO0wf0ZA0yb6Vm6e0DdHQI2zy5N3zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1HDiTvL/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1HDiTvL/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YtPx84MpqzlgTxf;
	Wed, 12 Feb 2025 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1739380295; x=1741972296; bh=CFa3NiEsRmN1lNODADwduqGdvfuA+LJY0Yb
	XnfYbzIc=; b=1HDiTvL/EhKmS1QeCm1Sh6QYPBz3+GZKG1j34Mkp057I0RcZGU1
	MNwQS74QNQc+J8UcjwT/7nxo4VePGo2YFVuB5J4IiG4BzylA4px5wUzoO5x8Jy+6
	wwjof6XVvkQFhejbVUIHrYMk+z/Kca0hlwWC5X6n3t+NHqsowNA336Ig22LTJDev
	vIRULaNNc2VVTh6KjFlhrHABuMyqZs1/ZoQ2uhX3AmyzpGVxfeE6s5/FmkHhnrqV
	N79oawYvEWK6ZTWEacUPF1zSJUpKjqMspijr10GmCTeTEP21REii9q04j1YbE2FK
	kmwx1XtWyCitPg7UAD2PlXX9pMlvx+bH4Ag==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z6YIVlzf9RkV; Wed, 12 Feb 2025 17:11:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YtPx155k1zlgTwc;
	Wed, 12 Feb 2025 17:11:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] md/raid*: Fix the set_queue_limits implementations
Date: Wed, 12 Feb 2025 09:11:07 -0800
Message-ID: <20250212171108.3483150-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

queue_limits_cancel_update() must only be called if
queue_limits_start_update() is called first. Remove the
queue_limits_cancel_update() calls from the raid*_set_limits() functions
because there is no corresponding queue_limits_start_update() call.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits=
")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/raid0.c  | 4 +---
 drivers/md/raid1.c  | 4 +---
 drivers/md/raid10.c | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8fc9339b00c7..70bcc3cdf2cd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -386,10 +386,8 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.io_opt =3D lim.io_min * mddev->raid_disks;
 	lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
 	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
=20
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9d57a88dbd26..10ea3af40991 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3219,10 +3219,8 @@ static int raid1_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors =3D 0;
 	lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
 	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
=20
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index efe93b979167..15b9ae5bf84d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4020,10 +4020,8 @@ static int raid10_set_queue_limits(struct mddev *m=
ddev)
 	lim.io_opt =3D lim.io_min * raid10_nr_stripes(conf);
 	lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
 	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
=20
