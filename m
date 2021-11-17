Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A664AC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 18:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8207E61BD4
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 18:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbhKQSN0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 13:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbhKQSN0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Nov 2021 13:13:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48713C061570
        for <linux-raid@vger.kernel.org>; Wed, 17 Nov 2021 10:10:27 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w1so15024053edc.6
        for <linux-raid@vger.kernel.org>; Wed, 17 Nov 2021 10:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zjlB3hrOFxaewC0B/0h8WdXl3O0vULDsbagiahTjDqQ=;
        b=h8l1wTBxnXmRydLOjGhT2N2V05WdEaZqC6pL6t0Rpa8f+RG0yqAHbdTZ94ZUzEWeuj
         ZRj25IttZdynBk3hwnKzjL2eSf6kZqSwB1agpw1XbYVh7sL1LMP9qpKWP1dja23nTz2y
         b8RG15f/8XW0HQd8x0laBJRlHWRfISaEmjMEUVelPIM3p73thcZNiYYPGDkIPuVhV64E
         J+MYbgFH3EaUTFyKLPdzitX8AAR8SnjRFKD8m/mj4R69ojUm55gj1gTlqITOQvWBMqhG
         cLT1LpFBuffXGNBCr3Vw6YTPhQVVzwsaWZpfgFJ13HxztPnaWBhgJ9OxXqyFNVbCfR+2
         k0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zjlB3hrOFxaewC0B/0h8WdXl3O0vULDsbagiahTjDqQ=;
        b=SU4hlsfCum+kVgH0vIXebd/Mg0AE9IoApbbmT4NV0HZa3ST555p3NDuocFs/Fxe6pF
         0RD3pnJCVFGyG1aFipSlS9oyOPQpDsfRE4KKLqnKVDi2ExWnUOg71L7ZNv/jhEOayiCV
         DyKcJMFQU0TrKbOcLjkd78PcAC92QV4l8rHpXF7XJQ4XI7r9OhejzNuhU/aH78UWb2mX
         k6Zv2EMHosfrVL2wFGzGhuqu2FdWx/aD0+9TJcpgXP3dDoMxQHA0/OthLV5lGZbrCZft
         LrLoXz+wJvU7JTI/k4rUH7fbD9M4ewQUHDmdj9FTLf1EEUV1QQFkswnC7BAzlGYDLkTg
         Y4JQ==
X-Gm-Message-State: AOAM533Pko6UChnV+gKcH5w4p5a/OMv4dheJfPFwm6EOsH3yA1Z6gR2C
        5c6BdIFYUQSxCs+6OqG+jc1tMU56zTI1iUruf6jDzLc=
X-Google-Smtp-Source: ABdhPJzpGjkMTP9OgSEAE1jjRv6MCjzDvicjX/W8vzPxghNyi/IYyy46345enJkHQ7dgwzPEAaxO/WQ0ENRCcSbfdT4=
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr24876854ejc.75.1637172625784;
 Wed, 17 Nov 2021 10:10:25 -0800 (PST)
MIME-Version: 1.0
References: <CAFPgooeJrvrNQcOQXUD82oc52rgB3DvH=JFzDVDMnfc+gs7nDg@mail.gmail.com>
 <06b0f87c-2d06-3f94-f0b3-19d631968fa0@youngman.org.uk>
In-Reply-To: <06b0f87c-2d06-3f94-f0b3-19d631968fa0@youngman.org.uk>
From:   Martin Thoma <thomamartin1985@googlemail.com>
Date:   Wed, 17 Nov 2021 19:10:14 +0100
Message-ID: <CAFPgoofZWN8d9O6LQ0LtKaOnU9yofvNAYO6AKxjrztqzod+doQ@mail.gmail.com>
Subject: Re: Failed Raid 5 - one Disk possibly Out of date - 2nd disk damaged
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks a lot.
Will try to get some new drives and do a dd and then will try to
assemble the Raid again.

The Drives are CMR Drives, a few Western Digital and Seagate drives.

Regards

Martin

Am Mi., 17. Nov. 2021 um 18:56 Uhr schrieb Wols Lists
<antlists@youngman.org.uk>:
>
> On 17/11/2021 12:22, Martin Thoma wrote:
> > Hi All,
> >
>
>
> >
> > So /dev/sdd1 was considered , when i ran the command again the raid
> > assembled without sdd1
> >
> > When i tried Reading Data after a while it stopped (propably when the
> > data was on /dev/sdc
> >
> > dmesg showed this:
> > [  368.433658] sd 8:0:0:1: [sdc] tag#0 FAILED Result: hostbyte=3DDID_OK
> > driverbyte=3DDRIVER_SENSE
> > [  368.433664] sd 8:0:0:1: [sdc] tag#0 Sense Key : Medium Error [curren=
t]
> > [  368.433669] sd 8:0:0:1: [sdc] tag#0 Add. Sense: Unrecovered read err=
or
> > [  368.433675] sd 8:0:0:1: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 00
> > 00 08 81 d8 00 00 00 08 00 00
> > [  368.433679] blk_update_request: critical medium error, dev sdc, sect=
or 557528
> > [  368.433689] raid5_end_read_request: 77 callbacks suppressed
> > [  368.433692] md/raid:md0: read error not correctable (sector 555480 o=
n sdc1).
> > [  375.944254] sd 8:0:0:1: [sdc] tag#0 FAILED Result: hostbyte=3DDID_OK
> > driverbyte=3DDRIVER_SENSE
> >
> > and the Raided stopped again.
> >
> > How can i force to assemble the raid including /dev/sdd1 and not
> > include /dev/sdc (because that drive is possibly damaged now)?
> > With a mdadm --create --assume-clean .. command?
>
> NO NO NO NO NO !!!
> >
> > I'm using  mdadm/zesty-updates,now 3.4-4ubuntu0.1 amd64 [installed] on
> > Linux version 4.10.0-21-generic (buildd@lgw01-12) (gcc version 6.3.0
> > 20170406 (Ubuntu 6.3.0-12ubuntu2) )
> >
> That's an old ubuntu? and an ancient mdadm 3.4?
>
> As a very first action, you need to source a much newer rescue disk!
>
> As a second action, if you think sdc and sdd are dodgy, then you need to
> replace them - use dd or ddrescue to do a brute-force copy.
>
> You don't mention what drives they are. Are they CMR? Are they suitable
> for raid? For replacement drives, I'd look at upsizing to 4TB for a bit
> of headroom maybe (or look at moving to raid 6). And look at Seagate
> IronWolf, WD Red *PRO*, or Toshiba N300. (Personally I'd pass on the WD .=
..)
>
> Once you've copied sdc and sdd, you can look at doing another force
> assemble, and you'll hopefully get your array back. At least the event
> count info implies damage to the array should be minimal.
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>
> Read, learn, and inwardly digest ...
>
> And DON'T do anything that will make changes to the disks - like a
> re-create!!!
>
> Cheers,
> Wol



--=20
With kind regards / Mit freundlichen Gr=C3=BC=C3=9Fen

Martin Thoma

G=C3=B6hrenstra=C3=9Fe 3
72414 Rangendingen

Cell:  0176 80 16 03 68

Mail:  Thoma-Martin@gmx.net
