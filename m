Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AA2C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 06:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266FD616EB
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 06:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhEKGko (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 02:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhEKGkn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 11 May 2021 02:40:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C28E61430
        for <linux-raid@vger.kernel.org>; Tue, 11 May 2021 06:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620715177;
        bh=dIIDGnlXNwzl9HhMtAvtVW/EMfPo+Cd1hpVIoOokMDg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZXNdL44eyNVoDGZZM5fIWsNeyz4ECyJk6jRiX1Q0E+EthKHhzUGG3GiGYKDnlP8jL
         1m5q+YBJGXr4iG4VGfts9QDuYmUAG9UerCX/p/KoWOq/sehIBgxXe28U4nqadiv4zu
         wCDGXARRaA7Yzm/nWqUg01Bce8WhxNzu6mfRlwILqozemj4SYEZ4mgsTuOtbYpTV84
         ekKYHCUxSmMBVkQpOIk5lEZ67DGOiuNyGWj3VKJpLI11orPqMonHSdYdSIYxDJMiOC
         D85r20dsxILzjJg6cn0lfxl7xC9DayhS1ZxknUvRpz/TUxzutLsThMlZCtf9oExLox
         yV4A57276JXNQ==
Received: by mail-lj1-f180.google.com with SMTP id w15so23737883ljo.10
        for <linux-raid@vger.kernel.org>; Mon, 10 May 2021 23:39:37 -0700 (PDT)
X-Gm-Message-State: AOAM531BOOvi72UkmeRrHfArd8RFniNBbYxZzGD1DR4ehC1fdL/JNUza
        k6Ix/ohtzFPMgVa/QQpM4+HKVaM1zudrH4P4Qos=
X-Google-Smtp-Source: ABdhPJw+iV/BJSoj7166j6yiCArKw7HqKoAOXdrP0pRILByrl4HITwgtJtgkuD97qm2meg7k0md+CKQJA7cC71Jmxrc=
X-Received: by 2002:a2e:1608:: with SMTP id w8mr23230242ljd.506.1620715175819;
 Mon, 10 May 2021 23:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210428082903.14783-1-lidong.zhong@suse.com> <8c7a3fc1-eaf8-b67c-d981-29932168295f@suse.com>
In-Reply-To: <8c7a3fc1-eaf8-b67c-d981-29932168295f@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 May 2021 23:39:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4bCW3VJEMoZyFhrfesQB_GX9seoGvoPO-wFY8nQfZMoQ@mail.gmail.com>
Message-ID: <CAPhsuW4bCW3VJEMoZyFhrfesQB_GX9seoGvoPO-wFY8nQfZMoQ@mail.gmail.com>
Subject: Re: [PATCH] md: adding a new flag MD_DELETING
To:     Zhong Lidong <lidong.zhong@suse.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Lidong,

On Sat, May 8, 2021 at 12:41 AM Zhong Lidong <lidong.zhong@suse.com> wrote:
>
> Hi Song,
>
> Could you share your opinion about this patch please?
>

The patch looks good to me. I will process it (run some tests etc)
later this week.

Thanks,
Song


>
> On 4/28/21 4:29 PM, Lidong Zhong wrote:
> > The mddev data structure is freed in mddev_delayed_delete(), which is
> > schedualed after the array is deconfigured completely when stopping. So
> > there is a race window between md_open() and do_md_stop(), which leads
> > to /dev/mdX can still be opened by userspace even it's not accessible
> > any more. As a result, a DeviceDisappeared event will not be able to be
> > monitored by mdadm in monitor mode. This patch tries to fix it by adding
> > this new flag MD_DELETING.
> >
> > Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> > ---
> >  drivers/md/md.c | 4 +++-
> >  drivers/md/md.h | 2 ++
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 21da0c48f6c2..566df2491318 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6439,6 +6439,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
> >               md_clean(mddev);
> >               if (mddev->hold_active == UNTIL_STOP)
> >                       mddev->hold_active = 0;
> > +             set_bit(MD_DELETING, &mddev->flags);
> >       }
> >       md_new_event(mddev);
> >       sysfs_notify_dirent_safe(mddev->sysfs_state);
> > @@ -7829,7 +7830,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
> >       if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
> >               goto out;
> >
> > -     if (test_bit(MD_CLOSING, &mddev->flags)) {
> > +     if (test_bit(MD_CLOSING, &mddev->flags) ||
> > +            (test_bit(MD_DELETING, &mddev->flags) && mddev->pers == NULL)) {
> >               mutex_unlock(&mddev->open_mutex);
> >               err = -ENODEV;
> >               goto out;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index bcbba1b5ec4a..83c7aa61699f 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -262,6 +262,8 @@ enum mddev_flags {
> >       MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> >                                * I/O in case an array member is gone/failed.
> >                                */
> > +     MD_DELETING,            /* If set, we are deleting the array, do not open
> > +                              * it then */
> >  };
> >
> >  enum mddev_sb_flags {
> >
>
