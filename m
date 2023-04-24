Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479F7C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 08:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjDXIHp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 04:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjDXIHk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 04:07:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF0C1727
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 01:07:39 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q4d493xdwzsS62;
        Mon, 24 Apr 2023 16:06:01 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 16:07:36 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 4/4] Fix memory leak in file mdadm
Date:   Mon, 24 Apr 2023 16:06:37 +0800
Message-ID: <20230424080637.2152893-5-miaoguanqin@huawei.com>
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

When we test mdadm with asan, we found some memory leaks in mdadm.c
We fix these memory leaks based on code logic.

Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
---
 mdadm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 2296911d..409da62c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1709,6 +1709,10 @@ int main(int argc, char *argv[])
 		autodetect();
 		break;
 	}
+	if (ss) {
+		ss->ss->free_super(ss);
+		free(ss);
+	}
 	if (locked)
 		cluster_release_dlmlock();
 	close_fd(&mdfd);
-- 
2.33.0

