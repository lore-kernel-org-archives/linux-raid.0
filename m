Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29E0C4320A
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 12:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8183460F38
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 12:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhHQMdk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhHQMdk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 17 Aug 2021 08:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629203586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+2Yus84hIugUWcGN23eW/FcOG0akl8Mx705tKe61RM=;
        b=Fe/ZPPD9m1G8r/GjhkLaE0zuAk/+Eylr++GP5+4NPXcF+Dw/R9Uc8fXDrWlpG5FnjY0niG
        G1icc3Yv2/dlW5T/cXlhYqh+WgOqVgFiLvdJ/lcQ4M+8MWvU2h9rfnDx/WAlUFV8RsmOWr
        CghvGETKaDl28iBotsUSqKyNzk6v758=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-UW29Z0szPfKY3RMkeZj6ng-1; Tue, 17 Aug 2021 08:33:03 -0400
X-MC-Unique: UW29Z0szPfKY3RMkeZj6ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB30D1008060;
        Tue, 17 Aug 2021 12:33:00 +0000 (UTC)
Received: from T590 (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C58375DA60;
        Tue, 17 Aug 2021 12:32:47 +0000 (UTC)
Date:   Tue, 17 Aug 2021 20:32:42 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRusakafZq0NMqLe@T590>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org>
 <YReFYrjtWr9MvfBr@T590>
 <YRox8gMjl/Y5Yt/k@infradead.org>
 <YRpOwFewTw4imskn@T590>
 <YRtDxEw7Zp2H7mxp@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRtDxEw7Zp2H7mxp@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 17, 2021 at 06:06:12AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 16, 2021 at 07:40:48PM +0800, Ming Lei wrote:
> > > > 
> > > > 0 ~ 254: each bvec's length is 512
> > > > 255: bvec's length is 8192
> > > > 
> > > > the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
> > > > still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().
> > > 
> > > Yes, we still need the rounding magic that alloc_behind_master_bio uses
> > > here.
> > 
> > But it is wrong to use max sectors to limit number of bvecs(segments), isn't it?
> 
> The raid1 write behind code cares about the size ofa bio it can reach by
> adding order 0 pages to it.  The bvecs are part of that and I think the
> calculation in the patch documents that a well.

Thinking of further, your and Guoqing's patch are correct & enough since
bio_copy_data() just copies bytes(sectors) stream from fs bio to the
write behind bio.


Thanks,
Ming

