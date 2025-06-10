Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1925722B8CB
	for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 07:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540042; cv=none; b=LaYM2egrYrb+5jAsiTZ4gzCpZWn4ZRluk3zo2AzVg8GFjzQvC7oRFWLSn4dSBfCXvdbG3/DT1KtXw5jRq15mVUGcn2BDk6+ACSVFUJ1SB1HrliwuWY7AAG5BWUDGbUCGzRJU6VYzAdxUepsCR1JkTPiqxsnDaS87tupYTQpQLSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540042; c=relaxed/simple;
	bh=8qPGjB00faLku1xllPKwhXsPYG3GzKBotGWIA4KTfOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RI8BfdZg6knCp8EWkT7RAjWX+8BcwHd4UalqhN/7Eg6fJpgwBF/+W19jMBY3h/saJ3IUpt/fPQmtmYuRlP/2GyL9Sc4MrYznFEh2/XaBWYH4enpL9h59NXyaOu75bX88YvcowAWfeuVK4vGT0/8T+xLVN3kTzciBcSPnWDYtEvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M69MVYd3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M69MVYd3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749540040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLVRI8XI+vQysbB0Af8ARh2dUJVXm6xJ38/Ip44U/8I=;
	b=M69MVYd3oe9sxvk3jq3UJjQtAjygpnVV/0o4s2MZb082S7+tsBP9wUTuYUzMGo4PMNtGrj
	+7cC83sQptkHH91yXUMmFGYSbSUayRdcJRCZzb2LijmSfQOjSTc8MJy7ejQXuav6T/tJu/
	a3FI6gE/c2BNXQhsnMsjJ1PY0WI/iYI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-ICTt3kqxNNKSq5qvtWEmlw-1; Tue,
 10 Jun 2025 03:20:36 -0400
X-MC-Unique: ICTt3kqxNNKSq5qvtWEmlw-1
X-Mimecast-MFC-AGG-ID: ICTt3kqxNNKSq5qvtWEmlw_1749540036
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0A7F19560B2;
	Tue, 10 Jun 2025 07:20:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.23])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DA64D19560A3;
	Tue, 10 Jun 2025 07:20:32 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 2/3] md: Don't clear MD_CLOSING until mddev is freed
Date: Tue, 10 Jun 2025 15:20:21 +0800
Message-Id: <20250610072022.98907-3-xni@redhat.com>
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
index 7445e44eabff..dde3d2bfd34d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6425,15 +6425,10 @@ static void md_clean(struct mddev *mddev)
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
@@ -6660,9 +6655,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
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

