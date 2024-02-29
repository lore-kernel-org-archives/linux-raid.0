Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540B1134428
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221805; cv=none; b=T5nzKbQsXWqGd7oxhXW3sH1VwisxVCD6FFKYHVbeeBNFBMjCV9YcXP2aK332joAxuWMTDfN+YoHSTkrqTmn+R8rRhJfhxnEkBccPFKX9yOe7Va+A6EfMCBT2Ab4nh/VqQuWtNLg7L4KmhTB0Unvdpa27YC6tQzIq+RDKHINZjfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221805; c=relaxed/simple;
	bh=OWBoe6+fAMVojgfAunr4vaW3PFA8dgvLQ6SANTycfXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dmQNnxnIB7YxFC9b15UNwO653Y1waDdP7tu1Cd7/IOici+QdpKzU/4KYIRXrsZ7X8nObnCNDI0NSmyQELbzC6uGOYvcB40W11KN8SW9mD14atrXRNqJft8lXG017SfAcnfWW7Vj+tClQEtwGlZZJlzwQrkxObTrpRraH4Vewh/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGZlQcXI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGZlQcXI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DNK4gvQ+bHqZYAYDjbVNjLmYadcAzhvUX3KDcuzvuv0=;
	b=BGZlQcXIHINJBDhsjZcEFWHm2XNRxQubMms39YZPF8v5cdQbh71d821jXQC7cByC1gtDer
	uPeUBhK2XfWLW1wOMcB6eGOhjs4cAU2Y1C0D7TcLxNeZ1mqTMSHhXZhxrUvrb9/zw4QwH+
	/oIsA4pdJg8H7mldeusaSkndfwi94wI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-511-oui4lvW4PXmEwBrv0QoLkA-1; Thu,
 29 Feb 2024 10:50:00 -0500
X-MC-Unique: oui4lvW4PXmEwBrv0QoLkA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C23829AA3BB;
	Thu, 29 Feb 2024 15:50:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E094C1D36C;
	Thu, 29 Feb 2024 15:49:56 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/6] md: Revert "md: Don't ignore suspended array in md_check_recovery()"
Date: Thu, 29 Feb 2024 23:49:38 +0800
Message-Id: <20240229154941.99557-4-xni@redhat.com>
In-Reply-To: <20240229154941.99557-1-xni@redhat.com>
References: <20240229154941.99557-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

This reverts commit 1baae052cccd08daf9a9d64c3f959d8cdb689757.

For dmraid, it doesn't allow any io including sync io when array is
suspended. Although it's a simple change in this patch, it still needs
more work to support it. Now we're trying to fix regression problems.
So let's keep as small changes as we can. We can rethink about this
in future.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6376b1aad4d9..79dfc015c322 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9492,6 +9492,9 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
+	if (READ_ONCE(mddev->suspended))
+		return;
+
 	if (mddev->bitmap)
 		md_bitmap_daemon_work(mddev);
 
-- 
2.32.0 (Apple Git-132)

