Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8033C77B73
	for <linux-raid@archiver.kernel.org>; Thu, 20 Apr 2023 05:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjDTF00 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Apr 2023 01:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDTF0Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Apr 2023 01:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EBD10D1
        for <linux-raid@vger.kernel.org>; Wed, 19 Apr 2023 22:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 147AC6450A
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 05:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738BDC433D2
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 05:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681968381;
        bh=zhbyrkBS4a+ul4UucrbkPxNEbJn5TwXDz7WZODaYEI4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WT3Dl8ZuU4ygtVByDQSmiKqJ3xTwhKUhU216jyklnghRpONy3MJBlCABWqWauLrL2
         S1SsTUcvBL4Y3985gj9rubPwEvkefvJ2UTdPPqdLuZtLeVqaBVeUeQKiY7CjFk7GiT
         fAC52g//yr9zQHPMy0CRLp9h/KLk1uA3zRQm/q4kDkSF540LsdQ1fJbxQIMDn+8nIl
         vIDElGbCZRb2B3+trqq2SjXBR/ZgcRp2w8zdW6WZ0PhU/wuol3oGGIhxod5UvLDf+I
         qgvibHhXgNwE8j0Jj97TEwrq4JQ0QJj3HucTnjd4vCIGiEIMt38dk33fNs/sUNHEb3
         +2wxbf2V5d7Vg==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4edbd6cc46bso308038e87.2
        for <linux-raid@vger.kernel.org>; Wed, 19 Apr 2023 22:26:21 -0700 (PDT)
X-Gm-Message-State: AAQBX9c15j0tvWdvIvDK7SGTapvSWt0JUfPAaBRd0KydwmEVTjHjWAQh
        JpFNQv/8IdqkfVQaqukwPksD7lcKqurDuu0Nh8k=
X-Google-Smtp-Source: AKy350aI5pNhj0Ne2w2ezC0tPFMdjhddLXp9gTNQDzQj8QnEC2+wDy9yEYNffK6+ApWs2aDJZNlpG8hWKN6jNEiCaVg=
X-Received: by 2002:ac2:54ab:0:b0:4ea:f9d4:9393 with SMTP id
 w11-20020ac254ab000000b004eaf9d49393mr16517lfk.3.1681968379466; Wed, 19 Apr
 2023 22:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230417171537.17899-1-jack@suse.cz> <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
In-Reply-To: <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 Apr 2023 22:26:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
Message-ID: <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 19, 2023 at 12:04=E2=80=AFPM Logan Gunthorpe <logang@deltatee.c=
om> wrote:
>
>
>
> On 2023-04-17 11:15, Jan Kara wrote:
> > Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed th=
e
> > order in which requests for underlying disks are created. Since for
> > large sequential IO adding of requests frequently races with md_raid5
> > thread submitting bios to underlying disks, this results in a change in
> > IO pattern because intermediate states of new order of request creation
> > result in more smaller discontiguous requests. For RAID5 on top of thre=
e
> > rotational disks our performance testing revealed this results in
> > regression in write throughput:
> >
> > iozone -a -s 131072000 -y 4 -q 8 -i 0 -i 1 -R
> >
> > before 7e55c60acfbb:
> >               KB  reclen   write rewrite    read    reread
> >        131072000       4  493670  525964   524575   513384
> >        131072000       8  540467  532880   512028   513703
> >
> > after 7e55c60acfbb:
> >               KB  reclen   write rewrite    read    reread
> >        131072000       4  421785  456184   531278   509248
> >        131072000       8  459283  456354   528449   543834
> >
> > To reduce the amount of discontiguous requests we can start generating
> > requests with the stripe with the lowest chunk offset as that has the
> > best chance of being adjacent to IO queued previously. This improves th=
e
> > performance to:
> >               KB  reclen   write rewrite    read    reread
> >        131072000       4  497682  506317   518043   514559
> >        131072000       8  514048  501886   506453   504319
> >
> > restoring big part of the regression.
> >
> > Fixes: 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")
> > Signed-off-by: Jan Kara <jack@suse.cz>
>
> Looks good to me. I ran it through some of the functional tests I used
> to develop the patch in question and found no issues.
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks Jan and Logan! I will apply this to md-next. But it may not make
6.4 release, as we are already at rc7.

>
> > ---
> >  drivers/md/raid5.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 44 insertions(+), 1 deletion(-)
> >
> > I'm by no means raid5 expert but this is what I was able to come up wit=
h. Any
> > opinion or ideas how to fix the problem in a better way?
>
> The other option would be to revert to the old method for spinning disks
> and use the pivot option only on SSDs. The pivot optimization really
> only applies at IO speeds that can be achieved by fast solid state disks
> anyway, and there isn't likely enough IOPS possible on spinning disks to
> get enough lock contention that the optimization would provide any benefi=
t.
>
> So it could make sense to just fall back to the old method of preparing
> the stripes in logical block order if we are running on spinning disks.
> Though, that might be a bit more involved than what this patch does. So
> I think this is probably a good approach, unless we want to recover more
> of the lost throughput.

How about we only do the optimization in this patch for spinning disks?
Something like:

        if (likely(conf->reshape_progress =3D=3D MaxSector) &&
            !blk_queue_nonrot(mddev->queue))
                logical_sector =3D raid5_bio_lowest_chunk_sector(conf, bi);

Thanks,
Song
