Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513EDC76196
	for <linux-raid@archiver.kernel.org>; Thu,  6 Apr 2023 12:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbjDFMCs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Apr 2023 08:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjDFMCc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Apr 2023 08:02:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F43BB9E
        for <linux-raid@vger.kernel.org>; Thu,  6 Apr 2023 04:59:57 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Psfdj2cH0zKx6c;
        Thu,  6 Apr 2023 19:38:33 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 6 Apr
 2023 19:41:02 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 3/4] Fix memory leak in file Manage
Date:   Thu, 6 Apr 2023 19:40:10 +0800
Message-ID: <20230406114011.3297545-4-miaoguanqin@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406114011.3297545-1-miaoguanqin@huawei.com>
References: <20230406114011.3297545-1-miaoguanqin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we test mdadm with asan, we found some memory leaks in Manage.c
We fix these memory leaks based on code logic.

Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
---
 Manage.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index fde6aba3..82bcb255 100644
--- a/Manage.c
+++ b/Manage.c
@@ -222,6 +222,8 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 		if (verbose >= 0)
 			pr_err("Cannot get exclusive access to %s:Perhaps a running process, mounted filesystem or active volume group?\n",
 			       devname);
+		if (mdi)
+			sysfs_free(mdi);
 		return 1;
 	}
 	/* If this is an mdmon managed array, just write 'inactive'
@@ -818,8 +820,15 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 						    rdev, update, devname,
 						    verbose, array);
 				dev_st->ss->free_super(dev_st);
-				if (rv)
+				if (rv) {
+					free(dev_st);
 					return rv;
+				}
+			}
+			if (dev_st) {
+				if (dev_st->sb)
+					dev_st->ss->free_super(dev_st);
+				free(dev_st);
 			}
 		}
 		if (dv->disposition == 'M') {
@@ -1716,6 +1725,8 @@ int Manage_subdevs(char *devname, int fd,
 			break;
 		}
 	}
+	if (tst)
+		free(tst);
 	if (frozen > 0)
 		sysfs_set_str(&info, NULL, "sync_action","idle");
 	if (test && count == 0)
@@ -1723,6 +1734,8 @@ int Manage_subdevs(char *devname, int fd,
 	return 0;
 
 abort:
+	if (tst)
+		free(tst);
 	if (frozen > 0)
 		sysfs_set_str(&info, NULL, "sync_action","idle");
 	return !test && busy ? 2 : 1;
-- 
2.33.0

