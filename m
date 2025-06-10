Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB76A22B8CB
	for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 07:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540046; cv=none; b=VR08wOGihOHev8YwuC0dGowZP6n8dFl+N7nu2DqcXRcvZDX/lhSyUl2LheuwoRLZ6/ZYcGDmNeYd5D+8jyEMTRX77vaNU/Iezvtz5mVGlycVOPS6jWkeG4eHap2pJH5FISePriX41J1GNRb/iAh6WnrLgLEfzySnfQYExLMSM54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540046; c=relaxed/simple;
	bh=EbUVNoFdx3zYmawSSKjJsL1rkA2gMhNCwKtvCU8eIlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kIS6byLU59jyxj7yPhTWMg9AosFgemXFm/bSwcfXOa3UCC7cmBen9jxOlfbaspXRxmkzzH0XpVNzusSTxZiUKLRU8/4An5ZVs00DU9+q+Fl9bQAO4OWRjIqo3ylzbgm64Hbk6LNfYv/NlkUFd5LH+DTJhxvUn4gLdRrqChr2cGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dq8ihLU4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dq8ihLU4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749540044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKFQNoOV6O/AxB1qQOWAYBHwemWxUcomdgD3WGnvWJE=;
	b=Dq8ihLU4uzIqrxqhXMnQhKfaSoZQZ8NCrGjGtXY740m/WwudSe+0xMFyH3Ptt1+RstAT8n
	+mydrhaNughVpHtp1ge7zQ6ffdhmEQlmyodFtzoaQqEG+OXVbZuIvPfMar4w3AY3mTyvJ+
	SQgCJpm0F09rB4xUEQHNeQ5CiHKtrtU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-UI5Os2-SMpOqQ4Usv78x5g-1; Tue,
 10 Jun 2025 03:20:40 -0400
X-MC-Unique: UI5Os2-SMpOqQ4Usv78x5g-1
X-Mimecast-MFC-AGG-ID: UI5Os2-SMpOqQ4Usv78x5g_1749540039
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8542E18002E4;
	Tue, 10 Jun 2025 07:20:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.23])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 717BA19560AF;
	Tue, 10 Jun 2025 07:20:36 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 3/3] md: remove/add redundancy group only in level change
Date: Tue, 10 Jun 2025 15:20:22 +0800
Message-Id: <20250610072022.98907-4-xni@redhat.com>
In-Reply-To: <20250610072022.98907-1-xni@redhat.com>
References: <20250610072022.98907-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

del_gendisk is called in synchronous way now. So it doesn't need to handle
redundancy group in stop path separately.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index dde3d2bfd34d..7ae91155f2e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6523,8 +6523,6 @@ static void __md_stop(struct mddev *mddev)
 	if (mddev->private)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
-	if (pers->sync_request && mddev->to_remove == NULL)
-		mddev->to_remove = &md_redundancy_group;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
-- 
2.32.0 (Apple Git-132)

