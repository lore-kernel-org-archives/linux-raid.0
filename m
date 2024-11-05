Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6551AA785
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730811998; cv=none; b=Kts4CPQ7lL5kd5W+vgZkbGLqADbAPnxBZcxVz4SiADFdhq39AgxxaBGCdYl9FngW1bhKRVSuLtcP8e6F/W/eB+U4aFXZ7zAIAsxIfNGgb5m9tePYRcofg/+L2fJaQnBXt4jZo54xCNMK2M/2CNVU80I5lBSdWFrkz0VSz1WUbuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730811998; c=relaxed/simple;
	bh=0n9qb9X39/ZSCc2/gGUi4IMVf5THzpTT6q6FAcGek7s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gDeFcBNbID3lwn03Klbnrm42U59ESI/KL6h2/bKRP4V03J7TEiv0mxybWOrvH9p+9o9pxWpARIj6SPq9fInqrBDtGe4E99FkxRWd3FZx1g4jdNtMumnj6MOwF+qKn3l7L5bO3H4CKAkgpRVMk1SsOM91iS0J9NlEM/yXb+T4g2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XjT7n15cZz2Fbsx;
	Tue,  5 Nov 2024 21:04:37 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (unknown [7.185.36.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 13149140361;
	Tue,  5 Nov 2024 21:06:17 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 5 Nov
 2024 21:06:16 +0800
From: Yuan Can <yuancan@huawei.com>
To: <song@kernel.org>, <yukuai3@huawei.com>, <linux-raid@vger.kernel.org>
CC: <yuancan@huawei.com>
Subject: [PATCH] md/md-bitmap: Add missing destroy_work_on_stack()
Date: Tue, 5 Nov 2024 21:01:05 +0800
Message-ID: <20241105130105.127336-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)

This commit add missed destroy_work_on_stack() operations for
unplug_work.work in bitmap_unplug_async().

Fixes: a022325ab970 ("md/md-bitmap: add a new helper to unplug bitmap asynchrously")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/md/md-bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 29da10e6f703..c3a42dd66ce5 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1285,6 +1285,7 @@ static void bitmap_unplug_async(struct bitmap *bitmap)
 
 	queue_work(md_bitmap_wq, &unplug_work.work);
 	wait_for_completion(&done);
+	destroy_work_on_stack(&unplug_work.work);
 }
 
 static void bitmap_unplug(struct mddev *mddev, bool sync)
-- 
2.17.1

