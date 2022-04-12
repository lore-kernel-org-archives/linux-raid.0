Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166E5C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Apr 2022 14:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356329AbiDLOcp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Apr 2022 10:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350121AbiDLOcn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Apr 2022 10:32:43 -0400
Received: from mallaury.nerim.net (smtp-102-tuesday.noc.nerim.net [178.132.17.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD99E4A3CB
        for <linux-raid@vger.kernel.org>; Tue, 12 Apr 2022 07:30:22 -0700 (PDT)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 1DBB3DB189;
        Tue, 12 Apr 2022 16:30:17 +0200 (CEST)
Message-ID: <c21430b4-165d-9679-0b60-438170ccb48b@plouf.fr.eu.org>
Date:   Tue, 12 Apr 2022 16:30:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     linux-raid@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: [PATCH] md/raid0: Ignore RAID0 layout if the second zone has only one
 device
Organization: Plouf !
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The RAID0 layout is irrelevant if all members have the same size so the
array has only one zone. It is *also* irrelevant if the array has two
zones and the second zone has only one device, for example if the array
has two members of different sizes.

So in that case it makes sense to allow assembly even when the layout is
undefined, like what is done when the array has only one zone.

Reviewed-By: NeilBrown <neilb@suse.de>
---
  drivers/md/raid0.c | 31 ++++++++++++++++---------------
  1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b21e101183f4..7623811cc11c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -128,21 +128,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
  	pr_debug("md/raid0:%s: FINAL %d zones\n",
  		 mdname(mddev), conf->nr_strip_zones);

-	if (conf->nr_strip_zones == 1) {
-		conf->layout = RAID0_ORIG_LAYOUT;
-	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
-		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = mddev->layout;
-	} else if (default_layout == RAID0_ORIG_LAYOUT ||
-		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = default_layout;
-	} else {
-		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
-		       mdname(mddev));
-		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
-		err = -ENOTSUPP;
-		goto abort;
-	}
  	/*
  	 * now since we have the hard sector sizes, we can make sure
  	 * chunk size is a multiple of that sector size
@@ -273,6 +258,22 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
  			 (unsigned long long)smallest->sectors);
  	}

+	if (conf->nr_strip_zones == 1 || conf->strip_zone[1].nb_dev == 1) {
+		conf->layout = RAID0_ORIG_LAYOUT;
+	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
+		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = mddev->layout;
+	} else if (default_layout == RAID0_ORIG_LAYOUT ||
+		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = default_layout;
+	} else {
+		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
+		       mdname(mddev));
+		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
+		err = -ENOTSUPP;
+		goto abort;
+	}
+
  	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
  	*private_conf = conf;

-- 
2.11.0

