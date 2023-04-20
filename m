Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E814DC77B78
	for <linux-raid@archiver.kernel.org>; Fri, 21 Apr 2023 06:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjDUGrs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjDUGrs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Apr 2023 02:47:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24261100
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 23:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682059667; x=1713595667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OWTa7wcdGwyqVqKdOPlIdsoLB8T7e0LaooX/ELGsNP0=;
  b=BvKoeN5Fy4p4yUdRMPp35bLBGETGMp3eZ5h/HhQ02rvtAsAF4LLWJomP
   Tr0ipzWNMKfKPLYBYk/eZYJhifHdZhBvAB72wGs3jqD0hFFTA2+Kf216K
   QrYrE1sltrGjbJOZfQecC2EHq6qdi6xGpFlFQqiA9xfVRpQNipteK7WQw
   ULPNjyVfdE47DSrO4EXC1rvOS70L8tLI4qHFPlIov5FWWTCHrh/tp+eyy
   Zv0/3g2eeurTPfUfhV81LqlFlOEDl9LnKguJCHxYp7V2KzKjtoan0Djai
   OJKVz4dLaDfTcRfEfNl4W6dXQNbyMfqBkdr04RBmyuzAAd/i2o/c5AHyj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="330128197"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="330128197"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 23:47:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="685641226"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="685641226"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2023 23:47:45 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] platform-intel: limit guid length
Date:   Fri, 21 Apr 2023 01:46:58 +0200
Message-Id: <20230420234658.367-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230420234658.367-1-kinga.tanska@intel.com>
References: <20230420234658.367-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Moving GUID_STR_MAX to header to use it as
a length limitation for snprintf function.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 platform-intel.c | 3 ---
 platform-intel.h | 5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 22ebb2b1..e63a112a 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -496,9 +496,6 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 	return get_orom_by_device_id(hba->dev_id);
 }
 
-#define GUID_STR_MAX	37  /* according to GUID format:
-			     * xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" */
-
 #define EFI_GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7) \
 ((struct efi_guid) \
 {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
diff --git a/platform-intel.h b/platform-intel.h
index 6238d23f..3d15411b 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -19,6 +19,9 @@
 #include <asm/types.h>
 #include <strings.h>
 
+/* according to GUID format: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" */
+#define GUID_STR_MAX	37
+
 /* The IMSM Capability (IMSM AHCI and ISCU OROM/EFI variable) Version Table definition */
 struct imsm_orom {
 	__u8 signature[4];
@@ -228,7 +231,7 @@ extern struct orom_entry *orom_entries;
 
 static inline char *guid_str(char *buf, struct efi_guid guid)
 {
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
+	snprintf(buf, GUID_STR_MAX, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
 		 guid.b[3], guid.b[2], guid.b[1], guid.b[0],
 		 guid.b[5], guid.b[4], guid.b[7], guid.b[6],
 		 guid.b[8], guid.b[9], guid.b[10], guid.b[11],
-- 
2.26.2

