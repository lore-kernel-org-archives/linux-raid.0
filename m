Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AADC4167D
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 12:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiDEMzF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384314AbiDEM1U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 08:27:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D54FABDA
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 04:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649158623; x=1680694623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PsLUrbqrDVYQGJtVj9RMKcbkPUxy7PWFJwYRsIK3yK8=;
  b=kjoHuuMKPcjE7N+XknStl4HPmL8JverZdRxX0hfOzYix3hzUMt88ddx+
   yx/hunKFQwY0Vr4X34TcSNw7nPfK7ObktbTZ+GYLLLlo9B1qi3DimJWbl
   hI5mQLiwxQ33W4T02W0iVy7g3qyDn3ry1/klf8bByQjBV/HiWWLG5+eGC
   7HTnkYru4k/LNckXpIpwbLWUypfIvVRuQbS2/NAU+iuts1+J3UHEzt8fr
   0C+wG4FbSuPBniERvT6cVUaWLQbiCABZvJ8lr7Jj2xu5xRXQcglbtfH/7
   vnKrXOBH49/wzw/BzxFeozAhf/j2fSfUb6goGcLjm6vqr0zSuqpZ+BJVq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241313842"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241313842"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:37:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="569845824"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2022 04:37:02 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v2 2/2] Mdmonitor: Improve logging method
Date:   Tue,  5 Apr 2022 13:40:57 +0200
Message-Id: <20220405114057.27080-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220405114057.27080-1-kinga.tanska@intel.com>
References: <20220405114057.27080-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Change logging, and as a result, mdmonitor in verbose
mode will report its configuration.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
---
 Monitor.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 0b24b656..bd417d04 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -137,24 +137,27 @@ int Monitor(struct mddev_dev *devlist,
 	struct mddev_ident *mdlist;
 	int delay_for_event = c->delay;
 
-	if (!mailaddr) {
+	if (!mailaddr)
 		mailaddr = conf_get_mailaddr();
-		if (mailaddr && ! c->scan)
-			pr_err("Monitor using email address \"%s\" from config file\n",
-			       mailaddr);
-	}
-	mailfrom = conf_get_mailfrom();
 
-	if (!alert_cmd) {
+	if (!alert_cmd)
 		alert_cmd = conf_get_program();
-		if (alert_cmd && !c->scan)
-			pr_err("Monitor using program \"%s\" from config file\n",
-			       alert_cmd);
-	}
+
+	mailfrom = conf_get_mailfrom();
+
 	if (c->scan && !mailaddr && !alert_cmd && !dosyslog) {
 		pr_err("No mail address or alert command - not monitoring.\n");
 		return 1;
 	}
+
+	if (c->verbose) {
+		pr_err("Monitor is started with delay %ds\n", c->delay);
+		if (mailaddr)
+			pr_err("Monitor using email address %s\n", mailaddr);
+		if (alert_cmd)
+			pr_err("Monitor using program %s\n", alert_cmd);
+	}
+
 	info.alert_cmd = alert_cmd;
 	info.mailaddr = mailaddr;
 	info.mailfrom = mailfrom;
-- 
2.26.2

