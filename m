Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302F18DB02
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 02:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746584072; cv=none; b=adDxVTFmLcRByS+oG1B9hW+cOhAlUmAnhEyrQp3vvMZDAJhLZSxL/q6oXF6G+3qw9sHaQ/GXcDnT2qjj+8+8P+7BCStiVn0tdbthmutVVU7exmpjtqyM3VRgT3wY4xEifgL82TqjTCiUUldSAih/f6h5xw0tBJEubvZ4tKnc4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746584072; c=relaxed/simple;
	bh=rD9VgE2PEFM01aDAE384EOokt8pqlEYtu3alTnRvLA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ohXmbM0YoJiwZ/8FUrhvcYu+R0sg5ws+ZAJe+jvRy0l/au762aKMi02E88qkhce42w7n4J9HUEHCa8Rm/sBOhtrrRqO1/c9pkFJTH7RLaT8s47v7Td0aDsLp138wZgnDrN4S3fZz0IxkFEYzaJ3tNac0gA5ueK5Yd+/bMuZqVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lk83wTHJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lk83wTHJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746584067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0SfrOGAVCqi+ztMukHblMPQdyYvipIf3tGTKAXv4qg=;
	b=Lk83wTHJlpqhiDwafNHCWAGn4zcnXYPnXYvXShnv5LXARqPFU6Wu6EXu8AAw/f29lUoAC5
	XpSF0k3Va0V3XZEi0XL+oh+mkqjcbuw9urC5p5E1VaLT428a0Nd3ZH/fxDyoDHRQ/8au/e
	8P5mTh7qWLExku7U8hmXFGi8lPN0QJM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-54SQu9YVNBOUqEwit5WOlQ-1; Tue,
 06 May 2025 22:14:25 -0400
X-MC-Unique: 54SQu9YVNBOUqEwit5WOlQ-1
X-Mimecast-MFC-AGG-ID: 54SQu9YVNBOUqEwit5WOlQ_1746584064
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BC1D1801BDD;
	Wed,  7 May 2025 02:14:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08C2D1800352;
	Wed,  7 May 2025 02:14:21 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com
Subject: [PATCH 1/3] md: Don't clear MD_CLOSING until mddev is freed
Date: Wed,  7 May 2025 10:14:13 +0800
Message-Id: <20250507021415.14874-2-xni@redhat.com>
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

UNTIL_STOP is used to avoid mddev is freed on the last close before adding
disks to mddev. And it should be cleared when stopping an array which is
mentioned in commit efeb53c0e572 ("md: Allow md devices to be created by
name."). So reset ->hold_active to 0 in md_clean.

And MD_CLOSING should be kept until mddev is freed to avoid reopen.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9daa78c5fe33..9b9950ed6ee9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6360,15 +6360,10 @@ static void md_clean(struct mddev *mddev)
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
+	/* if UNTIL_STOP is set, it's cleared here */
+	mddev->hold_active = 0;
+	/* Don't clear MD_CLOSING, or mddev can be opened again. */
+	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -6595,8 +6590,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		export_array(mddev);
 
 		md_clean(mddev);
-		if (mddev->hold_active == UNTIL_STOP)
-			mddev->hold_active = 0;
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.32.0 (Apple Git-132)

