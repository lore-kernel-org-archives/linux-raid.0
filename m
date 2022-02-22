Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D75C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 22 Feb 2022 06:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiBVGeo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Feb 2022 01:34:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBVGeo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Feb 2022 01:34:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98560EAC45
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 22:34:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BDCDB80E5D
        for <linux-raid@vger.kernel.org>; Tue, 22 Feb 2022 06:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC768C340F1
        for <linux-raid@vger.kernel.org>; Tue, 22 Feb 2022 06:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645511654;
        bh=oT02EpnofOST8bjz65F85EBSU7KDi8jDL8DCE+D+PgA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nPeRRljL7NhsD9vo0pxYaaj48/GvdWocmdXo3oIoOJWI8OVk+48x2+F+90vFCt57A
         Wmgsub7iBWjhLBxh/7u2JRfx4s50i/qOOG14TQxOx4mg3OznyRHNZyx4cGxF+3LVXh
         wBiirLrce7dzZR8KjE0mc9rG7QFdRZDv1fT4kLCvDFsBHYLJjBTXnYDAx9tT5TXOGT
         +dkQYfClD4sWw5aWJqq8TnAXCVvY2NlMrdZ1L2oYb6kxNeSotePiYkT4hTd6hjrlTG
         YAnE2o9hTv/J8r6pqzgdWVxUnOoUlMtijSXBE4bWWro6Yk/P9pTqVcZA7od/FwawJ7
         lxIinx8zfz3Hw==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2d6d0cb5da4so107369677b3.10
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 22:34:14 -0800 (PST)
X-Gm-Message-State: AOAM533g/grb8iAjZBS42LJWBvkhZKkcRJAmtAwCyRnMmm7KvsfZbWfr
        VUKOlNqHE2oOcfN94o66gl8E7x+qRkYLgm9V1KQ=
X-Google-Smtp-Source: ABdhPJwI1KS1rEeIsssSDS/PvUjuMpFq2MZYDYsVu/QA63jf8rIrlgYRENzbl8bpmsxuQlJYdNUpVdiVB7HL6eTuXZQ=
X-Received: by 2002:a0d:ebc3:0:b0:2d6:34f5:7d67 with SMTP id
 u186-20020a0debc3000000b002d634f57d67mr22012688ywe.73.1645511653964; Mon, 21
 Feb 2022 22:34:13 -0800 (PST)
MIME-Version: 1.0
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com> <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
 <20220214103738.000017f8@linux.intel.com> <67429e77-f669-87f7-c2db-aaa4f545590b@linux.dev>
 <20220215150637.0000584f@linux.intel.com>
In-Reply-To: <20220215150637.0000584f@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Feb 2022 22:34:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6xdntvmHZ6=NDVi7mO1H3B_8XjDDt9wDHrw-QC2cYx0A@mail.gmail.com>
Message-ID: <CAPhsuW6xdntvmHZ6=NDVi7mO1H3B_8XjDDt9wDHrw-QC2cYx0A@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

On Tue, Feb 15, 2022 at 6:06 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Tue, 15 Feb 2022 11:43:34 +0800
> Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> > >> It also adopts md_error(), we only want to call .error_handler for
> > >> those levels. mddev->pers->sync_request is additionally checked,
> > >> its existence implies a level with redundancy.
> > >>
> > >> Usage of error_handler causes that disk failure can be requested
> > >> from userspace. User can fail the array via #mdadm --set-faulty
> > >> command. This is not safe and will be fixed in mdadm.
> > >> What is the safe issue here? It would betterr to post mdadm fix
> > >> together.
> > > We can and should block user from damaging raid even if it is
> > > recoverable. It is a regression.
> >
> > I don't follow, did you mean --set-fault from mdadm could "damaging
> > raid"?
>
> Yes, now it will be able to impose failed state. This is a regression I
> caused and I'm aware of that.
> >
> > > I will fix mdadm. I don't consider it as a big risk (because it is
> > > recoverable) so I focused on kernel part first.
> > >
> > >>> It is correctable because failed
> > >>> state is not recorded in the metadata. After next assembly array
> > >>> will be read-write again.
> > >> I don't think it is a problem, care to explain why it can't be RW
> > >> again?
> > > failed state is not recoverable in runtime, so you need to recreate
> > > array.
> >
> > IIUC, the failfast flag is supposed to be set during transient error
> > not permanent failure, the rdev (marked as failfast) need to be
> > revalidated and readded to array.
> >
>
> The device is never marked as failed. I checked write paths (because I
> introduced more aggressive policy for writes) and if we are in a
> critical array, failfast flag is not added to bio for both raid1 and
> radi10, see raid1_write_request().
> >
> > [ ... ]
> >
> > >>> +         char *md_name = mdname(mddev);
> > >>> +
> > >>> +         pr_crit("md/linear%s: Disk failure on %pg
> > >>> detected.\n"
> > >>> +                 "md/linear:%s: Cannot continue, failing
> > >>> array.\n",
> > >>> +                 md_name, rdev->bdev, md_name);
> > >> The second md_name is not needed.
> > > Could you elaborate here more? Do you want to skip device name in
> > > second message?
> >
> > Yes, we printed two md_name here, seems unnecessary.
> >
> I will merge errors to one message.
>
> >
> > >>> --- a/drivers/md/md.c
> > >>> +++ b/drivers/md/md.c
> > >>> @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct
> > >>> md_rdev *rdev)
> > >>>           if (!mddev->pers || !mddev->pers->error_handler)
> > >>>                   return;
> > >>> - mddev->pers->error_handler(mddev,rdev);
> > >>> + mddev->pers->error_handler(mddev, rdev);
> > >>> +
> > >>> + if (!mddev->pers->sync_request)
> > >>> +         return;
> > >> The above only valid for raid0 and linear, I guess it is fine if DM
> > >> don't create LV on top
> > >> of them. But the new checking deserves some comment above.
> > > Will do, could you propose comment?
> >
> > Or, just check if it is raid0 or linear directly instead of implies
> > level with
> > redundancy.
>
> Got it.

Could you please resend the patchset with feedback addressed? I can
apply the newer version and force push to md-next.

Thanks,
Song
