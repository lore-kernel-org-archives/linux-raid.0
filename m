Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EDFC77B7C
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 08:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjDXIHo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 04:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjDXIHk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 04:07:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36736E72
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 01:07:38 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q4d481qjdzsRGb;
        Mon, 24 Apr 2023 16:06:00 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 16:07:35 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 2/4] Fix memory leak in file Kill
Date:   Mon, 24 Apr 2023 16:06:35 +0800
Message-ID: <20230424080637.2152893-3-miaoguanqin@huawei.com>
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

When we test mdadm with asan, we found some memory leaks in Kill.c
We fix these memory leaks based on code logic.

Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
---
 Kill.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Kill.c b/Kill.c
index bfd0efdc..43c9abed 100644
--- a/Kill.c
+++ b/Kill.c
@@ -41,6 +41,7 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 	 *  4 - failed to find a superblock.
 	 */
 
+	bool free_super = false;
 	int fd, rv = 0;
 
 	if (force)
@@ -52,8 +53,10 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 				dev);
 		return 2;
 	}
-	if (st == NULL)
+	if (st == NULL) {
 		st = guess_super(fd);
+		free_super = true;
+	}
 	if (st == NULL || st->ss->init_super == NULL) {
 		if (verbose >= 0)
 			pr_err("Unrecognised md component device - %s\n", dev);
@@ -77,6 +80,10 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 			rv = 0;
 		}
 	}
+	if (free_super && st) {
+		st->ss->free_super(st);
+		free(st);
+	}
 	close(fd);
 	return rv;
 }
-- 
2.33.0

