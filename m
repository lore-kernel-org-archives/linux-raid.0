Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43173D668C
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782218347; cv=none; b=JE3VA7MSzfeAWpLf/fitGSjycS2dCGQ7ycMT1t3jkretDy3+X9BpX4NfShGBL+/cAIJiS3EfwdtiOifDleNR0Y2OjlweyBSBkhKp2oX2aAhqk4eFYZ4aAaxi1bAJXPPX1zniE3vtk3crYNmQDSbk0o8ebjPhCCmhMZPUxV4blHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782218347; c=relaxed/simple;
	bh=NFcWNilJux3CZ4hraUiBzKM/Ijmm8OFLt06ah89ybrs=;
	h=Cc:Subject:Date:Mime-Version:References:To:From:Message-Id:
	 In-Reply-To:Content-Type; b=OCkXGDeb20ca8B3iUPmLp1hcMc8W9OEr8Xgk4tQDEbmD6BkiYqGk4lMBS31escF1Njbhbhh5ahJ4G7W4aE7y6F8Xwo8EpqA2J4b78UfV5eCiRCuW8eRWzOy1ScM+7BIpc2gn0E0K+th/vFpqW2tJazHBac2F8AAchXJ9q8mFqCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oSR4EG0D; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oSR4EG0D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782218335;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Zgg/UU/IkdxPS7LkTIqjR4Xhj9+lxrycKcYNDAr53MY=;
 b=oSR4EG0D5BFvG9clLCilfZlBH6TuMSlPCQnGW5VXVL83LwhqI6HZMP5JIMcUqh1M/xD/z7
 rZnRIRJZtRLTUbQpuiWqwPdnwZ6nu/k2V2LU8n5TVceWFiRnCjc79XHoqsRYx7jIMggbPB
 a1ktPZ1U/n5eIogGsCAplbm4qLVxS4faJoLH78ufTCDncFGXkQSgKeH0Dm/wjsXfZacbeQ
 OfsrHr38sKV8LzS1p/xq8+z1XtfWXs98BgXojmp/99HucjB/s3/wmdCZKNHTiXB+08vUCF
 9zW+yJ3xq+Wp1BPtG5WpIT8bM2qxEKxL3gOOTTpLC2vjpI7Z9w5HXFpzYunFXg==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 1/3] md: suspend array when sync_action=reshape
Date: Tue, 23 Jun 2026 20:38:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 20:38:52 +0800
X-Mailer: git-send-email 2.54.0
X-Lms-Return-Path: <lba+26a3a7e5d+82d381+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
References: <20260623123840.2521340-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260623123840.2521340-2-chencheng@fnnas.com>
In-Reply-To: <20260623123840.2521340-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

raid10 needs to resize/swap r10bio_pool when reshape changes
raid_disks, and, don't let new requests keep allocating r10bio
objects from the old pool while that transition is in progress.

suspend and lock array before mddev_start_reshape(), and resume
it on exit.

Other sync_action ops are unchanged.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..1377c407614c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5261,25 +5261,29 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	enum sync_action action;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	action = md_sync_action_by_name(page);
 retry:
 	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
-	ret = mddev_lock(mddev);
+	ret = (action == ACTION_RESHAPE) ?
+		mddev_suspend_and_lock(mddev) :
+		mddev_lock(mddev);
 	if (ret)
 		return ret;
 
 	if (work_busy(&mddev->sync_work)) {
-		mddev_unlock(mddev);
+		if (action == ACTION_RESHAPE)
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
@@ -5344,11 +5348,14 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	md_wakeup_thread(mddev->thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	ret = len;
 
 out:
-	mddev_unlock(mddev);
+	if (action == ACTION_RESHAPE)
+		mddev_unlock_and_resume(mddev);
+	else
+		mddev_unlock(mddev);
 	return ret;
 }
 
 static struct md_sysfs_entry md_scan_mode =
 __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
-- 
2.54.0
