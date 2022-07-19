Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B2CC43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 13:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbiGSNeI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238562AbiGSNds (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 09:33:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC428E1F6
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 05:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658234966; x=1689770966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1GLIXr1IylW0K3dfsF1qt7pjYzOCnaTORVHzVpxG2Kk=;
  b=OYr6IsQAnv31Y+C8H5xCuBbjQHdi2a5q735xCARZD/pZgxckXOr7aG0l
   CuX+AlzKX7VS3IysAAXttzwDvJg2lLncaE280U2lRKmTtPfCnjCf19/cb
   2MnMM8bn3EBk3jmTchZBF1Jb+JinPobPSKMorb4vqKhYVfklsT2ttn+Np
   rCSXEfP0U3kYElBAwERrDQmg+LC/yJulNBPMZUhDE55ZqBPzwQ3weNCB1
   JISWIZvcelVB0qN8gHUOta02beSKQJsDCFBL620P47OoWV9oKHWm5m1cQ
   4Xai9OmlKbTU+zJnMt0D/ScAt6AenESrpnsyNEvm6RsPtILHgWykbGJkI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287225207"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="287225207"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="687100967"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:47 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/3] mdadm: move data_offset to struct shape
Date:   Tue, 19 Jul 2022 14:48:23 +0200
Message-Id: <20220719124823.20302-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
References: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Data offset is a shape property so move it there to remove additional
parameter from some functions.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Create.c | 16 ++++++++--------
 Grow.c   |  7 +++----
 mdadm.c  | 20 +++++++++-----------
 mdadm.h  |  5 ++---
 4 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/Create.c b/Create.c
index c84c1ac..e06ec2a 100644
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
index 8c520d4..e2ee91b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1775,7 +1775,6 @@ static int reshape_container(char *container, char *devname,
 
 int Grow_reshape(char *devname, int fd,
 		 struct mddev_dev *devlist,
-		 unsigned long long data_offset,
 		 struct context *c, struct shape *s)
 {
 	/* Make some changes in the shape of an array.
@@ -1821,7 +1820,7 @@ int Grow_reshape(char *devname, int fd,
 		return 1;
 	}
 
-	if (data_offset != INVALID_SECTORS && array.level != 10 &&
+	if (s->data_offset != INVALID_SECTORS && array.level != 10 &&
 	    (array.level < 4 || array.level > 6)) {
 		pr_err("--grow --data-offset not yet supported\n");
 		return 1;
@@ -2179,7 +2178,7 @@ size_change_error:
 	if ((s->level == UnSet || s->level == array.level) &&
 	    (s->layout_str == NULL) &&
 	    (s->chunk == 0 || s->chunk == array.chunk_size) &&
-	    data_offset == INVALID_SECTORS &&
+	    s->data_offset == INVALID_SECTORS &&
 	    (s->raiddisks == 0 || s->raiddisks == array.raid_disks)) {
 		/* Nothing more to do */
 		if (!changed && c->verbose >= 0)
@@ -2379,7 +2378,7 @@ size_change_error:
 		}
 		sync_metadata(st);
 		rv = reshape_array(container, fd, devname, st, &info, c->force,
-				   devlist, data_offset, c->backup_file,
+				   devlist, s->data_offset, c->backup_file,
 				   c->verbose, 0, 0, 0);
 		frozen = 0;
 	}
diff --git a/mdadm.c b/mdadm.c
index 3e8bfef..cf7175c 100644
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
@@ -478,15 +478,15 @@ int main(int argc, char *argv[])
 
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
@@ -1414,7 +1414,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	if (c.backup_file && data_offset != INVALID_SECTORS) {
+	if (c.backup_file && s.data_offset != INVALID_SECTORS) {
 		pr_err("--backup-file and --data-offset are incompatible\n");
 		exit(2);
 	}
@@ -1585,8 +1585,7 @@ int main(int argc, char *argv[])
 
 		rv = Create(ss, devlist->devname,
 			    ident.name, ident.uuid_set ? ident.uuid : NULL,
-			    devs_found-1, devlist->next,
-			    &s, &c, data_offset);
+			    devs_found - 1, devlist->next, &s, &c);
 		break;
 	case MISC:
 		if (devmode == 'E') {
@@ -1704,10 +1703,9 @@ int main(int argc, char *argv[])
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
index 8d1af86..74ec05b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -594,6 +594,7 @@ struct shape {
 	int	assume_clean;
 	int	write_behind;
 	unsigned long long size;
+	unsigned long long data_offset;
 	int	consistency_policy;
 };
 
@@ -1430,7 +1431,6 @@ extern int Grow_addbitmap(char *devname, int fd,
 			  struct context *c, struct shape *s);
 extern int Grow_reshape(char *devname, int fd,
 			struct mddev_dev *devlist,
-			unsigned long long data_offset,
 			struct context *c, struct shape *s);
 extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);
@@ -1461,8 +1461,7 @@ extern int Create(struct supertype *st, char *mddev,
 		  char *name, int *uuid,
 		  int subdevs, struct mddev_dev *devlist,
 		  struct shape *s,
-		  struct context *c,
-		  unsigned long long data_offset);
+		  struct context *c);
 
 extern int Detail(char *dev, struct context *c);
 extern int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export, char *controller_path);
-- 
2.26.2

