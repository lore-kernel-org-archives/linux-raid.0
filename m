Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27601C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCCQVs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCCQVp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8769014235
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:42 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 46C1A22CE6;
        Fri,  3 Mar 2023 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=54SgTPAd3VoihteNQuzvqd9msT4mLQmq9AcwcnzXCcI=;
        b=aKvSXppf3lbnd6TDiGFSwoq0G73xh5+Bdys6POmncORdTdHbH1MvNqO6y50sR8DeW9XQ4U
        chJkdDJMevlpKr1YS2Ww0Tpgy0CMO6c29CeIj7jkms5ZdWbANQ/DMjJMG6bvJgAh1AlkNa
        YxAlYbA7G9x+SQ8c572L9bXxRYwC8GE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860501;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=54SgTPAd3VoihteNQuzvqd9msT4mLQmq9AcwcnzXCcI=;
        b=OgVXK2A63yOBSIfw+MIi4RCTe8Wq13XGwHisOsbDBurbLKC4vXOG3doAZp4H+GKA8VreKK
        Tg2oFDwjzuKwkhBg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 949282C141;
        Fri,  3 Mar 2023 16:21:39 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Coly Li <colyli@suse.de>
Subject: [PATCH v2 1/6] util.c: reorder code lines in parse_layout_faulty()
Date:   Sat,  4 Mar 2023 00:21:30 +0800
Message-Id: <20230303162135.45831-2-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
References: <20230303162135.45831-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Resort the code lines in parse_layout_faulty() to make it more
comfortable, no logic change.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
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

