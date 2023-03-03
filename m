Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E51C7EE2D
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjCCQWB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCCQV6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:58 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A815C10A
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:54 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F319B20532;
        Fri,  3 Mar 2023 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHysmSY16jNd7M5xVj60PNU0yvKD7xNuPUq8eJZEHeY=;
        b=GyB6CW0x57QkjrgyKFKw/r5fFMd7GBf/rFSs2BuI5VlDKKve+Usw0ThWKFgHa3wScNwW3Z
        +l2IWA9py0pqap0t7Ty6NOChl39vU1MgHNjx7jL2QMbigwmgRs155CSaepwVcMabpNBsz2
        NQR4im2PtVr/6UH01KtHIH/8KIn6Vow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHysmSY16jNd7M5xVj60PNU0yvKD7xNuPUq8eJZEHeY=;
        b=D46n/w6jPbkp0Ldf8z8dzzVEofQiaL3hATQMne+TfknGExU/Px2SVHXnmsw/+5X5Ywntfr
        ++wKqYvvv8qg3QAQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 13EFC2C141;
        Fri,  3 Mar 2023 16:21:50 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 6/6] super-ddf.c: fix memleak in get_vd_num_of_subarray()
Date:   Sat,  4 Mar 2023 00:21:35 +0800
Message-Id: <20230303162135.45831-7-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
References: <20230303162135.45831-1-colyli@suse.de>
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

