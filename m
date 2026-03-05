Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D501470818
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 01:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772673532; cv=none; b=o9nHAKyEJqVviA0Bmw+GI4cMvZKGy6pujVq4P2DVVXT9Teom+gP7zEDEDXTxtwQcCmF6zy6YLjVgWI4C7jPX0uRGwegdmyBChIs0ed8gXhhv2ftlqJ/vHqtbYL1VA6ByG3XjWgxPRKTwH3oLS47v3BTsxLW59My/gE5A/XXdXR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772673532; c=relaxed/simple;
	bh=zk9FRqaTJkitcVShzZ/WcKzKzAIqcU0PxdoInaoDLqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww8dzW3ua9ZlAnRGqo2cl4OJGUCOCIHXVCqwiJPYDPy8lSZrQz4h/L5OmqlyGvCOd5mAQ77iIW9lfKLihCNZMlKi8hWLxHasjCVV+hSKVeq2Xk+Mq5YUtdntOe1mbddD7V0A5uAi9/m4A3Y223VtudfcS8LB2NtMXWpjMJxZab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJ9mxzmD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJ9mxzmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772673529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kvgl8tvXC9GNMUoGHAhTpBX38sAk5PUJmQ7vfmsvYdc=;
	b=FJ9mxzmDrH1AejZ9oUtEjRHcDfXqGtjpmUS6g+iKXc37uAgU9UFuXGpHaNtL99UrO1ieuA
	B5xctDBzH6d9HPw4gDABDYet6TabN++qEWdPnpKAP6eaSy3hj0OYG/9hBQ/Za34XcstpIo
	9eRILwwVJb03XDFLcxffqYFNdD6b4Pk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-4PTPKM_MNG2GzsoHzthajg-1; Wed,
 04 Mar 2026 20:18:48 -0500
X-MC-Unique: 4PTPKM_MNG2GzsoHzthajg-1
X-Mimecast-MFC-AGG-ID: 4PTPKM_MNG2GzsoHzthajg_1772673528
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F049418005B2;
	Thu,  5 Mar 2026 01:18:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.20])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A9A1730001A1;
	Thu,  5 Mar 2026 01:18:45 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 1/2] md/raid1: fix the comparing region of interval tree
Date: Thu,  5 Mar 2026 09:18:33 +0800
Message-ID: <20260305011839.5118-2-xni@redhat.com>
In-Reply-To: <20260305011839.5118-1-xni@redhat.com>
References: <20260305011839.5118-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Interval tree uses [start, end] as a region which stores in the tree.
In raid1, it uses the wrong end value. For example:
bio(A,B) is too big and needs to be split to bio1(A,C-1), bio2(C,B).
The region of bio1 is [A,C] and the region of bio2 is [C,B]. So bio1 and
bio2 overlap which is not right.

Fix this problem by using right end value of the region.

Fixes: d0d2d8ba0494 ("md/raid1: introduce wait_for_serialization")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 181400e147c0..be2565dee420 100644
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
@@ -452,7 +452,7 @@ static void raid1_end_write_request(struct bio *bio)
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = r1_bio->sector + r1_bio->sectors;
+	sector_t hi = r1_bio->sector + r1_bio->sectors - 1;
 	bool ignore_error = !raid1_should_handle_error(bio) ||
 		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
-- 
2.50.1 (Apple Git-155)

