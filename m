Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA3B28F946
	for <linux-raid@vger.kernel.org>; Thu, 15 May 2025 09:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747300142; cv=none; b=SF1wivjG2GQtQW+H3h30d4sFF/lieQIcdIw+gIXaRn459xJo38OmUVUXoxTuxfxN9G+HnmBYmLrrQAQJ71mblc8dSdc8FZka9FBmypTqO5akgkNNHTMhV4LgGv+X2+T6LzAPc4WVMdVNKfERkDDLwF4OIhvoeyeeZYLEO9y1P0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747300142; c=relaxed/simple;
	bh=rD9VgE2PEFM01aDAE384EOokt8pqlEYtu3alTnRvLA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GAGTF2kvDpyvyaBctTfbQsExjpdbQVWL1zFOlzamR9naUSFSKtULxWLWBLg0aNV8b2ctUBWPTqmr/AtjRA2OUM6MVv31BwXF/dcXthfbSGj0DOA84J4fxEBGfr5j5n8XIIgnF8SvRF3CDFBhrm7eEWz8pQoYCP4eMO0qTh7iPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EauTqN+R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EauTqN+R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747300139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0SfrOGAVCqi+ztMukHblMPQdyYvipIf3tGTKAXv4qg=;
	b=EauTqN+RONWkuxu3jddesPgiR/7DV4c+HMtorA8qlg+dYnoPCyUj0ddzYetJkYoqC4hXAu
	vKEZOl3S+yceJTkzsJo47cY2+Yvd64HIVeFG8AQ/fcg6EGJ6JHxmjD6l2+kc3/IaDMMi1s
	WqovGdtmVYySNJLaigyEDencF9ErIaQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-OwmNAqVYNwyKmhZtjxnwug-1; Thu,
 15 May 2025 05:08:56 -0400
X-MC-Unique: OwmNAqVYNwyKmhZtjxnwug-1
X-Mimecast-MFC-AGG-ID: OwmNAqVYNwyKmhZtjxnwug_1747300135
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32518180087E;
	Thu, 15 May 2025 09:08:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.66.61.200])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E017B180087A;
	Thu, 15 May 2025 09:08:52 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	song@kernel.org
Subject: [PATCH 1/2] md: Don't clear MD_CLOSING until mddev is freed
Date: Thu, 15 May 2025 17:08:46 +0800
Message-Id: <20250515090847.2356-2-xni@redhat.com>
In-Reply-To: <20250515090847.2356-1-xni@redhat.com>
References: <20250515090847.2356-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

