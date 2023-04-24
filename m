Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4982FC7618E
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 08:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjDXIHn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 04:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjDXIHk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 04:07:40 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F61E170A
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 01:07:37 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Q4d1Y4plYz17Tgf;
        Mon, 24 Apr 2023 16:03:45 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 16:07:34 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 1/4] Fix memory leak in file Assemble
Date:   Mon, 24 Apr 2023 16:06:34 +0800
Message-ID: <20230424080637.2152893-2-miaoguanqin@huawei.com>
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

When we test mdadm with asan, we found some memory leaks in Assemble.c
We fix these memory leaks based on code logic.

Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
---
 Assemble.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 49804941..a49de183 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -341,8 +341,10 @@ static int select_devices(struct mddev_dev *devlist,
 				st->ss->free_super(st);
 			dev_policy_free(pol);
 			domain_free(domains);
-			if (tst)
+			if (tst) {
 				tst->ss->free_super(tst);
+				free(tst);
+			}
 			return -1;
 		}
 
@@ -417,6 +419,7 @@ static int select_devices(struct mddev_dev *devlist,
 				st->ss->free_super(st);
 				dev_policy_free(pol);
 				domain_free(domains);
+				free(st);
 				return -1;
 			}
 			if (c->verbose > 0)
@@ -425,6 +428,7 @@ static int select_devices(struct mddev_dev *devlist,
 
 			/* make sure we finished the loop */
 			tmpdev = NULL;
+			free(st);
 			goto loop;
 		} else {
 			content = *contentp;
@@ -533,6 +537,7 @@ static int select_devices(struct mddev_dev *devlist,
 				st->ss->free_super(st);
 				dev_policy_free(pol);
 				domain_free(domains);
+				free(tst);
 				return -1;
 			}
 			tmpdev->used = 1;
@@ -546,8 +551,10 @@ static int select_devices(struct mddev_dev *devlist,
 		}
 		dev_policy_free(pol);
 		pol = NULL;
-		if (tst)
+		if (tst) {
 			tst->ss->free_super(tst);
+			free(tst);
+		}
 	}
 
 	/* Check if we found some imsm spares but no members */
@@ -839,6 +846,7 @@ static int load_devices(struct devs *devices, char *devmap,
 				close(mdfd);
 				free(devices);
 				free(devmap);
+				free(best);
 				*stp = st;
 				return -1;
 			}
@@ -1950,6 +1958,7 @@ out:
 	} else if (mdfd >= 0)
 		close(mdfd);
 
+	free(best);
 	/* '2' means 'OK, but not started yet' */
 	if (rv == -1) {
 		free(devices);
-- 
2.33.0

