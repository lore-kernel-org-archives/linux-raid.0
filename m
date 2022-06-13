Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10571C43334
	for <linux-raid@archiver.kernel.org>; Mon, 13 Jun 2022 10:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbiFMKOr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241516AbiFMKOc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Jun 2022 06:14:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371FCA18D
        for <linux-raid@vger.kernel.org>; Mon, 13 Jun 2022 03:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115267; x=1686651267;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tYwucQsfN1+gg+IIOLWeTm84ZtJjUA/HcHCaAjbvdgQ=;
  b=GS/bdJOdf9g6axI0kn1DjKuaSc5OSm9VS5sHi9FL7gg3jc3iupq7iHLu
   fUWq2kkGloicNS1bckQaoqpqzORPQ17VMC0Pjg6FEhgod3AWRIEksjw8I
   /sxNoUNuQJyRC/qrXsTzIlqqv7B/BYXi68ucbdoThf8vSrEUv1Dr/SipB
   xOBEi+St19c3C7bCwFWe10QseYS1sy72yiUdtChfUFxZJ2tz/+nV2qgHv
   IIDkHcCYURzEzeqAoiXgYG6QFaof25zIoKGxBipn2ICoH8hBabva7+Mi+
   CGU+2ftzpsd8Tx9RWLF+BZ932w0cp60QJ+ROUc43E996s6oeCwYLCpRPT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="278272919"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="278272919"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="685958219"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2022 03:14:26 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH resend] Fix possible NULL ptr dereferences and memory leaks
Date:   Mon, 13 Jun 2022 11:59:34 +0200
Message-Id: <20220613095934.19042-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In Assemble there was a NULL check for sra variable,
which effectively didn't stop the execution in every case.
That might have resulted in a NULL pointer dereference.

Also in super-ddf, mu variable was set to NULL for some condition,
and then immidiately dereferenced.
Additionally some memory wasn't freed as well.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Assemble.c  | 7 ++++++-
 super-ddf.c | 9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 704b8293..2bd7f087 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1984,7 +1984,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	}
 
 	sra = sysfs_read(mdfd, NULL, GET_VERSION|GET_DEVS);
-	if (sra == NULL || strcmp(sra->text_version, content->text_version) != 0) {
+	if (sra == NULL) {
+		pr_err("Failed to read sysfs parameters\n");
+		return 1;
+	}
+
+	if (strcmp(sra->text_version, content->text_version) != 0) {
 		if (content->array.major_version == -1 &&
 		    content->array.minor_version == -2 &&
 		    c->readonly &&
diff --git a/super-ddf.c b/super-ddf.c
index 3f304cdc..a592c5d7 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -5125,13 +5125,16 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	 */
 	vc = find_vdcr(ddf, a->info.container_member, rv->disk.raid_disk,
 		       &n_bvd, &vcl);
-	if (vc == NULL)
+	if (vc == NULL) {
+		free(rv);
 		return NULL;
+	}
 
 	mu = xmalloc(sizeof(*mu));
 	if (posix_memalign(&mu->space, 512, sizeof(struct vcl)) != 0) {
 		free(mu);
-		mu = NULL;
+		free(rv);
+		return NULL;
 	}
 
 	mu->len = ddf->conf_rec_len * 512 * vcl->conf.sec_elmnt_count;
@@ -5161,6 +5164,8 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 			pr_err("BUG: can't find disk %d (%d/%d)\n",
 			       di->disk.raid_disk,
 			       di->disk.major, di->disk.minor);
+			free(mu);
+			free(rv);
 			return NULL;
 		}
 		vc->phys_refnum[i_prim] = ddf->phys->entries[dl->pdnum].refnum;
-- 
2.26.2

