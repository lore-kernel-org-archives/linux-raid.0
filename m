Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314CD12C54B;
	Mon,  3 Jun 2024 12:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419541; cv=none; b=pETGgah+/CdAI4o9A1F7BKsC01OYJgsHRi/Ebsk5Ebo8S+E67gYJtUz8seykDHPVYXnfa/AYcRZUtppsqRwjqxklPXBDgbmO/8So5WmWf/AIAt/xoy5fEdughSd/S1ZpafzHNzvysWCywtsG5axA0YNLXBpgQN5KZqD01teWqAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419541; c=relaxed/simple;
	bh=BMr1T6POjrtTgMDCctLWY9qwW/mvv6c4OE0VAANQlq4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbbqpEavc5wiIiXD0Cegyq9MCqkAfxcwmOMnX6wnVjycv7pnU6HX3A74NAS1/wG6OODIA1WsD7W4hXQQlMUUWmnPXbPhNw0FUHmDhUUx/VmN1HuWMK9GwyWs+VJtdhEZvlAq1CFWknzoHZHNJabKbxpOhAp2WU6qYShZVaoxPM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VtDGH1nrwzwRLn;
	Mon,  3 Jun 2024 20:55:03 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F2FB14037B;
	Mon,  3 Jun 2024 20:58:42 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:13 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 04/12] md: factor out helper to start reshape from action_store()
Date: Mon, 3 Jun 2024 20:58:07 +0800
Message-ID: <20240603125815.2199072-5-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240603125815.2199072-1-yukuai3@huawei.com>
References: <20240603125815.2199072-1-yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

There are no functional changes, just to make code cleaner and prepare
for following refactor.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 65 +++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e5487008f66e..28f50a106566 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5070,6 +5070,45 @@ static void frozen_sync_thread(struct mddev *mddev)
 	mutex_unlock(&mddev->sync_mutex);
 }
 
+static int mddev_start_reshape(struct mddev *mddev)
+{
+	int ret;
+
+	if (mddev->pers->start_reshape == NULL)
+		return -EINVAL;
+
+	ret = mddev_lock(mddev);
+	if (ret)
+		return ret;
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		mddev_unlock(mddev);
+		return -EBUSY;
+	}
+
+	if (mddev->reshape_position == MaxSector ||
+	    mddev->pers->check_reshape == NULL ||
+	    mddev->pers->check_reshape(mddev)) {
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		ret = mddev->pers->start_reshape(mddev);
+		if (ret) {
+			mddev_unlock(mddev);
+			return ret;
+		}
+	} else {
+		/*
+		 * If reshape is still in progress, and md_check_recovery() can
+		 * continue to reshape, don't restart reshape because data can
+		 * be corrupted for raid456.
+		 */
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	}
+
+	mddev_unlock(mddev);
+	sysfs_notify_dirent_safe(mddev->sysfs_degraded);
+	return 0;
+}
+
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
@@ -5089,32 +5128,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	} else if (cmd_match(page, "reshape")) {
-		int err;
-		if (mddev->pers->start_reshape == NULL)
-			return -EINVAL;
-		err = mddev_lock(mddev);
-		if (!err) {
-			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-				err =  -EBUSY;
-			} else if (mddev->reshape_position == MaxSector ||
-				   mddev->pers->check_reshape == NULL ||
-				   mddev->pers->check_reshape(mddev)) {
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-				err = mddev->pers->start_reshape(mddev);
-			} else {
-				/*
-				 * If reshape is still in progress, and
-				 * md_check_recovery() can continue to reshape,
-				 * don't restart reshape because data can be
-				 * corrupted for raid456.
-				 */
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-			}
-			mddev_unlock(mddev);
-		}
+		int err = mddev_start_reshape(mddev);
+
 		if (err)
 			return err;
-		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 	} else {
 		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-- 
2.39.2

