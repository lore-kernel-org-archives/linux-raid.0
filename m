Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16DC29994B
	for <linux-raid@vger.kernel.org>; Fri,  6 Feb 2026 05:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356326; cv=none; b=Va5UB+JMCC/tsSSy+NQUfuLAiXxqz4Xk3+qjKLZCjdnRbyh5fOoOIZXQarh0OlXz6b0MA700ugHayqlRBdB+ZaLQRk70XVSMTFBQX6UYbQn1dZAZRvvkoAXMgMQmnABmBu1SzD5jwSYEe15UfrYzr047Iq0IzgVTmMz2Lqucpn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356326; c=relaxed/simple;
	bh=sAl2AiJxV1vpAXKMKZXxOGi8j+SqvJ9N1kZOnaszGPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz76IqsBRLA/xUbj7WiE0tfg542QOuyv7+0OCStDB/vOSej1DqPniMnSMDd4tIxDtWkJVCeHXqBjtfab9JaQtpBSHE0aHZRfycR1VJlIheUarm5sitTohIQkp5vWgt+zuEIFc00tERI3Yfu/gsHvdQnK6AR0uaoPIpT7OSwEqi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DjJopdFP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DjJopdFP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770356324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIaJULXWNmQt52aaF7I+RQxcumYwz7I6+FXKv/TK8V4=;
	b=DjJopdFP/feSkyenI4acUftk671m3Iis3W/sT6cGKotHKYO5T71fZSiGbz7lywp64zPBu4
	1e2e0s6058HcfYpRlW0udrn5My7ee048UQXVDyOGBltTwM/6+hWNz7KzoOd8oejo/Pc0uJ
	XtewCwK7TAKjYsahj+l2ZMyoNNq8Ew0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-46qnJbtsOdCbPV_YBvOtcA-1; Fri,
 06 Feb 2026 00:38:39 -0500
X-MC-Unique: 46qnJbtsOdCbPV_YBvOtcA-1
X-Mimecast-MFC-AGG-ID: 46qnJbtsOdCbPV_YBvOtcA_1770356318
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 603C8195608A;
	Fri,  6 Feb 2026 05:38:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F2CB119560A7;
	Fri,  6 Feb 2026 05:38:35 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: song@kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com
Subject: [PATCH 2/2] md/raid1: serialize overlapped io for writemostly disk
Date: Fri,  6 Feb 2026 13:38:19 +0800
Message-ID: <20260206053826.37416-3-xni@redhat.com>
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

In behind mode, overlap bios for writemostly device are queued. They
In behind mode, bios which overlap the bio from the interval tree
need to wait in waitqueue. Those bios will be handled once the in-tree
bio finishes. They are waken up and try to get the tree lock. The bio
which gets the lock will be handled. So the sequence can't be guaranteed.

For example
bio1(100,200)
bio2(150,200)
bio3(150,300)
The write sequence of fast device is bio1,bio2,bio3. But the write
sequence of slow device is bio1,bio3,bio2. This causes data corruption.
Replace waitqueue with a fifo list to guarantee the write sequence.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    |  1 -
 drivers/md/md.h    |  4 +++-
 drivers/md/raid1.c | 39 +++++++++++++++++++++++++++++----------
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 59cd303548de..ab91d17c2d68 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
 
 		spin_lock_init(&serial_tmp->serial_lock);
 		serial_tmp->serial_rb = RB_ROOT_CACHED;
-		init_waitqueue_head(&serial_tmp->serial_io_wait);
 	}
 
 	rdev->serial = serial;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..64ffbb2efb87 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -126,7 +126,6 @@ enum sync_action {
 struct serial_in_rdev {
 	struct rb_root_cached serial_rb;
 	spinlock_t serial_lock;
-	wait_queue_head_t serial_io_wait;
 };
 
 /*
@@ -382,6 +381,9 @@ struct serial_info {
 	sector_t start;		/* start sector of rb node */
 	sector_t last;		/* end sector of rb node */
 	sector_t _subtree_last; /* highest sector in subtree of rb node */
+	struct list_head	list_node;
+	struct list_head	waiters;
+	struct completion	ready;
 };
 
 /*
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a41b1ec3d695..38c73538d038 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -57,19 +57,25 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, sector_t, _subtree_last,
 		     START, LAST, static inline, raid1_rb);
 
 static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
-				struct serial_info *si, int idx)
+				struct serial_info *si)
 {
 	unsigned long flags;
 	int ret = 0;
 	sector_t lo = r1_bio->sector;
 	sector_t hi = lo + r1_bio->sectors - 1;
+	int idx = sector_to_idx(r1_bio->sector);
 	struct serial_in_rdev *serial = &rdev->serial[idx];
+	struct serial_info *head_si;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	/* collision happened */
-	if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
+	head_si = raid1_rb_iter_first(&serial->serial_rb, lo, hi);
+	if (head_si && head_si != si) {
+		si->start = lo;
+		si->last = hi;
+		list_add_tail(&si->list_node, &head_si->waiters);
 		ret = -EBUSY;
-	else {
+	} else if (!head_si) {
 		si->start = lo;
 		si->last = hi;
 		raid1_rb_insert(si, &serial->serial_rb);
@@ -83,19 +89,23 @@ static void wait_for_serialization(struct md_rdev *rdev, struct r1bio *r1_bio)
 {
 	struct mddev *mddev = rdev->mddev;
 	struct serial_info *si;
-	int idx = sector_to_idx(r1_bio->sector);
-	struct serial_in_rdev *serial = &rdev->serial[idx];
 
 	if (WARN_ON(!mddev->serial_info_pool))
 		return;
 	si = mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
-	wait_event(serial->serial_io_wait,
-		   check_and_add_serial(rdev, r1_bio, si, idx) == 0);
+	INIT_LIST_HEAD(&si->waiters);
+	INIT_LIST_HEAD(&si->list_node);
+	init_completion(&si->ready);
+	while (check_and_add_serial(rdev, r1_bio, si)) {
+		wait_for_completion(&si->ready);
+		reinit_completion(&si->ready);
+	}
 }
 
 static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
 {
 	struct serial_info *si;
+	struct serial_info *first_si;
 	unsigned long flags;
 	int found = 0;
 	struct mddev *mddev = rdev->mddev;
@@ -106,16 +116,25 @@ static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
 	for (si = raid1_rb_iter_first(&serial->serial_rb, lo, hi);
 	     si; si = raid1_rb_iter_next(si, lo, hi)) {
 		if (si->start == lo && si->last == hi) {
-			raid1_rb_remove(si, &serial->serial_rb);
-			mempool_free(si, mddev->serial_info_pool);
 			found = 1;
 			break;
 		}
 	}
 	if (!found)
 		WARN(1, "The write IO is not recorded for serialization\n");
+	else {
+		raid1_rb_remove(si, &serial->serial_rb);
+		if (!list_empty(&si->waiters)) {
+			first_si = list_first_entry(&si->waiters,
+						struct serial_info, list_node);
+			list_del_init(&first_si->list_node);
+			list_splice_init(&si->waiters, &first_si->waiters);
+			raid1_rb_insert(first_si, &serial->serial_rb);
+			complete(&first_si->ready);
+		}
+		mempool_free(si, mddev->serial_info_pool);
+	}
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
-	wake_up(&serial->serial_io_wait);
 }
 
 /*
-- 
2.50.1 (Apple Git-155)

