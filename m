Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1DEC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 14:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242484AbiFTOli (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347215AbiFTOlV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 10:41:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A38A1ADB5
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655733655; x=1687269655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SFW97LmQIwtKQcceP1AKdTUDbE6nxmmbhEy+oSMibBQ=;
  b=Pyjk3LrM9jrg+p5RoKbC1ANj9RmXlDK/jZ+8D8pBjX42iIxmp77G2yS2
   CXnO9fA0zOkT15jB82mzsCW5V9plUIMNDHR5tj1WPvrehjYEWFOFWWl9Q
   NFOjB74gQuH7YPJGnAp32a7+hGRXI6OO0kO0wqQCGOxjp42BF0LNdgeNE
   Jt0ld59Kbs3/KVegtBEMTQfkrv30aHGkOvKIQO9mQfYjz0lAFxV2IzqA6
   7R/Xla2hV77c1XunZfd4rYErYcDR+9NK2JQAtL/UqbQ11XIaUc5sDUgIY
   mssnN7i0KhZSwatwPnj0AHdC9auix7XXXseIHRAGla5grMnhhYfuK6kfX
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343893151"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343893151"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:00:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="714634573"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga004.jf.intel.com with ESMTP; 20 Jun 2022 07:00:53 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v3] Monitor: use devname as char array instead of pointer
Date:   Mon, 20 Jun 2022 16:06:59 +0200
Message-Id: <20220620140659.20822-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
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
and devname with fixed size. Also safer string functions are propagated.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 6ca1ebe5..04112791 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -33,8 +33,8 @@
 #endif
 
 struct state {
-	char *devname;
-	char devnm[32];	/* to sync with mdstat info */
+	char devname[MD_NAME_MAX + 8];
+	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
 	unsigned int utime;
 	int err;
 	char *spare_group;
@@ -45,7 +45,7 @@ struct state {
 	int devstate[MAX_DISKS];
 	dev_t devid[MAX_DISKS];
 	int percent;
-	char parent_devnm[32]; /* For subarray, devnm of parent.
+	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
 				* For others, ""
 				*/
 	struct supertype *metadata;
@@ -187,13 +187,7 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 
 			st = xcalloc(1, sizeof *st);
-			if (mdlist->devname[0] == '/')
-				st->devname = xstrdup(mdlist->devname);
-			else {
-				st->devname = xmalloc(8+strlen(mdlist->devname)+1);
-				strcpy(strcpy(st->devname, "/dev/md/"),
-				       mdlist->devname);
-			}
+			snprintf(st->devname, MD_NAME_MAX + 8, "/dev/md/%s", basename(mdlist->devname));
 			if (!is_mddev(mdlist->devname))
 				return 1;
 			st->next = statelist;
@@ -216,7 +210,7 @@ int Monitor(struct mddev_dev *devlist,
 
 			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
-			st->devname = xstrdup(dv->devname);
+			snprintf(st->devname, MD_NAME_MAX + 8, "%s", dv->devname);
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -299,7 +293,6 @@ int Monitor(struct mddev_dev *devlist,
 		for (stp = &statelist; (st = *stp) != NULL; ) {
 			if (st->from_auto && st->err > 5) {
 				*stp = st->next;
-				free(st->devname);
 				free(st->spare_group);
 				free(st);
 			} else
@@ -552,7 +545,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		goto disappeared;
 
 	if (st->devnm[0] == 0)
-		strcpy(st->devnm, fd2devnm(fd));
+		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
 
 	for (mse2 = mdstat; mse2; mse2 = mse2->next)
 		if (strcmp(mse2->devnm, st->devnm) == 0) {
@@ -682,7 +675,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
 	    is_subarray(mse->metadata_version+9)) {
 		char *sl;
-		strcpy(st->parent_devnm, mse->metadata_version + 10);
+		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", mse->metadata_version + 10);
 		sl = strchr(st->parent_devnm, '/');
 		if (sl)
 			*sl = 0;
@@ -770,14 +763,13 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 				continue;
 			}
 
-			st->devname = xstrdup(name);
+			snprintf(st->devname, MD_NAME_MAX + 8, "%s", name);
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
@@ -789,7 +781,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			st->next = *statelist;
 			st->err = 1;
 			st->from_auto = 1;
-			strcpy(st->devnm, mse->devnm);
+			snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
 			st->percent = RESYNC_UNKNOWN;
 			st->expected_spares = -1;
 			if (mse->metadata_version &&
@@ -797,8 +789,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
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

