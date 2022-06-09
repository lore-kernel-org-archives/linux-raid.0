Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CCEC43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 03:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiFIDGT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 23:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiFIDGR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 23:06:17 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686383ED1C
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 20:06:16 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LJTTP06TXz1K9x1;
        Thu,  9 Jun 2022 11:04:25 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:06:14 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:06:14 +0800
Message-ID: <00ae6b42-b561-6542-0421-4ab8542d5d75@huawei.com>
Date:   Thu, 9 Jun 2022 11:06:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 1/5 v2] parse_layout_faulty: fix memleak
From:   Wu Guanghao <wuguanghao3@huawei.com>
To:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
In-Reply-To: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
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
a memory leak.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/util.c b/util.c
index cc94f96e..46b04afb 100644
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
