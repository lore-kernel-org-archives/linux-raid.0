Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC40C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 12:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346648AbiDDMm5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347378AbiDDMmz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 08:42:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECBE2E689
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 05:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649076059; x=1680612059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6BPFWPkpg3nktGwZ2G0wS6rWo0xej4WmdtCuusxAUB0=;
  b=BOYIdj/anw6aWigC0TTlmg+INO0GxawcKPnOm/6MmXQrOtVRs/HGswy/
   njB9/842GQG6EblepbAChX/s6iPQ/buLCS63yyxokbjAoMzTAkGxF4Lg8
   KHOdlkCkgfA3W3vAEWsimUC0WQKee1wXYmWuOHcioWdSPMP9ZwIY1erEL
   if2ChPUkqu1t7heP1sMyYuz8v3aFiEP3OpqCLg5pV7UWG0I+jRxrCH+H/
   /wltL7atS4xviASXTlLjfKMqCYTcBnusKHaGlL4NSS16Y+WGNcXd//e0a
   gqFZKYw9vqs0JA8BRS5FxZZ1EX71cmzdWjJDNdtqA8B9sBghC+EdRYpdW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="260492375"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260492375"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 05:40:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="569365693"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 04 Apr 2022 05:40:58 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] util: replace ioctl use with function
Date:   Mon,  4 Apr 2022 14:45:01 +0200
Message-Id: <20220404124501.13218-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Replace using of ioctl calling to get md array info with
special function prepared to it.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util.c b/util.c
index cdf1da24..003b2f86 100644
--- a/util.c
+++ b/util.c
@@ -268,7 +268,7 @@ int md_array_active(int fd)
 		 * GET_ARRAY_INFO doesn't provide access to the proper state
 		 * information, so fallback to a basic check for raid_disks != 0
 		 */
-		ret = ioctl(fd, GET_ARRAY_INFO, &array);
+		ret = md_get_array_info(fd, &array);
 	}
 
 	return !ret;
-- 
2.26.2

