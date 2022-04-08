Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244DBC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbiDHNCN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiDHNCM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 09:02:12 -0400
X-Greylist: delayed 554 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Apr 2022 06:00:01 PDT
Received: from smtp-delay1.nerim.net (mailhost-v2-m3.nerim-networks.com [78.40.49.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCC7A2ED6F
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 06:00:01 -0700 (PDT)
Received: from maiev.nerim.net (smtp-155-friday.nerim.net [194.79.134.155])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id BBFB6C7A88
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 14:50:45 +0200 (CEST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by maiev.nerim.net (Postfix) with ESMTP id 5E5E52E007;
        Fri,  8 Apr 2022 14:50:39 +0200 (CEST)
Message-ID: <23ea4d81-7c7e-0fea-8a15-52ee045da56f@plouf.fr.eu.org>
Date:   Fri, 8 Apr 2022 14:50:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: [PATCH] Ignore RAID0 layout if the second zone has only one device
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>
 <164919384282.10985.10644950304504061908@noble.neil.brown.name>
 <3d16d210-2077-26bf-1eb7-6b9c5ab5fd24@plouf.fr.eu.org>
 <164928572784.10985.3756904836293591231@noble.neil.brown.name>
Content-Language: en-US
Organization: Plouf !
In-Reply-To: <164928572784.10985.3756904836293591231@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 07/04/2022 à 00:55, NeilBrown wrote:
> On Wed, 06 Apr 2022, Pascal Hambourg wrote:
>> On 05/04/2022, NeilBrown wrote:
>>> On Wed, 06 Apr 2022, Pascal Hambourg wrote:
>>>>
>>>> This is a question about original/alternate layout enforcement for RAID0
>>>> arrays with members of different sizes introduced by commits
>>>> c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0 data
>>>> corruption due to layout confusion.)" and
>>>> 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c ("md: add feature flag
>>>> MD_FEATURE_RAID0_LAYOUT").
>>>>
>>>> The layout is irrelevant if all members have the same size so the array
>>>> has only one zone. But isn't it also irrelevant if the array has two
>>>> zones and the second zone has only one device, for example if the array
>>>> has two members of different sizes ?
>>>
>>> Yes.
>>
>> So wouldn't it make sense to allow assembly even when the layout is
>> undefined, like what is done when the array has only one zone ?
>>
> Yes.
> 
> P.S.  maybe you would like to try making the code change yourself, and
> posting the patch.

Sure. In order to check the number of devices in the second zone I had
to move the layout check after all zones are set up. Is this fine ?

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

