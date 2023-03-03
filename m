Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917B4C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCCIdt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjCCIdp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:33:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573B11027F
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:33:42 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0B32320386;
        Fri,  3 Mar 2023 08:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677832421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KndKLdJIWK5FsuiK84M52PIMaqJZtY5y1+nTPnb7hTc=;
        b=fNqdr9rsrjjpD9vyIaZukloHVzwapwslndMnmcmI+uOMLItlIyN781yJaer75cLS1s9AA3
        IK5qUUVx/ArXQdM8RzJAKQh+AC6Aw8myh6h4hFmOulFckAzFWMuphwXUlyTQM2pthGeUhS
        V7iDVWrVCxVZ+2DbP5DBMrCEiJdsQ6w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677832421;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KndKLdJIWK5FsuiK84M52PIMaqJZtY5y1+nTPnb7hTc=;
        b=ZZIviXzhx4kHI4rwKg4RtEOF7ONsJEg9caAMBGMHtpZqYTYeUplnjDYIvvYYIBEKEC477c
        Gw33MDV67CgeaGCw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 584EC2C141;
        Fri,  3 Mar 2023 08:33:39 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Wu Guanghao <wuguanghao3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 5/6] super-intel.c: fix memleak in find_disk_attached_hba()
Date:   Fri,  3 Mar 2023 16:33:22 +0800
Message-Id: <20230303083323.3406-6-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303083323.3406-1-colyli@suse.de>
References: <20230303083323.3406-1-colyli@suse.de>
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

