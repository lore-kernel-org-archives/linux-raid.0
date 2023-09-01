Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14AECA0FEC
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 21:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350770AbjIAVBS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 17:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350791AbjIAVBP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 17:01:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FC31728
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 13:59:47 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-500aed06ffcso4052771e87.0
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 13:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693601985; x=1694206785; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuFEmicRHmVfv/+eElMyAhxfl5k/aDgHJrY1O7UHpUI=;
        b=LE/8Znl3jR91jdO/NYbfK1qKio17TGtGIiRjcajQERJQtPfacNIabh339alCBCQ0YI
         53TuZVh5hqV7NlrOrg5Ric+N4Y3ISd1Bixyokzq7Yam4tZVVEE/7iPGJ0AyzicYPrkN5
         FLYmHvtgXZ5YbCbJzcLkCmgXVs4HCGyZR78BxnwhQLGrDiUrKLxwcAH6WHi0TxkTko/4
         OerNd8OBShrtLJlFMT6bCdZTi3slB1apD+AhecArEU4Uzw4FNxQgeR5I+wceRsCVhP5N
         Ca6CdPXCzEr2YvkPyvREzZSiAhJuVq3h93Ub7jWgrjrgeUOabXTw3IAYvvTKUWVSE3NX
         hPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693601985; x=1694206785;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iuFEmicRHmVfv/+eElMyAhxfl5k/aDgHJrY1O7UHpUI=;
        b=jCuPj1vGd6aKoL1tydjAVowOaVSfretmHPjdEJpAHnIDUVwTVfk7E+r1CtmshGcqMd
         jXe+Ml75bu+4RyrAToqIkg0fvz/cm2IarnamCuoaJqaZ1TkiMgwrTXQHZpIgWaNn+6Yx
         aao1nUWXHvp1U8PQ0Fw0WcbWtZKxDy1m6FEnzG/8EOaUxt4xmOGuvVhg/+XbOMNQB6SE
         g/Rz2R4KdrLzbp/NqqjZnAA4bwnTOLhheARnnP3XqoAo1yKAC+xf2E7VyU1QWboyP7Hp
         5DHKANhWsC75Lo/+rApawiQP7uFMQ7lVF+u8ob79Iz1PFcVnRf2nazfXW5pgsPK+go78
         v/7w==
X-Gm-Message-State: AOJu0YzJS0hTya3kdNX84Xvsz5vWgBPiPeXpBO7Sp7eBrkIunjAsly2+
        XAwo4ylEqqG6B3U/ReFnZV3DkULClRh2Q94EKVdAa5Ava3n3ig==
X-Google-Smtp-Source: AGHT+IH6F00NhnmJJxgN1SYR7gVoBy6Tm4NdhFWpywYlGWGxz0Jm4tk7XIZfs8jEicIgNvkcJrG0mrHNs/r/cKR3bOs=
X-Received: by 2002:ac2:4d8e:0:b0:500:bdca:c6ba with SMTP id
 g14-20020ac24d8e000000b00500bdcac6bamr2194975lfe.64.1693601985158; Fri, 01
 Sep 2023 13:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
In-Reply-To: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 03:58:50 +0700
Message-ID: <CAGqmV7o7pmXRwjng0S=6wZ-UycRRW4unPTmhvPSoKJmyc++_rg@mail.gmail.com>
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For statistics, the same everything except layout:

Offset: around 700-780MB/sec
created: mdadm --create /dev/md3 --run -b none --level=3D10 --layout=3Do2
--chunk=3D16 --raid-devices=3D4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
/dev/nvme5n1

md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
      7501212288 blocks super 1.2 16K chunks 2 offset-copies [4/4] [UUUU]
      [>....................]  resync =3D  1.5% (119689152/7501212288)
finish=3D156.3min speed=3D786749K/sec

near:around 700MB/sec
created: mdadm --create /dev/md3 --run -b none --level=3D10 --layout=3Dn2
--chunk=3D16 --raid-devices=3D4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
/dev/nvme5n1

md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
      7501212320 blocks super 1.2 16K chunks 2 near-copies [4/4] [UUUU]
      [>....................]  resync =3D  0.5% (42373104/7501212320)
finish=3D175.7min speed=3D707262K/sec

On Sat, Sep 2, 2023 at 3:23=E2=80=AFAM CoolCold <coolthecold@gmail.com> wro=
te:
>
> Good day!
>
> I have 4 NVMe new drives which are planned to replace 2 current NVMe
> drives, serving primarily as MYSQL storage, Hetzner dedicated server
> AX161 if it matters. Drives are SAMSUNG MZQL23T8HCLS-00A07, 3.8TB .
> System - Ubuntu 20.04 / 5.4.0-153-generic #170-Ubuntu
>
> So the strange thing I do observe, is its initial raid sync speed.
> Created with:
> mdadm --create /dev/md3 --run -b none --level=3D10 --layout=3Df2
> --chunk=3D16 --raid-devices=3D4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
> /dev/nvme5n1
>
> sync speed:
>
> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
>       7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
>       [=3D>...................]  resync =3D  6.2% (466905632/7501212288)
> finish=3D207.7min speed=3D564418K/sec
>
> If I try to create RAID1 with just two drives - sync speed is around
> 3.2GByte per second, sysclt is tuned of course:
> dev.raid.speed_limit_max =3D 8000000
>
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> [raid4] [raid10]
> md70 : active raid1 nvme4n1[1] nvme5n1[0]
>       3750606144 blocks super 1.2 [2/2] [UU]
>       [>....................]  resync =3D  1.5% (58270272/3750606144)
> finish=3D19.0min speed=3D3237244K/sec
>
> From iostat, drives are basically doing just READs, no writes.
> Quick tests with fio, mounting single drive shows it can do around 30k
> IOPS with 16kb ( fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> --directory=3Dtest-data --size=3D8200m --bs=3D16k --name=3Dmytest ) so li=
kely
> issue are not drives themselves.
>
> Not sure where to look further, please advise.
>
> --
> Best regards,
> [COOLCOLD-RIPN]



--=20
Best regards,
[COOLCOLD-RIPN]
