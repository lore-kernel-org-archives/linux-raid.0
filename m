Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24232C00144
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 02:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbiHBCRR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiHBCRP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 22:17:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14E243E6F
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 19:17:14 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lxdpv3BkZzlVmX;
        Tue,  2 Aug 2022 10:14:31 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:17:12 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:17:12 +0800
Message-ID: <62b32172-f3b5-8c32-0a74-77e8b18927d1@huawei.com>
Date:   Tue, 2 Aug 2022 10:17:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 5/5 v2] get_vd_num_of_subarray: fix memleak
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

sra = sysfs_read() should be free before return in
get_vd_num_of_subarray()

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-ddf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index abbc8b09..6d4618fe 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1599,15 +1599,20 @@ static unsigned int get_vd_num_of_subarray(struct supertype *st)
        sra = sysfs_read(-1, st->devnm, GET_VERSION);
        if (!sra || sra->array.major_version != -1 ||
            sra->array.minor_version != -2 ||
-           !is_subarray(sra->text_version))
+           !is_subarray(sra->text_version)) {
+               if (sra)
+                       sysfs_free(sra);
                return DDF_NOTFOUND;
+       }

        sub = strchr(sra->text_version + 1, '/');
        if (sub != NULL)
                vcnum = strtoul(sub + 1, &end, 10);
        if (sub == NULL || *sub == '\0' || *end != '\0' ||
-           vcnum >= be16_to_cpu(ddf->active->max_vd_entries))
+           vcnum >= be16_to_cpu(ddf->active->max_vd_entries)) {
+               sysfs_free(sra);
                return DDF_NOTFOUND;
+       }

        return vcnum;
 }
--
2.27.0
