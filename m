Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326DA2FC886
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756985398; cv=none; b=UGC3uMsRRs7Ssq5+69JoToI5A1MOFpcOoYolVYvySVepTR1jLzCsX8i80levcr/r3BQK0rnk2+XrB46G2aLThXuBUiKNWig+4cLENtR8Y023dZ3WcWPiqYaIyw68RQ40gu9yNjwoUsd0Z4rZBMal84tKcJFbYVvXZPVImnDmTB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756985398; c=relaxed/simple;
	bh=NBaMvam5YFCH0sqnoL9RdTEIHkasZ2+0k2cGmltthYQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=l136EiGbDeAi0xPoUnzvjDji5la2Yx19EKjzjQx++OBm0vduudilXyEdyGaNzfQRZL1sc/aqgSkfKh7rT0YJpP38SWtp6vydmOn9yg/5R3rxkLAtRqMhezM89AS/xpdLw4ZVTFRpqrwo4VlShZJS0TqCJaxJMVebYHrMSSd+1MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cHcJM6CB1ztTbT;
	Thu,  4 Sep 2025 19:12:19 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F4A31800B4;
	Thu,  4 Sep 2025 19:13:16 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Sep 2025 19:13:15 +0800
Message-ID: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
Date: Thu, 4 Sep 2025 19:13:15 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] md: cleanup md_check_recovery()
To: <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
CC: <linux-raid@vger.kernel.org>, <yangyun50@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj500016.china.huawei.com (7.202.194.46)

In md_check_recovery(), use new helpers to make code cleaner.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 drivers/md/md.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1baaf52c603c..cbbb9ac14cf6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9741,6 +9741,34 @@ static void unregister_sync_thread(struct mddev *mddev)
 	md_reap_sync_thread(mddev);
 }

+
+
+static bool md_should_do_recovery(struct mddev *mddev)
+{
+	/*
+	 * As long as one of the following flags is set,
+	 * recovery needs to do.
+	 */
+	if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_DONE, &mddev->recovery))
+		return true;
+
+	/*
+	 * If no flags are set and it is in read-only status,
+	 * there is nothing to do.
+	 */
+	if (!md_is_rdwr(mddev))
+		return false;
+
+	if ((mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
+	     (mddev->external == 0 && mddev->safemode == 1) ||
+	     (mddev->safemode == 2 && !mddev->in_sync &&
+	      mddev->resync_offset == MaxSector))
+		return true;
+
+	return false;
+}
+
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -9777,18 +9805,7 @@ void md_check_recovery(struct mddev *mddev)
 		flush_signals(current);
 	}

-	if (!md_is_rdwr(mddev) &&
-	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
-		return;
-	if ( ! (
-		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
-		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
-		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		(mddev->external == 0 && mddev->safemode == 1) ||
-		(mddev->safemode == 2
-		 && !mddev->in_sync && mddev->resync_offset == MaxSector)
-		))
+	if (!md_should_do_recovery(mddev))
 		return;

 	if (mddev_trylock(mddev)) {
-- 
2.27.0
