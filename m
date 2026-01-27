Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3932DC78C
	for <linux-raid@vger.kernel.org>; Tue, 27 Jan 2026 07:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769499603; cv=none; b=MVVvM+Og/eudWQ3OYI/5j2jlzPGPB+FQ8x3wmt5ixFAT53c9rDwZqgO7gPiCexbawb/p2l7H9XWodMbUeMQ0sOortsagzgbR9ZXnyEmO/LiBac6kFRBpUNNugqissz8rGyP5n65wxbHUCAmFofLlp1LFEr68e4AqPxQUhKutzls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769499603; c=relaxed/simple;
	bh=iOdLZOZC5G9/TWDdK2cw8I/6D/MXTMZEkhXKu4qaN7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iESwo0tjZMGlsnqAvO6q8GH14PWeHTJkuPH2Z2B/nWo7M6LzT7Q0t0wIrMl7kYDZP6XTTqQ43Li0bDhgxW6FEMIgEztpJgLVnOqS7VLU88GtqDeW2cHhv0l0fgjBlOxfeI0ibgb/RB9P+TNI0rqRwGDtwvu1b9J6IhYB38P4a44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4fr4led; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4fr4led"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769499601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oOjOlUUuJqmISmKkg9VplkuPXzowgwbD0FMXarmxNRA=;
	b=O4fr4ledJHjZokS/6+C7SwUV4cxgoYqLs/zyQ1jk1DNqRHJv4SANnay4Zl6abAMSCGAN0X
	56MQ1vqg5/XzOlikReO7mwEqG47YB5uLIo3xDyWIBR5/i+li9T0zUU0jH2GiTMFSvS40wk
	/zNy2XgwXvCJRp9rMJ4UWZ5zpFYRb/Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-JthhrxmWPP-DgqnBOaQdHQ-1; Tue,
 27 Jan 2026 02:39:58 -0500
X-MC-Unique: JthhrxmWPP-DgqnBOaQdHQ-1
X-Mimecast-MFC-AGG-ID: JthhrxmWPP-DgqnBOaQdHQ_1769499597
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F09F81955DB1;
	Tue, 27 Jan 2026 07:39:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.141])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E06411956095;
	Tue, 27 Jan 2026 07:39:54 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	bvanassche@acm.org
Subject: [PATCH 1/1] md: fix return value of mddev_trylock
Date: Tue, 27 Jan 2026 15:39:27 +0800
Message-ID: <20260127073951.17248-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

A return value of 0 is treaded as successful lock acquisition. In fact, a
return value of 1 means getting the lock successfully.

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Reported-by: Bart Van Assche <bvanassche@acm.org>
Closes: https://lore.kernel.org/linux-raid/20250611073108.25463-1-xni@redhat.com/T/#mfa369ef5faa4aa58e13e6d9fdb88aecd862b8f2f
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6985f2829bbd..3bfbee595156 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -737,8 +737,8 @@ static inline int mddev_trylock(struct mddev *mddev)
 	int ret;
 
 	ret = mutex_trylock(&mddev->reconfig_mutex);
-	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
-		ret = -ENODEV;
+	if (ret && test_bit(MD_DELETED, &mddev->flags)) {
+		ret = 0;
 		mutex_unlock(&mddev->reconfig_mutex);
 	}
 	return ret;
-- 
2.50.1 (Apple Git-155)

