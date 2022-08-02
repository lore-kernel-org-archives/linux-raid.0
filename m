Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC458C19F2A
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 02:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiHBCQT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiHBCQR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 22:16:17 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278A443E65
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 19:16:17 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LxdqR0G1czGpKD;
        Tue,  2 Aug 2022 10:14:59 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:16:15 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:16:14 +0800
Message-ID: <2b2cdeac-d052-bd11-a3d6-d82d9b3fe10e@huawei.com>
Date:   Tue, 2 Aug 2022 10:16:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 3/5 v2] load_imsm_mpb: fix double free
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
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When free(super->buf) but not set super->buf = NULL, will be double free

get_super_block
        err = load_and_parse_mpb
                load_imsm_mpb(.., s, ..)
                        if (posix_memalign(&super->buf, MAX_SECTOR_SIZE, super->len) != 0) // true, super->buf != NULL
                        if (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,); // false
                                free(super->buf); //but super->buf not set NULL
                                return 2;

        if err ! = 0
                if (s)
                        free_imsm(s)
                                 __free_imsm(s)
                                        if (s)
                                                free(s->buf); //double free

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/super-intel.c b/super-intel.c
index 4ddfcf94..ddbdd3e1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4510,6 +4510,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
            MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
                pr_err("could not allocate migr_rec buffer\n");
                free(super->buf);
+               super->buf = NULL;
                return 2;
        }
        super->clean_migration_record_by_mdmon = 0;
--
2.27.0
