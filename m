Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520E033981
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 07:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730793466; cv=none; b=ALj/bHpm+j0r4MSSv2s4UaG30bCPlEEguV75rX8UI9tNxYQ19a4KC+dj0Ooiv1q8zZ87cI2bgFiGn/CGalH6q5jzP9GmHZcGWRn9h43a4w0alCprb5pflEF1w5qChraQKZh/PNFfiMJ7dQ5abVKnTSbPGhIJtO0RrQlIQ961aK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730793466; c=relaxed/simple;
	bh=CJTrVugYpXe+gr5g6SCzpeKjcGiYAcSbDz2N7Vb6UP8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IzwE15J3uwmGKOKhw6iCx5BJqIUgnY/fRo9PHuWLv5TsCGditCFmDVrh4MKX9E53XORIc6PZFupBy5/lxcK0nWzi5DjaSVB7A+O1tjofbh54fUir1fxWzxYu9dv46cLOofnZDJ2VdRAEZ6iOekOMsxLBvSb4ty2iNYPM0GfAb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFNPz8Sb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFNPz8Sb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730793463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YrbZJ8j21Zy3ss2cxcgzCJebqmnAvZajIyXUA4rrqDk=;
	b=QFNPz8SbGn408cS0eZQIZfLUTM/9ciU1OYXA6sQAD0dduh5W2SHHFiyKeqCVi93ux9hbaB
	/Bfch9aBwUeryjlbgA0thMgZp+U6n6hNnj9yC+kdl/CL550O+GWifSODcrXYzNwjZYN+ON
	TSHuxECFKbpQhZpB357/oSUsFrMAzdY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-vkzgf4_GPdGDnffu2cL9nQ-1; Tue,
 05 Nov 2024 02:57:39 -0500
X-MC-Unique: vkzgf4_GPdGDnffu2cL9nQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1E1C1955E99;
	Tue,  5 Nov 2024 07:57:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6718619560AA;
	Tue,  5 Nov 2024 07:57:35 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Subject: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
Date: Tue,  5 Nov 2024 15:57:33 +0800
Message-Id: <20241105075733.66101-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

One customer reports a bug: raid5 is hung when changing thread cnt
while resync is running. The stripes are all in conf->handle_list
and new threads can't handle them.

Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
requests finish in suspend operation. One personality knows itself the
best. So pers->quiesce is a proper way to let personality quiesce.

Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 67108c397c5a..7409ecb2df68 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 		return err;
 	}
 
+	if (mddev->pers)
+		mddev->pers->quiesce(mddev, 1);
+
 	/*
 	 * For raid456, io might be waiting for reshape to make progress,
 	 * allow new reshape to start while waiting for io to be done to
@@ -514,6 +517,9 @@ static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
 	percpu_ref_resurrect(&mddev->active_io);
 	wake_up(&mddev->sb_wait);
 
+	if (mddev->pers)
+		mddev->pers->quiesce(mddev, 0);
+
 	if (recovery_needed)
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-- 
2.32.0 (Apple Git-132)

