Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A0AC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 11 Feb 2022 07:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347678AbiBKHYK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:24:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiBKHYJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 02:24:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4316CB3D
        for <linux-raid@vger.kernel.org>; Thu, 10 Feb 2022 23:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644564248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QNElpUPSrydr8AvXjF2ZVgb8Ylh8izy++p1qisi96x4=;
        b=OVri9+tzkoXbuij1DRjnLiF+ZWir8GLkIghrtnZh7gNAWr59xI05CKRYK3UI6nWiHTlqS1
        YKIVbSDfkinKDLP035twKM3Oi3PbTN40Ka06baRokRwP6XxGNiscllhpFgwDRt2s+1PeCz
        WJLmoiEI0pykHooFQZEcOzuZY1wPKzI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-CQnFrOqYMyOrjHRDLxjKNg-1; Fri, 11 Feb 2022 02:24:04 -0500
X-MC-Unique: CQnFrOqYMyOrjHRDLxjKNg-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso4816339edt.20
        for <linux-raid@vger.kernel.org>; Thu, 10 Feb 2022 23:24:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNElpUPSrydr8AvXjF2ZVgb8Ylh8izy++p1qisi96x4=;
        b=ATmRimQNPed+6CSDLTCE/N75EpbftJ1Gl/Fdcwfzn14U6vzauOfh3ELiI+knZGN21H
         36e8fK2QNI+Z7suUFFrGadpc+Xv1OdZJOlusNNvFk3wqQWAnGfRKu+Z1GC9y08uF3fXG
         44/HNHvxeySUnwz73qAdnUrOfmJj+0lqBUA4NgTVcuRjSobQjQEY5XuM0uhqKvAJu6Y6
         ilk5W4kJnoYO1v/R4mKVdv4sQgei48fZXJVXvuEFBI+N6+SjX4FsxGQH0leTZltK+JnU
         WK4I2OQ491EXDrCQR+ae2uvuzVxLTnI87o1As9f/5Xc1GhHMKCx1MPLScoBiT8w4bvV8
         cjdA==
X-Gm-Message-State: AOAM533KZOpDWrZes9d5uqMvQ/La3ShkLqY/EmP/KuSqGmCpnEDGKgYh
        dunBJVkGa1baRYeYkrzohwNRMCdZ4o5j0ym2PfY7C5BQENImgIJzRiIjzWC6ku55K7E53xXzKeq
        miW3SjJL2dfdx1NptXZ1soUPW15PSTeW6nRDnvw==
X-Received: by 2002:a17:907:9804:: with SMTP id ji4mr276280ejc.716.1644564243526;
        Thu, 10 Feb 2022 23:24:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5OZEJtPRwI8o07wfJPx/oZtwEhRReI8uCntMZ8/Ny2lxj++HXpT0Vy03bVndlzzYceIT9tzxwBh/DCg7WMUw=
X-Received: by 2002:a17:907:9804:: with SMTP id ji4mr276271ejc.716.1644564243306;
 Thu, 10 Feb 2022 23:24:03 -0800 (PST)
MIME-Version: 1.0
References: <20220209104046.00004427@linux.intel.com> <CALTww2-OLe4y1kjBnz7CTBQiNerd-y9XrEc34rjO1sm5tEV5VA@mail.gmail.com>
In-Reply-To: <CALTww2-OLe4y1kjBnz7CTBQiNerd-y9XrEc34rjO1sm5tEV5VA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 11 Feb 2022 15:24:40 +0800
Message-ID: <CALTww2-+JcA24BAt5PkFyOG1Un_fU-Jxy2LpkCuRPk3ici1pbw@mail.gmail.com>
Subject: Re: fail_last_dev and FailFast/LastDev flag incompatibility
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

And for raid1/raid10, it looks like fail_last_dev and FailFast want to
do opposite things.
It can fail the last and it doesn't send a rewrite bio when
fail_last_dev is true. Because the
last dev has been set faulty. There is no meaning to send the rewrite
bio. So FailFast only
works when fail_last_dev is false.

On Fri, Feb 11, 2022 at 2:48 PM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Marisuz
>
> We don't need to consider MD_FAILFAST for raid456. Because only raid1
> and raid10 support it.
> MD_FAILFAST_SUPPORTED is only set in raid1_run/raid10_run. So LastDev
> only be useful for
> raid1/raid10. It should be good to only check Faulty here.
>
> Best Regards
> Xiao
>
> On Wed, Feb 9, 2022 at 5:40 PM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > Hi All,
> > During my work under failed arrays handling[1] improvements, I
> > discovered potential issue with "failfast" and metadata writes. In
> > commit message[2] Neil mentioned that:
> > "If we get a failure writing metadata but the device doesn't
> > fail, it must be the last device so we re-write without
> > FAILFAST".
> >
> > Obviously, this is not true for RAID456 (again)[1] but it is also not
> > true for RAID1 and RAID10 with "fail_las_dev"[3] functionality enabled.
> >
> > I did a quick check and can see that setter for "LastDev" flag is
> > called if "Faulty" on device is not set. I proposed some changes in the
> > area in my patchset[4] but after discussion we decided to drop changes
> > here. Current approach is not correct for all branches, so my proposal
> > is to change:
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 7b024912f1eb..3daec14ef6b2 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -931,7 +931,7 @@ static void super_written(struct bio *bio)
> >                 pr_err("md: %s gets error=%d\n", __func__,
> >                        blk_status_to_errno(bio->bi_status));
> >                 md_error(mddev, rdev);
> > -               if (!test_bit(Faulty, &rdev->flags)
> > +               if (test_bit(MD_BROKEN, mddev->flag)
> >                     && (bio->bi_opf & MD_FAILFAST)) {
> >                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> >                         set_bit(LastDev, &rdev->flags);
> >
> >
> > It will force "LastDev" to be set on every metadata rewrite if mddevice
> > is known to be failed.
> > Do you have any other suggestions?
> >
> > + Guoqing - author of fail_last_dev.
> > + Xiao - you are familiarized with FailFast so please take a look.
> >
> > [1]https://lore.kernel.org/linux-raid/CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com/T/#m8cf7c57429b6fd332220157186151900ce23865d
> > [2]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=46533ff7fefb7e9e3539494f5873b00091caa8eb
> > [3]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce
> > [4]https://lore.kernel.org/linux-raid/CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com/
> >
> > Thanks,
> > Mariusz
> >

