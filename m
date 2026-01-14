Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E107F2E2DD2
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410772; cv=none; b=jZOL3CcFdeE8/b0c7TpunnGuSTOTVcpLq84KHuU6aEdwpwNXJaH2nw43m+b/Y2dgpjtB/lCZdrBh+NdJbzp3fUjh2NB3wKjdWU/XmERow/BZB0Tp41HRY3X4IsLX85z8Hiy20Xj27B+yohy53cSURBePl10TVUqYaPiKzTsNQtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410772; c=relaxed/simple;
	bh=v1aFxn/nnnd8mR/StdnWkNxCu1cIm3u/9oT8NBanoK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ4eJlyeEMp7kx6sXawkQMZrIusuWMqvIqeYscqI6bCze29djQlMU8DGXlcZ/FezKKR/Ur9bSKT5gh5YQtboNXHKMbSX8pt5f2tRpgHYJjrcIz9jbQZtAzY26em1rZ7xm9+DPCHUPQk3f4otCFSMoOqRJNULmZi1ims6yZYGGMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE753C4CEF7;
	Wed, 14 Jan 2026 17:12:49 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 01/12] md/raid5: fix raid5_run() to return error when log_init() fails
Date: Thu, 15 Jan 2026 01:12:29 +0800
Message-ID: <20260114171241.3043364-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260114171241.3043364-1-yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit f63f17350e53 ("md/raid5: use the atomic queue limit
update APIs"), the abort path in raid5_run() returns 'ret' instead of
-EIO. However, if log_init() fails, 'ret' is still 0 from the previous
successful call, causing raid5_run() to return success despite the
failure.

Fix this by capturing the return value from log_init().

Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e57ce3295292..39bec4d199a1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8055,7 +8055,8 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 	}
 
-	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
+	ret = log_init(conf, journal_dev, raid5_has_ppl(conf));
+	if (ret)
 		goto abort;
 
 	return 0;
-- 
2.51.0

