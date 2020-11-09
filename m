Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E163C2D0A3
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 16:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B196D2074F
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 16:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBAHlmAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbgKIQuE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 11:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgKIQuE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Nov 2020 11:50:04 -0500
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C9922074F
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 16:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604940602;
        bh=7iVPt3glHPMa3jd20qkMaKsYffB/xpHT1uk8JgbeuUI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HBAHlmAi9pF3vCtBBSunWs1Qq8UkiG8+w7emAlc4mP/wF+5990qCPIv9O22Fj589J
         fQDkJUxkS2Zil9igeUgmWXBHLrYDiCFKuYOA8SzoL9N0dKhIOJbo/iJQMzDFvgNZKN
         3bfEhy5NmyKB2JvaDgw89BLP1PYRlNheLjg/0qbA=
Received: by mail-lf1-f42.google.com with SMTP id d17so9990924lfq.10
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 08:50:02 -0800 (PST)
X-Gm-Message-State: AOAM5333OGpUu0XM4Tsn6iLh5FKuI/7nGB0YXhf53ZRytY9QGAxTY+7k
        Sy87aKNO4ifQVqqG5N5U7eSJW7TVNvWy0ObSIoI=
X-Google-Smtp-Source: ABdhPJyzanzHDQqsCDUbap3UUyKXd/Lvnw3RiC0Xb8f+C3Hs9SkZyOmBjJkY6KNhCAjTeIWSRaJFxRQ4jpBwZIoOWlc=
X-Received: by 2002:a19:8497:: with SMTP id g145mr6158810lfd.504.1604940600747;
 Mon, 09 Nov 2020 08:50:00 -0800 (PST)
MIME-Version: 1.0
References: <CF84A11A-D1E2-4B7D-825A-C54E2C82B28F@purdue.edu>
 <CAPhsuW4swc4VXkpjVMqj6mzY1Uj7DiAPuf5e0PoY1B675ij4yw@mail.gmail.com> <CC257BF4-6B53-4BA3-BDFE-22B35FCDAB90@purdue.edu>
In-Reply-To: <CC257BF4-6B53-4BA3-BDFE-22B35FCDAB90@purdue.edu>
From:   Song Liu <song@kernel.org>
Date:   Mon, 9 Nov 2020 08:49:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7ttH8W94--u60S_uZSDTfCSfbHAsYLNT1JJnA2Hae7jQ@mail.gmail.com>
Message-ID: <CAPhsuW7ttH8W94--u60S_uZSDTfCSfbHAsYLNT1JJnA2Hae7jQ@mail.gmail.com>
Subject: Re: PROBLEM: a concurrency bug in drivers/md/md.c
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 6, 2020 at 5:06 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
>
> Sorry, we didn=E2=80=99t notice this patch. It does fix the issue!
>
> Thanks,
> Sishuai

Thanks for confirming this fix! This patch will get in upstream soon.

Song

