Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471041CD0C
	for <linux-raid@vger.kernel.org>; Thu, 18 Sep 2025 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758202974; cv=none; b=Hya7qa6Lprhu+w6MS1L/e/JtcWPeR0hWIFX/CEC/Xrb/hnYcjA1x/mOMhukPO52wpAcBjvEpwDJ6hOhJbprv/sTQmipN21wsrFCKLmOVoE/3j+eg8uQVNYqU8XLkgfo6gkWbq7/s2ETHIbFxya0HUnSoIQZiNLQCGErtvii4s3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758202974; c=relaxed/simple;
	bh=qd3hXY9XgHiw8cjge13Lf6hOHRKSXKhDH3/3yP9EWrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIxw4Ip5pmgcPCkUNnB2Mfvj/TzjX5o0W6fWXOf64upB3ezukEd0STiSSFLN1kIT9ZSPyH7M3KrjamIEquji8cX6OJD2r+M5Z35TuuQf0W1BV/EfjK3qma6DN7ZXL3geKb65p/EZh6XJc86AZRHZe5FakH81qdz5ZZzNi+ztxsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BM3MYKsf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BM3MYKsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758202972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OO/zlqFI4HAQySVPIlojxj20+66UlyKTQ9bnhnA2hwE=;
	b=BM3MYKsf5hgBuNiYA7cwEHPx3PXdcjdJlSdx8owi52ZcS7uVudgJ8LlLIQVwCzPB+OoeGC
	Av0gA22PM9SmT7RJD7xYYsy00v6xRsmYTE4Le/5xtNnmLtNoSSVyyFnASgUf9Kxnk6e1hX
	5pUTZBQFfp1lB6P8Ozgi0NtTugFoHDQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-O7FC1pkoMbGJIt_TjXyPxw-1; Thu,
 18 Sep 2025 09:42:50 -0400
X-MC-Unique: O7FC1pkoMbGJIt_TjXyPxw-1
X-Mimecast-MFC-AGG-ID: O7FC1pkoMbGJIt_TjXyPxw_1758202970
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D55A2180057E;
	Thu, 18 Sep 2025 13:42:49 +0000 (UTC)
Received: from o.redhat.com (unknown [10.45.225.144])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A95A819560B8;
	Thu, 18 Sep 2025 13:42:47 +0000 (UTC)
From: Heinz Mauelshagen <heinzm@redhat.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] md raid: fix hang when stopping arrays with metadata through dm-raid
Date: Thu, 18 Sep 2025 15:42:42 +0200
Message-ID: <b58dddf537d5aa7519670a4df5838e7056a37c2a.1758201368.git.heinzm@redhat.com>
In-Reply-To: <cover.1758201368.git.heinzm@redhat.com>
References: <cover.1758201368.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

When using device-mapper's dm-raid target, stopping a RAID array can cause the
system to hang under specific conditions.

This occurs when:

-  A dm-raid managed device tree is suspended from top to bottom
   (the top-level RAID device is suspended first, followed by its
    underlying metadata and data devices)

-  The top-level RAID device is then removed

The hang happens because removing the top-level device triggers md_stop() from the
dm-raid destructor.  This function attempts to flush the write-intent bitmap, which
requires writing bitmap superblocks to the metadata sub-devices.  However, since
these metadata devices are already suspended, the write operations cannot complete,
causing the system to hang.

Fix:

-  Prevent bitmap flushing when md_stop() is called from dm-raid contexts
   and avoid a quiescing/unquescing cycle which could also cause I/O

-  Avoid any I/O operations that might occur during the quiesce/unquiesce process in md_stop()

This ensures that RAID array teardown can complete successfully even when the
underlying devices are in a suspended state.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/md.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..53e15bdd9ab2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6541,12 +6541,14 @@ static void __md_stop_writes(struct mddev *mddev)
 {
 	timer_delete_sync(&mddev->safemode_timer);
 
-	if (mddev->pers && mddev->pers->quiesce) {
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
-	}
+	if (!mddev_is_dm(mddev)) {
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

