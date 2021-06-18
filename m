Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A75C48BDF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 13:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14E83611B0
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 13:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhFRN4M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:56:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:35378 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234036AbhFRN4M (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 18 Jun 2021 09:56:12 -0400
IronPort-SDR: 7doQxTNuiOCDK8vetdSh9SrEaQe8azaJd5zXQac7QEdUMSHCZK537s2TWvD99qn1hV3AzIx6kX
 5M+snxvigeOw==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="193686265"
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="193686265"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 06:54:02 -0700
IronPort-SDR: BMKY2mGIMq2ppou1+A2JuowOdpFi2qD+949c4TO72i9X63bliwrCexmnvtYEIIjPilYl+Ek2nf
 fANvPr3XNQaA==
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="451401802"
Received: from unknown (HELO gklab-108-126.igk.intel.com) ([10.102.108.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 06:54:01 -0700
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Subject: [PATCH 3/3] Don't associate spares with other arrays during RAID Examine
Date:   Fri, 18 Jun 2021 15:53:32 +0200
Message-Id: <20210618135332.11293-3-oleksandr.shchirskyi@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
References: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Spares in imsm belong to containers, not volumes, and must go into
a separate container when assembling the RAID.
Remove association spares with other arrays and make Examine print
separate containers for spares.
Auto assemble without config file already works like this. So make
creating a config file and assembling from it consistent with auto
assemble.
With this change, mdadm -Es will add this line to output if spares
are found:
ARRAY metadata=imsm UUID=00000000:00000000:00000000:00000000

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
---
 Examine.c     |  2 +-
 super-intel.c | 74 +++++++++++++--------------------------------------
 2 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/Examine.c b/Examine.c
index 4381cd56..9574a3cc 100644
--- a/Examine.c
+++ b/Examine.c
@@ -166,7 +166,7 @@ int Examine(struct mddev_dev *devlist,
 			int newline = 0;
 
 			ap->st->ss->brief_examine_super(ap->st, c->verbose > 0);
-			if (ap->spares)
+			if (ap->spares && !ap->st->ss->external)
 				newline += printf("   spares=%d", ap->spares);
 			if (c->verbose > 0) {
 				newline += printf("   devices");
diff --git a/super-intel.c b/super-intel.c
index caeb6db3..d44e9f51 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2123,12 +2123,6 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 	/* We just write a generic IMSM ARRAY entry */
 	struct mdinfo info;
 	char nbuf[64];
-	struct intel_super *super = st->sb;
-
-	if (!super->anchor->num_raid_devs) {
-		printf("ARRAY metadata=imsm\n");
-		return;
-	}
 
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
@@ -3913,12 +3907,9 @@ static void imsm_copy_dev(struct imsm_dev *dest, struct imsm_dev *src)
 static int compare_super_imsm(struct supertype *st, struct supertype *tst,
 			      int verbose)
 {
-	/*
-	 * return:
+	/*  return:
 	 *  0 same, or first was empty, and second was copied
-	 *  1 second had wrong number
-	 *  2 wrong uuid
-	 *  3 wrong other info
+	 *  1 sb are different
 	 */
 	struct intel_super *first = st->sb;
 	struct intel_super *sec = tst->sb;
@@ -3928,31 +3919,30 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst,
 		tst->sb = NULL;
 		return 0;
 	}
+
 	/* in platform dependent environment test if the disks
 	 * use the same Intel hba
-	 * If not on Intel hba at all, allow anything.
+	 * if not on Intel hba at all, allow anything.
+	 * doesn't check HBAs if num_raid_devs is not set, as it means
+	 * it is a free floating spare, and all spares regardless of HBA type
+	 * will fall into separate container during the assembly
 	 */
-	if (!check_env("IMSM_NO_PLATFORM") && first->hba && sec->hba) {
+	if (first->hba && sec->hba && first->anchor->num_raid_devs != 0) {
 		if (first->hba->type != sec->hba->type) {
 			if (verbose)
 				pr_err("HBAs of devices do not match %s != %s\n",
 				       get_sys_dev_type(first->hba->type),
 				       get_sys_dev_type(sec->hba->type));
-			return 3;
+			return 1;
 		}
-
 		if (first->orom != sec->orom) {
 			if (verbose)
 				pr_err("HBAs of devices do not match %s != %s\n",
 				       first->hba->pci_id, sec->hba->pci_id);
-			return 3;
+			return 1;
 		}
-
 	}
 
-	/* if an anchor does not have num_raid_devs set then it is a free
-	 * floating spare
-	 */
 	if (first->anchor->num_raid_devs > 0 &&
 	    sec->anchor->num_raid_devs > 0) {
 		/* Determine if these disks might ever have been
@@ -3964,7 +3954,7 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst,
 
 		if (memcmp(first->anchor->sig, sec->anchor->sig,
 			   MAX_SIGNATURE_LENGTH) != 0)
-			return 3;
+			return 1;
 
 		if (first_family == 0)
 			first_family = first->anchor->family_num;
@@ -3972,43 +3962,17 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst,
 			sec_family = sec->anchor->family_num;
 
 		if (first_family != sec_family)
-			return 3;
+			return 1;
 
 	}
 
-	/* if 'first' is a spare promote it to a populated mpb with sec's
-	 * family number
-	 */
-	if (first->anchor->num_raid_devs == 0 &&
-	    sec->anchor->num_raid_devs > 0) {
-		int i;
-		struct intel_dev *dv;
-		struct imsm_dev *dev;
-
-		/* we need to copy raid device info from sec if an allocation
-		 * fails here we don't associate the spare
-		 */
-		for (i = 0; i < sec->anchor->num_raid_devs; i++) {
-			dv = xmalloc(sizeof(*dv));
-			dev = xmalloc(sizeof_imsm_dev(get_imsm_dev(sec, i), 1));
-			dv->dev = dev;
-			dv->index = i;
-			dv->next = first->devlist;
-			first->devlist = dv;
-		}
-		if (i < sec->anchor->num_raid_devs) {
-			/* allocation failure */
-			free_devlist(first);
-			pr_err("imsm: failed to associate spare\n");
-			return 3;
-		}
-		first->anchor->num_raid_devs = sec->anchor->num_raid_devs;
-		first->anchor->orig_family_num = sec->anchor->orig_family_num;
-		first->anchor->family_num = sec->anchor->family_num;
-		memcpy(first->anchor->sig, sec->anchor->sig, MAX_SIGNATURE_LENGTH);
-		for (i = 0; i < sec->anchor->num_raid_devs; i++)
-			imsm_copy_dev(get_imsm_dev(first, i), get_imsm_dev(sec, i));
-	}
+	/* if an anchor does not have num_raid_devs set then it is a free
+	* floating spare. don't assosiate spare with any array, as during assembly
+	* spares shall fall into separate container, from which they can be moved
+	* when necessary
+	*/
+	if (first->anchor->num_raid_devs ^ sec->anchor->num_raid_devs)
+		return 1;
 
 	return 0;
 }
-- 
2.27.0

