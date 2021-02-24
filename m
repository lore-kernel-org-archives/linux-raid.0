Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519F6C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 09:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD9764D79
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 09:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhBXJMG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234554AbhBXJKW (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Feb 2021 04:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F9F464EBB
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 09:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614157771;
        bh=499AmNNSq/ACSmtLf81LAjGu02ssK+cSwya+p/rg3ng=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ipiHD29sMifR10dKnV16O5SjuTUFVs2+BpJdljEpcaGdGeR04gI+5JiLq09nWw1ND
         fbdPtHclikS8yS40XGcOQDx5oiil7sj3Afj8ow045pSW4hde+yijg1QLjHPTMTMM03
         O65dM7Le+h+kjN0F7mo9p/aJx57/ccJIeHw/zuPnyIcWkcifjmW7hz9fIC4N+efXbz
         tYXZsXtskTdrZMJ5Cf/CYuK0hN3YYWqJOspxLlCPlY2PbUDlu1oF9k4wIR/vell95I
         etIOfzewPjCsNH0AEjW0c0Rn+sAruMirYRKLDhsBJoVJyBF6RxpD96sKTNKtZa+5hx
         fyM8nzssq4V5g==
Received: by mail-lj1-f171.google.com with SMTP id h4so1364572ljl.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 01:09:31 -0800 (PST)
X-Gm-Message-State: AOAM5335m4mc/VWt/daMUxgyNbUXlUjTLjkuMfpnuatzUJO2eHR/+YMQ
        mTYMW/nhap/Fz7fbNlAy3EZ5/M7tdE8SpwzZxg0=
X-Google-Smtp-Source: ABdhPJxIxpGmVpd0hvF9qqK6G6MCtyhOx+u4kaepzzQYkt4E1gzjn3RRlO7Jg+o/FiaQQwZ4vH9tbwiZ10YIzGucjgw=
X-Received: by 2002:a2e:9b05:: with SMTP id u5mr13811463lji.167.1614157769559;
 Wed, 24 Feb 2021 01:09:29 -0800 (PST)
MIME-Version: 1.0
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com> <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
In-Reply-To: <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 24 Feb 2021 01:09:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
Message-ID: <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex held
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> [+cc Donald]
>
> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
> > Unregister sync_thread doesn't need to hold reconfig_mutex since it
> > doesn't reconfigure array.
> >
> > And it could cause deadlock problem for raid5 as follows:
> >
> > 1. process A tried to reap sync thread with reconfig_mutex held after echo
> >     idle to sync_action.
> > 2. raid5 sync thread was blocked if there were too many active stripes.
> > 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
> >     which causes the number of active stripes can't be decreased.
> > 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
> >     to hold reconfig_mutex.
> >
> > More details in the link:
> > https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> >
> > And add one parameter to md_reap_sync_thread since it could be called by
> > dm-raid which doesn't hold reconfig_mutex.
> >
> > Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> > Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

I don't really like this fix. But I haven't got a better (and not too
complicated)
alternative.

> > ---
> > V2:
> > 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
> >
> >   drivers/md/dm-raid.c |  2 +-
> >   drivers/md/md.c      | 14 +++++++++-----
> >   drivers/md/md.h      |  2 +-
> >   3 files changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index cab12b2..0c4cbba 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
> >       if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
> >               if (mddev->sync_thread) {
> >                       set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > -                     md_reap_sync_thread(mddev);
> > +                     md_reap_sync_thread(mddev, false);

I think we can add mddev_lock() and mddev_unlock() here and then we don't
need the extra parameter?

Thanks,
Song
