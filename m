Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85D122FE11
	for <linux-raid@vger.kernel.org>; Mon, 28 Apr 2025 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745828821; cv=none; b=YysKKsXefLBv+Dsdm6fIZtdNWJrbyzHC1MAkNmk5DUEmaJRL1aucHB6cyj2+szdsB/UgtR1bVYFuxWgVLdgsscrkKk9AHhV3Rb5Ioorps3Y8SRCAVpsN1iGTgKp3IY7twx50oFk5P3AW4TWwD7T0pcu4sMyKcAkfJIPybBOMQq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745828821; c=relaxed/simple;
	bh=W9a+OkxrBRi/SkB5XvYjyMHUv3jR02+RAQ9WzRkqykw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aJp6CvZHNxT5PposGu3HwF4UYgzDWoCPmdGrBKiv83Yyj3V6MQ13LcR0AyyfpSy4TiaFcvQFJTVof23fxtOaeeZk7NRJvWNmyTZbesumh5ImocphGnRimHOBva4SKRLz1umeRalFaWXWKEOuw9Ha0+nOwJHZLtralMtcxjWBFaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEFOPxQR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEFOPxQR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745828818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cPQFthyw4C5jpXo9NIoIbSY4NxcXLkTFKIWprORgSjg=;
	b=dEFOPxQRDTW+75ZhTyDrlvsCHmbD9ugmEv+4dnL5kSluRtZXbcm0wEen4zkTmyTIo0lxy4
	7lvn+tFbNCd/uVk0ZZvpj3FMKxo0bA2YDh8THZTUByAfTtMk7L+AsROAmC5S6l4A0D9PG0
	hRhXUJIXpRdD2OhTW5g3nax+qbTFZSM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-NBV9WNBLMuO2fVF3CfrHgA-1; Mon,
 28 Apr 2025 04:26:54 -0400
X-MC-Unique: NBV9WNBLMuO2fVF3CfrHgA-1
X-Mimecast-MFC-AGG-ID: NBV9WNBLMuO2fVF3CfrHgA_1745828814
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12103180034A;
	Mon, 28 Apr 2025 08:26:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CAD0618001D5;
	Mon, 28 Apr 2025 08:26:48 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	mtkaczyk@kernel.org
Subject: [PATCH v2 1/3] md: replace MD_DELETED with MD_CLOSING
Date: Mon, 28 Apr 2025 16:26:39 +0800
Message-Id: <20250428082641.45027-2-xni@redhat.com>
In-Reply-To: <20250428082641.45027-1-xni@redhat.com>
References: <20250428082641.45027-1-xni@redhat.com>
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

This patch also removes the ->hold_active check in md_clean function.
->hold_active is used to avoid mddev is released on the last close before
adding disks to mddev. udev rule will open/close array once it's created.
The array can be closed without ->hold_active support. But it should not
work again when stopping an array. So remove the check ->hold_active in
md_clean function.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2 removes ->hold_active check in md_clean
 drivers/md/md.c | 24 +++++++-----------------
 drivers/md/md.h |  2 --
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9daa78c5fe33..e14253433c49 100644
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
@@ -6360,15 +6357,10 @@ static void md_clean(struct mddev *mddev)
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
+	/* UNTIL_STOP is cleared here */
+	mddev->hold_active = 0;
+	/* Don't clear MD_CLOSING, or mddev can be opened again. */
+	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -6595,8 +6587,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		export_array(mddev);
 
 		md_clean(mddev);
-		if (mddev->hold_active == UNTIL_STOP)
-			mddev->hold_active = 0;
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -8999,7 +8989,7 @@ void md_do_sync(struct md_thread *thread)
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

