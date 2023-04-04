Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC833C761A6
	for <linux-raid@archiver.kernel.org>; Tue,  4 Apr 2023 11:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbjDDLcV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Apr 2023 07:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbjDDLcU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Apr 2023 07:32:20 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DED268A
        for <linux-raid@vger.kernel.org>; Tue,  4 Apr 2023 04:32:16 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PrQYv1QsqzrV3D;
        Tue,  4 Apr 2023 19:30:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 19:32:13 +0800
From:   miaoguanqin <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH] Fix null pointer for incremental in mdadm
Date:   Tue, 4 Apr 2023 19:31:24 +0800
Message-ID: <20230404113124.1555782-1-miaoguanqin@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

when we excute mdadm --assemble, udev-md-raid-assembly.rules is triggered.
Then we stop array, we found an coredump for mdadm --incremental.func
stack are as follows:

#0  enough (level=10, raid_disks=4, layout=258, clean=1, 
    avail=avail@entry=0x0) at util.c:555
#1  0x0000562170c26965 in Incremental (devlist=<optimized out>, 
    c=<optimized out>, st=0x5621729b6dc0) at Incremental.c:514
#2  0x0000562170bfb6ff in main (argc=<optimized out>, 
    argv=<optimized out>) at mdadm.c:1762

func enough() use array avail,avail allocate space in func count_active,
it may not alloc space, causing a coredump.We fix this coredump.

Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 Incremental.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Incremental.c b/Incremental.c
index 09b94b9f..49a71f72 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -507,6 +507,9 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 				    GET_OFFSET | GET_SIZE));
 	active_disks = count_active(st, sra, mdfd, &avail, &info);
 
+	if (!avail)
+		goto out_unlock;
+
 	journal_device_missing = (info.journal_device_required) && (info.journal_clean == 0);
 
 	if (info.consistency_policy == CONSISTENCY_POLICY_PPL)
-- 
2.33.0

