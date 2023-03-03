Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F4FC678D4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCCIdm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCCIdl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:33:41 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3201027F
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:33:38 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C7A8020382;
        Fri,  3 Mar 2023 08:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqmQPr0U5NDHGeFXAGA2tVhQ0Oe5zBXzOz62yxjpU/4=;
        b=IwO82K5UuutjnTUVAsdepUd8viOzaZ6AhlHGAo15y7rlRvuXlOxOYh6gWuSzuQNtPRiY2q
        EHQpK7INZHrTDetABJj0W1lbObdQXk1uHHs66//p1Io+AyWwHfNaRPuOXAv0GtaTRm7tzz
        c58ZESVDfOqF142kKYw2ii99F6+D4pM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832416;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqmQPr0U5NDHGeFXAGA2tVhQ0Oe5zBXzOz62yxjpU/4=;
        b=/mEyOKx8xu3dKrL8vKIus/6B4kVRq/tqFhtlWR3pvTrq38vKEKNMsGNIQxfIof4eX3gwI+
        epzPYlmLmJqYbjCA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 213652C141;
        Fri,  3 Mar 2023 08:33:34 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Wu Guanghao <wuguanghao3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 3/6] Detail.c: fix memleak in Detail()
Date:   Fri,  3 Mar 2023 16:33:20 +0800
Message-Id: <20230303083323.3406-4-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303083323.3406-1-colyli@suse.de>
References: <20230303083323.3406-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Wu Guanghao <wuguanghao3@huawei.com>

char *sysdev = xstrdup() but not free() in for loop, will cause memory
leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Detail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Detail.c b/Detail.c
index ce7a8445..4ef26460 100644
--- a/Detail.c
+++ b/Detail.c
@@ -303,6 +303,7 @@ int Detail(char *dev, struct context *c)
 				if (path)
 					printf("MD_DEVICE_%s_DEV=%s\n",
 					       sysdev, path);
+				free(sysdev);
 			}
 		}
 		goto out;
-- 
2.39.2

