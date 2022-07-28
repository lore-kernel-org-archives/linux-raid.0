Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039AFC19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238309AbiG1MWt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiG1MWd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48AC4AD4B
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A26B31FE12;
        Thu, 28 Jul 2022 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LsG6dK588Kz9T+Aj8tADFtdVjWVi/tT+0bEZjyQO+I=;
        b=S2gtUAhDhw9Qx20gDE6gaN1ZfNxOdQSkme+T/wrcKoDzTD2pq4LqvcA0E5zALRpe/n0/WQ
        4d+yrh3GNG778XpQp6ZOPWlOy73K0EOGyX0ye1ei7sUDtmA96cjltu1aEXDWn4vPMM70jn
        fse2AkSwgSDyuyAH76Mb5gkZhjGpYok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010950;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LsG6dK588Kz9T+Aj8tADFtdVjWVi/tT+0bEZjyQO+I=;
        b=R/wk+DOmAu/J9X7Jmiw+aEffsOPqk1LfpAMOkx7zCiSscVnFJMZaSTJrXK05tmeCA0Eyiz
        uQA+8VDWlRdy7XDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id C0CE62C141;
        Thu, 28 Jul 2022 12:22:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 22/23] mdadm: move data_offset to struct shape
Date:   Thu, 28 Jul 2022 20:21:00 +0800
Message-Id: <20220728122101.28744-23-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Data offset is a shape property so move it there to remove additional
parameter from some functions.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Create.c | 16 ++++++++--------
 Grow.c   |  7 +++----
 mdadm.c  | 20 +++++++++-----------
 mdadm.h  |  5 ++---
 4 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/Create.c b/Create.c
index a6d2483d..953e7372 100644
--- a/Create.c
+++ b/Create.c
@@ -95,7 +95,7 @@ int Create(struct supertype *st, char *mddev,
 	   char *name, int *uuid,
 	   int subdevs, struct mddev_dev *devlist,
 	   struct shape *s,
-	   struct context *c, unsigned long long data_offset)
+	   struct context *c)
 {
 	/*
 	 * Create a new raid array.
@@ -288,7 +288,7 @@ int Create(struct supertype *st, char *mddev,
 	newsize = s->size * 2;
 	if (st && ! st->ss->validate_geometry(st, s->level, s->layout, s->raiddisks,
 					      &s->chunk, s->size*2,
-					      data_offset, NULL,
+					      s->data_offset, NULL,
 					      &newsize, s->consistency_policy,
 					      c->verbose >= 0))
 		return 1;
@@ -323,10 +323,10 @@ int Create(struct supertype *st, char *mddev,
 	info.array.working_disks = 0;
 	dnum = 0;
 	for (dv = devlist; dv; dv = dv->next)
-		if (data_offset == VARIABLE_OFFSET)
+		if (s->data_offset == VARIABLE_OFFSET)
 			dv->data_offset = INVALID_SECTORS;
 		else
-			dv->data_offset = data_offset;
+			dv->data_offset = s->data_offset;
 
 	for (dv=devlist; dv && !have_container; dv=dv->next, dnum++) {
 		char *dname = dv->devname;
@@ -342,7 +342,7 @@ int Create(struct supertype *st, char *mddev,
 			missing_disks ++;
 			continue;
 		}
-		if (data_offset == VARIABLE_OFFSET) {
+		if (s->data_offset == VARIABLE_OFFSET) {
 			doff = strchr(dname, ':');
 			if (doff) {
 				*doff++ = 0;
@@ -350,7 +350,7 @@ int Create(struct supertype *st, char *mddev,
 			} else
 				dv->data_offset = INVALID_SECTORS;
 		} else
-			dv->data_offset = data_offset;
+			dv->data_offset = s->data_offset;
 
 		dfd = open(dname, O_RDONLY);
 		if (dfd < 0) {
@@ -535,7 +535,7 @@ int Create(struct supertype *st, char *mddev,
 			if (!st->ss->validate_geometry(st, s->level, s->layout,
 						       s->raiddisks,
 						       &s->chunk, minsize*2,
-						       data_offset,
+						       s->data_offset,
 						       NULL, NULL,
 						       s->consistency_policy, 0)) {
 				pr_err("devices too large for RAID level %d\n", s->level);
@@ -754,7 +754,7 @@ int Create(struct supertype *st, char *mddev,
 		}
 	}
 	if (!st->ss->init_super(st, &info.array, s, name, c->homehost, uuid,
-				data_offset))
+				s->data_offset))
 		goto abort_locked;
 
 	total_slots = info.array.nr_disks;
diff --git a/Grow.c b/Grow.c
index be3010a7..9014342e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1834,7 +1834,6 @@ error:
 
 int Grow_reshape(char *devname, int fd,
 		 struct mddev_dev *devlist,
-		 unsigned long long data_offset,
 		 struct context *c, struct shape *s)
 {
 	/* Make some changes in the shape of an array.
@@ -1880,7 +1879,7 @@ int Grow_reshape(char *devname, int fd,
 		return 1;
 	}
 
-	if (data_offset != INVALID_SECTORS && array.level != 10 &&
+	if (s->data_offset != INVALID_SECTORS && array.level != 10 &&
 	    (array.level < 4 || array.level > 6)) {
 		pr_err("--grow --data-offset not yet supported\n");
 		return 1;
@@ -2186,7 +2185,7 @@ size_change_error:
 	if ((s->level == UnSet || s->level == array.level) &&
 	    (s->layout_str == NULL) &&
 	    (s->chunk == 0 || s->chunk == array.chunk_size) &&
-	    data_offset == INVALID_SECTORS &&
+	    s->data_offset == INVALID_SECTORS &&
 	    (s->raiddisks == 0 || s->raiddisks == array.raid_disks)) {
 		/* Nothing more to do */
 		if (!changed && c->verbose >= 0)
@@ -2386,7 +2385,7 @@ size_change_error:
 		}
 		sync_metadata(st);
 		rv = reshape_array(container, fd, devname, st, &info, c->force,
-				   devlist, data_offset, c->backup_file,
+				   devlist, s->data_offset, c->backup_file,
 				   c->verbose, 0, 0, 0);
 		frozen = 0;
 	}
