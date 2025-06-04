Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87F41DE884
	for <linux-raid@vger.kernel.org>; Wed,  4 Jun 2025 09:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749028087; cv=none; b=pSmlne/Hl5IpBCNAGOyj5vrOU5SZdEDHPBghlVmqXjaOxHcfH5Ey99uL9VJq8vudO+Q3uHd5XNzz5D/aOLllalj6X/Y0X5pcPta5FJLxst3ifdAjhrWTF75wlc/xcDCBkzYs7SRXvHSDqlvy7Ql/zwBrkQU/UpKIV1lEmyxjY5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749028087; c=relaxed/simple;
	bh=ZSfUPsZZc4n9LMwBePCUxN+PIYdbF+CS7djiuVCB4ks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mh830xAnJbnGH61kBwcNuFPwriYqK2loSDsASAOrFrvVrDXT0P2ahxTXfvscUIdI3NrzT5FtyFQOSKnADmsgxFZnh4KKn6SpG6Jre7+4UBaRRok8SrFrVofjQsJhYG6JNUzzriMB4SvyUV9qUhukyIADwECVGJZes5x1JVQy+u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gf/7g2Z9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gf/7g2Z9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749028084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIOnLkcSvq+r7tSGSNe4lPGhiXWUgQqB8ou8tlE/w1g=;
	b=Gf/7g2Z9b0Qw2h1dWSYT7hyeL+toq9v2lTxv7Y289niFmLyVi37kBsrlYMyI3CWAOO1bJa
	Vj40Vw89o49AmQurT+yxTNFE5kw63fkuF8G4TVBEHGWUVyAtuynGMhk7+6TpuMb6+xqvGZ
	XShCywGSU9gTS3jJdM1wQZcF2QFsxAA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-Kb7kXRm7MX2-Uksm_SCIEQ-1; Wed,
 04 Jun 2025 05:07:59 -0400
X-MC-Unique: Kb7kXRm7MX2-Uksm_SCIEQ-1
X-Mimecast-MFC-AGG-ID: Kb7kXRm7MX2-Uksm_SCIEQ_1749028078
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0850F1801A00;
	Wed,  4 Jun 2025 09:07:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 83EF1180049D;
	Wed,  4 Jun 2025 09:07:54 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 2/3] md: Don't clear MD_CLOSING until mddev is freed
Date: Wed,  4 Jun 2025 17:07:41 +0800
Message-Id: <20250604090742.37089-3-xni@redhat.com>
In-Reply-To: <20250604090742.37089-1-xni@redhat.com>
References: <20250604090742.37089-1-xni@redhat.com>
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
 drivers/md/md.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e58bb80bf2e9..8824ce64eee2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6430,15 +6430,10 @@ static void md_clean(struct mddev *mddev)
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
@@ -6665,9 +6660,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		export_array(mddev);
 		md_clean(mddev);
 		set_bit(MD_DELETED, &mddev->flags);
-
-		if (mddev->hold_active == UNTIL_STOP)
-			mddev->hold_active = 0;
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.32.0 (Apple Git-132)

