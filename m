Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B1CC6FA8B
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 02:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiITC2y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 22:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiITC2v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 22:28:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B271057570
        for <linux-raid@vger.kernel.org>; Mon, 19 Sep 2022 19:28:50 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWllY45ZmzpT2c;
        Tue, 20 Sep 2022 10:26:01 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 20 Sep
 2022 10:28:48 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <song@kernel.org>, <linux-raid@vger.kernel.org>
CC:     <yebin10@huawei.com>
Subject: [PATCH -next 2/3] md: factor out __md_set_array_info()
Date:   Tue, 20 Sep 2022 10:39:37 +0800
Message-ID: <20220920023938.3273598-3-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220920023938.3273598-1-yebin10@huawei.com>
References: <20220920023938.3273598-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Factor out __md_set_array_info(). No functional change.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/md.c | 65 ++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 19960bb33f6d..c981996c298d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7469,6 +7469,40 @@ static inline int md_ioctl_check(unsigned int cmd)
 	return 0;
 }
 
+static int __md_set_array_info(struct mddev *mddev, void __user *argp)
+{
+	mdu_array_info_t info;
+	int err;
+
+	if (!argp)
+		memset(&info, 0, sizeof(info));
+	else if (copy_from_user(&info, argp, sizeof(info)))
+		return -EFAULT;
+
+	if (mddev->pers) {
+		err = update_array_info(mddev, &info);
+		if (err)
+			pr_warn("md: couldn't update array info. %d\n", err);
+		return err;
+	}
+
+	if (!list_empty(&mddev->disks)) {
+		pr_warn("md: array %s already has disks!\n", mdname(mddev));
+		return -EBUSY;
+	}
+
+	if (mddev->raid_disks) {
+		pr_warn("md: array %s already initialised!\n", mdname(mddev));
+		return -EBUSY;
+	}
+
+	err = md_set_array_info(mddev, &info);
+	if (err)
+		pr_warn("md: couldn't set array info. %d\n", err);
+
+	return err;
+}
+
 static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
@@ -7565,36 +7599,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	}
 
 	if (cmd == SET_ARRAY_INFO) {
-		mdu_array_info_t info;
-		if (!arg)
-			memset(&info, 0, sizeof(info));
-		else if (copy_from_user(&info, argp, sizeof(info))) {
-			err = -EFAULT;
-			goto unlock;
-		}
-		if (mddev->pers) {
-			err = update_array_info(mddev, &info);
-			if (err) {
-				pr_warn("md: couldn't update array info. %d\n", err);
-				goto unlock;
-			}
-			goto unlock;
-		}
-		if (!list_empty(&mddev->disks)) {
-			pr_warn("md: array %s already has disks!\n", mdname(mddev));
-			err = -EBUSY;
-			goto unlock;
-		}
-		if (mddev->raid_disks) {
-			pr_warn("md: array %s already initialised!\n", mdname(mddev));
-			err = -EBUSY;
-			goto unlock;
-		}
-		err = md_set_array_info(mddev, &info);
-		if (err) {
-			pr_warn("md: couldn't set array info. %d\n", err);
-			goto unlock;
-		}
+		err = __md_set_array_info(mddev, argp);
 		goto unlock;
 	}
 
-- 
2.31.1

