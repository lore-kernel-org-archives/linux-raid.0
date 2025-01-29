Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18770199EBB
	for <linux-raid@vger.kernel.org>; Wed, 29 Jan 2025 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738191433; cv=none; b=VEZroZA6rZ6GbUqEXwe54azxAiBQ0fyBke+lRaYQ0JV5EVOe7oH8NjcqAIW2MYT8fEPDWuqqCxDYZcJ81tT7Xumc560EovmrQ/Mgms8YMUNQNVb2EfivFBZTPlhXwV+XU97VDbr2Db5V7G8hAGKKlEGytA7rZxzTR2eOqmN0Lq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738191433; c=relaxed/simple;
	bh=Gok2UKBVMoxErJjkOmVg8ELvCO3trxztvfMg1lZOieI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEjkA9WZ6Obn9VMzzxzHvE8Ni8so4zRQypVyglkynSq1gNo8fZjRXJC/hVi0GfiAdigHhf0MgzgFghXs13eRDJC0uEX/8FRANRxbQl/zTFZxG1ov8A8B25VAYqC7yyl9gCEJxYlPLSHmyTHHXuwipskS3S4Y6zAgnKo4RLGsJeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1IFc64xi; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1IFc64xi"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YjyG90Tg0zlgTWM;
	Wed, 29 Jan 2025 22:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1738191421; x=1740783422; bh=d4Ufct1Z2xaqO0Z9vhLVoATIlfhb6fgnPul
	++KTAhvM=; b=1IFc64xiL1vuQ12c504J8ZAAhIZyVK1JDHCz3Ntx0lYCSZq0ybE
	oRNq6YutyEQp4840Z2Y9lttQiSdul5xbwfxs2rTKthmQCR/1sTPQPWBvoooBP8QM
	ETDxbiApanBdakT824c3KvYwKQEzCBdn8hOX8RekkBOxjqWbEMEzWErfQi5aNsb8
	I4/X1YZNhKY29VDo2i+qvKBnzPa9ZeuFH76t/9NDjLazUpMcKl/14tP7ocXCJtOQ
	hWP66o58fN5eLxl3X+ZEAHc8G4eYTwk4arfyo5TrCPNGhJPFFM8QFfGFwWoWBL2E
	ksVvBploued2vB7GLo+6s/1w6U3DCBH1+FA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w2DEm5bZNFnw; Wed, 29 Jan 2025 22:57:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YjyG36X0ZzlgTWG;
	Wed, 29 Jan 2025 22:56:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] md: Fix linear_set_limits()
Date: Wed, 29 Jan 2025 14:56:35 -0800
Message-ID: <20250129225636.2667932-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

queue_limits_cancel_update() must only be called if
queue_limits_start_update() is called first. Remove the
queue_limits_cancel_update() call from linear_set_limits() because
there is no corresponding queue_limits_start_update() call.

This bug was discovered by annotating all mutex operations with clang
thread-safety attributes and by building the kernel with clang and
-Wthread-safety.

Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Coly Li <colyli@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: 127186cfb184 ("md: reintroduce md-linear")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/md-linear.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index a382929ce7ba..369aed044b40 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -76,10 +76,8 @@ static int linear_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
 	lim.io_min =3D mddev->chunk_sectors << 9;
 	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
=20
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
