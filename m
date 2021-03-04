Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E78C433E0
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 14:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C0D64F60
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 14:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhCDOkU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Mar 2021 09:40:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:56078 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232065AbhCDOj7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 4 Mar 2021 09:39:59 -0500
IronPort-SDR: uWgND0QFg3u7VyMe6+uCARbe5/xtx5bcy7t+0J0NdDQhQh3f8DIA5DDMa4+0Sswedf01KniQ3V
 +Tx5UjTAKghQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="186774463"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="186774463"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 06:38:14 -0800
IronPort-SDR: JWHcOo0+xoDadocrpf5eCbv6/bByFQs9hj+fBOdgj4yxnZGDNNgr4vs3Ax/Oswx+ORIPiCGrbm
 ZDiTBJMujEAw==
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="407809404"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 06:38:13 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH RESEND] imsm: add verbose flag to compare_super
Date:   Thu,  4 Mar 2021 15:38:05 +0100
Message-Id: <20210304143805.8485-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

IMSM does more than comparing metadata and errors reported directly
from compare_super_imsm can be useful.

Add verbose flag to compare_super method and make all not critical
error printing configurable.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Assemble.c    |  2 +-
 Examine.c     |  2 +-
 Incremental.c |  2 +-
 mdadm.h       |  3 ++-
 super-ddf.c   |  3 ++-
 super-intel.c | 21 ++++++++++++---------
 super0.c      |  3 ++-
 super1.c      |  3 ++-
 8 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index ed0ddfb1..48556d8c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -435,7 +435,7 @@ static int select_devices(struct mddev_dev *devlist,
 
 			if (st->ss != tst->ss ||
 			    st->minor_version != tst->minor_version ||
-			    st->ss->compare_super(st, tst) != 0) {
+			    st->ss->compare_super(st, tst, 1) != 0) {
 				/* Some mismatch. If exactly one array matches this host,
 				 * we can resolve on that one.
 				 * Or, if we are auto assembling, we just ignore the second
diff --git a/Examine.c b/Examine.c
index 7013480d..4381cd56 100644
--- a/Examine.c
+++ b/Examine.c
@@ -130,7 +130,7 @@ int Examine(struct mddev_dev *devlist,
 			char *d;
 			for (ap = arrays; ap; ap = ap->next) {
 				if (st->ss == ap->st->ss &&
-				    st->ss->compare_super(ap->st, st) == 0)
+				    st->ss->compare_super(ap->st, st, 0) == 0)
 					break;
 			}
 			if (!ap) {
diff --git a/Incremental.c b/Incremental.c
index e849bdda..cd9cc0fc 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -400,7 +400,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			}
 			st2 = dup_super(st);
 			if (st2->ss->load_super(st2, dfd2, NULL) ||
-			    st->ss->compare_super(st, st2) != 0) {
+			    st->ss->compare_super(st, st2, 1) != 0) {
 				pr_err("metadata mismatch between %s and chosen array %s\n",
 				       devname, chosen_name);
 				close(dfd2);
diff --git a/mdadm.h b/mdadm.h
index 1ee6c92e..60575af0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -966,7 +966,8 @@ extern struct superswitch {
 	 * moved in, otherwise the superblock in 'st' is compared with
 	 * 'tst'.
 	 */
-	int (*compare_super)(struct supertype *st, struct supertype *tst);
+	int (*compare_super)(struct supertype *st, struct supertype *tst,
+			     int verbose);
 	/* Load metadata from a single device.  If 'devname' is not NULL
 	 * print error messages as appropriate */
 	int (*load_super)(struct supertype *st, int fd, char *devname);
diff --git a/super-ddf.c b/super-ddf.c
index 7cd5702d..23147620 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3914,7 +3914,8 @@ static int store_super_ddf(struct supertype *st, int fd)
 	return 0;
 }
 
-static int compare_super_ddf(struct supertype *st, struct supertype *tst)
+static int compare_super_ddf(struct supertype *st, struct supertype *tst,
+			     int verbose)
 {
 	/*
 	 * return:
diff --git a/super-intel.c b/super-intel.c
index 715febf7..fe385eb6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3829,7 +3829,8 @@ static void imsm_copy_dev(struct imsm_dev *dest, struct imsm_dev *src)
 	memcpy(dest, src, sizeof_imsm_dev(src, 0));
 }
 
-static int compare_super_imsm(struct supertype *st, struct supertype *tst)
+static int compare_super_imsm(struct supertype *st, struct supertype *tst,
+			      int verbose)
 {
 	/*
 	 * return:
@@ -3852,18 +3853,20 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 	 */
 	if (!check_env("IMSM_NO_PLATFORM") && first->hba && sec->hba) {
 		if (first->hba->type != sec->hba->type) {
-			fprintf(stderr,
-				"HBAs of devices do not match %s != %s\n",
-				get_sys_dev_type(first->hba->type),
-				get_sys_dev_type(sec->hba->type));
+			if (verbose)
+				pr_err("HBAs of devices do not match %s != %s\n",
+				       get_sys_dev_type(first->hba->type),
+				       get_sys_dev_type(sec->hba->type));
 			return 3;
 		}
+
 		if (first->orom != sec->orom) {
-			fprintf(stderr,
-				"HBAs of devices do not match %s != %s\n",
-				first->hba->pci_id, sec->hba->pci_id);
+			if (verbose)
+				pr_err("HBAs of devices do not match %s != %s\n",
+				       first->hba->pci_id, sec->hba->pci_id);
 			return 3;
 		}
+
 	}
 
 	/* if an anchor does not have num_raid_devs set then it is a free
@@ -6962,7 +6965,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 
 			if (st->ss != tst->ss ||
 			    st->minor_version != tst->minor_version ||
-			    st->ss->compare_super(st, tst) != 0) {
+			    st->ss->compare_super(st, tst, 1) != 0) {
 				/* Some mismatch. If exactly one array matches this host,
 				 * we can resolve on that one.
 				 * Or, if we are auto assembling, we just ignore the second
diff --git a/super0.c b/super0.c
index 6af140bb..b79b97a9 100644
--- a/super0.c
+++ b/super0.c
@@ -926,7 +926,8 @@ static int write_init_super0(struct supertype *st)
 	return rv;
 }
 
-static int compare_super0(struct supertype *st, struct supertype *tst)
+static int compare_super0(struct supertype *st, struct supertype *tst,
+			  int verbose)
 {
 	/*
 	 * return:
diff --git a/super1.c b/super1.c
index 8b0d6ff3..62dac9e7 100644
--- a/super1.c
+++ b/super1.c
@@ -2114,7 +2114,8 @@ out:
 	return rv;
 }
 
-static int compare_super1(struct supertype *st, struct supertype *tst)
+static int compare_super1(struct supertype *st, struct supertype *tst,
+			  int verbose)
 {
 	/*
 	 * return:
-- 
2.25.0

