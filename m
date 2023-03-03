Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38FCC64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCCQVv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjCCQVt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:49 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E78213D79
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:44 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A049720530;
        Fri,  3 Mar 2023 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2I+Who3dVeWNwZoM5OltjMZpO4CJYuMNV8koUEN3Chs=;
        b=lGA0wVo+1+KPrHhrnz8O15WLQeftPGn+Qz+0+w1O1Xf3Tz2QnHQnKqGwwbk9knlMD4YfHQ
        lUneVZCWnRcittmxrxPh47Z8ubtMfs7VXTw9IYDKdFxVkORkfUrUKqD4BVMxiEX8rPjSRd
        ENo89uWJGxCMtHryDxCgmp8+Co43OP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860503;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2I+Who3dVeWNwZoM5OltjMZpO4CJYuMNV8koUEN3Chs=;
        b=4uURTNO5XWaSDNvXkrx5W8rPDattfcBN8pD+kWmJbVvPlxPZgZazzyl9tKXzuK8zYJLXpd
        /S58XQs6FW7wdPAw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id AECFA2C141;
        Fri,  3 Mar 2023 16:21:41 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 2/6] util.c: fix memleak in parse_layout_faulty()
Date:   Sat,  4 Mar 2023 00:21:31 +0800
Message-Id: <20230303162135.45831-3-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
References: <20230303162135.45831-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Wu Guanghao <wuguanghao3@huawei.com>

char *m is allocated by xstrdup but not free() before return, will cause
a memory leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/util.c b/util.c
index b0b7aec4..9f1e1f7c 100644
--- a/util.c
+++ b/util.c
@@ -432,6 +432,8 @@ int parse_layout_faulty(char *layout)
 	m = xstrdup(layout);
 	m[ln] = 0;
 	mode = map_name(faultylayout, m);
+	free(m);
+
 	if (mode == UnSet)
 		return -1;
 
-- 
2.39.2

