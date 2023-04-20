Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F78DC77B73
	for <linux-raid@archiver.kernel.org>; Thu, 20 Apr 2023 20:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjDTUHZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Apr 2023 16:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjDTUHX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Apr 2023 16:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138EA4695
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 13:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9806964B7D
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 20:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059A6C433EF
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 20:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682021240;
        bh=08OwocaQBxsweuTzrIr9ycR/ZE2f2SZCR9lpZ/RXmyo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IfqIeQeiZCnzgOSoxJRfql0Xl8KcExmqn0SUGycu+L/WAeQId+5PqHkeDqQMMDsPe
         V6o/IZ+ddugOcmdPwRWUrIFladFgzAm9MUc/yb8CVD0B1mR/vacVXe0/9XWdAEBRtE
         hoetekHpiU8KPIvmQ7060AFayOgNd+IVR2k34zXYaTX/OBelt8NG2JY8mYLuM8Ug1t
         Kgg8XuiZJqH55jtqDRLIYSr3ruhUT3hLhZ3tRcue2DhCcADync/jWT+jP3jbzWsABU
         +4sBQiBv2l1LxJqFpwC9iFBYCHDCuNYrxEzwOv33pqMH6f2u2INR82GW96CsDTTUPf
         2RBJy6FFtbvJA==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4ec8133c59eso826238e87.0
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 13:07:19 -0700 (PDT)
X-Gm-Message-State: AAQBX9ceFtMcj9iYYrAforIFWDRmTDybxWh1WVMiu135Wkskpv+NDLev
        dCXDQvp7ziWkG/78sh+luDExnoRVaCRZzNr7YbM=
X-Google-Smtp-Source: AKy350YmpZDdhv9zBzPbzwomK7ti94iEo70HpCMCXLHuzr/aemAKQm10C7jgt14R1yALUM655r0e6kDrGrJhlDXgANM=
X-Received: by 2002:ac2:424f:0:b0:4dd:a058:f08f with SMTP id
 m15-20020ac2424f000000b004dda058f08fmr725564lfl.3.1682021238021; Thu, 20 Apr
 2023 13:07:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230417171537.17899-1-jack@suse.cz> <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
 <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
 <20230420112613.l5wyzi7ran556pum@quack3> <c5830dd8-57c5-0d94-a48d-d85f154607e0@deltatee.com>
In-Reply-To: <c5830dd8-57c5-0d94-a48d-d85f154607e0@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Apr 2023 13:07:05 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5aaaTL1Ed-wKb82DKSSqg+ckC0MboaOLSUuaiGmTYTuA@mail.gmail.com>
Message-ID: <CAPhsuW5aaaTL1Ed-wKb82DKSSqg+ckC0MboaOLSUuaiGmTYTuA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 20, 2023 at 8:54=E2=80=AFAM Logan Gunthorpe <logang@deltatee.co=
m> wrote:
>
>
>
> On 2023-04-20 05:26, Jan Kara wrote:
> > On Wed 19-04-23 22:26:07, Song Liu wrote:
> >> On Wed, Apr 19, 2023 at 12:04=E2=80=AFPM Logan Gunthorpe <logang@delta=
tee.com> wrote:
> >>> On 2023-04-17 11:15, Jan Kara wrote:
> >>>> Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed=
 the
> >>>> order in which requests for underlying disks are created. Since for
> >>>> large sequential IO adding of requests frequently races with md_raid=
5
> >>>> thread submitting bios to underlying disks, this results in a change=
 in
> >>>> IO pattern because intermediate states of new order of request creat=
ion
> >>>> result in more smaller discontiguous requests. For RAID5 on top of t=
hree
> >>>> rotational disks our performance testing revealed this results in
> >>>> regression in write throughput:
> >>>>
> >>>> iozone -a -s 131072000 -y 4 -q 8 -i 0 -i 1 -R
> >>>>
> >>>> before 7e55c60acfbb:
> >>>>               KB  reclen   write rewrite    read    reread
> >>>>        131072000       4  493670  525964   524575   513384
> >>>>        131072000       8  540467  532880   512028   513703
> >>>>
> >>>> after 7e55c60acfbb:
> >>>>               KB  reclen   write rewrite    read    reread
> >>>>        131072000       4  421785  456184   531278   509248
> >>>>        131072000       8  459283  456354   528449   543834
> >>>>
> >>>> To reduce the amount of discontiguous requests we can start generati=
ng
> >>>> requests with the stripe with the lowest chunk offset as that has th=
e
> >>>> best chance of being adjacent to IO queued previously. This improves=
 the
> >>>> performance to:
> >>>>               KB  reclen   write rewrite    read    reread
> >>>>        131072000       4  497682  506317   518043   514559
> >>>>        131072000       8  514048  501886   506453   504319
> >>>>
> >>>> restoring big part of the regression.
> >>>>
> >>>> Fixes: 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")
> >>>> Signed-off-by: Jan Kara <jack@suse.cz>
> >>>
> >>> Looks good to me. I ran it through some of the functional tests I use=
d
> >>> to develop the patch in question and found no issues.
> >>>
> >>> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> >>
> >> Thanks Jan and Logan! I will apply this to md-next. But it may not mak=
e
> >> 6.4 release, as we are already at rc7.
> >
> > OK, sure, this is not a critical issue.
> >
> >>>> ---
> >>>>  drivers/md/raid5.c | 45 +++++++++++++++++++++++++++++++++++++++++++=
+-
> >>>>  1 file changed, 44 insertions(+), 1 deletion(-)
> >>>>
> >>>> I'm by no means raid5 expert but this is what I was able to come up =
with. Any
> >>>> opinion or ideas how to fix the problem in a better way?
> >>>
> >>> The other option would be to revert to the old method for spinning di=
sks
> >>> and use the pivot option only on SSDs. The pivot optimization really
> >>> only applies at IO speeds that can be achieved by fast solid state di=
sks
> >>> anyway, and there isn't likely enough IOPS possible on spinning disks=
 to
> >>> get enough lock contention that the optimization would provide any be=
nefit.
> >>>
> >>> So it could make sense to just fall back to the old method of prepari=
ng
> >>> the stripes in logical block order if we are running on spinning disk=
s.
> >>> Though, that might be a bit more involved than what this patch does. =
So
> >>> I think this is probably a good approach, unless we want to recover m=
ore
> >>> of the lost throughput.
> >>
> >> How about we only do the optimization in this patch for spinning disks=
?
> >> Something like:
> >>
> >>         if (likely(conf->reshape_progress =3D=3D MaxSector) &&
> >>             !blk_queue_nonrot(mddev->queue))
> >>                 logical_sector =3D raid5_bio_lowest_chunk_sector(conf,=
 bi);
> >
> > Yeah, makes sense. On SSD disks I was not able to observe any adverse
> > effects of the different stripe order. Will you update the patch or sho=
uld
> > I respin it?
>
> Does it make sense? If SSDs work fine with the new stripe order, why do
> things different for them? So I don't see a  benefit of making the fix
> only work with non-rotational devices. It's my original change which
> could be made for non-rotationatial only, but that's much more involved.

I am hoping to make raid5_make_request() a little faster for non-rotational
devices. We may not easily observe a difference in performance, but things
add up. Does this make sense?

Thanks,
Song
