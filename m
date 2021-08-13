Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232C0C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 08:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FED6104F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 08:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbhHMIje (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 04:39:34 -0400
Received: from out1.migadu.com ([91.121.223.63]:50172 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239035AbhHMIje (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Aug 2021 04:39:34 -0400
X-Greylist: delayed 9205 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 04:39:34 EDT
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628843946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CR/iaWbntZIadIIcaBov0HvNtx+4piia/RWoFZtzAY=;
        b=GTIa02NzzP4Xd5aAlqsfS5zoTa99mCyzOdBY8BEd/M61Q3uNhzpOU7SnnZ4juQGrUi4ORm
        fKTwep+05qTK3xirZp935cmRpuBPLKMa/NNQ05/LdTE7+1YM100dcsuIyiUqnCUuD2VWXC
        Evp+/4gsVWxC4c9rXzt6l0ME72R2rSg=
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        jens@chianterastutte.eu, linux-block@vger.kernel.org
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
Date:   Fri, 13 Aug 2021 16:38:59 +0800
MIME-Version: 1.0
In-Reply-To: <YRYj8A+mDfAQBo/E@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 8/13/21 3:49 PM, Christoph Hellwig wrote:
> On Fri, Aug 13, 2021 at 02:05:10PM +0800, Guoqing Jiang wrote:
>> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
>>
>> We can't split bio with more than BIO_MAX_VECS sectors, otherwise the
>> below call trace was triggered because we could allocate oversized
>> write behind bio later.
>>
>> [ 8.097936] bvec_alloc+0x90/0xc0
>> [ 8.098934] bio_alloc_bioset+0x1b3/0x260
>> [ 8.099959] raid1_make_request+0x9ce/0xc50 [raid1]
> Which bio_alloc_bioset is this?  The one in alloc_behind_master_bio?

Yes, it should be the one since bio_clone_fast calls bio_alloc_bioset 
with 0 iovecs.

> In which case I think you want to limit the reduction of max_sectors
> to just the write behind case, and clearly document what is going on.

Ok, thanks.

> In general the size of a bio only depends on the number of vectors, not
> the total I/O size.  But alloc_behind_master_bio allocates new backing
> pages using order 0 allocations, so in this exceptional case the total
> size oes actually matter.
>
> While we're at it: this huge memory allocation looks really deadlock
> prone.

Hmm, let me think more about it, or could you share your thought? 😉

Thanks,
Guoqing
