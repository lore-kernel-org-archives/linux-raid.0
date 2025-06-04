Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D884C1EEA5D
	for <linux-raid@vger.kernel.org>; Wed,  4 Jun 2025 09:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749028087; cv=none; b=EbrMpUl0NefkbFj3TDBzZm9rDT3/Th+GNaqng7c8t4SWjZocFDaD/xNo8w3locQrO9xg/kt6Xt4aRbVC8ROJM4d20JMJa0JB4mHj/cuALK0FghSuPsMRGMrOdhlw1B7Ko4IEXc22w4YAENItzsHR5EcwIxAI0qp3BcLQLJrxdrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749028087; c=relaxed/simple;
	bh=/4+pZbq/iBDp3gYeD1r87A2cD+DF2VS4M4q+mwfUBEs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DH0G76fFE3G/cRKqsUUXclmQwY6zTta28PTYMQFara1l1lReGVvLQCzIVGn88cMjF6DwMmfXSFSr+lgjn6WiremJB2XNPPswp4asYKzgaNsXiwcnoB/zit2Qd3ORrOKAQCQ0DxKUHQzBgHwEVQRNPK+64wa7tJbXQhtl8fq0IuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bNOGFhpa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNOGFhpa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749028084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MFnTVuCeAu2WNauyReoBkjeSjv2amauajv0Xs9Tquhc=;
	b=bNOGFhpaQWy1WuUYvj4OGHGLS9SWgt+KetSc6xpUQn8BNQ0bZ5TzF6U8jLN3smPjH8yPnS
	NW3//OGYaz2WT8mbBmhSckMledxW46EbZY7pP0AqIieHy08T7Lg5rSxfkWiIStei6wA3tJ
	rVqAaPFI6oBvHypeHf+jo6ZhpmQv44Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-8kGhh1-WMyGQmFqcrluYHg-1; Wed,
 04 Jun 2025 05:08:03 -0400
X-MC-Unique: 8kGhh1-WMyGQmFqcrluYHg-1
X-Mimecast-MFC-AGG-ID: 8kGhh1-WMyGQmFqcrluYHg_1749028082
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F6B4195608B;
	Wed,  4 Jun 2025 09:08:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E8BC2180045B;
	Wed,  4 Jun 2025 09:07:58 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 3/3] md: remove/add redundancy group only in level change
Date: Wed,  4 Jun 2025 17:07:42 +0800
Message-Id: <20250604090742.37089-4-xni@redhat.com>
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

del_gendisk is called in synchronous way now. So it doesn't need to handle
redundancy group in stop path separately.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8824ce64eee2..e3bb8c725bca 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6528,8 +6528,6 @@ static void __md_stop(struct mddev *mddev)
 	if (mddev->private)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
-	if (pers->sync_request && mddev->to_remove == NULL)
-		mddev->to_remove = &md_redundancy_group;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
-- 
2.32.0 (Apple Git-132)

