Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6803C3E5A2C
	for <linux-raid@vger.kernel.org>; Wed,  3 Jun 2026 03:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780459190; cv=none; b=Hp2iQPEk3PUwTwkfaAElxxQkk5Toz3aD6VsBYl2i9NQFPuHDfw+26JaVmObbO8Tgq7+GJF39kq73x66MGwja0uVU/cfl7yZC5N+OtHUSsK6HP8BQU4KfVKDw1xxVc4pfyBeT3a7K1cbCQ8+Opex4sQ1zECXGh3UZM/gBwZLrF9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780459190; c=relaxed/simple;
	bh=c5BQbYqejQFjB1Dvwa0j3DWOXNYbfrN5zfd9/TpBc+4=;
	h=Cc:Subject:Date:References:Message-Id:Mime-Version:In-Reply-To:
	 Content-Type:To:From; b=Pf+VK6YqX3O7e0uLXyVI9KPTkRMaFzo0P3eiXunofdfIWJYXjFEl0gVjhZk2Wr0mC6QjmJkbOPjhFsOf7/EdxzUe5VDEPsMxXAseRNrBFZzkfs1TJ3qmXQsxKQ/r/DJRW4y0QeXMjJSSKzkOI1gvzf8C2VImpUVRcb46S6L5Qxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GEgNS1Dx; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GEgNS1Dx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780459184;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rDqvK++FuXr4+qMneJDGiyKGgBn60HyAFWmj1wid1EI=;
 b=GEgNS1DxyQBXouYfl2kDSa+L5XWlJHGpRdbkMDBBwzyTudQKzoVp+mT3ekDIIyRttrtWHI
 f5Z+AjkT7rVygxxga+5b+f3k/v6JiXyyR/T2r9TPrp8ax1YoUAUikaXaMEbvcqa8ITViEx
 nuU29D4z9u9VS1BvU2m6LZpAvXoG6lgMyeUrl5Sa+Uzq2iGIprhHHMsh7WrauOg7pkW61B
 nYBybezIZmkSBji1znG7uE4icEPec+5LqBbrJls/GaY5NcwIs3l5KUjHVtKTe2bZ7PnNdu
 GjLrGfuVwVyrMLvEQu7pENxS+vV9K+RLeZQdKO91rbPzg4RwxNJDjE1tOJ/9gw==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/3] md: suspend array before raid10 reshape via sync_action
Date: Wed,  3 Jun 2026 11:59:23 +0800
References: <20260603035925.217847-1-chencheng@fnnas.com>
Message-Id: <20260603035925.217847-2-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260603035925.217847-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26a1fa6ae+1408ea+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
From: "Chen Cheng" <chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.161.59]) by smtp.feishu.cn with ESMTPS; Wed, 03 Jun 2026 11:59:41 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.54.0

From: Chen Cheng <chencheng@fnnas.com>

The sync_action=reshape path currently enters mddev_start_reshape() with
reconfig_mutex held but without suspending the array first. For raid10,
that means raid10_start_reshape() has to drop reconfig_mutex and reacquire
the array through mddev_suspend_and_lock_nointr() before it can safely
switch geometry-dependent state.

Use mddev_suspend_and_lock() for ACTION_RESHAPE in action_store(), so
the sysfs reshape path reaches mddev_start_reshape() with the array
already suspended and locked.

Other sync_action operations keep using mddev_lock() unchanged.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..5bc937e149ac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5256,30 +5256,39 @@ static int mddev_start_reshape(struct mddev *mddev)
 
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
 	int ret;
+	bool suspended = false;
 	enum sync_action action;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	action = md_sync_action_by_name(page);
 retry:
 	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
-	ret = mddev_lock(mddev);
+	if (action == ACTION_RESHAPE) {
+		ret = mddev_suspend_and_lock(mddev);
+		suspended = true;
+	} else {
+		ret = mddev_lock(mddev);
+		suspended = false;
+	}
 	if (ret)
 		return ret;
 
 	if (work_busy(&mddev->sync_work)) {
-		mddev_unlock(mddev);
+		if (suspended)
+			mddev_unlock_and_resume(mddev);
+		else
+			mddev_unlock(mddev);
 		goto retry;
 	}
 
-	action = md_sync_action_by_name(page);
-
 	/* TODO: mdadm rely on "idle" to start sync_thread. */
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		switch (action) {
 		case ACTION_FROZEN:
 			md_frozen_sync_thread(mddev);
@@ -5344,11 +5353,14 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	md_wakeup_thread(mddev->thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	ret = len;
 
 out:
-	mddev_unlock(mddev);
+	if (suspended)
+		mddev_unlock_and_resume(mddev);
+	else
+		mddev_unlock(mddev);
 	return ret;
 }
 
 static struct md_sysfs_entry md_scan_mode =
 __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
-- 
2.54.0
