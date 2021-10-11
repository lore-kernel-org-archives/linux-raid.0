Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904ACC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 11 Oct 2021 09:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 704C860EDF
	for <linux-raid@archiver.kernel.org>; Mon, 11 Oct 2021 09:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbhJKJov (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Oct 2021 05:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbhJKJos (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Oct 2021 05:44:48 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E27C061570
        for <linux-raid@vger.kernel.org>; Mon, 11 Oct 2021 02:42:48 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id y19so809150vsm.9
        for <linux-raid@vger.kernel.org>; Mon, 11 Oct 2021 02:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=elyOSwXUmSlTdb1/CJiGdQ6bWf9yMdIVeAywc3qURWQ=;
        b=wXcBHZKBoqVbo1hwNG+hikkfLkaxFwTo24yKdtKlLZNxYqDDjDtZAWGDErzVBSEs78
         GvWp5LDT+GM5DI4XnDDbgcZzXfuvyvMokDtHEUvfseBpueCpHy9F0JzcdGAnE8nP5fzH
         mjOfuKQVqwVVtfZgEtGm7Y4oc4J7VXCaFqgnj1mQmlG0a9KInuTHVvp4Yov0Gz4uS3yZ
         ngwh6MfllMT7cKDgJX19KmgREIynarYDLsElbPtFyXuDYjPp3kxaXckubeUKyf+V5YQx
         dUcUgQF2kZNVaq8HrEEZByv5qEkMgfe01edsSIq1QSLINHYt4GfXEZv0KkkK6ZQpHrTR
         nGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=elyOSwXUmSlTdb1/CJiGdQ6bWf9yMdIVeAywc3qURWQ=;
        b=3PpT5RQis8d2gdnwGX8r8Q45vy3MR2pYtYmkFOdDCRYmFmcB1GCt9ebV0QhNvpNbzQ
         N/3qYRixmj3ydwmSu7b2A26CJFTyXMjieyjM9sKTbKvO0lwj5zqhcWXw7DMidT6TKH0Y
         99V6POTuoV9CgsW5zMacBkzpghPYiIOVATaBTBhXgWKZq3YtgQXbqjpuMf1cFFzhJPQ7
         QqqRIRS9+gbu9bEzDj5lAwG/r2lUv44/PsZBp73/sSzLHWJDcZwkz4a7/XhRjwe9VbSj
         JITdeFGlfxgDOBn0Eh6TAGb9T8Ybox1rU6V+AiIAJjeqnmQe6Zz0INsZ43wKYDQmlhiT
         7ysg==
X-Gm-Message-State: AOAM5305GPiPFDwduwCzZcRyVFXY7jFoKJ2+h96ELCF0DcXM+Lea6st3
        /Mx/jEA/5YLJXkT+pcdvigsJMP78nMfk9FIR3/37Mw==
X-Google-Smtp-Source: ABdhPJzrQ6F83mHYri4ahs7UbpwEco4J1CLexA6Bt25RLqrWz1tpazLW7QI6Kf0/0jyLoNpVqjlnLoad+TWIHderEgA=
X-Received: by 2002:a05:6102:222b:: with SMTP id d11mr21378183vsb.20.1633945367425;
 Mon, 11 Oct 2021 02:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
In-Reply-To: <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Mon, 11 Oct 2021 17:42:35 +0800
Message-ID: <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=A5=E5=91=
=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:49=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi all
>
> Now the per device sysfs interface file state can change failfast. Do
> we need a new file for failfast?
>
> I did a test. The steps are:
>
> mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
> cd /sys/block/md0/md/dev-sdb
> echo failfast > state
> cat state
> in_sync,failfast

This works,  will it be persisted to disk?

>
> Best Regards
> Xiao
>
> On Sat, Oct 9, 2021 at 7:36 AM Song Liu <song@kernel.org> wrote:
> >
> > On Thu, Oct 7, 2021 at 8:22 PM Li Feng <fengli@smartx.com> wrote:
> > >
> > > When the running RAID1/RAID10 need to be set with the fail_fast flag,
> > > we have to remove each device from RAID and re-add it again with the
> > > --fail_fast flag.
> > >
> > > Export the fail_fast flag to the userspace to support the read and
> > > write.
> > >
> > > Signed-off-by: Li Feng <fengli@smartx.com>
> >
> > Thanks for the patch! I applied it to md-next, with some changes in the
> > commit log.
> >
> > Thanks,
> > Song
> >
>
