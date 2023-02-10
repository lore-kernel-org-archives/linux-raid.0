Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17638C636CD
	for <linux-raid@archiver.kernel.org>; Fri, 10 Feb 2023 10:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjBJK2e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Feb 2023 05:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBJK2d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Feb 2023 05:28:33 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A1528856
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 02:28:32 -0800 (PST)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PCqfG6lfYzHtcn;
        Fri, 10 Feb 2023 18:26:46 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 10 Feb 2023 18:28:29 +0800
Message-ID: <ef9c2ae2-2102-c1ad-5113-39809afe5934@huawei.com>
Date:   Fri, 10 Feb 2023 18:28:28 +0800
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
Subject: [PATCH] Fix memory leak for function Manage_subdevs Manage_add Kill
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we excute mdadm,we found some memory leak.
The function call stack is as follows:
#0 in xcalloc
#1 in guess_super_type
#2 in guess_super
#3 in Kill
#4 in misc_list
#5 in main

#0 in __interceptor_posix_memalign
#1 in init_super1
#2 in Kill
#3 in misc_list
#4 in main

#0 in __interceptor_calloc
#1 in xcalloc
#2 in match_metadata_desc1
#3 in super_by_fd
#4 in Manage_subdevs
#5 in main

#0 in __interceptor_calloc
#1 in xcalloc
#2 in dup_super
#3 in Manage_add
#4 in Manage_subdevs
#5 in main

We fix these memory leak based on code logic.

Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
---
  Kill.c   | 12 ++++++++++--
  Manage.c |  9 ++++++++-
  2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/Kill.c b/Kill.c
index d4767e2..d1207cf 100644
--- a/Kill.c
+++ b/Kill.c
@@ -40,7 +40,8 @@ int Kill(char *dev, struct supertype *st, int force, 
int verbose, int noexcl)
  	 *  2 - failed to open the device.
  	 *  4 - failed to find a superblock.
  	 */
-
+	
+	int flags = 0;
  	int fd, rv = 0;

  	if (force)
@@ -52,8 +53,10 @@ int Kill(char *dev, struct supertype *st, int force, 
int verbose, int noexcl)
  				dev);
  		return 2;
  	}
-	if (st == NULL)
+	if (st == NULL) {
  		st = guess_super(fd);
+		flags = 1;
+	}
  	if (st == NULL || st->ss->init_super == NULL) {
  		if (verbose >= 0)
  			pr_err("Unrecognised md component device - %s\n", dev);
@@ -77,6 +80,11 @@ int Kill(char *dev, struct supertype *st, int force, 
int verbose, int noexcl)
  			rv = 0;
  		}
  	}
+	if (flags == 1 && st) {
+		if (st->sb)
+			free(st->sb);
+		free(st);
+	}
  	close(fd);
  	return rv;
  }
diff --git a/Manage.c b/Manage.c
index ffe55f8..15635eb 100644
--- a/Manage.c
+++ b/Manage.c
@@ -819,9 +819,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
  						    rdev, update, devname,
  						    verbose, array);
  				dev_st->ss->free_super(dev_st);
-				if (rv)
+				if (rv){
+					if (dev_st)
+						free(dev_st);
  					return rv;
+				}
  			}
+			if (dev_st)
+				free(dev_st);
  		}
  		if (dv->disposition == 'M') {
  			if (verbose > 0)
@@ -1649,6 +1654,8 @@ int Manage_subdevs(char *devname, int fd,
  			break;
  		}
  	}
+	if (tst)
+		free(tst);
  	if (frozen > 0)
  		sysfs_set_str(&info, NULL, "sync_action","idle");
  	if (test && count == 0)
-- 
2.33.0

