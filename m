Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90528C678D4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCCIeE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCCIdr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:33:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DED19F1B
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:33:44 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 24B0C20388;
        Fri,  3 Mar 2023 08:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHysmSY16jNd7M5xVj60PNU0yvKD7xNuPUq8eJZEHeY=;
        b=xUMqbJnXmpF+hGFK0NWpSVJ5ZVanYWf8G+ifj2ovmumRCQqVrYX3IDaRsBBGptSMAFOAEA
        ku4E5S7LjtpwVhOwfPDtedexp8NAcjlI4ssngPcz1rMln5bRbYjpt4+NbiqhqzYDHkh/NU
        1kMBQaAHqzCJmtAqdOoTje9bWjKeepk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHysmSY16jNd7M5xVj60PNU0yvKD7xNuPUq8eJZEHeY=;
        b=aefkx14ikLAh2zapGCLHSHkUbO/bT3wOCK0dAbUPtyJMsWR6YfQSg0dCTmWPccp3d2u7ut
        2g9Y7EQkQ2cPl5Cw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 738E62C141;
        Fri,  3 Mar 2023 08:33:41 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Wu Guanghao <wuguanghao3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 6/6] super-ddf.c: fix memleak in get_vd_num_of_subarray()
Date:   Fri,  3 Mar 2023 16:33:23 +0800
Message-Id: <20230303083323.3406-7-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303083323.3406-1-colyli@suse.de>
References: <20230303083323.3406-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Wu Guanghao <wuguanghao3@huawei.com>

sra = sysfs_read() should be free before return in
get_vd_num_of_subarray()

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-ddf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 309812df..b86c6acd 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1592,15 +1592,20 @@ static unsigned int get_vd_num_of_subarray(struct supertype *st)
 	sra = sysfs_read(-1, st->devnm, GET_VERSION);
 	if (!sra || sra->array.major_version != -1 ||
 	    sra->array.minor_version != -2 ||
-	    !is_subarray(sra->text_version))
+	    !is_subarray(sra->text_version)) {
+		if (sra)
+			sysfs_free(sra);
 		return DDF_NOTFOUND;
+	}
 
 	sub = strchr(sra->text_version + 1, '/');
 	if (sub != NULL)
 		vcnum = strtoul(sub + 1, &end, 10);
 	if (sub == NULL || *sub == '\0' || *end != '\0' ||
-	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries))
+	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries)) {
+		sysfs_free(sra);
 		return DDF_NOTFOUND;
+	}
 
 	return vcnum;
 }
-- 
2.39.2

