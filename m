Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB0DC77B73
	for <linux-raid@archiver.kernel.org>; Wed, 19 Apr 2023 19:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjDSTE2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Apr 2023 15:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDSTE1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Apr 2023 15:04:27 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE36B2120
        for <linux-raid@vger.kernel.org>; Wed, 19 Apr 2023 12:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=FdAYAsG23Szwu9uX1GI5V5Rl6n8PJCeOqY6I9lwPgks=; b=cCXw/H50pNbp0bEw3V0Ay4+Pry
        vC05GinOGiW2RA702LUlBtoY1rLaVZRdHmQcvBvZo1+pwQa2wls7uFH2iP4bcY5JYm1Y+oAI9ZZwA
        YyDsDUgzarO70sOoHk5mRvaqYsseas8qL2aENuhWrc0epo555fIuoXqViIxgCv3XUwaN5bLvqKRHk
        tylASgcUWZMk/FduIC2zVY2yjBDulOZKPxFbCPLJ3VhnZjwtGsipNB5+NGZiPf5louqtAy9KVsn6x
        s6Qz/ek3feOBnP0yTYI0b/o7Bg2hWaPvWSvXfONpfkXvV8ateajBxnTZt+TivUrrMuwUKJTNyBhvq
        cNUUf7jQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ppD6N-00ChH9-0i; Wed, 19 Apr 2023 13:04:23 -0600
Message-ID: <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
Date:   Wed, 19 Apr 2023 13:04:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-CA
To:     Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, David Sloan <David.Sloan@eideticom.com>
References: <20230417171537.17899-1-jack@suse.cz>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20230417171537.17899-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: jack@suse.cz, linux-raid@vger.kernel.org, song@kernel.org, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-04-17 11:15, Jan Kara wrote:
> Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed the
> order in which requests for underlying disks are created. Since for
> large sequential IO adding of requests frequently races with md_raid5
> thread submitting bios to underlying disks, this results in a change in
> IO pattern because intermediate states of new order of request creation
> result in more smaller discontiguous requests. For RAID5 on top of three
> rotational disks our performance testing revealed this results in
> regression in write throughput:
> 
> iozone -a -s 131072000 -y 4 -q 8 -i 0 -i 1 -R
> 
> before 7e55c60acfbb:
>               KB  reclen   write rewrite    read    reread
>        131072000       4  493670  525964   524575   513384
>        131072000       8  540467  532880   512028   513703
> 
> after 7e55c60acfbb:
>               KB  reclen   write rewrite    read    reread
>        131072000       4  421785  456184   531278   509248
>        131072000       8  459283  456354   528449   543834
> 
> To reduce the amount of discontiguous requests we can start generating
> requests with the stripe with the lowest chunk offset as that has the
> best chance of being adjacent to IO queued previously. This improves the
> performance to:
>               KB  reclen   write rewrite    read    reread
>        131072000       4  497682  506317   518043   514559
>        131072000       8  514048  501886   506453   504319
> 
> restoring big part of the regression.
> 
> Fixes: 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me. I ran it through some of the functional tests I used
to develop the patch in question and found no issues.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> ---
>  drivers/md/raid5.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> I'm by no means raid5 expert but this is what I was able to come up with. Any
> opinion or ideas how to fix the problem in a better way?

The other option would be to revert to the old method for spinning disks
and use the pivot option only on SSDs. The pivot optimization really
only applies at IO speeds that can be achieved by fast solid state disks
anyway, and there isn't likely enough IOPS possible on spinning disks to
get enough lock contention that the optimization would provide any benefit.

So it could make sense to just fall back to the old method of preparing
the stripes in logical block order if we are running on spinning disks.
Though, that might be a bit more involved than what this patch does. So
I think this is probably a good approach, unless we want to recover more
of the lost throughput.

Logan
