Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB69C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 06:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiEaGuX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 02:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiEaGuW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 02:50:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7081D703DD
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 23:50:21 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LC2tv3D2DzQjCD;
        Tue, 31 May 2022 14:49:11 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:50:19 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:50:19 +0800
Message-ID: <4ded262a-9313-d328-a3e1-fca56210bf62@huawei.com>
Date:   Tue, 31 May 2022 14:50:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 3/5] load_imsm_mpb: fix double free
From:   Wu Guanghao <wuguanghao3@huawei.com>
To:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
In-Reply-To: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
---
 super-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index ba3bd41f..ef21ffba 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4452,7 +4452,6 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	if (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,
 	    MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
 		pr_err("could not allocate migr_rec buffer\n");
-		free(super->buf);
 		return 2;
 	}
 	super->clean_migration_record_by_mdmon = 0;
-- 
2.27.0
