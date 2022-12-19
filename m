Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB1EC10F1B
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 10:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiLSKWH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 05:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiLSKWF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 05:22:05 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E582DF6
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 02:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671445324; x=1702981324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EUGSsdRkiB7qeapSnsIN0KkDMa/R+Sb5sDzxDQB2lQg=;
  b=PW3xoo8MQrXuUhu1oBfXjyGQY1ukKEdZVZukdabuBRdfLy+mb5cooEJl
   VdvP8uKWwPb/xFCJZHKMrEq66+g5V0pYkNJf9jhvF83+nFwIguFP7Drze
   FRNyZJUCHUJRDFMAtj1b+iiO+aY2fPW0vnyfbFGgwHSh5AFSRTMOdd1Do
   ymxCkQUTQTZdrX0MQ8a6cQkNhYaj6tGkfMlLiSDkfBGCr2I6pExNPPb5J
   beeRzJ6IbAECMobtY3xK2oUqdCFwqlgFD/Uifp+AC5uN8ZUgXDYpDzaKG
   11rrx7DxfW50FN9vOEYwG3vax25egCORkNc39XQ8R+DAcubkuDqF0+e4D
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="319364342"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="319364342"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 02:22:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="824805170"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="824805170"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2022 02:22:03 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH V2 1/2] Monitor: block if monitor modes are combined.
Date:   Mon, 19 Dec 2022 11:21:57 +0100
Message-Id: <20221219102158.10180-2-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221219102158.10180-1-blazej.kucman@intel.com>
References: <20221219102158.10180-1-blazej.kucman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Block monitoring start if --scan mode and MD devices list are combined.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
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

