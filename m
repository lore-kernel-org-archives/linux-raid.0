Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07811322DCC
	for <linux-raid@vger.kernel.org>; Tue, 23 Sep 2025 12:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758632317; cv=none; b=oI9DCsnMd56h5m8c5qpFOE8VLDLJDtKk3nMTcTGdGH1eDmDU/VNKsliZdA38/uy4bQ4dURWyrM0CBjdNM0+AsQJYl5j51Xsa4tUY3jTF/RRod/Fkme46YcSlOdXxhPv5DksMTbd4dPu9rh+DmixAKvKsL/boHGr4T42HEEF1GcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758632317; c=relaxed/simple;
	bh=gjw7r1SS9jjJC0tPoCN02e3Ms3MVIaXIhqKnNBQgw+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2+om+fEa2l8HJ7OlS3naeXeHIIJOESPQq49zV4dr9y3laY+Vbqaq4JdLaPpI3yNthmh/DAc4dy/bShuXb3MfgnqlqJjg3NMnoDWv6Z/xhOk6WSPb1PZJDHXrsHC+MCi6VPqmweaCU3cmkCevjLEjZacrXsxyJGsdOZPwCmzgdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FUa/YYgH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FUa/YYgH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758632315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwD096IZGmRO63mE/rtcWyoPAkv3ltYnE2YuvKgpdGE=;
	b=FUa/YYgH1oyJBPEWZzLOW3HMMVncGvA0zIj1tBn/JEoDojIQwqC7OXcmqpE2ALO6M/lN+r
	eWGrHC2DaiqUefNiMQwyRP7E4k20ltPf6tln9gapRd9aFAM0kBtESInbSW8YSRDerUqg+f
	Kd67MHwKMStjzDUoe5qp+6u51aKt994=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-5URhde7xOnShGsFawDKd5g-1; Tue,
 23 Sep 2025 08:58:31 -0400
X-MC-Unique: 5URhde7xOnShGsFawDKd5g-1
X-Mimecast-MFC-AGG-ID: 5URhde7xOnShGsFawDKd5g_1758632310
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A31071956055;
	Tue, 23 Sep 2025 12:58:29 +0000 (UTC)
Received: from o.redhat.com (unknown [10.44.33.178])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06E2B195608E;
	Tue, 23 Sep 2025 12:58:26 +0000 (UTC)
From: Heinz Mauelshagen <heinzm@redhat.com>
To: yukuai1@huaweicloud.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2] md raid: fix hang when stopping arrays with metadata through dm-raid
Date: Tue, 23 Sep 2025 14:58:14 +0200
Message-ID: <d4bab4c8921eaecae856447131c4f4f1aa190dd3.1758631268.git.heinzm@redhat.com>
In-Reply-To: <414ae6e0-604a-f4d3-d7ce-260bd8564927@huaweicloud.com>
References: <414ae6e0-604a-f4d3-d7ce-260bd8564927@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When using device-mapper's dm-raid target, stopping a RAID array can cause the
system to hang under specific conditions.

This occurs when:

- A dm-raid managed device tree is suspended from top to bottom
   (the top-level RAID device is suspended first, followed by its
    underlying metadata and data devices)

- The top-level RAID device is then removed

Removing the top-level device triggers a hang in the following sequence: the dm-raid
destructor calls md_stop(), which tries to flush the write-intent bitmap by writing
to the metadata sub-devices. However, these devices are already suspended, making
them unable to complete the write operations and causing an indefinite block.

Fix:

- Prevent bitmap flushing when md_stop() is called from dm-raid destructor context
  and avoid a quiescing/unquescing cycle which could also cause I/O

- Still allow write-intent bitmap flushing when called from dm-raid suspend context

This ensures that RAID array teardown can complete successfully even when the
underlying devices are in a suspended state.

This second patch uses md_is_rdwr() to distinguish between suspend and
destructor paths as elaborated on above.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/md.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..78408d2f78fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6541,12 +6541,14 @@ static void __md_stop_writes(struct mddev *mddev)
 {
 	timer_delete_sync(&mddev->safemode_timer);
 
-	if (mddev->pers && mddev->pers->quiesce) {
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
-	}
+	if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
+		if (mddev->pers && mddev->pers->quiesce) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
 
-	mddev->bitmap_ops->flush(mddev);
+		mddev->bitmap_ops->flush(mddev);
+	}
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-- 
2.51.0

