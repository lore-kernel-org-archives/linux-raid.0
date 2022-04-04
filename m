Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8687BC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 13:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376443AbiDDN7O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 09:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbiDDN7M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 09:59:12 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41C3E5F5
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 06:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649080636; x=1680616636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/s5c7P74VoMNNJ5KWQIA2V15n2vy9uKwouU4MFSB7tg=;
  b=XKyqe6siL739/NeCLdT5t3SHyPtzNqgNwjeoF8Z0CpyQkTB6zCSACM7+
   l1EctuF1tJYKLaR0ND1Qaw+xDigbPtSCIEO6MBZlWAwfCGbCHZ6iatgBe
   hVrFJ7ctZo24kmCs1m8sDWI10RrVRJ4kPkwHPpZGfXl8DA9BS0rdn9qDM
   f/yETvVCss5h+3P6g7R1OZR1D9K1lx/B7UN4imOjperObX7LrWKDcyyEX
   pVdfz/F8XPhJ/FWEiOTyhy6a4A2F24pL1QlwYzwhqWBcTF0FOymOP4UMz
   35Zk09W6f7F6usyA9FiBffnohmYCHaPG4QvTxP/7+cKvzxoZQ7YMfVTnE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="321213574"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="321213574"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 06:57:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="587577499"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga001.jf.intel.com with ESMTP; 04 Apr 2022 06:57:15 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 1/2] Assemble: check if device is container before scheduling force-clean update
Date:   Mon,  4 Apr 2022 16:01:14 +0200
Message-Id: <20220404140115.16973-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220404140115.16973-1-kinga.tanska@intel.com>
References: <20220404140115.16973-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When assemble is used with --force flag and array is not clean then
"force-clean" update is scheduled. Containers are considered as not
clean because this field is not set for them. To exclude them from
meaningless update (it is ignored quietly) check if the device
is a container first.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 704b8293..f31372db 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1813,10 +1813,9 @@ try_again:
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
2.26.2

