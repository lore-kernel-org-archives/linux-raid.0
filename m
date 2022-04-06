Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37F4C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 15:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiDFPlW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbiDFPlD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 11:41:03 -0400
X-Greylist: delayed 81387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 05:57:36 PDT
Received: from bamako.nerim.net (bamako.nerim.net [178.132.17.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F31F140DC8
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 05:57:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bamako.nerim.net (Postfix) with ESMTP id 7E09939DECF;
        Wed,  6 Apr 2022 14:48:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at nerim.net
Received: from bamako.nerim.net ([127.0.0.1])
        by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vUV64D4-su-O; Wed,  6 Apr 2022 14:48:30 +0200 (CEST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by bamako.nerim.net (Postfix) with ESMTP id 3236239DED2;
        Wed,  6 Apr 2022 14:48:29 +0200 (CEST)
Message-ID: <3d16d210-2077-26bf-1eb7-6b9c5ab5fd24@plouf.fr.eu.org>
Date:   Wed, 6 Apr 2022 14:47:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: RAID0 layout if strip_zone[1].nb_dev=1 ?
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>
 <164919384282.10985.10644950304504061908@noble.neil.brown.name>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <164919384282.10985.10644950304504061908@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 05/04/2022, NeilBrown wrote:
> On Wed, 06 Apr 2022, Pascal Hambourg wrote:
>>
>> This is a question about original/alternate layout enforcement for RAID0
>> arrays with members of different sizes introduced by commits
>> c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0 data
>> corruption due to layout confusion.)" and
>> 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c ("md: add feature flag
>> MD_FEATURE_RAID0_LAYOUT").
>>
>> The layout is irrelevant if all members have the same size so the array
>> has only one zone. But isn't it also irrelevant if the array has two
>> zones and the second zone has only one device, for example if the array
>> has two members of different sizes ?
>
> Yes.

So wouldn't it make sense to allow assembly even when the layout is 
undefined, like what is done when the array has only one zone ?
