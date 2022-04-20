Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB282C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 11:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378251AbiDTLvA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 07:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378243AbiDTLu6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 07:50:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA36419B7
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 04:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650455293; x=1681991293;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tYwucQsfN1+gg+IIOLWeTm84ZtJjUA/HcHCaAjbvdgQ=;
  b=Ftp98ktsgBGraYvDHGBlEHoiGh9AN1Ho50NQPZkGeNNAl6zp/11EV7ev
   otsKME4TArtAq841a/JTwPEeUBFxEUZmskxBjJVPXNYqRxivUpnVJtw3p
   T3WxwzT/Ymton2lq/XCZLrlvC4ngm4RUVtdKi9d8c/kjTDuDlTqvy1Jj/
   YhW9rB9aqBQh3GJ3CuF6VArdfGYFHXJNAdLBneORtPT9Ugu6E4jlKz2xq
   EDZuHTU7jvCni0/nOSElEPKA10QJl2qMNWt9rFWSU8pw4lvGHhfqy+W28
   RbuByv9fX7Olj45QdOShsvDS3S6x0/3BYEnIaHGMJflWSjGKVYOB5kyBy
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263769544"
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="263769544"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 04:48:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="529718443"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2022 04:48:11 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Fix possible NULL ptr dereferences and memory leaks
Date:   Wed, 20 Apr 2022 13:34:00 +0200
Message-Id: <20220420113400.6103-1-mateusz.grzonka@intel.com>
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

