Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED961C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 02:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbhLJCbF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:31:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46428 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbhLJCbF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 21:31:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7710CE2996
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 02:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E349CC341C6
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 02:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639103247;
        bh=MvG18vWU7Stpf+612BhrO9IFuO8xqHuvaaAOUbRQgMA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ExqZMqf4PXEjhXiInXCrLT1rOqMa+FuIW7YXEGGavxq/rdBu4dP2VoOuGS39o2bk4
         nHIv4m1EUdPULpTZRn7+B3KtdNR03qjKg9YYehfKkXtjaTZjOo9geHo3USSu2nouvg
         QlL9U1QtOrBpvXnwG9/6m3EscoxDvW7+rk9URnO6sbjigL62PBrmQ7RFzynhSHofCQ
         pG/s7Mzs1f1v+yCM0nj9Si9ACUrzKVACjUwcM4QUEHk8MO4yjR3HInqsT9IFngRziA
         lseXgdwZSh9rg6Zqa855EOFkrNJR8eFkCzcj7W8uITkl2ukfrZTYx5zhb7NH3vABDm
         vqgnivSk2ygjg==
Received: by mail-yb1-f178.google.com with SMTP id 131so18142006ybc.7
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 18:27:27 -0800 (PST)
X-Gm-Message-State: AOAM532ujz4YM9apwW8Eg6MIb6Ck6X/S91tNcRN49ueynCnm9kEufABY
        goaoe1xMhXJX3ZbY/7OBn0+Dy09kpG3rCC1+HF0=
X-Google-Smtp-Source: ABdhPJwqHPR+Ka3GIBrdidTbCeSh7B8jCwBxQkejQj+yyJ3sP1spi9oWKRr/MzWT3l1DT7WqbPYJNXl4Szwgm8pCGAM=
X-Received: by 2002:a25:26cb:: with SMTP id m194mr10809224ybm.558.1639103247011;
 Thu, 09 Dec 2021 18:27:27 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com> <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <CALTww29Q57wDf4eWn31ChaU4dW7A=DehdtVkL-8oyzfxnwZY6w@mail.gmail.com>
In-Reply-To: <CALTww29Q57wDf4eWn31ChaU4dW7A=DehdtVkL-8oyzfxnwZY6w@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Dec 2021 18:27:15 -0800
X-Gmail-Original-Message-ID: <CAPhsuW59g9mZNJ4mX8rviCnN6n3Ap8tA+215Ri+t727=3POKzw@mail.gmail.com>
Message-ID: <CAPhsuW59g9mZNJ4mX8rviCnN6n3Ap8tA+215Ri+t727=3POKzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
To:     Xiao Ni <xni@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 9, 2021 at 5:19 PM Xiao Ni <xni@redhat.com> wrote:
>
> On Fri, Dec 10, 2021 at 2:02 AM Song Liu <song@kernel.org> wrote:
> >
> > On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > It doesn't free memory when register integrity failed. And move
> > > free conf codes into a single function.
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  drivers/md/raid0.c | 18 +++++++++++++++---
> > >  1 file changed, 15 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > > index 62c8b6adac70..3fa47df1c60e 100644
> > > --- a/drivers/md/raid0.c
> > > +++ b/drivers/md/raid0.c
> > > @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
> > >         return array_sectors;
> > >  }
> > >
> > > +static void free_conf(struct r0conf *conf);
> > >  static void raid0_free(struct mddev *mddev, void *priv);
> > >
> > >  static int raid0_run(struct mddev *mddev)
> > > @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
> > >         dump_zones(mddev);
> > >
> > >         ret = md_integrity_register(mddev);
> > > +       if (ret)
> > > +               goto free;
> > >
> > >         return ret;
> > > +
> > > +free:
> > > +       free_conf(conf);
> >
> > Can we just use raid0_free() here? Also, after freeing conf,
>
> At first I used raid0_free too. But it looks strange after adding
> acct_bioset_exit
> in raid0_free. Because if creating stripe zones failed, it doesn't
> need to free conf,
> although it doesn't have problems that passes NULL to kfree.
>
I see. Let's add free_conf() then. Maybe we can move both free_conf()
and raid0_free() ahead to avoid the extra declaration?

Thanks,
Song
