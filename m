Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254EDCA0FF6
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 21:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjIAVvh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 17:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350787AbjIAVqV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 17:46:21 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1337A1BE3
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 14:18:44 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4ff09632194so4295637e87.2
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 14:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693603123; x=1694207923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyap+8XGn485FLutas1T/bq3vkoElGnSmJz3p40/1Ek=;
        b=i/02q+V08kDD0Ca4brZhXPh5C4n9T3ZwhtgtjYsIp+DFNCO02FaXZO6QoVWLdDYmOX
         /dBCu/FTsCnZR3F5eQoKtzr6aM/iPDQNmdtnoweStPYNOBl59QZNFfPLtd05WWPYv5PX
         2lXFU86MxAe5v+oSMkev3zPOrx6pAYmkqXA9/JztLhAlhV9HLvcuWvyrmTYxMKYoO/tX
         fdQQZrA5cfrCjTVE1I99mgWSYJbwdqLDGFIHjVSkV+SY73/yX+Zx54flO6fqDsVjJHcf
         M78Ct9lurEzYpCTwwpW+OCyRF9XRg/ptn3UhHRnvmVG9LvMJ5a+h4OySTSF+4uXqLrsX
         9yVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693603123; x=1694207923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyap+8XGn485FLutas1T/bq3vkoElGnSmJz3p40/1Ek=;
        b=PvFfBxyzJXdDfbFhSEFqEw1YdSgQpcY9LoBWbQzO7IPrkF7PnFPxgf5PSIpuM6Ph6v
         ny8RwjGaDO70/Rdi97SF+ebHY1QR8ezvvkZLFaKAPKvLVdxk44irBxs4Bv+t1/J5C4s9
         RY9llD5vcVOuWGSuXjW/Ce5IaVHVU5pgCuxsd4A6Wqv5nx0FgOQFpaFKf8IcAyFvfUJ2
         E49B0iaQGLazcqKMnp6NLTm866bnY7gaeCmDZgHOPeEULW9mCUlTELACEEisCKYBIZIq
         D3yZbvzA51PKR3bYauncDEbtD4Mw0mvpvwVwtjLaO79LBqYFOvD96gWxb6PPZ16hFPIa
         75tA==
X-Gm-Message-State: AOJu0YzDJPjmN0/AskVrXPLNZFRKC7Ri09Epq0bsZs7Tk6rkls21FZ1t
        ZBvvpqez1XJ98Sm6DzMiUWtfz0sxM311R4z6V28p4q3rHtrjOQ==
X-Google-Smtp-Source: AGHT+IF05YkxM0aJvgIzfvjSj8/yY5v7qZRqRMb3KHLAJsaZXxmhdrjWF+SMqhDF+JZJNJj0Txzg7QZOwctYJQmSIpE=
X-Received: by 2002:a05:6512:3f1e:b0:4fe:ecd:4950 with SMTP id
 y30-20020a0565123f1e00b004fe0ecd4950mr2516024lfa.1.1693603122240; Fri, 01 Sep
 2023 14:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
 <20230902013700.4c969472@nvm> <CAGqmV7reuaeGNY3jz-8BjrmwTR3kmNzCXEa7JxouZ8v7t9QqnA@mail.gmail.com>
 <20230902020048.356667d4@nvm>
In-Reply-To: <20230902020048.356667d4@nvm>
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 04:17:46 +0700
Message-ID: <CAGqmV7oX90YGM8-XwS_yqT_Lk94_EMWKr0SpQ+cmrgVpywKdbA@mail.gmail.com>
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Sep 2, 2023 at 4:00=E2=80=AFAM Roman Mamedov <rm@romanrm.net> wrote=
:
>
> On Sat, 2 Sep 2023 03:43:42 +0700
> CoolCold <coolthecold@gmail.com> wrote:
>
> > > > md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> > > >       7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UU=
UU]
> > > >       [=3D>...................]  resync =3D  6.2% (466905632/750121=
2288)
> > > > finish=3D207.7min speed=3D564418K/sec
> > >
> > > Any difference if you use e.g. --chunk=3D1024?
> > Goes up to 1.4GB
> >
> > md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> >       7501209600 blocks super 1.2 1024K chunks 2 far-copies [4/4] [UUUU=
]
> >       [>....................]  resync =3D  0.4% (35959488/7501209600)
> > finish=3D86.4min speed=3D1438382K/sec
>
> Looks like you have found at least some bottleneck. Does it ever reach th=
e

Definitely there is a bottleneck and I very much doubt I'm the first
one facing this - NVMe drives with > 1GB/sec are quite widespread.

> RAID1 performance at some point if you raise it further to 4096, 8192 or =
more?

I can try, for sake of testing, but in terms of practical outcome -
let's imagine with 8MB chunks it reaches maximum - what to do with
that knowledge?

>
> It might also be worth it to try making the RAID with --assume-clean, and=
 then
> look at the actual array performance, not just the sync speed.
>
> > > How about a newer kernel (such as 6.1)?
> > Not applicable in my case- there is no test machine unluckily to play
> > around with non LTS and reboots. Upgrading to next HWE kernel may
> > happen though, which is 5.15.0-82-generic #91-Ubuntu.
> > Do you know any specific patches/fixes landed since 5.4?
>
> No idea. I guessed if you are just setting up a new server, it would be
> possible to slip in a reboot or a few. :)
Unluckily no - trying to speedup existing DB which is a master node in
this setup.

Full disclosure: I've actually done a "quick" test with those drives
handling the load - created RADI10/f2, added to VG, did pvmove for
mysql specific LV and observed. In terms of weighted io time, it
performed much better. Now, I've moved data back to "old" drives
(pvmove again) and preparing for "proper" not "quick" setup - NVME
sector size, XFS sunit/swidth change and so on.

>
> --
> With respect,
> Roman



--=20
Best regards,
[COOLCOLD-RIPN]
