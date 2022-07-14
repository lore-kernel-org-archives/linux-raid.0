Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CA8C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jul 2022 06:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiGNGzO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jul 2022 02:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiGNGzN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jul 2022 02:55:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D652A97D
        for <linux-raid@vger.kernel.org>; Wed, 13 Jul 2022 23:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657781712; x=1689317712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hmSSLvxVIX+QfY6uYQD1ge+EV4339bYBR/lhYq356hA=;
  b=ParkjOOpeEuaQpmuEDI41fm9YLm7YEMHDWsoAGqYbsLA8z4SYOR9Smm0
   /38wiyM6KvCWnuA7XS3WjK7sfY/LEsk/PWBpWE7wrWk4BiDtWWEsmiZBw
   S2nsuQ399ECT3p9KWI52XjageU3l7If6fDE44Cu3m2BnHAqG2mxoiMsOv
   kREFqbTxLUQzuR/gMVWXC1kC7Zv5Zek0uIG0Lv2ZhkD2rGE4WwveNUYug
   f15UzaSuGpEB/PHpEs3rSMqXwaMooMSSwcNMvbz3YOE3iAye58JWIWjhH
   QXeoHioI/iL7OZZy5nvtNLxfgOxoU7ECKS9Ot7BfOu//OMXItQ0E0Lkg0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265845872"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="265845872"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 23:55:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="570945163"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga006.jf.intel.com with ESMTP; 13 Jul 2022 23:55:10 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] Monitor: use snprintf to fill device name
Date:   Thu, 14 Jul 2022 09:02:11 +0200
Message-Id: <20220714070211.9941-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220714070211.9941-1-kinga.tanska@intel.com>
References: <20220714070211.9941-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Safe string functions are propagated in Monitor.c.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index a5b11ae2..93f36ac0 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -33,8 +33,8 @@
 #endif
 
 struct state {
-	char *devname;
-	char devnm[32];	/* to sync with mdstat info */
+	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of "/dev/md/" + device name + terminating byte*/
+	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
 	unsigned int utime;
 	int err;
 	char *spare_group;
@@ -45,9 +45,9 @@ struct state {
 	int devstate[MAX_DISKS];
 	dev_t devid[MAX_DISKS];
 	int percent;
-	char parent_devnm[32]; /* For subarray, devnm of parent.
-				* For others, ""
-				*/
+	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
+					* For others, ""
+					*/
 	struct supertype *metadata;
 	struct state *subarray;/* for a container it is a link to first subarray
 				* for a subarray it is a link to next subarray
@@ -187,15 +187,8 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 
 			st = xcalloc(1, sizeof *st);
-			if (mdlist->devname[0] == '/')
-				st->devname = xstrdup(mdlist->devname);
-			else {
-				/* length of "/dev/md/" + device name + terminating byte */
-				size_t _len = sizeof("/dev/md/") + strnlen(mdlist->devname, PATH_MAX);
-
-				st->devname = xcalloc(_len, sizeof(char));
-				snprintf(st->devname, _len, "/dev/md/%s", mdlist->devname);
-			}
+			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"),
+				 "/dev/md/%s", basename(mdlist->devname));
 			if (!is_mddev(mdlist->devname))
 				return 1;
 			st->next = statelist;
@@ -218,7 +211,7 @@ int Monitor(struct mddev_dev *devlist,
 
 			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
-			st->devname = xstrdup(dv->devname);
+			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"), "%s", dv->devname);
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -301,7 +294,6 @@ int Monitor(struct mddev_dev *devlist,
 		for (stp = &statelist; (st = *stp) != NULL; ) {
 			if (st->from_auto && st->err > 5) {
 				*stp = st->next;
-				free(st->devname);
 				free(st->spare_group);
 				free(st);
 			} else
@@ -554,7 +546,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		goto disappeared;
 
 	if (st->devnm[0] == 0)
-		strcpy(st->devnm, fd2devnm(fd));
+		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
 
 	for (mse2 = mdstat; mse2; mse2 = mse2->next)
 		if (strcmp(mse2->devnm, st->devnm) == 0) {
@@ -684,7 +676,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
 	    is_subarray(mse->metadata_version+9)) {
 		char *sl;
-		strcpy(st->parent_devnm, mse->metadata_version + 10);
+		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", mse->metadata_version + 10);
 		sl = strchr(st->parent_devnm, '/');
 		if (sl)
 			*sl = 0;
@@ -772,14 +764,13 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 				continue;
 			}
 
-			st->devname = xstrdup(name);
+			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"), "%s", name);
 			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
 			    md_get_array_info(fd, &array) < 0) {
 				/* no such array */
 				if (fd >= 0)
 					close(fd);
 				put_md_name(st->devname);
-				free(st->devname);
 				if (st->metadata) {
 					st->metadata->ss->free_super(st->metadata);
 					free(st->metadata);
@@ -791,7 +782,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			st->next = *statelist;
 			st->err = 1;
 			st->from_auto = 1;
-			strcpy(st->devnm, mse->devnm);
+			snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
 			st->percent = RESYNC_UNKNOWN;
 			st->expected_spares = -1;
 			if (mse->metadata_version &&
@@ -799,8 +790,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 				    "external:", 9) == 0 &&
 			    is_subarray(mse->metadata_version+9)) {
 				char *sl;
-				strcpy(st->parent_devnm,
-					mse->metadata_version+10);
+				snprintf(st->parent_devnm, MD_NAME_MAX,
+					 "%s", mse->metadata_version + 10);
 				sl = strchr(st->parent_devnm, '/');
 				*sl = 0;
 			} else
-- 
2.26.2

