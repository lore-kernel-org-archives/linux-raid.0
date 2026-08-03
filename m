Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A971A2F7445
	for <linux-raid@vger.kernel.org>; Mon,  3 Aug 2026 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785780215; cv=none; b=KIgQMHvPYj59s1NUdm1zBI2NiMRGmXUH+C8M4DuyjVkQQLtc8XafuyO9l43zmt3hDiW7vvzDBtpdQ7vRMHrpFgE+Qi6IYFXHKeS0BHMd1wEJrhtLewBWVkFO5wWVatJc8OxLO8J1A3ZDqZIAor9UIUTePkkkWNSp3jwVNqsmrt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785780215; c=relaxed/simple;
	bh=MxP+oVxI8ZTB0TkJZ1AUSfNCa6QEi/6sbJv2k4tpguA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WSzKGllqxvFuujlqRe0mY4IpS6u5o1YjlBVb2CbmkJHt+Xwen1+RESI3CsPOzf0r3GFkyttcmK7NdlB7sdMQ+P4AKWC9+sT7Sr4TkF5iqNswMIwyGmQYAjuqoXwNKX2XKSke66ldC2UCFMJVgEnkQysiXuwY84Q3812EhO/PeCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eQWeNNQ3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQWeNNQ3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785780212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vwgVusZlIs22b8ngCzwgwKqLRYChdloVGnle5SB99vw=;
	b=eQWeNNQ3PsdXqQImZOJtiT8ZTVU1JIAC8v2atB+Vgf8UyE2SOD6t+37X2BIMXJMzRvEgr4
	2AdKJEl40t1D566+XhCUiRfKPoBXo9gWc+76bXAtcueSxM6+c3Sfohql1r7JNVRt/CLqBq
	oOx51CT309OBxcDH/p+sLVWCbhVbmDQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-wvZrNCt2Ns6N87ODmRLRRg-1; Mon,
 03 Aug 2026 14:03:29 -0400
X-MC-Unique: wvZrNCt2Ns6N87ODmRLRRg-1
X-Mimecast-MFC-AGG-ID: wvZrNCt2Ns6N87ODmRLRRg_1785780208
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC6B1195608E;
	Mon,  3 Aug 2026 18:03:27 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 839431956087;
	Mon,  3 Aug 2026 18:03:27 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 2FBCF2354D; Mon, 03 Aug 2026 14:03:27 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH] md/raid1: don't set array_frozen in raid1_takeover()
Date: Mon,  3 Aug 2026 14:02:39 -0400
Message-ID: <20260803180240.1177104-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

raid1_takeover() sets conf->array_frozen = 1 on the newly-allocated
r1conf and nothing ever clears it, so every I/O to the array stalls
permanently once _wait_barrier() sees it stuck at 1.

This used to be harmless: level_store() called mddev_resume() right
after pers->run(), which called raid1_quiesce(mddev, 0) and cleared
array_frozen back to 0 regardless of what raid1_takeover() set. Commit
b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removed that
quiesce(mddev, 0) call, so the pre-set now sticks.

setup_conf() already zero-initializes the new r1conf via kzalloc, so
just don't set array_frozen here.

Same class of bug as commit 892da88d1cd9 ("md/raid10: fix a
'conf->barrier' leakage in raid10_takeover()"), also triggered by
b39f35ebe86d.

Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
Link: https://issues.redhat.com/browse/RHEL-191802
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/raid1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96a..2a247ed5f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3485,8 +3485,6 @@ static void *raid1_takeover(struct mddev *mddev)
 		mddev->new_chunk_sectors = 0;
 		conf = setup_conf(mddev);
 		if (!IS_ERR(conf)) {
-			/* Array must appear to be quiesced */
-			conf->array_frozen = 1;
 			mddev_clear_unsupported_flags(mddev,
 				UNSUPPORTED_MDDEV_FLAGS);
 		}
-- 
2.54.0

