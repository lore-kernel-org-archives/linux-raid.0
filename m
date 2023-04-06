Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CF5C7618D
	for <linux-raid@archiver.kernel.org>; Thu,  6 Apr 2023 12:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbjDFMDu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Apr 2023 08:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbjDFMD3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Apr 2023 08:03:29 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EADCCA3C
        for <linux-raid@vger.kernel.org>; Thu,  6 Apr 2023 05:01:09 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Psfgt1lchzKqnf;
        Thu,  6 Apr 2023 19:40:26 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 6 Apr
 2023 19:41:03 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 4/4] Fix memory leak in file mdadm
Date:   Thu, 6 Apr 2023 19:40:11 +0800
Message-ID: <20230406114011.3297545-5-miaoguanqin@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406114011.3297545-1-miaoguanqin@huawei.com>
References: <20230406114011.3297545-1-miaoguanqin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we test mdadm with asan, we found some memory leaks in mdadm.c
We fix these memory leaks based on code logic.

Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
---
 mdadm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 4685ad6b..19d7916b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1709,6 +1709,10 @@ int main(int argc, char *argv[])
 		autodetect();
 		break;
 	}
+	if (ss) {
+		ss->ss->free_super(ss);
+		free(ss);
+	}
 	if (locked)
 		cluster_release_dlmlock();
 	close_fd(&mdfd);
-- 
2.33.0

