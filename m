Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F409C4320A
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 07:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1A661A89
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 07:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhHPHNv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 03:13:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234177AbhHPHNu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 03:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629097999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KN0aTxLzmAWtRL2/TRaeBPXJ//S3RA2yfVjwHBnBNpk=;
        b=Vuw2z2E/CCZXdgq9xoFp6uXW6bB1fzvZ/AwEd91+Ruuoqt4OvMU4NjIH3pmzJqZRiANgxA
        wL+U03CHJFmTPcoL8aCbKkXuttOQcpgn7845yhrRrsUCMWayA42xKos/2pVZxdb1TenpLw
        Kj6BE2ed0jPciSf4eX+2sOPDz0Q/xYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-_K7AeRc1PoOjf81aqk5SBQ-1; Mon, 16 Aug 2021 03:13:17 -0400
X-MC-Unique: _K7AeRc1PoOjf81aqk5SBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21AAD1008064;
        Mon, 16 Aug 2021 07:13:16 +0000 (UTC)
Received: from T590 (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E205C60CCC;
        Mon, 16 Aug 2021 07:13:07 +0000 (UTC)
Date:   Mon, 16 Aug 2021 15:13:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Christoph Hellwig <hch@infradead.org>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRoP/XU6XnPna4jU@T590>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org>
 <YReFYrjtWr9MvfBr@T590>
 <05bdd906-2e78-bc85-c186-7bffac9076e0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05bdd906-2e78-bc85-c186-7bffac9076e0@linux.dev>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 16, 2021 at 02:27:48PM +0800, Guoqing Jiang wrote:
> Hi Ming and Christoph,
> 
> On 8/14/21 4:57 PM, Ming Lei wrote:
> > On Sat, Aug 14, 2021 at 08:55:21AM +0100, Christoph Hellwig wrote:
> > > On Fri, Aug 13, 2021 at 04:38:59PM +0800, Guoqing Jiang wrote:
> > > > Ok, thanks.
> > > > 
> > > > > In general the size of a bio only depends on the number of vectors, not
> > > > > the total I/O size.  But alloc_behind_master_bio allocates new backing
> > > > > pages using order 0 allocations, so in this exceptional case the total
> > > > > size oes actually matter.
> > > > > 
> > > > > While we're at it: this huge memory allocation looks really deadlock
> > > > > prone.
> > > > Hmm, let me think more about it, or could you share your thought? ????
> > > Well, you'd need a mempool which can fit the max payload of a bio,
> > > that is BIO_MAX_VECS pages.
> 
> IIUC, the behind bio is allocated from bio_set (mddev->bio_set) which is
> allocated in md_run by
> call bioset_init, so the mempool (bvec_pool) of  this bio_set is created by
> biovec_init_pool which
> uses global biovec slabs. Do we really need another mempool? Or, there is no
> potential deadlock
>  for this case.
> 
> > > FYI, this is what I'd do instead of this patch for now.  We don't really
> > > need a vetor per sector, just per page.  So this limits the I/O
> > > size a little less.
> > > 
> > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > index 3c44c4bb40fc..5b27d995302e 100644
> > > --- a/drivers/md/raid1.c
> > > +++ b/drivers/md/raid1.c
> > > @@ -1454,6 +1454,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
> > >   		goto retry_write;
> > >   	}
> > > +	/*
> > > +	 * When using a bitmap, we may call alloc_behind_master_bio below.
> > > +	 * alloc_behind_master_bio allocates a copy of the data payload a page
> > > +	 * at a time and thus needs a new bio that can fit the whole payload
> > > +	 * this bio in page sized chunks.
> > > +	 */
> 
> Thanks for the above, will copy it accordingly. I will check if WriteMostly
> is set before, then check both
> the flag and bitmap.
> 
> > > +	if (bitmap)
> > > +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SIZE);
> > s/PAGE_SIZE/PAGE_SECTORS
> 
> Agree.
> 
> > > +
> > >   	if (max_sectors < bio_sectors(bio)) {
> > >   		struct bio *split = bio_split(bio, max_sectors,
> > >   					      GFP_NOIO, &conf->bio_split);
> > Here the limit is max single-page vectors, and the above way may not work,
> > such as:ust splitted and not
> > 
> > 0 ~ 254: each bvec's length is 512
> > 255: bvec's length is 8192
> > 
> > the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
> > still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().
> 
> Thanks for deeper looking! I guess it is because how vcnt is calculated.
> 
> > One solution is to add queue limit of max_single_page_bvec, and let
> > blk_queue_split() handle it.
> 
> The path (blk_queue_split -> blk_bio_segment_split -> bvec_split_segs) which
> respects max_segments
> of limit. Do you mean introduce max_single_page_bvec to limit? Then perform
> similar checking as for
>  max_segment.

Yes, then the bio is guaranteed to not reach max single-page bvec limit,
just like what __blk_queue_bounce() does.


thanks,
Ming

