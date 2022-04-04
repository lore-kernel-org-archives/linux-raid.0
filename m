Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B00C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 12:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346762AbiDDMlV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345904AbiDDMlU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 08:41:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCAF167F7
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 05:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649075964; x=1680611964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PsLUrbqrDVYQGJtVj9RMKcbkPUxy7PWFJwYRsIK3yK8=;
  b=KH6GcGF6toWdLWATgcUSmYEf4OAE2MJ1nsWdppe8oEXY4EF94vULqdph
   tr7Wz8sjrG1gCcDGfnlzJJ2wgaGphkwGcxQIXV0qmarblmkqneZhzYux+
   dx8koL7Io9n+3VKFtDPQu87FKSiTu+dpk+WyihYpDJzMiVZ8l0QSATVfz
   7ykVQyWNqZtfHgcdpsg5nMWEZ5yhipX8tgItGXtIF7tVFtbJRApyHwfE2
   6gFRdva2Mg7sTo6+5XpMygdR9MkhE/IgLL7sGe4huoIU1e0ppetIq7uqS
   KwDKwjKrfJNnYIB4fWcWB4IrNENPdVanNx/CtjBNei09aiFA7LFXSbHAX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="241091298"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="241091298"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 05:39:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="569365373"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 04 Apr 2022 05:39:23 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] Mdmonitor: Improve logging method
Date:   Mon,  4 Apr 2022 14:43:16 +0200
Message-Id: <20220404124316.12880-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220404124316.12880-1-kinga.tanska@intel.com>
References: <20220404124316.12880-1-kinga.tanska@intel.com>
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

