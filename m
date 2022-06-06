Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32735C43334
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 10:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiFFK0Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiFFK0Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 06:26:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E60533899
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 03:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654511183; x=1686047183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PsLUrbqrDVYQGJtVj9RMKcbkPUxy7PWFJwYRsIK3yK8=;
  b=f91OCxYXgn9po+wLidOxH7sTUcJVFjUP0lWQ+REyoVCRmB3e5tAnj81d
   5AX6HSid7UcFbqubkiBa5FmL/GLFweVjna4J+XyEeg7sa52FoVvhBCFju
   OdQcJnJkMIoBPMopICnElGX/yJ+my2VUph92CwmMSroJ9TRSFM5kpTbqB
   uBobpN1MJ/s/5He20953Gs86EAELi0dMn0/eFBH0AtI7x+hEIoJEKhUrE
   hLLlJ+E082SZPyJx3vR3OvY8Fkd+ItrEkC39/VftaEbf79Aydl3C2TxcK
   UNyOzSv80qofwSpMEZo5zG7I+ABdy24H/MIIiUrfUvxV5an2dSll+HUwb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276595289"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276595289"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682193230"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 03:26:22 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v4 2/2] Mdmonitor: Improve logging method
Date:   Mon,  6 Jun 2022 12:32:13 +0200
Message-Id: <20220606103213.12753-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220606103213.12753-1-kinga.tanska@intel.com>
References: <20220606103213.12753-1-kinga.tanska@intel.com>
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

