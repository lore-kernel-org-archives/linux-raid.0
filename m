Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC2CC77B76
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 08:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjDXIHq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 04:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjDXIHk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 04:07:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E44A171A
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 01:07:38 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q4d163yYZzSv5J;
        Mon, 24 Apr 2023 16:03:22 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 16:07:35 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 3/4] Fix memory leak in file Manage
Date:   Mon, 24 Apr 2023 16:06:36 +0800
Message-ID: <20230424080637.2152893-4-miaoguanqin@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230424080637.2152893-1-miaoguanqin@huawei.com>
References: <20230424080637.2152893-1-miaoguanqin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
 Manage.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index f54de7c6..7b6b2798 100644
--- a/Manage.c
+++ b/Manage.c
@@ -222,6 +222,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 		if (verbose >= 0)
 			pr_err("Cannot get exclusive access to %s:Perhaps a running process, mounted filesystem or active volume group?\n",
 			       devname);
+		sysfs_free(mdi);
 		return 1;
 	}
 	/* If this is an mdmon managed array, just write 'inactive'
@@ -801,8 +802,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
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
+				dev_st->ss->free_super(dev_st);
+				free(dev_st);
 			}
 		}
 		if (dv->disposition == 'M') {
@@ -1699,6 +1706,7 @@ int Manage_subdevs(char *devname, int fd,
 			break;
 		}
 	}
+	free(tst);
 	if (frozen > 0)
 		sysfs_set_str(&info, NULL, "sync_action","idle");
 	if (test && count == 0)
@@ -1706,6 +1714,7 @@ int Manage_subdevs(char *devname, int fd,
 	return 0;
 
 abort:
+	free(tst);
 	if (frozen > 0)
 		sysfs_set_str(&info, NULL, "sync_action","idle");
 	return !test && busy ? 2 : 1;
-- 
2.33.0

