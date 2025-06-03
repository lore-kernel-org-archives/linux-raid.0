Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4767114A0B7
	for <linux-raid@vger.kernel.org>; Tue,  3 Jun 2025 05:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748928043; cv=none; b=rQJXdYfizo6XKjiccrO0o5CO7vA+jd9/BwvsvcD34TBCHkH3vg2pgkG3LkNn2dqQXzNYVWruhBL6+p7KU0DJcuZrTfW/+gcmYDe8FaHOgDSWo3tnCWf4r0DItvZu5hnkPScISgLAdWWUWKbnXwertWXJdQUdW2kfEeCFjkfSNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748928043; c=relaxed/simple;
	bh=/npHX+kBH50s9v9t/SMm5kR8YORHgrvFNvkquLJp4kE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OccwBoWwOoDMy7tHPP0iYHi77jXvW42OCXGocGXr2HextTsukJ6JxkWnZab4b11O/Z3BanGZ4jNzGpc7G5NVZvuoC66HDBtS7ay15wQ9gECHig3gLh/lVsQ2wO7NBZUmue8YpmF+a3jOZvzJo0FODbWNV4MRNpO9OWtDGPiK0Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUz3hONS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUz3hONS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748928040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeiY2/DDl1ITH0dA+nFLSFH24KTJjVzRDz/19Q8kS9c=;
	b=EUz3hONS6OcCA14qSHwb8BAcYN5SJlbWk+HIzjMa8PJtjGew7Ph5PDuxC1okr9nT1ph4W+
	3NVeWknwjUpM5yyPy6IhIt4iFnUo5JH572G3GM845n55Qh7CwtA0AxBzyZgVHvv7sJJIJr
	T95WxMiIarsyvklmJub5khkXOhHOoAE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-gB4R49b_N8OVXtOmrNY7WQ-1; Tue,
 03 Jun 2025 01:20:36 -0400
X-MC-Unique: gB4R49b_N8OVXtOmrNY7WQ-1
X-Mimecast-MFC-AGG-ID: gB4R49b_N8OVXtOmrNY7WQ_1748928036
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14BE118001EA;
	Tue,  3 Jun 2025 05:20:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 782A830002C6;
	Tue,  3 Jun 2025 05:20:33 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	song@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 2/3] md: Don't clear MD_CLOSING until mddev is freed
Date: Tue,  3 Jun 2025 13:20:22 +0800
Message-Id: <20250603052023.7922-3-xni@redhat.com>
In-Reply-To: <20250603052023.7922-1-xni@redhat.com>
References: <20250603052023.7922-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
index fd6c5ff0e3c1..0913b8236471 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6377,15 +6377,10 @@ static void md_clean(struct mddev *mddev)
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
@@ -6612,9 +6607,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
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

