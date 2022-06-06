Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8796AC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 10:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiFFK0Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiFFK0W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 06:26:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B22A438
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 03:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654511181; x=1686047181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jy1j/4CRFo9I8aP3s/xwA8/XhmTZSAJYF+pF3c1agb0=;
  b=nFQo96eeqofDanwnEMX72R9ZPn9lUumeL+E40n0OjReE/kOVRmbWHN9O
   Miu3Th5fAuh3Pys32p+Al2aWiwfmxddJkLCv4aTtgPIygxQ03+TvAh9xY
   9NGs+m4z9oDtHRvDbKMd0ng0mSfFfDsob6FqYTtaeymsPuqWvfUYHEt0i
   bCbzzvZz5wR5m+5aDMD2Qt1sZd57GbeeNt948M2q62AR+2mYLdV69cqmX
   uarh+PzvPlvKA/ZqXu+SBdlKCXzHNxESkxL6M0yABiU/VT7G9gIjvlTGH
   KVnYPSwVYfI+dtdCvZkAmKdvdFgJc9mB8dLJ3UDHiHUu2VIqwjc7KZS0p
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276595278"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276595278"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682193188"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 03:26:20 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v4 1/2] Mdmonitor: Fix segfault
Date:   Mon,  6 Jun 2022 12:32:12 +0200
Message-Id: <20220606103213.12753-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220606103213.12753-1-kinga.tanska@intel.com>
References: <20220606103213.12753-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mdadm with "--monitor" parameter requires md device
as an argument to be monitored. If given argument is
not a md device, error shall be returned. Previously
it was not checked and invalid argument caused
segmentation fault. This commit adds checking
that devices passed to mdmonitor are md devices.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 10 +++++++++-
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index f5412299..3d0c147a 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -183,6 +183,7 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
+
 			st = xcalloc(1, sizeof *st);
 			if (mdlist->devname[0] == '/')
 				st->devname = xstrdup(mdlist->devname);
@@ -191,6 +192,8 @@ int Monitor(struct mddev_dev *devlist,
 				strcpy(strcpy(st->devname, "/dev/md/"),
 				       mdlist->devname);
 			}
+			if (!is_mddev(mdlist->devname))
+				return 1;
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -204,7 +207,12 @@ int Monitor(struct mddev_dev *devlist,
 		struct mddev_dev *dv;
 
 		for (dv = devlist; dv; dv = dv->next) {
-			struct state *st = xcalloc(1, sizeof *st);
+			struct state *st;
+
+			if (!is_mddev(dv->devname))
+				return 1;
+
+			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
 			st->devname = xstrdup(dv->devname);
 			st->next = statelist;
diff --git a/mdadm.h b/mdadm.h
index 8f8841d8..03151c34 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1607,6 +1607,7 @@ extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
 #define	FOREIGN	2
 #define	METADATA 3
 extern int open_mddev(char *dev, int report_errors);
+extern int is_mddev(char *dev);
 extern int open_container(int fd);
 extern int metadata_container_matches(char *metadata, char *devnm);
 extern int metadata_subdev_matches(char *metadata, char *devnm);
diff --git a/mdopen.c b/mdopen.c
index 245be537..d18c9319 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -475,6 +475,23 @@ int open_mddev(char *dev, int report_errors)
 	return mdfd;
 }
 
+/**
+ * is_mddev() - check that file name passed is an md device.
+ * @dev: file name that has to be checked.
+ * Return: 1 if file passed is an md device, 0 if not.
+ */
+int is_mddev(char *dev)
+{
+	int fd = open_mddev(dev, 1);
+
+	if (fd >= 0) {
+		close(fd);
+		return 1;
+	}
+
+	return 0;
+}
+
 char *find_free_devnm(int use_partitions)
 {
 	static char devnm[32];
-- 
2.26.2

