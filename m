Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2C8C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 11:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95C76322D
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 11:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhHPLll (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236189AbhHPLlk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 07:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629114068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zGrBBP0G4Srr7e/YCV954y2P30zJcDLWKXt/AZ5NHSg=;
        b=h894vgqfLOXhkUJ3hzhUWV8HSGZ+FCkrEpUAJt+3eFkwe8FiT4CT+AU4jRAm62bEGWvLQp
        tpgwVSsBYzitk2QLxajL/+fgkk8+wtr4EiJ5ifTpgoqzjxZBNldliFQIt42DBpT8EjnS1C
        fBGobqpSChbzYYVg6U8QrhcY6WdanfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-ajuQk1g8O-qoabvWEmqytg-1; Mon, 16 Aug 2021 07:41:05 -0400
X-MC-Unique: ajuQk1g8O-qoabvWEmqytg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44A6E1082925;
        Mon, 16 Aug 2021 11:41:04 +0000 (UTC)
Received: from T590 (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51E9B60FB8;
        Mon, 16 Aug 2021 11:40:54 +0000 (UTC)
Date:   Mon, 16 Aug 2021 19:40:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRpOwFewTw4imskn@T590>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org>
 <YReFYrjtWr9MvfBr@T590>
 <YRox8gMjl/Y5Yt/k@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRox8gMjl/Y5Yt/k@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 16, 2021 at 10:37:54AM +0100, Christoph Hellwig wrote:
> On Sat, Aug 14, 2021 at 04:57:06PM +0800, Ming Lei wrote:
> > > +	if (bitmap)
> > > +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SIZE);
> > 
> > s/PAGE_SIZE/PAGE_SECTORS
> 
> Yeah, max_sectors is in size units, I messed that up.
> 
> > 
> > > +
> > >  	if (max_sectors < bio_sectors(bio)) {
> > >  		struct bio *split = bio_split(bio, max_sectors,
> > >  					      GFP_NOIO, &conf->bio_split);
> > > 
> > 
> > Here the limit is max single-page vectors, and the above way may not work,
> > such as:
> > 
> > 0 ~ 254: each bvec's length is 512
> > 255: bvec's length is 8192
> > 
> > the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
> > still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().
> 
> Yes, we still need the rounding magic that alloc_behind_master_bio uses
> here.

But it is wrong to use max sectors to limit number of bvecs(segments), isn't it?


Thanks,
Ming

