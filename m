Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FA3219ED
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 02:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746584073; cv=none; b=J5O7mV4Hrb2baNzw5L046xpPXnlPgQ2AeCXXa4pZN0IZV0geMgJkGJT7RrszYRhVmVb2poTctSIet3WnpvWG8bR4jMwDrv0H8tm5ue+KAv0qCo3usPOnvgPVXt8/b4TMD5qA7ytb2Kpg5GbwPsVrfagxCaJV/zOQCnuVehToLx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746584073; c=relaxed/simple;
	bh=vwnwsiI5ySmVTqPjc9WakDCcI85XMTFplEzqe6LqG3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fjwH6f7Mc4E5OaRncIeT69nnlsD9R8Os4MWwzTYNim/NkVTQtMgLPF4x9lwocuoLfxe8Loz0Fw5OQ6xjKU4a3pbBgpy6bLBzDxLimJ5H+nohSv0OpFI1VRS7KH7dYm5Bq8BqcmAx+ybmFZn4r3y5BrlY6z7xdlJRZm1Hk1xEudQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gN9vlAuY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gN9vlAuY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746584070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RLLm+oNtLkjSzfjZ9jnbsyJ5e0R9blMABSyEMpsLbc=;
	b=gN9vlAuYWyin8mOPLV8L3dPv8wbc9NL47pXutcluDlddvp2+v+XRfFFamOb60NHcKkDQp/
	PTVPHFTg1GJWb/5Ze6v2bvmV4BCFIU2faxaoiGUW9RPuT2dS1JAcCNbpnBPLntQvT0gyTJ
	n1oloVH61h9zcNqbi65ziJ22jtfHZU8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-9LlPT0PoNmKm4dCoAYO1EQ-1; Tue,
 06 May 2025 22:14:29 -0400
X-MC-Unique: 9LlPT0PoNmKm4dCoAYO1EQ-1
X-Mimecast-MFC-AGG-ID: 9LlPT0PoNmKm4dCoAYO1EQ_1746584068
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E78818011FB;
	Wed,  7 May 2025 02:14:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DAF018001DA;
	Wed,  7 May 2025 02:14:25 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com
Subject: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
Date: Wed,  7 May 2025 10:14:14 +0800
Message-Id: <20250507021415.14874-3-xni@redhat.com>
In-Reply-To: <20250507021415.14874-1-xni@redhat.com>
References: <20250507021415.14874-1-xni@redhat.com>
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
index 9b9950ed6ee9..c226747be9e3 100644
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
@@ -8992,7 +8989,7 @@ void md_do_sync(struct md_thread *thread)
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

