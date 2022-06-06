Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB991C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 10:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiFFK22 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiFFK20 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 06:28:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3F0201FC3
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 03:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654511305; x=1686047305;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L77JMJaOBHN/L7UE49lckSe+1juoxerP8Vsm+T68vVc=;
  b=SGBhcwyEFTXgz2IMYIDTcwXuKWWjGBKigzNjSk4LnBNK669x4skWrtRZ
   QD1Z6NaE54YatNjeotT+mpfBeDHWWsab1fFXXh2+hIGAVwM4/PB3adhkZ
   39006IGXkM5C42jMWKdJPvQHW2ICQQ7fgzCoEBH9TJ+mcB57Y4qupbGs/
   lLqngeSo68Khde5rHWl6wFGIM7LPZY8DF8Qob8zmY72XnuPf3t2OVr4nK
   NloBDKT6KIJcprkwKBGVhSiuxCwxnenp/Mr4LlSYUDJX3nXn1tm1OyTSt
   kgNfMNhNOl43QdwORhN/UFc5o2zZkjK+Fvp0JwQfqs3p327YZwZz0a46p
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276883203"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276883203"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:28:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="825754048"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2022 03:28:23 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2] Monitor: use devname as char array instead of pointer
Date:   Mon,  6 Jun 2022 12:34:20 +0200
Message-Id: <20220606103420.13135-1-kinga.tanska@intel.com>
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
index c0ab5412..2235aebf 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -33,8 +33,8 @@
 #endif
 
 struct state {
-	char *devname;
-	char devnm[32];	/* to sync with mdstat info */
+	char devname[MD_NAME_MAX + 9];	/* length of "/dev/md/" + device name + terminating byte */
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
@@ -183,13 +183,7 @@ int Monitor(struct mddev_dev *devlist,
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
 			st = xcalloc(1, sizeof *st);
-			if (mdlist->devname[0] == '/')
-				st->devname = xstrdup(mdlist->devname);
-			else {
-				st->devname = xmalloc(8+strlen(mdlist->devname)+1);
-				strcpy(strcpy(st->devname, "/dev/md/"),
-				       mdlist->devname);
-			}
+			snprintf(st->devname, MD_NAME_MAX + 9, "/dev/md/%s", basename(mdlist->devname));
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -205,7 +199,7 @@ int Monitor(struct mddev_dev *devlist,
 		for (dv = devlist; dv; dv = dv->next) {
 			struct state *st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
-			st->devname = xstrdup(dv->devname);
+			snprintf(st->devname, MD_NAME_MAX + 9, "%s", dv->devname);
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -288,7 +282,6 @@ int Monitor(struct mddev_dev *devlist,
 		for (stp = &statelist; (st = *stp) != NULL; ) {
 			if (st->from_auto && st->err > 5) {
 				*stp = st->next;
-				free(st->devname);
 				free(st->spare_group);
 				free(st);
 			} else
@@ -541,7 +534,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		goto disappeared;
 
 	if (st->devnm[0] == 0)
-		strcpy(st->devnm, fd2devnm(fd));
+		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
 
 	for (mse2 = mdstat; mse2; mse2 = mse2->next)
 		if (strcmp(mse2->devnm, st->devnm) == 0) {
@@ -671,7 +664,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
 	    is_subarray(mse->metadata_version+9)) {
 		char *sl;
-		strcpy(st->parent_devnm, mse->metadata_version + 10);
+		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", mse->metadata_version + 10);
 		sl = strchr(st->parent_devnm, '/');
 		if (sl)
 			*sl = 0;
@@ -759,14 +752,13 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 				continue;
 			}
 
-			st->devname = xstrdup(name);
+			snprintf(st->devname, MD_NAME_MAX + 9, "%s", name);
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
@@ -778,7 +770,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			st->next = *statelist;
 			st->err = 1;
 			st->from_auto = 1;
-			strcpy(st->devnm, mse->devnm);
+			snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
 			st->percent = RESYNC_UNKNOWN;
 			st->expected_spares = -1;
 			if (mse->metadata_version &&
@@ -786,8 +778,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
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

