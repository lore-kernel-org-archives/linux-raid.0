Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E00C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 16:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiEKQOU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 12:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344424AbiEKQOT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 12:14:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E03186D187
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 09:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652285656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fv+6txrgeLpg3ornmrUCSMXBZM7wKbE5CBLVE9pQtY4=;
        b=XDllsV04hvsfVLhqDnN20vkiyzWdBS1YiIUDunx3i/YH6dpoVITHxr4ZxPx4+Kwf0TkSDU
        DdyVdUXMBKOAL7mjdPAS4eNVTAJmuodRFbTx9/1XhtT6eBzxaQjD6XJpH6cZrVjEDZImQm
        T/290gDLB5Ip6WX+FZdfwuUfq65I6K0=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-Lp03RPSJNeqq1mtVAcjBgA-1; Wed, 11 May 2022 12:14:15 -0400
X-MC-Unique: Lp03RPSJNeqq1mtVAcjBgA-1
Received: by mail-oo1-f71.google.com with SMTP id t19-20020a4a96d3000000b003295d7ce159so1355467ooi.11
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 09:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fv+6txrgeLpg3ornmrUCSMXBZM7wKbE5CBLVE9pQtY4=;
        b=b2vMoq8cbhON/fTXYIC/UOlMspt/X7rLhZU/NGyAT1SoOlLnVTJaNCCf5Sy6z528q8
         /6GWLHXwJ4PBXrkAHA0rm1WRUQjNQDc6tw7LNRTARfZsNsOopErZQx32DpFD1gNp0QrS
         8Xw/1+yb8lsfBimyMsl7mOQ7U6WDKVHpsro9CjGFKgBFPdiZQcCmeoPSBMWSSLxrTRNa
         kzlgzza/GKaTdM24jAHS6y/LVL44318y3DCb5grUj3SPV7TLB6/hoo7WNzbCkzxoBGJS
         Ni0tZqjqSXBcC6TJkgMD4JAcJNjs9eN8ezw/kfC52J7FEdaGF0nRP/IVFIZXtEqEPHSD
         KWjw==
X-Gm-Message-State: AOAM530knY6f9eX9zJOO2vCte2oN+EZ+vuqrqQKQo64CEzJONN2PtCo5
        mi6Q4llIfW3RKpkmnjdU5zQDPlOSYvheaUS56t9YlwbVGwr2ZaVKVUuimRIefZZsBnDp4H8OXgu
        ovXvc/8sMA67eZMSXZOm0KT72fyfwnbNdtfDYNg==
X-Received: by 2002:a4a:de4b:0:b0:35e:bac9:807f with SMTP id z11-20020a4ade4b000000b0035ebac9807fmr10067298oot.16.1652285654422;
        Wed, 11 May 2022 09:14:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqXwOFO/oRuikUJEf3+SUx5Y+K6u/QYkW1+RAdPn0I+BTtlgfVoGnIpEteDSGjzZsO/0F0/nabhCIjy+23w7A=
X-Received: by 2002:a4a:de4b:0:b0:35e:bac9:807f with SMTP id
 z11-20020a4ade4b000000b0035ebac9807fmr10067284oot.16.1652285654016; Wed, 11
 May 2022 09:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <1651208967-4701-1-git-send-email-xni@redhat.com> <CAPhsuW7J3EQde_XGdysjNGjHjEb+Zq2kXwXsj+4xpXBA_Bq2Eg@mail.gmail.com>
In-Reply-To: <CAPhsuW7J3EQde_XGdysjNGjHjEb+Zq2kXwXsj+4xpXBA_Bq2Eg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 12 May 2022 00:15:03 +0800
Message-ID: <CALTww2_hyAH+EJc=EymgcBwhTCQpddy500eqZf=qr_r4=H8Y6w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't set mddev private to NULL in raid0 pers->free
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Fine Fan <ffan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 9, 2022 at 2:24 PM Song Liu <song@kernel.org> wrote:
>
> Hi Xiao,
>
> Thanks for the patch!
>
> On Thu, Apr 28, 2022 at 10:09 PM Xiao Ni <xni@redhat.com> wrote:
> >
>
> prefix the subject with "md:", and provide more details.

Hi Song

Thanks for pointing about this and I will add "md:" in v2.
>
> > It panics when reshaping from raid0 to other raid levels. raid0 sets
> > mddev->private to NULL. It's the reason that causes the problem.
> > Function level_store finds new pers and create new conf, then it
> > calls oldpers->free. In oldpers->free, raid0 sets mddev->private
> > to NULL again. And __md_stop is the right position to set
> > mddev->private to NULL.
>
> We need more details here: the panic backtrace, and why it panics.
> raid5_free also sets private to NULL. Does it has the same problem?

The backtrace will be added in v2.

I don't find raid5_free sets mddev->private to NULL.
The normal process of stopping a raid should be like this:

do_md_stop
       |
__md_stop  (pers->free(); mddev->private=NULL)
       |
md_free (free biosets of mddev; free mddev)

personality raid doesn't set mddev->private to NULL. __md_stop does this job.
Reshaping from raid0 to raid other raid level doesn't stop the raid.
The new raid
will go on working. Now raid0_free->free_conf sets mddev->private to NULL during
reshape. The new raid can't work anymore. It will panic when dereference
mddev->private because of NULL pointer dereference.


>
> >
> > And this patch also deletes double free memory codes. io_acct_set
> > is free in pers->free.
>
> Please put this part in a separate patch.

will do this in v2

Regards
Xiao

>
> Thanks,
> Song
>
> >
> > Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
> > Reported-by: Fine Fan <ffan@redhat.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  drivers/md/md.c    | 4 ----
> >  drivers/md/raid0.c | 1 -
> >  2 files changed, 5 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 707e802..55b6412e 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5598,8 +5598,6 @@ static void md_free(struct kobject *ko)
> >
> >         bioset_exit(&mddev->bio_set);
> >         bioset_exit(&mddev->sync_set);
> > -       if (mddev->level != 1 && mddev->level != 10)
> > -               bioset_exit(&mddev->io_acct_set);
> >         kfree(mddev);
> >  }
> >
> > @@ -6285,8 +6283,6 @@ void md_stop(struct mddev *mddev)
> >         __md_stop(mddev);
> >         bioset_exit(&mddev->bio_set);
> >         bioset_exit(&mddev->sync_set);
> > -       if (mddev->level != 1 && mddev->level != 10)
> > -               bioset_exit(&mddev->io_acct_set);
> >  }
> >
> >  EXPORT_SYMBOL_GPL(md_stop);
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index e11701e..5fa0d40 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -362,7 +362,6 @@ static void free_conf(struct mddev *mddev, struct r0conf *conf)
> >         kfree(conf->strip_zone);
> >         kfree(conf->devlist);
> >         kfree(conf);
> > -       mddev->private = NULL;
> >  }
> >
> >  static void raid0_free(struct mddev *mddev, void *priv)
> > --
> > 2.7.5
> >
>

