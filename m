Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810C02701B1
	for <linux-raid@vger.kernel.org>; Thu, 24 Apr 2025 10:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745488863; cv=none; b=NkvL69T9Pra0sd1LiEdtSF8I1kSsMldOrDW2kACV8lhFlz4jFPj4GC4Ayf3EfAMes23v54G2W45gibjZ9RdpRWuMFxaxmRObqDNRsAor8gdLA2sATbbHmzMK8waenLBWN1kxwl0XAT3zbqpdHNzuMbn6n+DDGUjblH5DMQRPuIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745488863; c=relaxed/simple;
	bh=rWuHAEx/zhunWYN6Wr7cnZmzH1JZuNg69AIaGAg1+/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S5u1Itw08jkgzb9hBHmGcGpclPpctWTbGr7y0YbswDKBTrt/VjIZSco37jgqUhxvvREk1X46EIzRHnKEfgujCCBqVb8IJChfsJGKx30SYTrfBQ1RAWBqKB8+dpe0AUdGDfPZ8IFkxShwD0PeRxjh5eGwk9iN1peTKhyxC4YJrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SjyqxFFF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SjyqxFFF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745488860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hGdjZlVphvPgFY6AoiE8JijfdhiW38evdry2IHKpbg=;
	b=SjyqxFFFN5u26uILTQgyN5c3ofS56g2F3AcJQL0lzniTn4uUrauOlBHrQdrnps0ynEsYSp
	aP48Mxc98Z4/BCZD7ttWftKSUgrEoCDBsZPwy468Z+xWTj8MPIBp1poceVndLStpTiKglI
	As3w17f/CqfKPSkuE1w6w3PWDpJZXng=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-urm9MHYzOQCOlHDnqvKKyQ-1; Thu,
 24 Apr 2025 06:00:56 -0400
X-MC-Unique: urm9MHYzOQCOlHDnqvKKyQ-1
X-Mimecast-MFC-AGG-ID: urm9MHYzOQCOlHDnqvKKyQ_1745488855
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BFBF1956096;
	Thu, 24 Apr 2025 10:00:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.20])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD18D180045B;
	Thu, 24 Apr 2025 10:00:51 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	hch@lst.de
Subject: [PATCH RFC 1/3] md: replace MD_DELETED with MD_CLOSING
Date: Thu, 24 Apr 2025 18:00:42 +0800
Message-Id: <20250424100044.33564-2-xni@redhat.com>
In-Reply-To: <20250424100044.33564-1-xni@redhat.com>
References: <20250424100044.33564-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Before commit 12a6caf27324 ("md: only delete entries from all_mddevs when
the disk is freed") MD_CLOSING is cleared in ioctl path. Now MD_CLOSING
will keep until mddev is freed. So MD_CLOSING can be used to check if the
array is stopping.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 9 +++------
 drivers/md/md.h | 2 --
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9daa78c5fe33..3cfe26359d7e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -599,7 +599,7 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 {
 	lockdep_assert_held(&all_mddevs_lock);
 
-	if (test_bit(MD_DELETED, &mddev->flags))
+	if (test_bit(MD_CLOSING, &mddev->flags))
 		return NULL;
 	atomic_inc(&mddev->active);
 	return mddev;
@@ -613,9 +613,6 @@ static void __mddev_put(struct mddev *mddev)
 	    mddev->ctime || mddev->hold_active)
 		return;
 
-	/* Array is not configured at all, and not held active, so destroy it */
-	set_bit(MD_DELETED, &mddev->flags);
-
 	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
@@ -3312,7 +3309,7 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
-		if (test_bit(MD_DELETED, &mddev->flags))
+		if (test_bit(MD_CLOSING, &mddev->flags))
 			continue;
 		rdev_for_each(rdev2, mddev) {
 			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
@@ -8999,7 +8996,7 @@ void md_do_sync(struct md_thread *thread)
 			goto skip;
 		spin_lock(&all_mddevs_lock);
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
-			if (test_bit(MD_DELETED, &mddev2->flags))
+			if (test_bit(MD_CLOSING, &mddev2->flags))
 				continue;
 			if (mddev2 == mddev)
 				continue;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1cf00a04bcdd..a9dccb3d84ed 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -338,7 +338,6 @@ struct md_cluster_operations;
  * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
  *		   array is ready yet.
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
- * @MD_DELETED: This device is being deleted
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -353,7 +352,6 @@ enum mddev_flags {
 	MD_HAS_MULTIPLE_PPLS,
 	MD_NOT_READY,
 	MD_BROKEN,
-	MD_DELETED,
 };
 
 enum mddev_sb_flags {
-- 
2.32.0 (Apple Git-132)

