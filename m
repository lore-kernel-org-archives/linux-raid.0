Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D811C7EE2F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCCIdg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCCIde (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:33:34 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C1E2D4C
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:33:33 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6392E2299D;
        Fri,  3 Mar 2023 08:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXwSmFG6VXjVI6JJAGflb1UwkSfDosHgaPU3ut0vnks=;
        b=ZXMuo2UKKTyb39GpV7++hhW7+I7THTrQpastlOvYSPkQfzwbhsxhnib1B7pHtP+mkFEi5d
        Oqj7y7gII69SZ3SWRqK76Y2KyU49SKK8iduQy+hhmr+AA25/v8gYphiv1A6SCvvaoTmy+j
        /DV04qOwverKPfdRPQUR1uufP/dNr98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXwSmFG6VXjVI6JJAGflb1UwkSfDosHgaPU3ut0vnks=;
        b=5jmY76BWxl4aQmgw+BTc/dBdNvsKr3Qnixd/JyBAsigQoVN9/yjveB/d+WW9M+zR/xFH6N
        X3Bm5CXKb1AJTxCg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 3025D2C141;
        Fri,  3 Mar 2023 08:33:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 1/6] util.c: code cleanup for parse_layout_faulty()
Date:   Fri,  3 Mar 2023 16:33:18 +0800
Message-Id: <20230303083323.3406-2-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303083323.3406-1-colyli@suse.de>
References: <20230303083323.3406-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Resort the code lines in parse_layout_faulty() to make it more
comfortable, no logic change.

Signed-off-by: Coly Li <colyli@suse.de>
---
 util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/util.c b/util.c
index 7fc881bf..b0b7aec4 100644
--- a/util.c
+++ b/util.c
@@ -421,12 +421,15 @@ int parse_layout_10(char *layout)
 
 int parse_layout_faulty(char *layout)
 {
+	int ln, mode;
+	char *m;
+
 	if (!layout)
 		return -1;
+
 	/* Parse the layout string for 'faulty' */
-	int ln = strcspn(layout, "0123456789");
-	char *m = xstrdup(layout);
-	int mode;
+	ln = strcspn(layout, "0123456789");
+	m = xstrdup(layout);
 	m[ln] = 0;
 	mode = map_name(faultylayout, m);
 	if (mode == UnSet)
-- 
2.39.2

