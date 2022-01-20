Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BCFC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jan 2022 12:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241515AbiATMSq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:18:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:54204 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241784AbiATMSq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Jan 2022 07:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642681125; x=1674217125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iMxYLRdelUGK0NPCWro0fBaPuhsFv4s/N//atEEXosU=;
  b=LfSqFDEClyDm/EdOzT7WTpHKtd3AkGcdzvU+01TMUjJznIAk+fwKbnrd
   8LhqIKS3Pocap0IZCFoHPtgJ+q0mI/IKMr5sR3rOa5YflqJrty0NLw3IZ
   wrmbrxpYyed+zgfnPPPX9iencvwr5Auyms6B6B4qxNYs5AB2zPevg8nMB
   oJCtTcwwMwJn+cTpHySlyx0lVPPxpBni9OTQsKN5hd223p22jJkoRnTME
   StTTTPd6jdd+jmWj4+4RqbOEKXV4bKMlnY7/P8mn+snT3Wc6LKpfR8LCW
   VIiiqLZ8CSqmxgJ1Tj5Rn96Vz4qUSwGriV1hmW+cZ0CEKo9L61S6exjF6
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="242902486"
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="242902486"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 04:18:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="532751013"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 04:18:44 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/2] Create, Build: use default_layout()
Date:   Thu, 20 Jan 2022 13:18:32 +0100
Message-Id: <20220120121833.16055-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
References: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This code is duplicated for Build mode so make default_layout() extern
and use it. Simplify the function structure.

It introduced change for Build mode, now for raid0 RAID0_ORIG_LAYOUT
will be returned same as for Create.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Build.c  | 23 +------------------
 Create.c | 67 ++++++++++++++++++++++++++++++++++----------------------
 mdadm.h  |  1 +
 3 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/Build.c b/Build.c
index 962c2e3..8d6f6f5 100644
--- a/Build.c
+++ b/Build.c
@@ -71,28 +71,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	}
 
 	if (s->layout == UnSet)
-		switch(s->level) {
-		default: /* no layout */
-			s->layout = 0;
-			break;
-		case 10:
-			s->layout = 0x102; /* near=2, far=1 */
-			if (c->verbose > 0)
-				pr_err("layout defaults to n1\n");
-			break;
-		case 5:
-		case 6:
-			s->layout = map_name(r5layout, "default");
-			if (c->verbose > 0)
-				pr_err("layout defaults to %s\n", map_num(r5layout, s->layout));
-			break;
-		case LEVEL_FAULTY:
-			s->layout = map_name(faultylayout, "default");
-
-			if (c->verbose > 0)
-				pr_err("layout defaults to %s\n", map_num(faultylayout, s->layout));
-			break;
-		}
+		s->layout = default_layout(NULL, s->level, c->verbose);
 
 	/* We need to create the device.  It can have no name. */
 	map_lock(&map);
diff --git a/Create.c b/Create.c
index 0ff1922..9ea19de 100644
--- a/Create.c
+++ b/Create.c
@@ -39,39 +39,54 @@ static int round_size_and_verify(unsigned long long *size, int chunk)
 	return 0;
 }
 
-static int default_layout(struct supertype *st, int level, int verbose)
+/**
+ * default_layout() - Get default layout for level.
+ * @st: metadata requested, could be NULL.
+ * @level: raid level requested.
+ * @verbose: verbose level.
+ *
+ * Try to ask metadata handler first, otherwise use global defaults.
+ *
+ * Return: Layout or &UnSet, return value meaning depends of level used.
+ */
+int default_layout(struct supertype *st, int level, int verbose)
 {
 	int layout = UnSet;
+	mapping_t *layout_map = NULL;
+	char *layout_name = NULL;
 
 	if (st && st->ss->default_geometry)
 		st->ss->default_geometry(st, &level, &layout, NULL);
 
-	if (layout == UnSet)
-		switch(level) {
-		default: /* no layout */
-			layout = 0;
-			break;
-		case 0:
-			layout = RAID0_ORIG_LAYOUT;
-			break;
-		case 10:
-			layout = 0x102; /* near=2, far=1 */
-			if (verbose > 0)
-				pr_err("layout defaults to n2\n");
-			break;
-		case 5:
-		case 6:
-			layout = map_name(r5layout, "default");
-			if (verbose > 0)
-				pr_err("layout defaults to %s\n", map_num(r5layout, layout));
-			break;
-		case LEVEL_FAULTY:
-			layout = map_name(faultylayout, "default");
+	if (layout != UnSet)
+		return layout;
 
-			if (verbose > 0)
-				pr_err("layout defaults to %s\n", map_num(faultylayout, layout));
-			break;
-		}
+	switch (level) {
+	default: /* no layout */
+		layout = 0;
+		break;
+	case 0:
+		layout = RAID0_ORIG_LAYOUT;
+		break;
+	case 10:
+		layout = 0x102; /* near=2, far=1 */
+		layout_name = "n2";
+		break;
+	case 5:
+	case 6:
+		layout_map = r5layout;
+		break;
+	case LEVEL_FAULTY:
+		layout_map = faultylayout;
+		break;
+	}
+
+	if (layout_map) {
+		layout = map_name(layout_map, "default");
+		layout_name = map_num(layout_map, layout);
+	}
+	if (layout_name && verbose > 0)
+		pr_err("layout defaults to %s\n", layout_name);
 
 	return layout;
 }
diff --git a/mdadm.h b/mdadm.h
index c7268a7..6aff034 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1511,6 +1511,7 @@ extern int get_linux_version(void);
 extern int mdadm_version(char *version);
 extern unsigned long long parse_size(char *size);
 extern int parse_uuid(char *str, int uuid[4]);
+int default_layout(struct supertype *st, int level, int verbose);
 extern int is_near_layout_10(int layout);
 extern int parse_layout_10(char *layout);
 extern int parse_layout_faulty(char *layout);
-- 
2.26.2

