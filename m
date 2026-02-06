Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFA53370E4
	for <linux-raid@vger.kernel.org>; Fri,  6 Feb 2026 05:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356321; cv=none; b=qT+WaXeXSaSycfxQeNSDeqLU9z3kWshsjpxAMPhDCf5FW1IfhvmOL4pLzpU6kaSwmMEI2h0JKcCe7ZLWlvDOYyOhfeEKJKEWOqDD9JqTW5g4C5lEUuFxB9K/UIwXSajKG/PYaBmHb5fSWbW37mqreQv01Tn1Xak5fhFazBOvMb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356321; c=relaxed/simple;
	bh=+o5baD60dPbr4atG5Iylax2tf/5WRbSrjsqfCMweHH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO1XflhQmR0SkzObSpm86AG2PNLn1OJ7d1LMJfWW1uJ6bCGWYuakM9De5Ub633xqUhkwq2sx7uoQ3KV0118JdPRAfSBvzhtSnMWAI/EDK0TksNJaGLKPm4SKzqQHkEYFmkt8+je3ZPdtDMu+TTwGI64eH7UlSTIjXii5cSkWNOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aIsnOHIa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aIsnOHIa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770356320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVGoFO1NWsZgnfwV6jzDpobBGe6G6s5urtIjvlWNjE0=;
	b=aIsnOHIaDjYu8EFvi2RU5PCqarIfyW3ilfLVTUYoedlH1XSU6fsUBu0YgRocBhjzDIveYd
	JWTIywSz38G7zlBa2AsiLEoL+A+mQIoK1LS027YquDXG+2vBVl3S3IaQ0d/xVt3j6iomTt
	Uc0zBlFCKnBka+y7e0LH18MGeBUQGhI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-FgLJovU-Opi-1HfztXw2Xw-1; Fri,
 06 Feb 2026 00:38:36 -0500
X-MC-Unique: FgLJovU-Opi-1HfztXw2Xw-1
X-Mimecast-MFC-AGG-ID: FgLJovU-Opi-1HfztXw2Xw_1770356315
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3864C195609D;
	Fri,  6 Feb 2026 05:38:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2D7419560A7;
	Fri,  6 Feb 2026 05:38:32 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: song@kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com
Subject: [PATCH 1/2] md/raid1: fix the comparing region of interval tree
Date: Fri,  6 Feb 2026 13:38:18 +0800
Message-ID: <20260206053826.37416-2-xni@redhat.com>
In-Reply-To: <20260206053826.37416-1-xni@redhat.com>
References: <20260206053826.37416-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Interval tree uses [start, end] as a region which stores in the tree.
In raid1, it uses the wrong end value. For example:
bio(A,B) is too big and needs to be split to bio1(A,C-1), bio2(C,B).
The region of bio1 is [A,C] and the region of bio2 is [C,B]. So bio1 and
bio2 overlap which is not right.

Fix this problem by using right end value of the region.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 867db18bc3ba..a41b1ec3d695 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -62,7 +62,7 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
 	unsigned long flags;
 	int ret = 0;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = lo + r1_bio->sectors;
+	sector_t hi = lo + r1_bio->sectors - 1;
 	struct serial_in_rdev *serial = &rdev->serial[idx];
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -453,7 +453,7 @@ static void raid1_end_write_request(struct bio *bio)
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = r1_bio->sector + r1_bio->sectors;
+	sector_t hi = r1_bio->sector + r1_bio->sectors - 1;
 	bool ignore_error = !raid1_should_handle_error(bio) ||
 		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
-- 
2.50.1 (Apple Git-155)

