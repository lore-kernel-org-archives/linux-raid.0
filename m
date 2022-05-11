Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC26C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 06:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbiEKGmr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 02:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiEKGmq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 02:42:46 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C176EB1D4;
        Tue, 10 May 2022 23:42:42 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 11 May
 2022 14:42:42 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 11 May
 2022 14:42:40 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <pmenzel@molgen.mpg.de>
CC:     <baihaowen@meizu.com>, <linux-kernel@vger.kernel.org>,
        <linux-raid@vger.kernel.org>, <song@kernel.org>
Subject: [PATCH V2] md: remove useless INIT_LIST_HEAD()
Date:   Wed, 11 May 2022 14:42:38 +0800
Message-ID: <1652251358-14953-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <d5aecbb9-a897-9423-833f-432907b5be87@molgen.mpg.de>
References: <d5aecbb9-a897-9423-833f-432907b5be87@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

list candidates has been initialized statically through LIST_HEAD,
so there's no need to call another INIT_LIST_HEAD. Simply remove it.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: fix typo at description.
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 707e802d0082..eb2b23ef5ecc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6491,7 +6491,6 @@ static void autorun_devices(int part)
 					 struct md_rdev, same_set);
 
 		pr_debug("md: considering %s ...\n", bdevname(rdev0->bdev,b));
-		INIT_LIST_HEAD(&candidates);
 		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				pr_debug("md:  adding %s ...\n",
-- 
2.7.4

