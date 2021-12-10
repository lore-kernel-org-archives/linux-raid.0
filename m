Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7326C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 02:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhLJCdH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhLJCdG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 21:33:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E62C061746
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 18:29:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB505B82483
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 02:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E5AC004DD
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 02:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639103369;
        bh=ffP5lo0cb0mDpiQ/GSLaQ7RvKhzSNrKce4w8QAuXxIM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OuIPp0n8L46trOvbMJWi/4z/eWhJXkpnZ3Q+RLYN3/fLjOE1MWZy2ViQt5DUQwvVu
         cQhF0XXIzWBOAQDlmJ51PzltMjKqNIcrx16SDiwkTujBbwAUQlAooKWBR3f75jI+yQ
         OKI2ykkfp+xmp1aO50UEUPS7AkASNorcOPAyzDzeJRWCP0VekePVdb3U1O3CyS5heQ
         /oAA7O+w8pdnm75sK0RJjd2HFY/Ugz/WtkEspnu4j2sLoxXDReudTaBkqq3pQr4LlA
         7gKA5BgraxVwaGoP5n1//xJbDM3M+LabrEGGWts7zQDDmIRFQFbMX97ZOhCUl+b2qE
         9z67wWNouDVfA==
Received: by mail-yb1-f169.google.com with SMTP id d10so18332344ybn.0
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 18:29:29 -0800 (PST)
X-Gm-Message-State: AOAM532ZNmEVXoVgXbpxUDVJ/Act8X1gbbvaE3AdYNT6I3vmW+0ESNkc
        WB4pvoJ3wRkQ4KbO4ZKBlYVrgyaL577JuGSdZAw=
X-Google-Smtp-Source: ABdhPJzZFS9lpByPNP7OKZbYFTo6PsobBBvdhfPC5hzO4I9lRNWKLBVuwX3gk2LL0mC0z/b97vTX7O4Vq/FHWWRhi/I=
X-Received: by 2002:a25:b519:: with SMTP id p25mr11126283ybj.195.1639103368789;
 Thu, 09 Dec 2021 18:29:28 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com> <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev> <CALTww293ewiXD8s0b-sLbdFZgnxMZh=5e4Fj=WMB+ifoJcNP7g@mail.gmail.com>
In-Reply-To: <CALTww293ewiXD8s0b-sLbdFZgnxMZh=5e4Fj=WMB+ifoJcNP7g@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Dec 2021 18:29:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW46cotj7a=VKfd84v0cdbVLV5ErgCC5rTBy945nY4WCvg@mail.gmail.com>
Message-ID: <CAPhsuW46cotj7a=VKfd84v0cdbVLV5ErgCC5rTBy945nY4WCvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
To:     Xiao Ni <xni@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 9, 2021 at 5:34 PM Xiao Ni <xni@redhat.com> wrote:
>
> On Fri, Dec 10, 2021 at 9:22 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
> >
> >
> >
> > On 12/10/21 2:02 AM, Song Liu wrote:
> > > On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni<xni@redhat.com>  wrote:
> > >> It doesn't free memory when register integrity failed. And move
> > >> free conf codes into a single function.
> > >>
> > >> Signed-off-by: Xiao Ni<xni@redhat.com>
> > >> ---
> > >>   drivers/md/raid0.c | 18 +++++++++++++++---
> > >>   1 file changed, 15 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > >> index 62c8b6adac70..3fa47df1c60e 100644
> > >> --- a/drivers/md/raid0.c
> > >> +++ b/drivers/md/raid0.c
> > >> @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
> > >>          return array_sectors;
> > >>   }
> > >>
> > >> +static void free_conf(struct r0conf *conf);
> > >>   static void raid0_free(struct mddev *mddev, void *priv);
> > >>
> > >>   static int raid0_run(struct mddev *mddev)
> > >> @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
> > >>          dump_zones(mddev);
> > >>
> > >>          ret = md_integrity_register(mddev);
> > >> +       if (ret)
> > >> +               goto free;
> > >>
> > >>          return ret;
> > >> +
> > >> +free:
> > >> +       free_conf(conf);
> > > Can we just use raid0_free() here? Also, after freeing conf,
> > > we should set mddev->private to NULL.
> >
> > Agree, like what raid1_run did. And we might need to check the
> > return value of pers->run in level_store as well.
>
> Yes. It needs to check the return value and try to reback to the original
> state. I planed to fix this in the following days not this patch. This patch
> only fix the NULL reference problem after reshape.
>
> In fact, no only we need to check pers->run in level_store, we also need
> to check integrity during reshape. Now integrity only supports
> raid0/raid1/raid10,
> so it needs to do some jobs related with integrity (unregister/register)
>
> I plan to fix these two problems in the next patches. Is it OK?

Yes, that works. We don't have to fix all the issues in one set. :)

Song
