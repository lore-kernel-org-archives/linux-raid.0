Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A08EC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiG1MWh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238350AbiG1MWR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6770715828
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1D0D81FEBA;
        Thu, 28 Jul 2022 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKSxtq5OgVOCa9TUoMI3ZUEiGFpQtf3X/mLmmqKgk8A=;
        b=sZJ0xQMtg594iFUCQuZ1y6UScGXsVdpa7lB1APsHA7uA+NwVFDYW8CRdw43r+eWXcIlBRa
        8LnVKv3axcFZp3Hj7HLFrqmXDPi4Qr43N3BKmRFfgCsKQjHNdgtSo/A3mql23k1Z94g4W7
        nXuA9ngu2hv1t5B7x+pKYJ66WhWyLlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010935;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKSxtq5OgVOCa9TUoMI3ZUEiGFpQtf3X/mLmmqKgk8A=;
        b=qaRw4oAgN0zrKuSPw0brsgrhgZ/pMpW9LnuR9XjgJzidkuW/ffZCvW8IM86s/MzGiCzbXK
        71ko9fqQUVYhbtBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id DAB192C141;
        Thu, 28 Jul 2022 12:22:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Kinga Tanska <kinga.tanska@intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 17/23] Assemble: check if device is container before scheduling force-clean update
Date:   Thu, 28 Jul 2022 20:20:55 +0800
Message-Id: <20220728122101.28744-18-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Kinga Tanska <kinga.tanska@intel.com>

When assemble is used with --force flag and array is not clean then
"force-clean" update is scheduled. Containers are considered as not
clean because this field is not set for them. To exclude them from
meaningless update (it is ignored quietly) check if the device
is a container first.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Assemble.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 6df6bfbc..1856b916 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1809,10 +1809,9 @@ try_again:
 		}
 #endif
 	}
-	if (c->force && !clean &&
+	if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
 	    !enough(content->array.level, content->array.raid_disks,
-		    content->array.layout, clean,
-		    avail)) {
+		    content->array.layout, clean, avail)) {
 		change += st->ss->update_super(st, content, "force-array",
 					       devices[chosen_drive].devname, c->verbose,
 					       0, NULL);
-- 
2.35.3

