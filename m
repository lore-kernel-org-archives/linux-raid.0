Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9E8C54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 02:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiITC2x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 22:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiITC2v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 22:28:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415615756F
        for <linux-raid@vger.kernel.org>; Mon, 19 Sep 2022 19:28:50 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWllY1gm1zpT1x;
        Tue, 20 Sep 2022 10:26:01 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 20 Sep
 2022 10:28:48 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <song@kernel.org>, <linux-raid@vger.kernel.org>
CC:     <yebin10@huawei.com>
Subject: [PATCH -next 1/3] md: refactor md ioctl cmd check
Date:   Tue, 20 Sep 2022 10:39:36 +0800
Message-ID: <20220920023938.3273598-2-yebin10@huawei.com>
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

Rename md_ioctl_valid to  md_ioctl_check, check whether the command is valid
and whether the permission passes.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/md.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 729be2c5296c..19960bb33f6d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7440,16 +7440,17 @@ static int md_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static inline bool md_ioctl_valid(unsigned int cmd)
+static inline int md_ioctl_check(unsigned int cmd)
 {
 	switch (cmd) {
-	case ADD_NEW_DISK:
+	case RAID_VERSION:
 	case GET_ARRAY_INFO:
-	case GET_BITMAP_FILE:
 	case GET_DISK_INFO:
+		break;
+	case ADD_NEW_DISK:
+	case GET_BITMAP_FILE:
 	case HOT_ADD_DISK:
 	case HOT_REMOVE_DISK:
-	case RAID_VERSION:
 	case RESTART_ARRAY_RW:
 	case RUN_ARRAY:
 	case SET_ARRAY_INFO:
@@ -7458,10 +7459,14 @@ static inline bool md_ioctl_valid(unsigned int cmd)
 	case STOP_ARRAY:
 	case STOP_ARRAY_RO:
 	case CLUSTERED_DISK_NACK:
-		return true;
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		break;
 	default:
-		return false;
+		return -ENOTTY;
 	}
+
+	return 0;
 }
 
 static int md_ioctl(struct block_device *bdev, fmode_t mode,
@@ -7472,18 +7477,9 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	struct mddev *mddev = NULL;
 	bool did_set_md_closing = false;
 
-	if (!md_ioctl_valid(cmd))
-		return -ENOTTY;
-
-	switch (cmd) {
-	case RAID_VERSION:
-	case GET_ARRAY_INFO:
-	case GET_DISK_INFO:
-		break;
-	default:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-	}
+	err = md_ioctl_check(cmd);
+	if (err)
+		return err;
 
 	/*
 	 * Commands dealing with the RAID driver but not any
-- 
2.31.1

