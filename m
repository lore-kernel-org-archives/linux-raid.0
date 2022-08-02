Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42736C00144
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 02:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiHBCPc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiHBCPb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 22:15:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E661CB1D
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 19:15:30 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lxdmv5hDszlVmZ;
        Tue,  2 Aug 2022 10:12:47 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:15:28 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:15:28 +0800
Message-ID: <19e8b467-a786-f42d-f07e-dfacae4f57c9@huawei.com>
Date:   Tue, 2 Aug 2022 10:15:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 1/5 v2] parse_layout_faulty: fix memleak
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

char *m is allocated by xstrdup but not free() before return, will cause
a memory leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/util.c b/util.c
index 38f0420e..2e0f1de7 100644
--- a/util.c
+++ b/util.c
@@ -427,8 +427,11 @@ int parse_layout_faulty(char *layout)
        int ln = strcspn(layout, "0123456789");
        char *m = xstrdup(layout);
        int mode;
+
        m[ln] = 0;
        mode = map_name(faultylayout, m);
+       free(m);
+
        if (mode == UnSet)
                return -1;

--
2.27.0