>
> > On Nov 6, 2020, at 6:15 PM, Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Nov 6, 2020 at 10:58 AM Gong, Sishuai <sishuai@purdue.edu> wrot=
e:
> >>
> >>
> >> Hi,
> >>
> >> We found a concurrency bug in linux 5.3.11 that we were able to reprod=
uce in x86 under specific interleavings. This bug causes a warning message =
=E2=80=9CWARNING: linux-5.3.11/drivers/md/md.c:7279 md_ioctl+0x9cd/0x1b02=
=E2=80=9D.
> >>
> >> This bug is triggered when two kernel threads run the md_ioctl() funct=
ion on the same resource interleave with each other. The code sets the mdde=
v->flags to indicate that the resource is being modified and resets it afte=
r the modification. However, the current code allows another thread to exec=
ute after the mddev->flags is set but before it is reset, resulting in the =
warning message.
> >>
> >> ------------------------------------------
> >> Kernel console output
> >> [  140.524331] WARNING: CPU: 1 PID: 1815 at /tmp/tmp.B7zb7od2zE-5.3.11=
/extract/linux-5.3.11/drivers/md/md.c:7279 md_ioctl+0x9cd/0x1b02
> >> [  145.438749] Modules linked in:
> >> [  147.691130] CPU: 1 PID: 1815 Comm: ski-executor Not tainted 5.3.11 =
#1
> >> [  150.333839] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> >> [  153.712887] EIP: md_ioctl+0x9cd/0x1b02
> >> [  157.464368] Code: ff ff ff e8 0f ed 91 ff c6 45 84 01 e9 10 ff ff f=
f 8d 83 74 01 00 00 e8 75 33 24 00 c6 45 84 00 be f0 ff ff ff e9 3e f7 ff f=
f <0f> 0b eb bf b0 00 eb 02 b0 01 84 c0 0f 84 2c f7 ff ff 89 7c 24 0c
> >> [  168.813781] EAX: 00000002 EBX: f3df4800 ECX: f3df497c EDX: 00000002
> >> [  171.890615] ESI: 00000000 EDI: 00000932 EBP: e527be2c ESP: e527bd98
> >> [  175.465728] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00=
000202
> >> [  179.394439] CR0: 80050033 CR2: 08572568 CR3: 25242000 CR4: 00000690
> >> [  183.140588] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> >> [  186.578976] DR6: 00000000 DR7: 00000000
> >>
> >> ------------------------------------------
> >> Test input
> >>
> >> The bug is triggered when the same kernel test program is executed con=
currently by two different threads. In particular, it is triggered when the=
 system call md_ioctl() interleaves with itself.
> >>
> >> The test program is in Syzkaller=E2=80=99s format as follows:
> >> r0 =3D openat$md(0xffffffffffffff9c, &(0x7f0000000000)=3D'/dev/md0\x00=
', 0x0, 0x0)
> >> ioctl$BLKTRACETEARDOWN(r0, 0x932, 0x0)
> >>
> >>
> >>
> >> ------------------------------------------
> >> Interleaving
> >>
> >> Our analysis revealed that the following interleaving can trigger this=
 bug:
> >>
> >> Thread 1                                                              =
                          Thread 2
> >>                                                                       =
                         md_open()
> >>                                                                       =
                         -if (test_bit(MD_CLOSING, &mddev->flags)) {
> >>                                                                       =
                                 mutex_unlock(&mddev->open_mutex);
> >>                                                                       =
                                 err =3D -ENODEV;
> >>                                                                       =
                                 goto out;
> >>                                                                       =
                                 }
> >>                                                                       =
                         (condition is false)
> >>                                                                       =
                         -=E2=80=A6
> >>                                                                       =
                         -mutex_unlock(&mddev->open_mutex);
> >>                                                                       =
                         -=E2=80=A6
> >>                                                                       =
                         -return err;
> >>                                                                       =
                         (md_open finishes correctly)
> >> md_open()
> >> -if (test_bit(MD_CLOSING, &mddev->flags)) {
> >>        mutex_unlock(&mddev->open_mutex);
> >>        err =3D -ENODEV;
> >>        goto out;
> >> }
> >> (condition is false)
> >> -...
> >> -return err;
> >> (md_open finishes correctly)
> >>
> >> md_ioctl()
> >> (drivers/md/md.c:7279)
> >> -WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
> >> -set_bit(MD_CLOSING, &mddev->flags);
> >> -...
> >> -mutex_unlock(&mddev->open_mutex);
> >>                                                                       =
                         md_ioctl()
> >>                                                                       =
                         (drivers/md/md.c:7279)
> >>                                                                       =
                         -WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags))=
;
> >>                                                                       =
                         (warning message shows)
> >> (drivers/md/md.c:7347)
> >> -case STOP_ARRAY:
> >>       err =3D do_md_stop(mddev, 0, bdev);
> >>       goto unlock;
> >> (mddev->flags will be cleared inside do_md_stop())
> >>
> >
> > Thanks for the report. Could you please verify whether this commit
> > address this issue:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=
=3Dmd-next&id=3De7f1456b5ee4e97934ae724e7015d95f88984df0
> >
> > Thanks,
> > Song
>
