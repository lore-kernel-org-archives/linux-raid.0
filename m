Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23FCC46467
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 12:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbiDEMzQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359146AbiDELRy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 07:17:54 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5C4B53D2
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 03:50:32 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id z8so12973716oix.3
        for <linux-raid@vger.kernel.org>; Tue, 05 Apr 2022 03:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IJuULAWG/1FoMVqzHQX34K6xZh/Bayqguu7zyUUS81A=;
        b=WP90U6H3kg4IkJK+XU4uOMDLabMOTjjhMVQdCMsSClpQ95f3n+gSAGwXok55ow7MrW
         490a/i4ghNafyIy8SQKYU+QXf6k4rfulAfGBh1xST4eK91dnOfUCYoHWQcFJ2BGYEyRe
         kSN9jqnFw2FNiK5elx0ZDUiK/BrA/wKbNb9WB9WT3bzDgl4hKAbfgqVeFQ9l1eXtuB3O
         c1tF617cYQjSkEGJeG87braG457aVV/eALR/6pSgx+HndyRUi1kkM20KC6IUVzofvwfT
         BCwfdtu2cW1SfdNEriym6fIIn6Ye/w6YazLg4Xzj7BG+7BnqWfW13pChzvojIONf4L2a
         eLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IJuULAWG/1FoMVqzHQX34K6xZh/Bayqguu7zyUUS81A=;
        b=lrBWh76xKadf9jejYonFPUARUe/wilZuE2ICIKqPEIf130S7itJOxiwFhd2xiHkHVm
         sRvpsT1b2gPMcue1V+cKr5mIhooeabIikPynxtQ3DV8q9rQY270mbZaK8pgD3VyxZIWc
         yn24fD/uhCLj9ipcYHa/eR7i6EV8qRti62GwfQgSxxCJNoZ73bxTIFJ4JSEFtfGxoquu
         uB/43aFNn2RpiEGd2AKMOGOmVenJYVhOTGI2U6EJga1DF/7MJGXBe9zxjhvfqc1KG9OV
         MGXSCGVj4MVls2BFJzOyUeR1QT24X3Jgwpl5LyS5ocl8fsUcVX5JTOx3PK9h8edEcji9
         YSaw==
X-Gm-Message-State: AOAM533ZJ7tL+d2fmDuaE54OVHBJpiBWzyRvXl8vXHthtVf5Z3P7XTdU
        8e9JWDwcEkwWBNvP1TQAD4zUy9V0le4HLgGZykuQhzhDdQ==
X-Google-Smtp-Source: ABdhPJwrgAoJ/KNVOr8OKzLOFlFiPNt1YsG/thQ5w5AJXrGVDDZu7oD9PLhMyE48tJWwZtshqPQ+YOhqZI0llTn9fto=
X-Received: by 2002:a05:6808:14c2:b0:2f7:43eb:c824 with SMTP id
 f2-20020a05680814c200b002f743ebc824mr1028541oiw.154.1649155831719; Tue, 05
 Apr 2022 03:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com>
 <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net> <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net>
From:   Jorge Nunes <jorgebnunes@gmail.com>
Date:   Tue, 5 Apr 2022 11:50:20 +0100
Message-ID: <CANDfL1YiKq9aeUsrmdZyLb5Fy98Tifjcr_zZJY6a+LxyqKYKkA@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi roy.

Thank you for your time.

Now, I'm doing a photorec on /dev/sda and /dev/sdd and I get better
results on (some) of the data recovered if I do it on top of /dev/md0.
I don't care anymore about recovering the filesystem, I just want to
maximize the quality of data recovered with photorec.

Best regards,
Jorge

Roy Sigurd Karlsbakk <roy@karlsbakk.net> escreveu no dia ter=C3=A7a,
5/04/2022 =C3=A0(s) 10:17:
>
> I re-did these tests this morning, since I was unsure if I could have mad=
e some mistake last night - I was tired. There results were about the same =
- complete data loss.
>
> As for curiousity, I also tried to skip the expand phase after creating t=
he initial raid5 on top of the raid1. After creating it, I stopped it and r=
ecreated the old raid1 with --assume-clean. This worked well - no errors fr=
om mount or fsck.
>
> So I guess it was the mdadm --grow --raid-devices=3D4 that was the final =
nail in the coffin.
>
> I just hope you find a way to backup your files next time. I'm quite sure=
 we've all been there - thought we were smart enough or something and the s=
hit hit the fan and no - we weren't.
>
> Vennlig hilsen
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =
=C3=AD snj=C3=B3 rita.
>
> ----- Original Message -----
> > From: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
> > To: "Jorge Nunes" <jorgebnunes@gmail.com>
> > Cc: "Linux Raid" <linux-raid@vger.kernel.org>
> > Sent: Tuesday, 5 April, 2022 02:29:03
> > Subject: Re: RAID 1 to RAID 5 failure
>
> >> Didn't do a backup :-(
> >
> > First mistake=E2=80=A6 *Always* keep a backup (or three)
> >
> >>
> >> Unmount everything:
> >
> > No need - what you should have done, was just to grow the array by
> >
> > Partition the new drives exactly like the old ones
> > mdadm --add /dev/md0 /dev/sd[cd]1 # note that sd[cd] means sdc and sdd,=
 but can
> > be written this way on the commandline
> > mdadm --grow --level=3D5 --raid-devices=3D4
> >
> > This would have grown and converted the array to raid5 without any data=
 loss.
> >
> >> $ sudo mdadm --create /dev/md0 -a yes -l 5 -n 2 /dev/sda /dev/sdd
> >
> > As earlier mentioned, this is to create a new array, not a conversion.
> >
> >> So, my question is: Is there a chance to redo the array correctly
> >> without losing the information inside? Is it possible to recover the
> >> 'lost' partition that existed on RAID 1 to be able to do a convenient
> >> backup? Or the only chance is to have a correct disk alignment inside
> >> the array to be able to use photorec to recover the files correctly?
> >
> > As mentioned, it doesn't look promising, but there are a few things tha=
t can be
> > tried.
> >
> > Your data may still reside on the sda1 and sdd1, but since it was conve=
rted to
> > RAID-5, the data would have been distributed among the two drives and n=
ot being
> > the same on both. Further growing the raid, would move the data around =
to the
> > other disks. I did a small test here on some vdisks to see if this coul=
d be
> > reversed somehow and see if I could find the original filesystem. I cou=
ld - but
> > it was terribly corrupted, so not a single file remained.
> >
> > If this was valuable data, there might be a way to rescue them, but I f=
ear a lot
> > is overwritten already. Others in here (or other places) may know more =
about
> > how to fix this, though. If you find out how, please tell. It'd be inte=
resting
> > to learn :)
> >
> > PS: I have my personal notebook for technical stuff at
> > https://wiki.karlsbakk.net/index.php/Roy's_notes in case you might find=
 that
> > interesting. There's quite a bit about storage there. Simply growing a =
raid is
> > apparently forgotten, since I thought that was too simple. I'll add it.
> >
> > So hope you didn't lose too much valuable data
> >
> > Vennlig hilsen / Best regards
> >
> > roy
> > --
> > Roy Sigurd Karlsbakk
> > (+47) 98013356
> > --
> > I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er
> > et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 ekses=
siv anvendelse av
> > idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvat=
e og
> > relevante synonymer p=C3=A5 norsk.
