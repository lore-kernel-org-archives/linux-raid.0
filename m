Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E14C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 21:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348207AbiEKVfM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 17:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348178AbiEKVfM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 17:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211517222B
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 14:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3FBFB82629
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 21:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784F6C340EE
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 21:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652304908;
        bh=0bkh0aeiNTTiSvnw+vX7l56ASzkfGZHEiH9suH9ZP2U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IF9qcGpSLTLVbaRRAWwEq/xKIQoa04ZjLTBFVj++7UJWPhqIBA/2G2DcwcioNiliL
         LuPCXG3vAKp3A6k1dkUtAxw3bx6yYFDb+MQfW3Z9puj5Fx72NpgPCbU2DHCs70qyG9
         zjnCfyhicGImLKzNI6YP2xhmWLaCpGUqXy8wYD6C7JdMyxpaCgO9wV/Ef6ikVWgo09
         bB/s0gGOhPlK1yTHM26385tmb9BG1K5VDKBxFbznr8+sPgeGvO+v6rNsLCbj76m7Xd
         OZ/hafC6finMTjYwL8/nwhnbBuD5xW9v37Uhuk8V1Bk5QBxFXLUEDgkaCooLNouhb0
         IxGfMlrreTTXQ==
Received: by mail-yb1-f180.google.com with SMTP id r11so6398503ybg.6
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 14:35:08 -0700 (PDT)
X-Gm-Message-State: AOAM5305x7RrDaSEOCydtvqH96Ft/Htet7Fq2kt7A9du4HRl6QzB2sZA
        QP4su/4aXAYgn4GmBtAIfi/7fbUDJZ4VXs+sZrU=
X-Google-Smtp-Source: ABdhPJxAZkDzUfkhb5ulJLDY6imMZveMz7tavT234p66Z237SXF5Ahj62x1LQo4c4Q/dowZiAsAGe39Rvum7NbanhLU=
X-Received: by 2002:a05:6902:114c:b0:641:87a7:da90 with SMTP id
 p12-20020a056902114c00b0064187a7da90mr26093093ybu.561.1652304907508; Wed, 11
 May 2022 14:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <1651208967-4701-1-git-send-email-xni@redhat.com>
 <CAPhsuW7J3EQde_XGdysjNGjHjEb+Zq2kXwXsj+4xpXBA_Bq2Eg@mail.gmail.com> <CALTww2_hyAH+EJc=EymgcBwhTCQpddy500eqZf=qr_r4=H8Y6w@mail.gmail.com>
In-Reply-To: <CALTww2_hyAH+EJc=EymgcBwhTCQpddy500eqZf=qr_r4=H8Y6w@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 11 May 2022 14:34:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6RXrxrRP_cK_m15v5C1A5CNmvW4Fz1KpePg=kA+PYh+A@mail.gmail.com>
Message-ID: <CAPhsuW6RXrxrRP_cK_m15v5C1A5CNmvW4Fz1KpePg=kA+PYh+A@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't set mddev private to NULL in raid0 pers->free
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Fine Fan <ffan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 11, 2022 at 9:14 AM Xiao Ni <xni@redhat.com> wrote:
>
> On Mon, May 9, 2022 at 2:24 PM Song Liu <song@kernel.org> wrote:
> >
> > Hi Xiao,
> >
> > Thanks for the patch!
> >
> > On Thu, Apr 28, 2022 at 10:09 PM Xiao Ni <xni@redhat.com> wrote:
> > >
> >
> > prefix the subject with "md:", and provide more details.
>
> Hi Song
>
> Thanks for pointing about this and I will add "md:" in v2.
> >
> > > It panics when reshaping from raid0 to other raid levels. raid0 sets
> > > mddev->private to NULL. It's the reason that causes the problem.
> > > Function level_store finds new pers and create new conf, then it
> > > calls oldpers->free. In oldpers->free, raid0 sets mddev->private
> > > to NULL again. And __md_stop is the right position to set
> > > mddev->private to NULL.
> >
> > We need more details here: the panic backtrace, and why it panics.
> > raid5_free also sets private to NULL. Does it has the same problem?
>
> The backtrace will be added in v2.
>
> I don't find raid5_free sets mddev->private to NULL.
> The normal process of stopping a raid should be like this:
>
> do_md_stop
>        |
> __md_stop  (pers->free(); mddev->private=NULL)
>        |
> md_free (free biosets of mddev; free mddev)
>
> personality raid doesn't set mddev->private to NULL. __md_stop does this job.
> Reshaping from raid0 to raid other raid level doesn't stop the raid.
> The new raid
> will go on working. Now raid0_free->free_conf sets mddev->private to NULL during
> reshape. The new raid can't work anymore. It will panic when dereference
> mddev->private because of NULL pointer dereference.

Got it. Thanks for the explanation.

Thanks,
Song
