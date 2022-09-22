Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFCDC6FA8B
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 06:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIVG1p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 02:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIVG1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 02:27:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4EA0258
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 23:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663828063; x=1695364063;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IUBKHQTVBvD3/EO0aMxDxn85t63V1yIAhzbiNQnl2hA=;
  b=BdDxHyT4fPvB1dKuDc5zVmKGiAwecLsxPi8ZETO+Awy4eAYUcgVUFlmY
   QtExvtoyWtrApzxHlqdBNyzCGRCY7TJrpJJV47ul5eAGp0fUbqDJQRlqE
   vxgQQNKQ7EQu8uxm+AIgXi5YNrsScIZY10sm1y0Hh4+w7GOpnI9dv2l+p
   hYDwHas4Eyo2PY3MVcFMWgf97Hzn5nkRkEM1rfwp9ElFaEP0dk8Uo72Tq
   UgEmK2ePTOAVT5EZoaoOmlNwVIINe/PxiccSenTktfUj4iilXADkhGNjK
   sNKeMjhU04SNn6RHrz2BDvVyeSJvBsWN+DRNadkKqQCG28kBq9/A2FIrK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="298928073"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="298928073"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 23:27:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="682084327"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by fmsmga008.fm.intel.com with ESMTP; 21 Sep 2022 23:27:42 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Mdmonitor: Omit non-md devices
Date:   Thu, 22 Sep 2022 08:29:50 +0200
Message-Id: <20220922062950.9709-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Fix segfault commit [1] introduced check whether given device is
mddevice, but it happend to terminate Mdmonitor if at least one of given
devices didn't fulfill that condition. In result Mdmonitor service was
no longer started on boot (with --scan option) when config contained some
non-existent array entry.

This commit introduces ommiting non-md devices so scan option can still
be used when config is wrong and allow Mdmonitor service to run on boot.

Giving a list of devices to monitor containing non-existing or
non-md devices will result in monitoring only confirmed mddevices.

[1] https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=e702f392959d1c2ad2089e595b52235ed97b4e18

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 Monitor.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index b4e954c6..7d7dc4d2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -185,10 +185,8 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
-			if (!is_mddev(mdlist->devname)) {
-				free_statelist(statelist);
-				return 1;
-			}
+			if (!is_mddev(mdlist->devname))
+				continue;
 
 			st = xcalloc(1, sizeof *st);
 			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"),
@@ -208,10 +206,8 @@ int Monitor(struct mddev_dev *devlist,
 		for (dv = devlist; dv; dv = dv->next) {
 			struct state *st;
 
-			if (!is_mddev(dv->devname)) {
-				free_statelist(statelist);
-				return 1;
-			}
+			if (!is_mddev(dv->devname))
+				continue;
 
 			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
-- 
2.26.2

