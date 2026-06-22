Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF739E9DD
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130422; cv=none; b=lJYeXh9+ffrmjr3mS+ankHWuELS/Ko9navkPcIj3jelYNCftOjbNVGw11GU4XP25jtfyBAe+30jYqDTP3iA/UtWzKcVpF6wBgNA8neoxuTYB65L3o5A4L/yn5xkNs4cs4Dip5mNJr3JZpN8TKRrrktyzT55t/Ah5abksIQlFrrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130422; c=relaxed/simple;
	bh=yj4H9XoLdo2KG8Tl3xjyiBKniKjvkCDrCjAikJXZ278=;
	h=To:In-Reply-To:Subject:Date:Message-Id:Mime-Version:Content-Type:
	 Cc:From:References; b=tYP2hFcyjLNeHzfACobGmu9CK7RRdMPtcEf6QHFwLKO4uzaGSoGBH0ibNShy23wAny73SNMDFFDbuJrP1JhY+KyVShQywZjoXK7anZI0voWva1ITbmoh42A+GLWZuWs5hwu64upRJ6w7PI+pyQ0fSrFbKRtxDyy1jjGrUIeeKI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=zNtpmSYS; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="zNtpmSYS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782130407;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=fdfb3OQJGWUKR6VacF0LsroljSD8I1hobsbQedYbecE=;
 b=zNtpmSYS+rJfZfqeOlcA16ne53sHG+JOPEFPomwIFC+3lp1fRvxGguzJAthx3QTwhgNeMN
 sf9OBZBgWroxIjKB6K+r895HPFHpA2Oz0ZOGFAcAIVe/2sheUTKPoFHMImfwc+LmEDNFz0
 vUdiKzq6g3bjfN1GRC6qwV36R2tlMdKarKQajr9dypA+KYglYPbh8UO6UDWijFB4XjPI+1
 8AkbYNJhH45iZ1QwPkKQbCbe2P3ZMZAyIaQuFXozRhT4ls1cxctOSONVT0hzyyeWfJuy+P
 JRiWMcaGQ2OY4S4oEpvjMwXjCc+5LEg8n3oSYxqlq5p2AUJQgkM/zNOQwBlTog==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26a3926e5+c107cc+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 20:13:24 +0800
In-Reply-To: <20260622121312.1775322-1-chencheng@fnnas.com>
Subject: [PATCH v5 1/3] md: suspend array when sync_action=reshape
Date: Mon, 22 Jun 2026 20:13:10 +0800
Message-Id: <20260622121312.1775322-2-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.54.0
X-Original-From: chencheng@fnnas.com
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
References: <20260622121312.1775322-1-chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

raid10 needs to resize/swap r10bio_pool when reshape changes
raid_disks, and, don't let new requests keep allocating r10bio
objects from the old pool while that transition is in progress.

suspend and lock array before mddev_start_reshape(), and resume
it on exit.

Other sync_action ops are unchanged.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..e139f36e30b9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5256,30 +5256,41 @@ static int mddev_start_reshape(struct mddev *mddev)
 
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
 	int ret;
+	bool suspended = false;
 	enum sync_action action;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	action = md_sync_action_by_name(page);
+	if (action == ACTION_RESHAPE) {
+		ret = mddev_suspend(mddev, true);
+		if (ret)
+			return ret;
+		suspended = true;
+	}
 retry:
 	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
 	ret = mddev_lock(mddev);
-	if (ret)
+	if (ret) {
+		mddev_resume(mddev);
 		return ret;
+	}
 
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
@@ -5344,11 +5355,14 @@ action_store(struct mddev *mddev, const char *page, size_t len)
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
