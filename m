Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77DCC7EE2F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCCQVt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCCQVs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E42BBBA
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:47 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 01B992052F;
        Fri,  3 Mar 2023 16:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqmQPr0U5NDHGeFXAGA2tVhQ0Oe5zBXzOz62yxjpU/4=;
        b=xU2FFodT2YCNqUH3H9lJVkmoqE9FJWsML2LXkiaIaVNq0/oIlHZ9g/7PnMKp5AfTgZ5CzR
        XWSTQDb6MR8dejD15UmyrJ9wu2c1QwkuPlJ0XMTTJ8jUZqo4beAc76z6XRELeaGWy24yrN
        n8OHbK7ZnTKsf+TGDLiWRctDPAMxe9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860506;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqmQPr0U5NDHGeFXAGA2tVhQ0Oe5zBXzOz62yxjpU/4=;
        b=au962Zjpf9+e+SwVQby2KX01wmyyCP0Pd7JMWvx6g1dLLfHTSVdo9BZj0AzR5Qb9kB17CH
        VzR5Cfyi5ccgmUAw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 145B12C141;
        Fri,  3 Mar 2023 16:21:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 3/6] Detail.c: fix memleak in Detail()
Date:   Sat,  4 Mar 2023 00:21:32 +0800
Message-Id: <20230303162135.45831-4-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
References: <20230303162135.45831-1-colyli@suse.de>
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

