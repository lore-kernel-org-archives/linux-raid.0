Return-Path: <SRS0=g69Z=EM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC36C2D0A3
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 23:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 632B720867
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604704548;
	bh=77MlmP2XqNoJ5d0nP6XJl60DoojyLYk0GcJi+67pMDg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=1coRSFW55eYIWkRck8qeNgd0b97nOMHmsunv2gZ3YEOYORQDYopF/EV5FuijhQmbT
	 uboBD48bbqSFr9xnFphNuE0JfM0Gc2A25rpYiDTy3B8MRts/vEkVXLv8GZ77PE9LWR
	 vrN/rhKW6TFarwwQ0IFC6/78B+7oS99DUccpRbYc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgKFXPr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbgKFXPr (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 6 Nov 2020 18:15:47 -0500
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F028820867
        for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2020 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604704546;
        bh=77MlmP2XqNoJ5d0nP6XJl60DoojyLYk0GcJi+67pMDg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jm6b+hqfO3dR8u0m4Plo6cXimURv5TBOZJzVqyPTOPCGm6CrIFqJ5pL9y98g2n9mi
         lcLGfjUAurRxLaT/yAc7mxc6WyGbIe1SrDXJM6N825VKW9olOjAnjCY00j6793Pr/M
         NWEe+eRcfSawPFYncGgTi/jiI0HetOonh0BtOPG0=
Received: by mail-lf1-f47.google.com with SMTP id r19so1849703lfe.6
        for <linux-raid@vger.kernel.org>; Fri, 06 Nov 2020 15:15:45 -0800 (PST)
X-Gm-Message-State: AOAM531U6qFmDlKAKUm7ph8FnGntkops6tnFL776rwXM4qMAJ45Mbpc1
        awmiZpTcdanFPbLDEtewYEd0WNLDCYXcyTpxVzE=
X-Google-Smtp-Source: ABdhPJz/cCJXJTeALbLAZ3WIVgHix1QTi/lY17IzYnk0PpjP0EJuqWoTFqjHSVA1a+KxVDGRC5pftztf8R2BR395/cE=
X-Received: by 2002:a19:4b45:: with SMTP id y66mr1634712lfa.482.1604704544129;
 Fri, 06 Nov 2020 15:15:44 -0800 (PST)
MIME-Version: 1.0
References: <CF84A11A-D1E2-4B7D-825A-C54E2C82B28F@purdue.edu>
In-Reply-To: <CF84A11A-D1E2-4B7D-825A-C54E2C82B28F@purdue.edu>
From:   Song Liu <song@kernel.org>
Date:   Fri, 6 Nov 2020 15:15:32 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4swc4VXkpjVMqj6mzY1Uj7DiAPuf5e0PoY1B675ij4yw@mail.gmail.com>
Message-ID: <CAPhsuW4swc4VXkpjVMqj6mzY1Uj7DiAPuf5e0PoY1B675ij4yw@mail.gmail.com>
Subject: Re: PROBLEM: a concurrency bug in drivers/md/md.c
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 6, 2020 at 10:58 AM Gong, Sishuai <sishuai@purdue.edu> wrote:
>
>
> Hi,
>
> We found a concurrency bug in linux 5.3.11 that we were able to reproduce=
 in x86 under specific interleavings. This bug causes a warning message =E2=
=80=9CWARNING: linux-5.3.11/drivers/md/md.c:7279 md_ioctl+0x9cd/0x1b02=E2=
=80=9D.
>
> This bug is triggered when two kernel threads run the md_ioctl() function=
 on the same resource interleave with each other. The code sets the mddev->=
flags to indicate that the resource is being modified and resets it after t=
he modification. However, the current code allows another thread to execute=
 after the mddev->flags is set but before it is reset, resulting in the war=
ning message.
>
> ------------------------------------------
> Kernel console output
> [  140.524331] WARNING: CPU: 1 PID: 1815 at /tmp/tmp.B7zb7od2zE-5.3.11/ex=
tract/linux-5.3.11/drivers/md/md.c:7279 md_ioctl+0x9cd/0x1b02
> [  145.438749] Modules linked in:
> [  147.691130] CPU: 1 PID: 1815 Comm: ski-executor Not tainted 5.3.11 #1
> [  150.333839] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  153.712887] EIP: md_ioctl+0x9cd/0x1b02
> [  157.464368] Code: ff ff ff e8 0f ed 91 ff c6 45 84 01 e9 10 ff ff ff 8=
d 83 74 01 00 00 e8 75 33 24 00 c6 45 84 00 be f0 ff ff ff e9 3e f7 ff ff <=
0f> 0b eb bf b0 00 eb 02 b0 01 84 c0 0f 84 2c f7 ff ff 89 7c 24 0c
> [  168.813781] EAX: 00000002 EBX: f3df4800 ECX: f3df497c EDX: 00000002
> [  171.890615] ESI: 00000000 EDI: 00000932 EBP: e527be2c ESP: e527bd98
> [  175.465728] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00000=
202
> [  179.394439] CR0: 80050033 CR2: 08572568 CR3: 25242000 CR4: 00000690
> [  183.140588] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  186.578976] DR6: 00000000 DR7: 00000000
>
> ------------------------------------------
> Test input
>
> The bug is triggered when the same kernel test program is executed concur=
rently by two different threads. In particular, it is triggered when the sy=
stem call md_ioctl() interleaves with itself.
>
> The test program is in Syzkaller=E2=80=99s format as follows:
> r0 =3D openat$md(0xffffffffffffff9c, &(0x7f0000000000)=3D'/dev/md0\x00', =
0x0, 0x0)
> ioctl$BLKTRACETEARDOWN(r0, 0x932, 0x0)
>
>
>
> ------------------------------------------
> Interleaving
>
> Our analysis revealed that the following interleaving can trigger this bu=
g:
>
> Thread 1                                                                 =
                       Thread 2
>                                                                          =
                       md_open()
>                                                                          =
                       -if (test_bit(MD_CLOSING, &mddev->flags)) {
>                                                                          =
                               mutex_unlock(&mddev->open_mutex);
>                                                                          =
                               err =3D -ENODEV;
>                                                                          =
                               goto out;
>                                                                          =
                               }
>                                                                          =
                       (condition is false)
>                                                                          =
                       -=E2=80=A6
>                                                                          =
                       -mutex_unlock(&mddev->open_mutex);
>                                                                          =
                       -=E2=80=A6
>                                                                          =
                       -return err;
>                                                                          =
                       (md_open finishes correctly)
> md_open()
> -if (test_bit(MD_CLOSING, &mddev->flags)) {
>         mutex_unlock(&mddev->open_mutex);
>         err =3D -ENODEV;
>         goto out;
> }
> (condition is false)
> -...
> -return err;
> (md_open finishes correctly)
>
> md_ioctl()
> (drivers/md/md.c:7279)
> -WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
> -set_bit(MD_CLOSING, &mddev->flags);
> -...
> -mutex_unlock(&mddev->open_mutex);
>                                                                          =
                       md_ioctl()
>                                                                          =
                       (drivers/md/md.c:7279)
>                                                                          =
                       -WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
>                                                                          =
                       (warning message shows)
> (drivers/md/md.c:7347)
> -case STOP_ARRAY:
>        err =3D do_md_stop(mddev, 0, bdev);
>        goto unlock;
> (mddev->flags will be cleared inside do_md_stop())
>

Thanks for the report. Could you please verify whether this commit
address this issue:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=3Dmd-=
next&id=3De7f1456b5ee4e97934ae724e7015d95f88984df0

Thanks,
Song
