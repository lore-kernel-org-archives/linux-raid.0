Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808807A157
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221802; cv=none; b=BA5HfKNaKa3l+TavLBlmgi6MCuUCsHb+3lVjcp74ImBxRJUg9/dTFX740pkYASxrOCde9u4/cmUBP4v50Uz/mfgNkpornZk2qqJh6V1pulmu9PeHLCBl7g7u2vLc94EB8E4GdGYCSDWFLPdhImxzrDXnOvGbEZ6Lyir1ZH6jYw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221802; c=relaxed/simple;
	bh=6KCzEtTF5WUnU+nH49pMCEZH3yxkZWWwXlBTM3MMiHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZzOed5ThTuGqbfrahZxW14J4hwJHpphQZ8GLF8tM25vvuCUniYLTIrEZY+FRbC80y+1UOFjDsMVRQZtQj/9LO1kp3iGGBzcSENY+XA+zUUhVT1AMs+0q051TDj5jW0OABjsKYKmcGHsp4evmCxV91aFAyeqqgFkUIC2xOv50bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IkXBtXyv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IkXBtXyv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=da+5u9B4hhHOxuNEUVTs2cHeQnZWLj/nJmX2jJGb57A=;
	b=IkXBtXyv7eJa+tYQ1Vg1tIXS14ZWgadHZc00dhaU/8Iqum1xqFXlUvtUyntUtd3tqONTPM
	wTYc1JleAU0uEMy5/5amTU0+CKSZJSgFjOo6LqR9KbMdRBZOg3/ciM9Q/hZatViJm4FiNA
	5EOwTj3BDeMMB+iovi0gzvPWRdreuzw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-pOhqcrI_NX25mUPXwc5HbQ-1; Thu, 29 Feb 2024 10:49:56 -0500
X-MC-Unique: pOhqcrI_NX25mUPXwc5HbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A3688D284;
	Thu, 29 Feb 2024 15:49:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 294B1C1D36C;
	Thu, 29 Feb 2024 15:49:51 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/6] md: Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
Date: Thu, 29 Feb 2024 23:49:37 +0800
Message-Id: <20240229154941.99557-3-xni@redhat.com>
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

This reverts commit 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6.

The root cause is that MD_RECOVERY_WAIT isn't cleared when stopping raid.
The following patch 'Clear MD_RECOVERY_WAIT when stopping dmraid' fixes
this problem.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index db4743ba7f6c..6376b1aad4d9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8792,16 +8792,12 @@ void md_do_sync(struct md_thread *thread)
 	int ret;
 
 	/* just incase thread restarts... */
-	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
 		return;
-
-	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-		goto skip;
-
-	if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
-	    !md_is_rdwr(mddev)) {/* never try to sync a read-only array */
+	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		goto skip;
+		return;
 	}
 
 	if (mddev_is_clustered(mddev)) {
-- 
2.32.0 (Apple Git-132)

