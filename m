Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E6BC00144
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 02:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiHBCQn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiHBCQm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 22:16:42 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DCB43E6B
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 19:16:42 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lxdqw11f2zGpKT;
        Tue,  2 Aug 2022 10:15:24 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:16:40 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:16:40 +0800
Message-ID: <c9b240d7-cf0d-8a98-d1b5-9f4ae203526c@huawei.com>
Date:   Tue, 2 Aug 2022 10:16:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 4/5 v2] find_disk_attached_hba: fix memleak
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
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If disk_path = diskfd_to_devpath(), we need free(disk_path) before
return, otherwise there will be a memory leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ddbdd3e1..2a4019e7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -713,12 +713,12 @@ static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)

        for (elem = list; elem; elem = elem->next)
                if (path_attached_to_hba(disk_path, elem->path))
-                       return elem;
+                       break;

        if (disk_path != devname)
                free(disk_path);

-       return NULL;
+       return elem;
 }

 static int find_intel_hba_capability(int fd, struct intel_super *super,
--
2.27.0
