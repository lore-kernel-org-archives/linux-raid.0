Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9965AC64EC4
	for <linux-raid@archiver.kernel.org>; Thu,  9 Mar 2023 14:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjCIOuZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Mar 2023 09:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjCIOuD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Mar 2023 09:50:03 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE21A53D88
        for <linux-raid@vger.kernel.org>; Thu,  9 Mar 2023 06:48:07 -0800 (PST)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PXX8R6zdwzKmYl;
        Thu,  9 Mar 2023 22:47:19 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 22:47:27 +0800
Message-ID: <f4aabc6f-22c1-3bf3-aef4-709051266f6c@huawei.com>
Date:   Thu, 9 Mar 2023 22:47:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>, <lixiaokeng@huawei.com>
From:   miaoguanqin <miaoguanqin@huawei.com>
Subject: [PATCH] Create /dev/md/x link when md device is created
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After the /dev/mdx is created,we can see that /dev/mdx file is
created.When we reboot machines,we found /dev/md/x will be created,
and map file will be rebuild and changed.

During RAID rebuild after the reboot, we found /dev/md/x is created
with high priority. To consistent behavior, we think that /dev/md/x
should also be created when creating devices.

We modified the logic for creating /dev/mdx,creating /dev/md/x at
the same time.

Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
  mdopen.c | 11 ++++++-----
  1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 98c54e4..d128396 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -373,11 +373,12 @@ int create_mddev(char *dev, char *name, int autof, 
int trustworthy,

  	sprintf(devname, "/dev/%s", devnm);

-	if (dev && dev[0] == '/')
-		strcpy(chosen, dev);
-	else if (cname[0] == 0)
-		strcpy(chosen, devname);
-
+	if (strncmp(chosen, "/dev/md/", 8) != 0) {
+		if (dev && dev[0] == '/')
+			strcpy(chosen, dev);
+		else if (cname[0] == 0)
+			strcpy(chosen, devname);
+	}
  	/* We have a device number and name.
  	 * If we cannot detect udev, we need to make
  	 * devices and links ourselves.
-- 
2.33.0

