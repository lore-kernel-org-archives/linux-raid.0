Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F35C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 06:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbiEaGtU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 02:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244329AbiEaGtU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 02:49:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7838F703DD
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 23:49:19 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LC2sj4K08zjXDX;
        Tue, 31 May 2022 14:48:09 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:49:17 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:49:17 +0800
Message-ID: <bd8d7da6-83e7-da9b-1647-d95220a535e7@huawei.com>
Date:   Tue, 31 May 2022 14:49:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: [PATCH 1/5] parse_layout_faulty: fix memleak
From:   Wu Guanghao <wuguanghao3@huawei.com>
To:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
In-Reply-To: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

char *m is allocated by xstrdup but not free() before return, will cause
a memory leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util.c b/util.c
index cc94f96e..da18a68d 100644
--- a/util.c
+++ b/util.c
@@ -429,6 +429,7 @@ int parse_layout_faulty(char *layout)
 	int mode;
 	m[ln] = 0;
 	mode = map_name(faultylayout, m);
+	free(m);
 	if (mode == UnSet)
 		return -1;

-- 
2.27.0
