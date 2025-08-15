Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA89A1862
	for <linux-raid@vger.kernel.org>; Fri, 15 Aug 2025 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755230442; cv=none; b=PAt54fh3eaCS4zwND9zPYQ5tnx9UfE6TiQmWPdWjFMs2YunZZ1qwTNfX1pj5eEA6FQgaN62kB4eWupI7DOPKGfZLIouiEWM/h3tLLcXV01EBeQvRP7OJO/NP6hKpl/o17NQo1WDa5w8i43+79pszVLxkRbC8dM6NKX3oe5o3irQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755230442; c=relaxed/simple;
	bh=57veNCXqhbY48mX1whburbKEC2v0adTVrARsBJYX2yw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DABDFS1v9V7t0RxCKKW9TWzSL6gEWNB8YdWqNYgJ6HeOIt3GZtyZdBFuwzAhzYSIKA9b9tQ1LDFviOmbMRAnMuppcAIwuBiGJaH+Vs8GQ4P/MJML+1Bzn1cvpShiK5OP/Gd+abseUXf9MH5dCZIWbQsj1KYBaU7q4dcOEzE85ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bo0XhoYm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bo0XhoYm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755230439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0BeeM2dcVXD+Fk1ZqqnbMwrUAj6HZIafhyUI1yaBDFY=;
	b=bo0XhoYmVOu+QGoFRehDy54NPuc4+yiKIcCW3ObbvQR4qUAsKlbuAeIUnk8hSiWOXI6EOz
	wO93ZRkD24p9rkCkJF6GRYs4gl6fpK9YDdrXtwtrnw0JNwsE6RaRxU0sROKCi1VKr4GLQX
	iXqZyLRI2XiEKFwghptHo3jE4pBXofc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-oDHttDf_NJODA_BlPFsMQQ-1; Fri,
 15 Aug 2025 00:00:36 -0400
X-MC-Unique: oDHttDf_NJODA_BlPFsMQQ-1
X-Mimecast-MFC-AGG-ID: oDHttDf_NJODA_BlPFsMQQ_1755230435
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F16A21800345;
	Fri, 15 Aug 2025 04:00:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 11FC730001A2;
	Fri, 15 Aug 2025 04:00:31 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai3@huawei.com
Cc: linan666@huaweicloud.com,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 1/1] md: keep recovery_cp in mdp_superblock_s
Date: Fri, 15 Aug 2025 12:00:28 +0800
Message-Id: <20250815040028.18085-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

commit 907a99c314a5 ("md: rename recovery_cp to resync_offset") replaces
recovery_cp with resync_offset in mdp_superblock_s which is in md_p.h.
md_p.h is used in userspace too. So mdadm building fails because of this.
This patch revert this change.

Fixes: 907a99c314a5 ("md: rename recovery_cp to resync_offset")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c                | 6 +++---
 include/uapi/linux/raid/md_p.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 772cffe02ff5..3836fc7eff67 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1423,7 +1423,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		else {
 			if (sb->events_hi == sb->cp_events_hi &&
 				sb->events_lo == sb->cp_events_lo) {
-				mddev->resync_offset = sb->resync_offset;
+				mddev->resync_offset = sb->recovery_cp;
 			} else
 				mddev->resync_offset = 0;
 		}
@@ -1551,13 +1551,13 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	mddev->minor_version = sb->minor_version;
 	if (mddev->in_sync)
 	{
-		sb->resync_offset = mddev->resync_offset;
+		sb->recovery_cp = mddev->resync_offset;
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
 		if (mddev->resync_offset == MaxSector)
 			sb->state = (1<< MD_SB_CLEAN);
 	} else
-		sb->resync_offset = 0;
+		sb->recovery_cp = 0;
 
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index b13946287277..ac74133a4768 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -173,7 +173,7 @@ typedef struct mdp_superblock_s {
 #else
 #error unspecified endianness
 #endif
-	__u32 resync_offset;	/* 11 resync checkpoint sector count	      */
+	__u32 recovery_cp;	/* 11 resync checkpoint sector count	      */
 	/* There are only valid for minor_version > 90 */
 	__u64 reshape_position;	/* 12,13 next address in array-space for reshape */
 	__u32 new_level;	/* 14 new level we are reshaping to	      */
-- 
2.32.0 (Apple Git-132)

