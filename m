Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD7230997
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 07:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627094; cv=none; b=jc7/0JqnTz9LX6x+3qBqZjfcpf6ZnEGe3lgFmneePkrD6Y1+R3i2nYP0hZu6IRC0apuxB20jOtRZw7Vl9tFg2eJ4JvBMoLAksL8UczzLcChvQagyCc0eHSf2NqWTL/ILSNoobexilj66dmQCNZ+F3qpm82dT0RcpkxjUrEYkwRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627094; c=relaxed/simple;
	bh=NQ0Fc8+yH2BR/6uYHq4+avJRc/TTHzW33f6oU3kxAMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f5wTlJfrHRQZcHz5JkZTvPiKnfIgO4wIerXZihGW2wf0NZUcl25NSpZwlMdBFKL3easdIngNpPcao1/dpQumfwxDeXVvhi8UjJlpjPkWIINYqBEckzU5czGqfz4uPA+Kv4ReB05h5wC8Jw+bIO/hR1exy81T17Dv5h046dAZrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iNMRcOUE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNMRcOUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749627091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EU0epXfaQjW82c+FeUVm+s5F6k3o/XO1EnSqXfH7jDU=;
	b=iNMRcOUEc2iwhJDQpIi5lzawU1RXFrNZlNMdU9Qrkas/yAYc8ObfCsGbgTCDeXklqEjWiN
	GgVXfyjYLbDR3tuGLwS+FSKnliQn2C4YDjDWoC/gtwZkabN+qCjJ/US2pCov0oHvhtXOwu
	prXr8EUTuXYAqAtURmtwn7xJD48DxE4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-vZwBvHIwPRyj2HWTWAT9Sw-1; Wed,
 11 Jun 2025 03:31:27 -0400
X-MC-Unique: vZwBvHIwPRyj2HWTWAT9Sw-1
X-Mimecast-MFC-AGG-ID: vZwBvHIwPRyj2HWTWAT9Sw_1749627086
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36B011956080;
	Wed, 11 Jun 2025 07:31:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07CD418003FC;
	Wed, 11 Jun 2025 07:31:22 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 3/3] md: remove/add redundancy group only in level change
Date: Wed, 11 Jun 2025 15:31:08 +0800
Message-Id: <20250611073108.25463-4-xni@redhat.com>
In-Reply-To: <20250611073108.25463-1-xni@redhat.com>
References: <20250611073108.25463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

del_gendisk is called in synchronous way now. So it doesn't need to handle
redundancy group in stop path separately.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
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

