Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA42C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 11 Dec 2020 11:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549B023EF6
	for <linux-raid@archiver.kernel.org>; Fri, 11 Dec 2020 11:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394431AbgLKLam (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Dec 2020 06:30:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:45302 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391610AbgLKLag (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 11 Dec 2020 06:30:36 -0500
IronPort-SDR: PW+bPJ9dMRdEJvRfl4fLiPv0PeskEaxgcNxL+ZFQGX7ISBaGMG8GvwvkqY3wBbC32ORFfQfJAV
 92w3Q3n6Zztw==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="238521794"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="238521794"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 03:28:49 -0800
IronPort-SDR: vtRckCet6sYnIWuu/UzKUogB82qnB44fXu+lTJG8ToFM8WiBG2yDiPqhhQT1OlWWLXaLkSfhPK
 PIyhFBR6a3Og==
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="321877382"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 03:28:48 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] Incremental: Remove redundant spare movement logic
Date:   Fri, 11 Dec 2020 12:28:38 +0100
Message-Id: <20201211112838.10900-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If policy is set then mdmonitor is responsible for moving spares.
This logic is reduntant and potentialy dangerus, spare could be moved at
initrd stage depending on drives appearance order.

Remove it.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c | 62 ---------------------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index ad9ec1c..e849bdd 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1460,12 +1460,6 @@ static int Incremental_container(struct supertype *st, char *devname,
 	int trustworthy;
 	struct mddev_ident *match;
 	int rv = 0;
-	struct domainlist *domains;
-	struct map_ent *smp;
-	int suuid[4];
-	int sfd;
-	int ra_blocked = 0;
-	int ra_all = 0;
 	int result = 0;
 
 	st->ss->getinfo_super(st, &info, NULL);
@@ -1509,12 +1503,10 @@ static int Incremental_container(struct supertype *st, char *devname,
 		struct map_ent *mp;
 		struct mddev_ident *match = NULL;
 
-		ra_all++;
 		/* do not activate arrays blocked by metadata handler */
 		if (ra->array.state & (1 << MD_SB_BLOCK_VOLUME)) {
 			pr_err("Cannot activate array %s in %s.\n",
 				ra->text_version, devname);
-			ra_blocked++;
 			continue;
 		}
 		mp = map_by_uuid(&map, ra->uuid);
@@ -1617,60 +1609,6 @@ static int Incremental_container(struct supertype *st, char *devname,
 		}
 		printf("\n");
 	}
-
-	/* don't move spares to container with volume being activated
-	   when all volumes are blocked */
-	if (ra_all == ra_blocked)
-		return 0;
-
-	/* Now move all suitable spares from spare container */
-	domains = domain_from_array(list, st->ss->name);
-	memcpy(suuid, uuid_zero, sizeof(int[4]));
-	if (domains &&
-	    (smp = map_by_uuid(&map, suuid)) != NULL &&
-	    (sfd = open(smp->path, O_RDONLY)) >= 0) {
-		/* spare container found */
-		struct supertype *sst =
-			super_imsm.match_metadata_desc("imsm");
-		struct mdinfo *sinfo;
-
-		if (!sst->ss->load_container(sst, sfd, NULL)) {
-			struct spare_criteria sc = {0, 0};
-
-			if (st->ss->get_spare_criteria)
-				st->ss->get_spare_criteria(st, &sc);
-
-			close(sfd);
-			sinfo = container_choose_spares(sst, &sc,
-							domains, NULL,
-							st->ss->name, 0);
-			sst->ss->free_super(sst);
-			if (sinfo){
-				int count = 0;
-				struct mdinfo *disks = sinfo->devs;
-				while (disks) {
-					/* move spare from spare
-					 * container to currently
-					 * assembled one
-					 */
-					if (move_spare(
-						    smp->path,
-						    devname,
-						    makedev(disks->disk.major,
-							    disks->disk.minor)))
-						count++;
-					disks = disks->next;
-				}
-				if (count)
-					pr_err("Added %d spare%s to %s\n",
-					       count, count>1?"s":"", devname);
-			}
-			sysfs_free(sinfo);
-		} else
-			close(sfd);
-	}
-	domain_free(domains);
-	map_free(map);
 	return 0;
 }
 
-- 
2.25.0

