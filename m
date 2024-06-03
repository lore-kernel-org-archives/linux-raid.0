Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9CD3236
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451775; cv=none; b=S8iLb5LdccUWxy7TgwFx6Mh1jFsI2lglTI3Tkt6w3gvskENiO7YRmdgax7fIaYZaMbP9rPC0KMghejA9+TZq3Jyt8gjjfv4B2lRWRP2DR7+xPwvUYHgXZTaK4AhauU8QrPf3JAdNhpDAFb0tLwPXgzkDzbI4peIhfGx5jkPWNvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451775; c=relaxed/simple;
	bh=mr95cb8Cakkz1aINeR5m2OqNVr6C9rItxOZz7AQoMLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JogpPnirFx1TArOB0IaWBxxVZ4RjEFf+aKPegC9PN8hag3UHk87Yc2NqySc+oBT37rlTaVqTiaqxhyZ93UvyV4OFuJMAz/cEr2Hbt6Oidtu8ABtIRvP7jAMu76HK9Ut6xIdh8EAaFyt2GlBTMnIuOcMCDglVUr3dc5af2Ykf5+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8eVsRS2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8eVsRS2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7QfJM4OivEDDP468XqO5qvcSTv1uiaZYZ/eqmTgdcpc=;
	b=G8eVsRS2A12H93MAycX3Qw74FgfZdXTmDCW5IaYk59haCyO5L9Cv65tFEuqv9mRoPXI9HC
	IMye6ljFwdfbb/rbNx20Z9StoeVHo4aSVk+vxd1stT4MLvSdkZkSI/PkC2pHLAs8ZlPGuF
	A5ROWqF0f6O9fetOR5+lStFXBj1uANQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-YbWDBwCjPXGagTI3t7STFw-1; Mon,
 03 Jun 2024 17:56:09 -0400
X-MC-Unique: YbWDBwCjPXGagTI3t7STFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED4333806703;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E319E200F075;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 8/8] md-cluster: use DLM_LSFL_SOFTIRQ for dlm_new_lockspace()
Date: Mon,  3 Jun 2024 17:55:58 -0400
Message-ID: <20240603215558.2722969-9-aahringo@redhat.com>
In-Reply-To: <20240603215558.2722969-1-aahringo@redhat.com>
References: <20240603215558.2722969-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Recently the DLM subsystem introduced the flag DLM_LSFL_SOFTIRQ for
dlm_new_lockspace() to signal the capability to handle DLM ast/bast
callbacks in softirq context to avoid an additional context switch due
the DLM callback workqueue.

The md-cluster implementation only does synchronized calls above the
async DLM API. That synchronized API should may be also offered by DLM,
however it is very simple as md-cluster callbacks only does a complete()
call for their wait_for_completion() wait that is occurred after the
async DLM API call. This patch activates the recently introduced
DLM_LSFL_SOFTIRQ flag that allows that the DLM callbacks are executed in
a softirq context that md-cluster can handle. It is reducing a
unnecessary context workqueue switch and should speed up DLM in some
circumstance.

In future other DLM users e.g. gfs2 will also take usage of this flag to
avoid the additional context switch due the DLM callback workqueue. In
far future hopefully we can remove this kernel lockspace flag only and
remove the callback workqueue at all.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 8e36a0feec09..eb9bbf12c8d8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -887,7 +887,7 @@ static int join(struct mddev *mddev, int nodes)
 	memset(str, 0, 64);
 	sprintf(str, "%pU", mddev->uuid);
 	ret = dlm_new_lockspace(str, mddev->bitmap_info.cluster_name,
-				0, LVB_SIZE, &md_ls_ops, mddev,
+				DLM_LSFL_SOFTIRQ, LVB_SIZE, &md_ls_ops, mddev,
 				&ops_rv, &cinfo->lockspace);
 	if (ret)
 		goto err;
-- 
2.43.0

