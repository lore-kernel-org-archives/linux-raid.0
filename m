Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D72C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCCQWA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjCCQVx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B2014480
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:51 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A0A5A22C01;
        Fri,  3 Mar 2023 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KndKLdJIWK5FsuiK84M52PIMaqJZtY5y1+nTPnb7hTc=;
        b=JC8WUKJ6XtxmpCWeq2mk4yl/UmxH7ZzPdNsfkNFWnlbGHv16qUmHeH+cL2ZPMWIlfYM/Sh
        PjN5IL+stfL4+hP0BPBdLUAGEfeiD1z/vb2rQRNDuBm/l6GmAANM41AqXUl1gm2phal4VR
        jXZI3KdqUnMuJdHQNgbP7jOWlydkLzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860510;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KndKLdJIWK5FsuiK84M52PIMaqJZtY5y1+nTPnb7hTc=;
        b=FiapPISoeXS2xm2BxnIzSMLMsHtWm/vz/UkfXdNYkXUDyTerlHtHGJEMDaWb7yBrbHvYFk
        LRs833Sta9UG6QAQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id B4AB32C141;
        Fri,  3 Mar 2023 16:21:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 5/6] super-intel.c: fix memleak in find_disk_attached_hba()
Date:   Sat,  4 Mar 2023 00:21:34 +0800
Message-Id: <20230303162135.45831-6-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
References: <20230303162135.45831-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Wu Guanghao <wuguanghao3@huawei.com>

If disk_path = diskfd_to_devpath(), we need free(disk_path) before
return, otherwise there will be a memory leak

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4a3da847..e155a8ae 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -713,12 +713,12 @@ static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)
 
 	for (elem = list; elem; elem = elem->next)
 		if (path_attached_to_hba(disk_path, elem->path))
-			return elem;
+			break;
 
 	if (disk_path != devname)
 		free(disk_path);
 
-	return NULL;
+	return elem;
 }
 
 static int find_intel_hba_capability(int fd, struct intel_super *super,
-- 
2.39.2

