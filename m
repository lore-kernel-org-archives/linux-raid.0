Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC2CECAAA1
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 13:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiIINvv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 09:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiIINva (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 09:51:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68438A221B
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 06:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662731475; x=1694267475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I5I4wNq39rWKPSbxGewfd7As4Vy9kzMHehR4CLK3QvY=;
  b=bPhIbSwL13hqCaJBW2gitHtkONREVO5OmH4Grga2IEXCVTWZbrh7bWDQ
   i4Qty9DQb3U1ZQcm4hbJy59PGS53cv6E6LNm4ziiCCJ/crXDE2bKeYCNk
   GSgxxwZ9XUeEfvuqB7U4TE25hyPwH0ZaCtq5tYgeS1zMilG6eCKttuqJe
   WsFllCyJEu/IAB0mrlsYt3mcTS3ykyi6NADLXqHUdrnPB1SdrbsNwH31m
   IZxmb/D3B5aHns9/A7rOpmFRKxE646OJRNHocL7KDm5UpJd3s2VvNu5Th
   GVbusD4geAZtfw2Ta3EimpBRqv6mLMyVbS1XZasWkX3J9PRZdnF3hLfDv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298815266"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="298815266"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:50:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="592612693"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:50:51 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     felix.lechner@lease-up.com, linux-raid@vger.kernel.org
Subject: [PATCH v2 2/2] ReadMe: fix command-line help
Date:   Fri,  9 Sep 2022 15:50:34 +0200
Message-Id: <20220909135034.14397-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
References: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Make command-line help consistent with manual page.
Copied from Debian.

Cc: Felix Lechner <felix.lechner@lease-up.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 ReadMe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ReadMe.c b/ReadMe.c
index 7f94847..50a5e36 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -477,7 +477,7 @@ char Help_assemble[] =
 ;
 
 char Help_manage[] =
-"Usage: mdadm arraydevice options component devices...\n"
+"Usage: mdadm [mode] arraydevice [options] <component devices...>\n"
 "\n"
 "This usage is for managing the component devices within an array.\n"
 "The --manage option is not needed and is assumed if the first argument\n"
-- 
2.26.2

