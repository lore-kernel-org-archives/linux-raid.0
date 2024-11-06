Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922B21D79A5
	for <linux-raid@vger.kernel.org>; Wed,  6 Nov 2024 09:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730886697; cv=none; b=HEHbWSfF0ZEIxIyDR90AyWWrNAQXxAT+Hr3U/ScCb67esBi9hFlyB1WZi/UpbmhZWDDF56AFuV85bbzxywSZm27iEhRRdKXRrSimXt147kqfjpfdREJeGAlUlhUnHnNj816M+Ezohl/EsB87WH8po5KDqxSVr3GUwMd0tDg4cWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730886697; c=relaxed/simple;
	bh=KIQYZKbmH5UjXVDBKRtXIZzuNFI0URJJr2NVitVVJnw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TBlziDB/Erzs+/CiYuS+g/YJlpjamD8JsI6EkmynqVhD5eaozHj371J0Olac/qOXk6th4JcLGwQzLkURMQ4Q4p9hFQ7QBZ9Ly8eXQ90OkgSpBRLeSmK6Aw0ZuFct3h+7bH8De0rfn8zipJN9o3TpRbFvWbw1Sy212xpnAtAQxPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBms/Qkm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBms/Qkm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730886694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fkiI7QT+j3Fni2t0BNB93+fvxNzSJcGCeM2USkOupGs=;
	b=XBms/QkmJIj1qmSb+NlB4hnpn38nT439dAjdJavzGH3r7nl7mXj+JPyGH1su12JdWsv9gg
	InPv60IcdELVy701ojk6MKeHXW/EIlIFBu7RSkeKVl5bgLV9tNZK0e5o1MZ1fxUZY2P8/u
	PVzz9Kxv2RZZ1oMxLcJdKIN+B7+215Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-qPGLZ-azMbK8jx-Kk_Iq5Q-1; Wed,
 06 Nov 2024 04:51:30 -0500
X-MC-Unique: qPGLZ-azMbK8jx-Kk_Iq5Q-1
X-Mimecast-MFC-AGG-ID: qPGLZ-azMbK8jx-Kk_Iq5Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7629B1955EE6;
	Wed,  6 Nov 2024 09:51:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D76BB30000DF;
	Wed,  6 Nov 2024 09:51:26 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/1] md/raid5: Wait sync io to finish before changing group cnt
Date: Wed,  6 Nov 2024 17:51:24 +0800
Message-Id: <20241106095124.74577-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

One customer reports a bug: raid5 is hung when changing thread cnt
while resync is running. The stripes are all in conf->handle_list
and new threads can't handle them.

Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
pers->quiesce from mddev_suspend/resume. Before this patch, mddev_suspend
needs to wait for all ios including sync io to finish. Now it's used
to only wait normal io.

In this patch, it calls raid5_quiesce in raid5_store_group_thread_cnt
directly to wait all sync requests to finish before changing the group
cnt.

Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc2ea636d173..2fa1f270fb1d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7177,6 +7177,8 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
+	raid5_quiesce(mddev, true);
+
 	conf = mddev->private;
 	if (!conf)
 		err = -ENODEV;
@@ -7198,6 +7200,8 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 			kfree(old_groups);
 		}
 	}
+
+	raid5_quiesce(mddev, false);
 	mddev_unlock_and_resume(mddev);
 
 	return err ?: len;
-- 
2.32.0 (Apple Git-132)

