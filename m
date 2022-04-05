Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4528C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 01:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiDFB1o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448554AbiDEPsZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 11:48:25 -0400
X-Greylist: delayed 531 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 07:30:00 PDT
Received: from smtp-delay1.nerim.net (mailhost-e3-p0.nerim-networks.com [195.5.209.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABD441F60C
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 07:29:59 -0700 (PDT)
Received: from mallaury.nerim.net (smtp-102-tuesday.noc.nerim.net [178.132.17.102])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id 460EC22F33E
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 16:21:05 +0200 (CEST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 3B63DDB189;
        Tue,  5 Apr 2022 16:21:03 +0200 (CEST)
Message-ID: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>
Date:   Tue, 5 Apr 2022 16:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     linux-raid@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: RAID0 layout if strip_zone[1].nb_dev=1 ?
Organization: Plouf !
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[Please Cc me, I am not subscribed to the list]

Hello,

This is a question about original/alternate layout enforcement for RAID0 
arrays with members of different sizes introduced by commits
c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0 data 
corruption due to layout confusion.)" and
33f2c35a54dfd75ad0e7e86918dcbe4de799a56c ("md: add feature flag 
MD_FEATURE_RAID0_LAYOUT").

The layout is irrelevant if all members have the same size so the array 
has only one zone. But isn't it also irrelevant if the array has two 
zones and the second zone has only one device, for example if the array 
has two members of different sizes ?
