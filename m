Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71634CA0FFC
	for <linux-raid@archiver.kernel.org>; Sat,  2 Sep 2023 06:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351598AbjIBGIC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Sep 2023 02:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjIBGIC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Sep 2023 02:08:02 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FC810F5
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 23:07:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-500d13a8fafso4836224e87.1
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 23:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693634877; x=1694239677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kk26C4u224R1+B84B4+Pjf/8D5UNBGa9AYBgvk4Q1hE=;
        b=VSRbGtxWoKBNxgbPJ1WrHhUy5/C8Nxq59JQ6qs7Ng0018/5BqBsyOvB17TQQfcSSA/
         uNJbufmsMfLZlwJwrbM/D7XlsIQbE9jb11ZFoIgFRREgGb+P5EXYIV1ORD2t+93igNWr
         1oRjrtEBk9IEdqHq1NeLdb0GFqsMiRZi+GWaqdBW3jYZdG2XwQ2F3UnPInL8nhZ76Plo
         9xt3x9k5RYp13jc4iI806m1+9PqJogxqvlep3Fye3qHXxThZph4e588Bmbl6QoJZgKtn
         sDf/vZSqXPupydTKRQ1x2dDIGxz5ymTtYh64loDPbui36EZwBsFYz4FPtakQa046FjAl
         jJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693634877; x=1694239677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kk26C4u224R1+B84B4+Pjf/8D5UNBGa9AYBgvk4Q1hE=;
        b=CqQKlyJBuWwdYqDp6RO/1EQeu7WVHhEyxI4nbDoCRf8y3D/ECPdZy/gz2PO+IG9TCk
         ZOoEtP/GsoUHn8RmD8prFa9kIjP9233zBLwmLbW2e90KIQQhIMxW2L1VbplXXBgvek3H
         MuABTwmrzC+WKh+7NYGvaHdZU7AfPWUq2Pcvcqz5HlfOreZZlkW3yGbis6oG9U7Ds2BX
         k55gOrumlIqwCe/JWWVzDow63l7JzHJBImWKRdu4obfy8sFTbr9w8mQzLtsmf9cqRQuM
         c0iCqza7Ari8/znybPnDRh4kKX2i22e2Edepne5YGKUh8gu8ehg+P4LlfbScpWVCoM6i
         nUaQ==
X-Gm-Message-State: AOJu0YzPlXt+Ed7UPxlJmxR91/Ad4nTy9QAsd5Tdd8RDj5GfuStkV42E
        whbFqp+owTefpY87pHmmo1tIzdiwdPYkX57ly3rVms3VCoc=
X-Google-Smtp-Source: AGHT+IECs5m3gVDFoi5Wkc5wtZ0cQoIbjgLflj8KKmGXokoMuq2VBLH/IKvvaJcFNTYbFEBePK5QAHkz8Fl1IQZmhys=
X-Received: by 2002:a19:9118:0:b0:4fb:9712:a717 with SMTP id
 t24-20020a199118000000b004fb9712a717mr2856130lfd.13.1693634876902; Fri, 01
 Sep 2023 23:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
 <7a10a252-46be-4921-7a68-59b2e0dca570@huaweicloud.com>
In-Reply-To: <7a10a252-46be-4921-7a68-59b2e0dca570@huaweicloud.com>
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 13:07:01 +0700
Message-ID: <CAGqmV7opNzLp+Zbp__bS0ctQQ2M2tPSe_W1vBWXghFpwCFrcUA@mail.gmail.com>
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good day!
No, no other activities happened during initial sync - at least I have
not done anything. In iostat it were only read operations as well.


On Sat, 2 Sept 2023, 10:57 Yu Kuai, <yukuai1@huaweicloud.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2023/09/02 4:23, CoolCold =E5=86=99=E9=81=93:
> > Good day!
> >
> > I have 4 NVMe new drives which are planned to replace 2 current NVMe
> > drives, serving primarily as MYSQL storage, Hetzner dedicated server
> > AX161 if it matters. Drives are SAMSUNG MZQL23T8HCLS-00A07, 3.8TB .
> > System - Ubuntu 20.04 / 5.4.0-153-generic #170-Ubuntu
> >
> > So the strange thing I do observe, is its initial raid sync speed.
> > Created with:
> > mdadm --create /dev/md3 --run -b none --level=3D10 --layout=3Df2
> > --chunk=3D16 --raid-devices=3D4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
> > /dev/nvme5n1
> >
> > sync speed:
> >
> > md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> >        7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
> >        [=3D>...................]  resync =3D  6.2% (466905632/750121228=
8)
> > finish=3D207.7min speed=3D564418K/sec
> >
> Is there any read/write to the array? Because for raid10, normal io
> can't concurrent with sync io, brandwidth will be bad if they both exit,
> specially for old kernels.
>
> Thanks,
> Kuai
>
> > If I try to create RAID1 with just two drives - sync speed is around
> > 3.2GByte per second, sysclt is tuned of course:
> > dev.raid.speed_limit_max =3D 8000000
> >
> > Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> > [raid4] [raid10]
> > md70 : active raid1 nvme4n1[1] nvme5n1[0]
> >        3750606144 blocks super 1.2 [2/2] [UU]
> >        [>....................]  resync =3D  1.5% (58270272/3750606144)
> > finish=3D19.0min speed=3D3237244K/sec
> >
> >>From iostat, drives are basically doing just READs, no writes.
> > Quick tests with fio, mounting single drive shows it can do around 30k
> > IOPS with 16kb ( fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> > --directory=3Dtest-data --size=3D8200m --bs=3D16k --name=3Dmytest ) so =
likely
> > issue are not drives themselves.
> >
> > Not sure where to look further, please advise.
> >
>
