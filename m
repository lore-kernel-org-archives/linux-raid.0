Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0281C41B379
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217169; cv=none; b=CS+hHQeXdEyQv3tSEGk7/USLQ6HqpT6P1Yc9E7NrKWp7FachHNmPLxkKAp2IevDIAU4SLJ7mzpt3jG2Yv3xqCGkiE0LeG/N0bzZaRb4BD5K3yKG89tr4vRUbYvl0RqMta5l/AevoF78fIUKa3R6PbdeTB4bl1Lx4O5qyZVz2t5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217169; c=relaxed/simple;
	bh=bq0e5vbpfOOFaq9GLFaFbVOK+//hB+GxuYZzHbKOrvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enrOhcPKR4f0oM3mRJAyRrJlA4BVevPN5BIuzxLZim/8xfYWe7c8i9BtW7Y4ftlQ/sszvvdtCLWppEOKR3LBfZwoK9tSyh+N6ebLhBAhXvMrp2RpS0cX+HqlCUd2lAMC07CNNmDVsL08twvzAGJ7pvTm33CTx2fPaPhISRNB6XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLVPg2nM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLVPg2nM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770217168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8Dt3Ga5euoRbaWcoAKNky31hOmZ7r2MmgcjRaZVw7I=;
	b=aLVPg2nMqShiNYhAxwDOX3QiKXpYVGiYYEmdBPs/0V2c7VU4I8Zn05MelmYktmW1eFfQse
	6K5wD+ewK+Cf3NylYRKBcAHfP1OK94aqHD/F2Z7MUuYdv4Dbf6hIpHqbnIRsVYK8mKDjab
	iwxE0z5NikLosHB7sD5S716enXNKlrE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-WxrHjhaYPGOsN9tz8GsRtA-1; Wed,
 04 Feb 2026 09:59:24 -0500
X-MC-Unique: WxrHjhaYPGOsN9tz8GsRtA-1
X-Mimecast-MFC-AGG-ID: WxrHjhaYPGOsN9tz8GsRtA_1770217164
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D33C018003F5;
	Wed,  4 Feb 2026 14:59:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.66])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A41519560AD;
	Wed,  4 Feb 2026 14:59:21 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH RFC 3/3] md/raid1: fix incorrect sector range in serialization
Date: Wed,  4 Feb 2026 22:58:57 +0800
Message-ID: <20260204145912.9463-4-xni@redhat.com>
In-Reply-To: <20260204145912.9463-1-xni@redhat.com>
References: <20260204145912.9463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

md/raid1: fix incorrect sector range in serialization

Fix off-by-one error in sector range calculation for serialization.
The range should be [lo, hi] inclusive, where hi = lo + sectors - 1,
not lo + sectors.

The current implementation causes false collision detection for
consecutive writes. For example, when writing:
- R1 to sectors 0-1023 (hi = 1024)
- R2 to sectors 1024-2047 (lo = 1024)

R1's hi equals R2's lo, causing raid1_rb_iter_first() to return
true and triggering unnecessary serialization, even though these
requests don't actually overlap.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 029aa458ffb2..e3d9ba71796f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -62,7 +62,7 @@ static int check_and_add_serial(struct mddev *mddev, struct r1bio *r1_bio,
 	unsigned long flags;
 	int ret = 0;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = lo + r1_bio->sectors;
+	sector_t hi = lo + r1_bio->sectors - 1;
 	struct serial *serial = &mddev->serial[idx];
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -100,7 +100,7 @@ static void remove_serial(struct r1bio *r1_bio)
 	int found = 0;
 	struct mddev *mddev = r1_bio->mddev;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = r1_bio->sector + r1_bio->sectors;
+	sector_t hi = r1_bio->sector + r1_bio->sectors - 1;
 	int idx = sector_to_idx(lo);
 	struct serial *serial = &mddev->serial[idx];
 
-- 
2.50.1 (Apple Git-155)

