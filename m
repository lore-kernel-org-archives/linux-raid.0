Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF997C43334
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jul 2022 06:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiGNGzN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jul 2022 02:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiGNGzL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jul 2022 02:55:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400592AC5D
        for <linux-raid@vger.kernel.org>; Wed, 13 Jul 2022 23:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657781710; x=1689317710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ox4XoSaaV/vIdXgIPa8J31cS8c4q4bOSIt2uYemacJo=;
  b=Z65rgkXdUK5CSzKjp13NC6I8cC+IxWn07kLUWHMblwnnc3hENIlbCAKG
   RYR5kFdzDqIgfj82IDxVwpg4k+dhlcTD8NzOfEPU/ehQmhSdGy3YcBAi8
   lHt5oHAfoknmB3o5eSNaEmg/kyb5kQRFe0cjnfjVN9vvxuHUwrSmJSakD
   iTxjuVd/2KRurKhdQeibV7DXlqxqMDtTeU8BpvtDeHFeAmIMhrFsu/etD
   EnUoL8Y3urY4i9irG2bwW3sZJKAexemhnljqejRbNcUX3O4R9U+dqjFl3
   iFuI50/2ufoLP7Cb5K+bp/V2FH7btE93igJivnsdwvoJlh2FmBsXNijhz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265845860"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="265845860"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 23:55:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="570945156"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga006.jf.intel.com with ESMTP; 13 Jul 2022 23:55:09 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] Monitor: use devname as char array instead of pointer
Date:   Thu, 14 Jul 2022 09:02:10 +0200
Message-Id: <20220714070211.9941-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220714070211.9941-1-kinga.tanska@intel.com>
References: <20220714070211.9941-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Device name wasn't filled properly due to incorrect use of strcpy.
Strcpy was used twice. Firstly to fill devname with "/dev/md/"
and then to add chosen name. First strcpy result was overwritten by
second one (as a result <device_name> instead of "/dev/md/<device_name>"
was assigned). This commit changes this implementation to use snprintf
and devname with fixed size.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 6ca1ebe5..a5b11ae2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -190,9 +190,11 @@ int Monitor(struct mddev_dev *devlist,
 			if (mdlist->devname[0] == '/')
 				st->devname = xstrdup(mdlist->devname);
 			else {
-				st->devname = xmalloc(8+strlen(mdlist->devname)+1);
-				strcpy(strcpy(st->devname, "/dev/md/"),
-				       mdlist->devname);
+				/* length of "/dev/md/" + device name + terminating byte */
+				size_t _len = sizeof("/dev/md/") + strnlen(mdlist->devname, PATH_MAX);
+
+				st->devname = xcalloc(_len, sizeof(char));
+				snprintf(st->devname, _len, "/dev/md/%s", mdlist->devname);
 			}
 			if (!is_mddev(mdlist->devname))
 				return 1;
-- 
2.26.2

