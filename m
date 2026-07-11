Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D836AB4D
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 10:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764259; cv=none; b=HUkhAB/Da9N+q2aPaCXXfrXy3qp34rvyBSpJS//9soK6jcIFLXFw4RvBTYVfwnIrV/9UYE4HSAAJiffzdt/iiaS7ZQVl0nrABfxCFgXLydfhUdTSADBwpcxrqPzAadgdNqOjChgmKqR6dHV50Kl9pWWcEtwmYakwBw0GiLr14Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764259; c=relaxed/simple;
	bh=zO9S3Uc7S2ENZZD/Yj6G28n9IT9h2LxDSHVCu7650wE=;
	h=From:Mime-Version:References:Message-Id:In-Reply-To:Content-Type:
	 To:Cc:Date:Subject; b=ELqEfIFfPb8pdi7gJEgGWzCWQYSbkIE+SOdQ7e+Op4B+DDXqIebuHiYfnkS2ooDxgj+rApb6+xOQMYN0RSe7aHNF3t5rOOIUSF0Kj+XknTHLO4zMKY1B90oajY0RVxS9AdcLq2N17qLVSBSr2oBphslwIOQTtzF3kktDV96sDEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=0aPO2VWx; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="0aPO2VWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783764251;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4MCbwe4EZJW2QS9n0NC3Qy3hAR1knQgcIejgOVgPr3Q=;
 b=0aPO2VWxvL4JhntmmaeFa6dMP2LSXvI9pRXS028IRvDmAIZyVr1ZFixxq/pVXYTSJnD4c7
 jEcLuURu2avEqoEBuyza/gs8LgWERENv/2GrF09P+1tQS/ExXQUGI73Dlwiyq8UZ+HtaiG
 O58woahyvdsdjUbZBW4hmYJQzNi4Duf92POJhP+sd0kSrnHnhG+XtBqBb8bP3Z6IoPUxLY
 6zm7uBgwUiDfQJDjxMZGl7JTh46H/uV2be1E+tSB0s6E9p3DwZpdogbwHenn3cq2yxzgPy
 yqR8SUsQzlehedmB23ibyaiHx9XtQLghXSqQQaLJdamW7dqyxwRM2Xq9I/YQHg==
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
References: <20260711100352.425177-1-chencheng@fnnas.com>
Message-Id: <20260711100352.425177-2-chencheng@fnnas.com>
In-Reply-To: <20260711100352.425177-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Sat, 11 Jul 2026 18:03:50 +0800
Received: from fedora ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 18:04:08 +0800
X-Lms-Return-Path: <lba+26a521519+d4c916+vger.kernel.org+chencheng@fnnas.com>
Subject: [PATCH v7 1/3] md: suspend array when sync_action=reshape
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

raid10 needs to resize/swap r10bio_pool when reshape changes
raid_disks, and, don't let new requests keep allocating r10bio
objects from the old pool while that transition is in progress.

suspend and lock array before mddev_start_reshape(), and resume
it on exit.

Other sync_action ops are unchanged.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..8ee2dcc116eb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5261,25 +5261,32 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	enum sync_action action;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	action = md_sync_action_by_name(page);
+	if (action == ACTION_RESHAPE) {
+		ret = mddev_suspend(mddev, true);
+		if (ret)
+			return ret;
+	}
 retry:
 	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
 	ret = mddev_lock(mddev);
-	if (ret)
+	if (ret) {
+		if (action == ACTION_RESHAPE)
+			mddev_resume(mddev);
 		return ret;
+	}
 
 	if (work_busy(&mddev->sync_work)) {
 		mddev_unlock(mddev);
 		goto retry;
 	}
 
-	action = md_sync_action_by_name(page);
-
 	/* TODO: mdadm rely on "idle" to start sync_thread. */
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		switch (action) {
 		case ACTION_FROZEN:
 			md_frozen_sync_thread(mddev);
@@ -5345,10 +5352,12 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	ret = len;
 
 out:
 	mddev_unlock(mddev);
+	if (action == ACTION_RESHAPE)
+		mddev_resume(mddev);
 	return ret;
 }
 
 static struct md_sysfs_entry md_scan_mode =
 __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
-- 
2.54.0
