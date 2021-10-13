Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FDDC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 07:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60AA60E97
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 07:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbhJMIAO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:00:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232692AbhJMIAO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 04:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634111891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uwSRG5VpgF9GMHGYBZADyWxlcRVpODekeZlTKT4bouc=;
        b=BNAJoRA/Ap7iRKT6sC2/UGWXObnewhfhZWqPG3vZe/HeQg2YsAiR6QuhUQ+IIVfDbmcvaR
        jncQzrizIy1IfCt/CxPUkeaIXht1nTR9ZQhUnyKSx1vbJ8e5P3OeJCcoGFovvchheDcq5E
        lx5Mx2TSz8/oysLDz369NhkdQG20Xes=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-CkbqzXSNOByFCkrOkYjHtA-1; Wed, 13 Oct 2021 03:58:10 -0400
X-MC-Unique: CkbqzXSNOByFCkrOkYjHtA-1
Received: by mail-ed1-f69.google.com with SMTP id f4-20020a50e084000000b003db585bc274so1460718edl.17
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 00:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uwSRG5VpgF9GMHGYBZADyWxlcRVpODekeZlTKT4bouc=;
        b=GD4jyYSX5vETvQTXEQeCIwaejLihMiHX+6XxB4xQwhftHRgUg3dXPsCatplwU9gVLa
         Gz9IZLaVbw7Lrz7IjEj3k4C2If5hdLGwQza9YL5feKv/aPkWmCyDSd8gT5GWhAM6FNJr
         g+rD/yn54Ed5oLxwcY3X/QLLZJU+B1Jnqg9TXBdSE9oobzyeWIhNRdd81UZBM+y2zUxI
         8vBtVW5gi6Tau3arxAFQv8itleXrE1YvnIBz8+20EccqvAXfXr4/4Y/Utbs+ws9xONON
         bFK16I3xLP4IxolNJV3+ePYYTwyc8oiKyn/bdr6KLnma9+3Y1xtPwEywUbUBy8g0NC9Y
         JR3Q==
X-Gm-Message-State: AOAM533bLY8i7XNCWKy5ERDPck651u25tWe2fgha+zCbSOd+FNeAucSi
        4hW8dhBvN0v2+UJJiNvGQkA5pIEHFrYpiCjN++Ptf4BXiI3WgxwgXK4ZhWmquIPcQIoGVFvZCMv
        JwRsPtvBhgIbHOQ9iDAqBtgLpzmqyUyyv7fGR8Q==
X-Received: by 2002:a17:906:6d0a:: with SMTP id m10mr37614242ejr.90.1634111888515;
        Wed, 13 Oct 2021 00:58:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiR77ZWt17w0FdzUumhatfva+RqZ5nCNAG7etUI8DT4C/RC/+Tasmj+lgu/Ql9RQxad4oOgH9u1PWtUmX6RII=
X-Received: by 2002:a17:906:6d0a:: with SMTP id m10mr37614226ejr.90.1634111888338;
 Wed, 13 Oct 2021 00:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
 <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
 <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
 <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com>
 <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
 <CAHckoCxRj1qb=yfeQ2o_8n_BSSLD9JXqm8GopUp2qx9NEPxr7w@mail.gmail.com>
 <CALTww2_eScuqd4yUtDFhaRUGAK-f8J_L=yOZdTVA9uZ7Tq4bxg@mail.gmail.com> <CAHckoCys6_SG56jzuK0OfFwKb6BtBsUhpp6A70hOKFSeVTWU-Q@mail.gmail.com>
In-Reply-To: <CAHckoCys6_SG56jzuK0OfFwKb6BtBsUhpp6A70hOKFSeVTWU-Q@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 13 Oct 2021 15:57:57 +0800
Message-ID: <CALTww29m_RQHbZY6owX2y1_rmOeCEL9rSWg4=shnnitA1RpWQg@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Li Feng <fengli@smartx.com>
Cc:     Song Liu <song@kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 12, 2021 at 5:14 PM Li Feng <fengli@smartx.com> wrote:
> >          sysfs_notify_dirent_safe(rdev->sysfs_state);
> > +    if (need_update_sb)
> > +        if (mddev->pers) {
> > +            set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> > +            md_wakeup_thread(mddev->thread);
> > +        }
> When will mddev->pers is NULL?

The process of creating a raid device is:
1. md_ioctl->md_add_new_disk
2. md_ioctl->do_md_run->md_run->(pers->run)->(mddev->pers = pers)
In md_add_new_disk it creates the per device sysfs files. It can
read/write these
files before setting mddev->pers.

> If it is NULL, this change will not on disk.

I did a test. You are right. Someone can change the per device state
before ADD_NEW_DISK
and RUN_ARRAY ioctl. Please note, the mdadm --create command doesn't
return until RUN_ARRAY
ioctl finishes. Even though the are small, we can try to set MD_SB_CHANGE_DEVS.

Best regards
Xiao

