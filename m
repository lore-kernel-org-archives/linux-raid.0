Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8D5CA0FF8
	for <linux-raid@archiver.kernel.org>; Sat,  2 Sep 2023 06:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjIBGkK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Sep 2023 02:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345784AbjIBGkK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Sep 2023 02:40:10 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24591702
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 23:40:06 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-500b0f06136so4896946e87.0
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 23:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693636805; x=1694241605; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOMBDCY2mDKehJWt3gdtUmcN7fVGLeFIAISfC5dxIko=;
        b=ZV9GxA5pgEFoF+Nde2ds6bm1HNYlv+pfO3geOw5Man3XOpD5d5An3AcK60jlAXLAOA
         spL3nO2wFY++bLjfkDI38sNXG08tVE8AMQ4Z+04dVfKV8Oi/LISd6EkPpPZm3syT1nt+
         sh7E3y0HCX3qOjC9qgLMgCWwnv7zEMwXlKbIr1qhksgOLhatEZOIgmejzWOsPguvjE+L
         P5/nFmF64jgLQz09fGoLgqx76lnFJsmhvMJUal8oiCHzUwfv6bk9A877noSuPqSuWUnj
         /QUup3pyfufV9tKq/i32y8ui4qVIj/Np+AyZMy7Jdwqst+mUBdpzRCPUTIJqMBDEN7Gy
         pTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693636805; x=1694241605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOMBDCY2mDKehJWt3gdtUmcN7fVGLeFIAISfC5dxIko=;
        b=YEzF9gRfqbZSSuxrbxu8NEhmJllpCzEt0AF4rbITNkDeWD6UqJ/uDfus1POfu1v1Ql
         /haH997Lyf2z6pQhSe190SZpHUYpPg9oBUq/zFIqBhiB+COq0YD2bJihqngmt81MjGUt
         pzx6OQDg1hG9TwA+RTWvOit/FQBuVgtLlNaNezEyEg3dKGVxgGPg91f4NeHnp9nER1Eb
         SWdWyyRqZuwRx/FtCHecz11vIZgMy5oAp0bo+kN/jWq/LnEpWOF4f2/cDbkWgxc3Rlpk
         IYYLJBUn2ZRzeUIuS01ur2o43NlzlO3cAhaLjmiApuVvVQvWzXlwdfeJXA0UF1ylYB2W
         ar6w==
X-Gm-Message-State: AOJu0YxZbbDFaTXlYbyu8gKgs8xHKI+mg2f+7/fD1j2dxxv78zc8Ltvn
        kWewsSD/b4hdsD1WHhgPunUpsuePhzIbDGi9dJdB4JQU+gnQEQ==
X-Google-Smtp-Source: AGHT+IEMLDCAIAzzetqhf45tNphodamrD2iXhaTxzrWbZQildm93pgkk0nFoYAbId9lImPCepp/rB8JuogUoL3fbLy0=
X-Received: by 2002:a05:6512:32b5:b0:500:7d05:552a with SMTP id
 q21-20020a05651232b500b005007d05552amr2942430lfe.53.1693636804630; Fri, 01
 Sep 2023 23:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
 <7a10a252-46be-4921-7a68-59b2e0dca570@huaweicloud.com> <CAGqmV7opNzLp+Zbp__bS0ctQQ2M2tPSe_W1vBWXghFpwCFrcUA@mail.gmail.com>
 <7e920033-be0b-ef0b-a1b7-6c9611b339a0@huaweicloud.com>
In-Reply-To: <7e920033-be0b-ef0b-a1b7-6c9611b339a0@huaweicloud.com>
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 13:39:08 +0700
Message-ID: <CAGqmV7qk-th9QcdeLdp8rRC+oSiuPSwAuxbZnHM7s0Sc1K5JzQ@mail.gmail.com>
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Makes some sense, but from my perspective not much sense - in any
practical case I can remember, creating a FRESH/NEW array silently
assumes you want to have it be filled by zeroes. When you care about
actual drive content - there is an "assume-clean" option.

Will option like "--fill-with-zeroes" make sense to do "no compare"
and just write the same data on all drives?

My current drives are relatively small - 3.8TB, but 15TB and 30TB
NVMes exist and I hardly can imagine provisioning such server where
raid10 sync will take WEEK?

Highly likely I'm not the first one facing this behavior and larger
market players have already met something of this sort.

On Sat, Sep 2, 2023 at 1:13=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/09/02 14:07, CoolCold =E5=86=99=E9=81=93:
> > Good day!
> > No, no other activities happened during initial sync - at least I have
> > not done anything. In iostat it were only read operations as well.
> >
> I think this is because resync is different for raid1 and raid10,
>
> In raid1, just read from one rdev and write to the other rdev.
>
> In raid10, resync must read from all rdev first, and then compare and
> write if contents is different, it is obvious that raid10 will be slower
> if contents is different. However, I do feel this behavior is strange,
> because contents is likely different in initial sync.
>
> Thanks,
> Kuai
>
> >
> > On Sat, 2 Sept 2023, 10:57 Yu Kuai, <yukuai1@huaweicloud.com> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/09/02 4:23, CoolCold =E5=86=99=E9=81=93:
> >>> Good day!
> >>>
> >>> I have 4 NVMe new drives which are planned to replace 2 current NVMe
> >>> drives, serving primarily as MYSQL storage, Hetzner dedicated server
> >>> AX161 if it matters. Drives are SAMSUNG MZQL23T8HCLS-00A07, 3.8TB .
> >>> System - Ubuntu 20.04 / 5.4.0-153-generic #170-Ubuntu
> >>>
> >>> So the strange thing I do observe, is its initial raid sync speed.
> >>> Created with:
> >>> mdadm --create /dev/md3 --run -b none --level=3D10 --layout=3Df2
> >>> --chunk=3D16 --raid-devices=3D4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n=
1
> >>> /dev/nvme5n1
> >>>
> >>> sync speed:
> >>>
> >>> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> >>>         7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UU=
UU]
> >>>         [=3D>...................]  resync =3D  6.2% (466905632/750121=
2288)
> >>> finish=3D207.7min speed=3D564418K/sec
> >>>
> >> Is there any read/write to the array? Because for raid10, normal io
> >> can't concurrent with sync io, brandwidth will be bad if they both exi=
t,
> >> specially for old kernels.
> >>
> >> Thanks,
> >> Kuai
> >>
> >>> If I try to create RAID1 with just two drives - sync speed is around
> >>> 3.2GByte per second, sysclt is tuned of course:
> >>> dev.raid.speed_limit_max =3D 8000000
> >>>
> >>> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> >>> [raid4] [raid10]
> >>> md70 : active raid1 nvme4n1[1] nvme5n1[0]
> >>>         3750606144 blocks super 1.2 [2/2] [UU]
> >>>         [>....................]  resync =3D  1.5% (58270272/375060614=
4)
> >>> finish=3D19.0min speed=3D3237244K/sec
> >>>
> >>> >From iostat, drives are basically doing just READs, no writes.
> >>> Quick tests with fio, mounting single drive shows it can do around 30=
k
> >>> IOPS with 16kb ( fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> >>> --directory=3Dtest-data --size=3D8200m --bs=3D16k --name=3Dmytest ) s=
o likely
> >>> issue are not drives themselves.
> >>>
> >>> Not sure where to look further, please advise.
> >>>
> >>
> >
> > .
> >
>


--=20
Best regards,
[COOLCOLD-RIPN]
