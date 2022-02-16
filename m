Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD846C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 16 Feb 2022 09:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiBPJrQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Feb 2022 04:47:16 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiBPJrP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Feb 2022 04:47:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F095D63AE
        for <linux-raid@vger.kernel.org>; Wed, 16 Feb 2022 01:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645004818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lITahrFLFY3rSccPdxygik51Jub7ZQ/g/NCrO3scwkA=;
        b=TZUisFx7RHbxBf9MocIQuCFoVWLLp9IO6lYi/9EWqisECI3/natQ78iynp78mwrlHwUyH3
        umJgFLnjVfIb1m8EG3amsPqc6e0nNKO/vz3hF3nKXI14GbZkjckuCXrRRsI7677bAzNLUj
        4aCc0a1Sz24h4kA9+NC/RGM/WWnMT1I=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-19ln1DONN9eY0KBlyyzLCA-1; Wed, 16 Feb 2022 04:46:56 -0500
X-MC-Unique: 19ln1DONN9eY0KBlyyzLCA-1
Received: by mail-ed1-f71.google.com with SMTP id f9-20020a056402354900b0040fb9c35a02so1206140edd.18
        for <linux-raid@vger.kernel.org>; Wed, 16 Feb 2022 01:46:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lITahrFLFY3rSccPdxygik51Jub7ZQ/g/NCrO3scwkA=;
        b=GVXLa4GZ5ZxSMZSkLvFylv6b2m0unBYhCPimImHs3nBoX4QaBrHSkSGMQFXwuPVXOl
         qcK7XCKlNpB3/F2hUrzZ6mClofTyb0tHhf6sadeywyBLU0RnxYI8vBU2W6nz3yXxwZ39
         G2mC9r2/byhe+J+BJi6ixyf2Zvc8Xez1CB1649OOkHTT051ZO3BcR+xUb0raDkSxzXhc
         bkNV6Ah5RZrCpcDejUfnpGlue3FYvgJX0Id4XRRoS/81ukmUo4jwMmGej5YjpIfpJrxU
         3PX+blz1Yc/xwIBehuNuUrOBAstDGM10do/xXj8HBPvWrPPdMJ57vunOl2+jhQzGK7Z5
         +I3w==
X-Gm-Message-State: AOAM530fP7k5eaYnYToNNuTWKH9KzHBE7FtX8XjhrXOF3TTpPLYf+Jdh
        l+Akqib/063IA+e9iYiAu7Vg5ynmS5c+Plu/93wuPF+Z3OK8RphSl8+fiQbgumYy+ECWNio8D+v
        /KPX2eRI8rxvk1BPDLoQcmpV2XcM3p7MYbjTNiA==
X-Received: by 2002:a17:906:5250:b0:6cb:987a:b436 with SMTP id y16-20020a170906525000b006cb987ab436mr1669021ejm.108.1645004815102;
        Wed, 16 Feb 2022 01:46:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwKBA1jRTtls5yJQmuore450AHHzf+vi9dis16pmyvWNZeqdqATQ3lFooTmPcNAxE4qCBq6NNtf8DUMF5hBi0=
X-Received: by 2002:a17:906:5250:b0:6cb:987a:b436 with SMTP id
 y16-20020a170906525000b006cb987ab436mr1669009ejm.108.1645004814857; Wed, 16
 Feb 2022 01:46:54 -0800 (PST)
MIME-Version: 1.0
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com> <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
 <20220214103738.000017f8@linux.intel.com> <67429e77-f669-87f7-c2db-aaa4f545590b@linux.dev>
 <20220215150637.0000584f@linux.intel.com>
In-Reply-To: <20220215150637.0000584f@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 16 Feb 2022 17:47:33 +0800
Message-ID: <CALTww28+n59mNbLRTG8GePa+KmaoxfzKgCApQGX-YiXPJ3+E9w@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 15, 2022 at 10:07 PM Mariusz Tkaczyk
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

Hi all

The "failed state" in the patch should mean MD_BROKEN, right? If so,
are you talking
in the wrong direction?

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

Hi guoqing, could you explain this more? If we create LV on raid
device, this check doesn't work?

Regards
Xiao

