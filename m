Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55991C433B4
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 06:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF726137A
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 06:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhDDG1N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 4 Apr 2021 02:27:13 -0400
Received: from verein.lst.de ([213.95.11.211]:47624 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhDDG1L (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 4 Apr 2021 02:27:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 870CE68BFE; Sun,  4 Apr 2021 08:27:04 +0200 (CEST)
Date:   Sun, 4 Apr 2021 08:27:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, song@kernel.org,
        lidong.zhong@suse.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] md: factor out a mddev_find_locked helper from
 mddev_find
Message-ID: <20210404062704.GA2367@lst.de>
References: <20210403161529.659555-1-hch@lst.de> <20210403161529.659555-2-hch@lst.de> <b46903ee-c64d-85ba-5a89-7acdf29dc10b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b46903ee-c64d-85ba-5a89-7acdf29dc10b@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Apr 04, 2021 at 10:24:36AM +0800, heming.zhao@suse.com wrote:
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 368cad6cd53a6e..5692427e78ba37 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -734,6 +734,17 @@ void mddev_init(struct mddev *mddev)
>>   }
>>   EXPORT_SYMBOL_GPL(mddev_init);
>>   
>
> I didn't know if I have right to give this patch "Reviewed-by: Heming Zhao <heming.zhao@suse.com>"

You always do!
