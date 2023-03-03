Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B80CC64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCCIdm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCCIdh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:33:37 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2407014EAF
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:33:36 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AFAC22299C;
        Fri,  3 Mar 2023 08:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2I+Who3dVeWNwZoM5OltjMZpO4CJYuMNV8koUEN3Chs=;
        b=boFt2UQKm7ihvSXktkimUcr19w0sfJDIoas74OAjeZuUVvOjWIW+LUbcKE11cUQPCIdOJI
        Ef0pJROpQ2nKeOl36hMQtdTfVzysoftzWXAdqqZFeg+m5cTw6JGhVxPX4fNxyczExTQruz
        mmmEZ8mUnmB/ZgC+CmjG++BcPA9iqxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832414;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2I+Who3dVeWNwZoM5OltjMZpO4CJYuMNV8koUEN3Chs=;
        b=a5Ye5vLtMXhr/eIXsj2JOhD2YR51FnS7JGOjomeTLTTH8UpFVbjMyFI3BSkzbB19Bo5421
        2rSFJgEVI8m+emDg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id CC5272C141;
        Fri,  3 Mar 2023 08:33:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Wu Guanghao <wuguanghao3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/6] util.c: fix memleak in parse_layout_faulty()
Date:   Fri,  3 Mar 2023 16:33:19 +0800
Message-Id: <20230303083323.3406-3-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303083323.3406-1-colyli@suse.de>
References: <20230303083323.3406-1-colyli@suse.de>
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

