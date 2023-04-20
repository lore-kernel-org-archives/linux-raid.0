Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B700C77B72
	for <linux-raid@archiver.kernel.org>; Thu, 20 Apr 2023 11:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjDTL1Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Apr 2023 07:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbjDTL0w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Apr 2023 07:26:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0521C2D44
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 04:26:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9AFBA219E0;
        Thu, 20 Apr 2023 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681989973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aJKnG4ghOvGXLbvtDwdPn7ijtG7dm0aIotHEb6WCd8k=;
        b=Nxqt1xAJhD8oC8BZ2bBHOw3FeVBUQrloDpUYP2DmeM3UZHluFwOlXi4EtSytUmRhWVYKfm
        M2SwRbdBp837Huxd6cmTZMFBLVb8lCm9BTQ3bE2msNqR5LALew0wIoVHXaBk6ZrLntPZ57
        aFS+FK9s+loQv6LN22I3AIz835MC0I4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681989973;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aJKnG4ghOvGXLbvtDwdPn7ijtG7dm0aIotHEb6WCd8k=;
        b=cdlmB0J0pGROcDTFj7h0nSwTyK8A4+ScP0Jf5JtDDaufhT9XqkBj6wEes4wXomZ1MoHvNW
        PhfANz13Qr4wf+Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82D5E13584;
        Thu, 20 Apr 2023 11:26:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vgHpH1UhQWTzUwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 20 Apr 2023 11:26:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 17AD7A0729; Thu, 20 Apr 2023 13:26:13 +0200 (CEST)
Date:   Thu, 20 Apr 2023 13:26:13 +0200
From:   Jan Kara <jack@suse.cz>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Jan Kara <jack@suse.cz>,
        linux-raid@vger.kernel.org, David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
Message-ID: <20230420112613.l5wyzi7ran556pum@quack3>
References: <20230417171537.17899-1-jack@suse.cz>
 <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
 <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed 19-04-23 22:26:07, Song Liu wrote:
> On Wed, Apr 19, 2023 at 12:04 PM Logan Gunthorpe <logang@deltatee.com> wrote:
> > On 2023-04-17 11:15, Jan Kara wrote:
> > > Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed the
> > > order in which requests for underlying disks are created. Since for
> > > large sequential IO adding of requests frequently races with md_raid5
> > > thread submitting bios to underlying disks, this results in a change in
> > > IO pattern because intermediate states of new order of request creation
> > > result in more smaller discontiguous requests. For RAID5 on top of three
> > > rotational disks our performance testing revealed this results in
> > > regression in write throughput:
> > >
> > > iozone -a -s 131072000 -y 4 -q 8 -i 0 -i 1 -R
> > >
> > > before 7e55c60acfbb:
> > >               KB  reclen   write rewrite    read    reread
> > >        131072000       4  493670  525964   524575   513384
> > >        131072000       8  540467  532880   512028   513703
> > >
> > > after 7e55c60acfbb:
> > >               KB  reclen   write rewrite    read    reread
> > >        131072000       4  421785  456184   531278   509248
> > >        131072000       8  459283  456354   528449   543834
> > >
> > > To reduce the amount of discontiguous requests we can start generating
> > > requests with the stripe with the lowest chunk offset as that has the
> > > best chance of being adjacent to IO queued previously. This improves the
> > > performance to:
> > >               KB  reclen   write rewrite    read    reread
> > >        131072000       4  497682  506317   518043   514559
> > >        131072000       8  514048  501886   506453   504319
> > >
> > > restoring big part of the regression.
> > >
> > > Fixes: 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> >
> > Looks good to me. I ran it through some of the functional tests I used
> > to develop the patch in question and found no issues.
> >
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> 
> Thanks Jan and Logan! I will apply this to md-next. But it may not make
> 6.4 release, as we are already at rc7.

OK, sure, this is not a critical issue.

> > > ---
> > >  drivers/md/raid5.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 44 insertions(+), 1 deletion(-)
> > >
> > > I'm by no means raid5 expert but this is what I was able to come up with. Any
> > > opinion or ideas how to fix the problem in a better way?
> >
> > The other option would be to revert to the old method for spinning disks
> > and use the pivot option only on SSDs. The pivot optimization really
> > only applies at IO speeds that can be achieved by fast solid state disks
> > anyway, and there isn't likely enough IOPS possible on spinning disks to
> > get enough lock contention that the optimization would provide any benefit.
> >
> > So it could make sense to just fall back to the old method of preparing
> > the stripes in logical block order if we are running on spinning disks.
> > Though, that might be a bit more involved than what this patch does. So
> > I think this is probably a good approach, unless we want to recover more
> > of the lost throughput.
> 
> How about we only do the optimization in this patch for spinning disks?
> Something like:
> 
>         if (likely(conf->reshape_progress == MaxSector) &&
>             !blk_queue_nonrot(mddev->queue))
>                 logical_sector = raid5_bio_lowest_chunk_sector(conf, bi);

Yeah, makes sense. On SSD disks I was not able to observe any adverse
effects of the different stripe order. Will you update the patch or should
I respin it?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
