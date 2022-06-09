Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7DFC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 03:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbiFIDIB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 23:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiFIDIA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 23:08:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BB3182A6B
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 20:07:58 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LJTWv6sm0zjYWZ;
        Thu,  9 Jun 2022 11:06:35 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:07:57 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:07:56 +0800
Message-ID: <3a17cad1-928b-2f44-88e6-df457102cfb2@huawei.com>
Date:   Thu, 9 Jun 2022 11:07:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 3/5 v2] load_imsm_mpb: fix double free
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
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When free(super->buf) but not set super->buf = NULL, will be double free.

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
---
 super-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/super-intel.c b/super-intel.c
index ba3bd41f..ee9e112e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4453,6 +4453,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
            MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
                pr_err("could not allocate migr_rec buffer\n");
                free(super->buf);
+               super->buf = NULL;
                return 2;
        }
        super->clean_migration_record_by_mdmon = 0;
--
2.27.0