diff --git a/mdadm.c b/mdadm.c
index 180f7a9c..845e4466 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -49,7 +49,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	unsigned long long array_size = 0;
-	unsigned long long data_offset = INVALID_SECTORS;
 	struct mddev_ident ident;
 	char *configfile = NULL;
 	int devmode = 0;
@@ -79,6 +78,7 @@ int main(int argc, char *argv[])
 		.layout		= UnSet,
 		.bitmap_chunk	= UnSet,
 		.consistency_policy	= CONSISTENCY_POLICY_UNKNOWN,
+		.data_offset = INVALID_SECTORS,
 	};
 
 	char sys_hostname[256];
@@ -479,15 +479,15 @@ int main(int argc, char *argv[])
 
 		case O(CREATE,DataOffset):
 		case O(GROW,DataOffset):
-			if (data_offset != INVALID_SECTORS) {
+			if (s.data_offset != INVALID_SECTORS) {
 				pr_err("data-offset may only be specified one. Second value is %s.\n", optarg);
 				exit(2);
 			}
 			if (mode == CREATE && strcmp(optarg, "variable") == 0)
-				data_offset = VARIABLE_OFFSET;
+				s.data_offset = VARIABLE_OFFSET;
 			else
-				data_offset = parse_size(optarg);
-			if (data_offset == INVALID_SECTORS) {
+				s.data_offset = parse_size(optarg);
+			if (s.data_offset == INVALID_SECTORS) {
 				pr_err("invalid data-offset: %s\n",
 					optarg);
 				exit(2);
@@ -1416,7 +1416,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	if (c.backup_file && data_offset != INVALID_SECTORS) {
+	if (c.backup_file && s.data_offset != INVALID_SECTORS) {
 		pr_err("--backup-file and --data-offset are incompatible\n");
 		exit(2);
 	}
@@ -1587,8 +1587,7 @@ int main(int argc, char *argv[])
 
 		rv = Create(ss, devlist->devname,
 			    ident.name, ident.uuid_set ? ident.uuid : NULL,
-			    devs_found-1, devlist->next,
-			    &s, &c, data_offset);
+			    devs_found - 1, devlist->next, &s, &c);
 		break;
 	case MISC:
 		if (devmode == 'E') {
@@ -1706,10 +1705,9 @@ int main(int argc, char *argv[])
 						   c.verbose);
 		else if (s.size > 0 || s.raiddisks || s.layout_str ||
 			 s.chunk != 0 || s.level != UnSet ||
-			 data_offset != INVALID_SECTORS) {
+			 s.data_offset != INVALID_SECTORS) {
 			rv = Grow_reshape(devlist->devname, mdfd,
-					  devlist->next,
-					  data_offset, &c, &s);
+					  devlist->next, &c, &s);
 		} else if (s.consistency_policy != CONSISTENCY_POLICY_UNKNOWN) {
 			rv = Grow_consistency_policy(devlist->devname, mdfd, &c, &s);
 		} else if (array_size == 0)
diff --git a/mdadm.h b/mdadm.h
index 55791b09..5291514e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -595,6 +595,7 @@ struct shape {
 	int	assume_clean;
 	int	write_behind;
 	unsigned long long size;
+	unsigned long long data_offset;
 	int	consistency_policy;
 };
 
@@ -1431,7 +1432,6 @@ extern int Grow_addbitmap(char *devname, int fd,
 			  struct context *c, struct shape *s);
 extern int Grow_reshape(char *devname, int fd,
 			struct mddev_dev *devlist,
-			unsigned long long data_offset,
 			struct context *c, struct shape *s);
 extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);
@@ -1462,8 +1462,7 @@ extern int Create(struct supertype *st, char *mddev,
 		  char *name, int *uuid,
 		  int subdevs, struct mddev_dev *devlist,
 		  struct shape *s,
-		  struct context *c,
-		  unsigned long long data_offset);
+		  struct context *c);
 
 extern int Detail(char *dev, struct context *c);
 extern int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export, char *controller_path);
-- 
2.35.3

