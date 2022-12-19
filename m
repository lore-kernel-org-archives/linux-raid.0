Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBC1C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 09:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiLSJ7Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 04:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLSJ7O (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 04:59:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4912DF4
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 01:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671443953; x=1702979953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=05DoqP1HFhHjSnqwxxTCMKbBMRuvTVIUXpzLYhZ/UPE=;
  b=Qrgij4vpDujAgGZfNCfd5URNGL5FYG9wZUfP6tGfDRn/nqKNDdYJ6Yoq
   xRplBBMEa3jVm0tgIDjGD0ER3M1KwguTizOMvgdv84EAWqBX+eBNyDkvl
   l3hg8SkhlolQvAe466zUPE25q9QlKbUnE3tYoJuJTrKTDoy8ez/HWwcoC
   x5J/z7VviMxTrUTVUfJVFTrb0QQUiPqbLOemAjmGb2RRzLhYQRv7WqT6z
   X/Qo/Qqismg6IZT9d/IfAqWYaldpVYczTOzImFeYnTxhrHsWad3ZcyW/w
   UaYETT+41DQhRvNibn/nKILvYKYwAqKk2NEJYwKAaVX1AZ8yEUHuL3oAJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="306990590"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="306990590"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 01:59:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="774860950"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="774860950"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orsmga004.jf.intel.com with ESMTP; 19 Dec 2022 01:59:12 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] Monitor: block if monitor modes are combined.
Date:   Mon, 19 Dec 2022 10:58:34 +0100
Message-Id: <20221219095835.686-2-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221219095835.686-1-blazej.kucman@intel.com>
References: <20221219095835.686-1-blazej.kucman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Block monitoring start if --scan mode and MD devices list are combined.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
Change-Id: Ic2b90662dbd297e8e2c8e88194155d65110ef517
---
 Monitor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index 7d7dc4d2..119e17d8 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -123,7 +123,7 @@ int Monitor(struct mddev_dev *devlist,
 	 *  and if we can get_disk_info and find a name
 	 *  Then we hot-remove and hot-add to the other array
 	 *
-	 * If devlist is NULL, then we can monitor everything because --scan
+	 * If devlist is NULL, then we can monitor everything if --scan
 	 * was given.  We get an initial list from config file and add anything
 	 * that appears in /proc/mdstat
 	 */
@@ -136,6 +136,11 @@ int Monitor(struct mddev_dev *devlist,
 	struct mddev_ident *mdlist;
 	int delay_for_event = c->delay;
 
+	if (devlist && c->scan) {
+		pr_err("Devices list and --scan option cannot be combined - not monitoring.\n");
+		return 1;
+	}
+
 	if (!mailaddr)
 		mailaddr = conf_get_mailaddr();
 
-- 
2.35.3

