Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B94C7EE23
	for <linux-raid@archiver.kernel.org>; Wed,  7 Jun 2023 06:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbjFGG65 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Jun 2023 02:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbjFGG6z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Jun 2023 02:58:55 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8551730
        for <linux-raid@vger.kernel.org>; Tue,  6 Jun 2023 23:58:54 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QbdNp32SKzqTTn;
        Wed,  7 Jun 2023 14:54:02 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 7 Jun
 2023 14:58:49 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>, <miaoguanqin@huawei.com>
Subject: [PATCH] Fix mdmonitor-oneshot.service fail to be executed
Date:   Wed, 7 Jun 2023 14:57:34 +0800
Message-ID: <20230607065734.2722921-1-miaoguanqin@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we start mdmonitor-oneshot.service, we found an fail 
for mdmonitor-oneshot.service:

mdadm: No mail address or alert command - not monitoring

According to the error information, We modified the Environment 
field and added the syslog parameter.The service can be 
executed successfully.
---
 systemd/mdmonitor-oneshot.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/systemd/mdmonitor-oneshot.service b/systemd/mdmonitor-oneshot.service
index ba86b44e..032b8aad 100644
--- a/systemd/mdmonitor-oneshot.service
+++ b/systemd/mdmonitor-oneshot.service
@@ -10,7 +10,7 @@ Description=Reminder for degraded MD arrays
 Documentation=man:mdadm(8)
 
 [Service]
-Environment=MDADM_MONITOR_ARGS=--scan
+Environment=MDADM_MONITOR_ARGS="--scan --syslog"
 EnvironmentFile=-/run/sysconfig/mdadm
 ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=BINDIR/mdadm --monitor --oneshot $MDADM_MONITOR_ARGS
-- 
2.33.0

