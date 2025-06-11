Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA81230BFB
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 07:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627087; cv=none; b=mVdcM4hK/riowaacQOPF6Ex6c19cHxUHIxOYbsAlEQRVuUR+HAmznov0H0imzrzEKfWcSWJKUUtDJ4YGJT8IRYMJMQ+NF0C7ypZSUO/6UO10kCsrUE8he3KherWkD2IkJMfJ7S26V6tX/hAn8CVA4i3Fzxha0hyau+ttU0JuTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627087; c=relaxed/simple;
	bh=ROKhnnOZy4pREdUZ4Iop2fX4VoxVvUAmQFck0dMY/8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DJ66uVd7ivU3to2a0/32xIPuj25xejAMG2bvhLM5qEaeV89jTC9Rh59rctCJ1Kb5Z/j7zgLoVI8NxJlGVuDvIVMzy+ltKa2SxSOiWyL779p8FuqSXRE7FsAGZNbJ3pQitIrMrJANiSVOulgFK0fZmHZL33e1aNxOeuLWQ2Axnww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjeqDh1b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjeqDh1b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749627084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cPqDF1D6OJO6Bvm6hZU4z79IV4f1Bl3oHJ9jPg2dU/4=;
	b=hjeqDh1bfi9G0WhiK10ZiNLW4TLscsLXB7aibFbMqU6V/xFOc0J70HnnM01SsgCzs0omJ8
	EYD+3jz79bSkz0Ya1pOL504E11HJL4RBcxOyjzhFiauLv/vyiDIHHdoFIyvjiZwdtecvF6
	4RdR8zufiCvAJPBJ3bHBp2+Dc9SHdCg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-UX7nHQbXN5iPn1j2_4wnjA-1; Wed,
 11 Jun 2025 03:31:23 -0400
X-MC-Unique: UX7nHQbXN5iPn1j2_4wnjA-1
X-Mimecast-MFC-AGG-ID: UX7nHQbXN5iPn1j2_4wnjA_1749627082
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30A2F180034E;
	Wed, 11 Jun 2025 07:31:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DE107180045B;
	Wed, 11 Jun 2025 07:31:18 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 2/3] md: Don't clear MD_CLOSING until mddev is freed
Date: Wed, 11 Jun 2025 15:31:07 +0800
Message-Id: <20250611073108.25463-3-xni@redhat.com>
In-Reply-To: <20250611073108.25463-1-xni@redhat.com>
References: <20250611073108.25463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

UNTIL_STOP is used to avoid mddev is freed on the last close before adding
disks to mddev. And it should be cleared when stopping an array which is
mentioned in commit efeb53c0e572 ("md: Allow md devices to be created by
name."). So reset ->hold_active to 0 in md_clean.

And MD_CLOSING should be kept until mddev is freed to avoid reopen.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7445e44eabff..dde3d2bfd34d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6425,15 +6425,10 @@ static void md_clean(struct mddev *mddev)
 	mddev->persistent = 0;
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
-	/*
-	 * Don't clear MD_CLOSING, or mddev can be opened again.
-	 * 'hold_active != 0' means mddev is still in the creation
-	 * process and will be used later.
-	 */
-	if (mddev->hold_active)
-		mddev->flags = 0;
-	else
-		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
+	/* if UNTIL_STOP is set, it's cleared here */
+	mddev->hold_active = 0;
+	/* Don't clear MD_CLOSING, or mddev can be opened again. */
+	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -6660,9 +6655,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		export_array(mddev);
 		md_clean(mddev);
 		set_bit(MD_DELETED, &mddev->flags);
-
-		if (mddev->hold_active == UNTIL_STOP)
-			mddev->hold_active = 0;
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.32.0 (Apple Git-132)

