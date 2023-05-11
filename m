Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DCBC7EE22
	for <linux-raid@archiver.kernel.org>; Thu, 11 May 2023 09:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbjEKJ5e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 May 2023 05:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbjEKJ45 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 May 2023 05:56:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25702D07B
        for <linux-raid@vger.kernel.org>; Thu, 11 May 2023 02:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683799003; x=1715335003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RJS0GeCAIh0DhOi6LyspsO3iorZnfKWXKkRCg2T8kNM=;
  b=eTJiBlsu3Kt4hjETBE4QGdqwMtFFIn9oXJpYR7PYhMWeORiPlF1SJrnS
   e3ejlQYsdpeL+fgaX5PRVbMePJsfp/T1qnsTF7VfUn4Q9m/56+BxQthYS
   toooVlkN93VH+p1m820S7TcXH2RhH18XejH0xpxgDqdD8bTqvtMetKHwF
   eTdeaCptFq8oTDMRLIde5wYDE8JoW14y8cghkpXNYylTfzL7cUEeaFDgN
   IAFbSZdMsc6ylJG5KXNAxr5lvNRHgEkSBOJoi2Qee1lKn4t+ciPIUkzcW
   QPHsy0dAeQ1QVKxbC4b811pKyPCTBzf49V3HsJUjF+9oDAPpZzE6uN9KL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334936779"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334936779"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 02:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="946073705"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="946073705"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmsmga006.fm.intel.com with ESMTP; 11 May 2023 02:54:22 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 2/2] platform-intel: limit guid length
Date:   Thu, 11 May 2023 04:55:13 +0200
Message-Id: <20230511025513.13783-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230511025513.13783-1-kinga.tanska@intel.com>
References: <20230511025513.13783-1-kinga.tanska@intel.com>
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
index eb6e1b7e..ef90c3fd 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -510,9 +510,6 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 	return get_orom_by_device_id(hba->dev_id);
 }
 
-#define GUID_STR_MAX	37  /* according to GUID format:
-			     * xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" */
-
 #define EFI_GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7) \
 ((struct efi_guid) \
 {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
diff --git a/platform-intel.h b/platform-intel.h
index 2c0f4e39..ba97fb04 100644
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
@@ -229,7 +232,7 @@ extern struct orom_entry *orom_entries;
 
 static inline char *guid_str(char *buf, struct efi_guid guid)
 {
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
+	snprintf(buf, GUID_STR_MAX, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
 		 guid.b[3], guid.b[2], guid.b[1], guid.b[0],
 		 guid.b[5], guid.b[4], guid.b[7], guid.b[6],
 		 guid.b[8], guid.b[9], guid.b[10], guid.b[11],
-- 
2.26.2

