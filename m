Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F5BC00144
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 02:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiHBCPy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiHBCPx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 22:15:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBCB43E65
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 19:15:52 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Lxdmy1jXDz1M8NT;
        Tue,  2 Aug 2022 10:12:50 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:15:50 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:15:50 +0800
Message-ID: <32551992-ff6d-3d42-51dd-54e0a69e0cfd@huawei.com>
Date:   Tue, 2 Aug 2022 10:15:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 2/5 v2] Detail: fix memleak
From:   Wu Guanghao <wuguanghao3@huawei.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     linfeilong <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
In-Reply-To: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

char *sysdev = xstrdup() but not free() in for loop, will cause memory
leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Detail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Detail.c b/Detail.c
index ce7a8445..4ef26460 100644
--- a/Detail.c
+++ b/Detail.c
@@ -303,6 +303,7 @@ int Detail(char *dev, struct context *c)
                                if (path)
                                        printf("MD_DEVICE_%s_DEV=%s\n",
                                               sysdev, path);
+                               free(sysdev);
                        }
                }
                goto out;
--
2.27.0
