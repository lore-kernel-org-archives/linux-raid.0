Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260C1C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 11:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiDFLvk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 07:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiDFLv1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 07:51:27 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4275747F01E
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 23:58:06 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-de3ca1efbaso1958039fac.9
        for <linux-raid@vger.kernel.org>; Tue, 05 Apr 2022 23:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XlA/s7tYmDkAS/6H8h6Ckw+VLfAJXqYxO/DzR4iJpOg=;
        b=HU9j6l37i5k7VtL4zsVEU8Gl109ym7jD/yR3alrWJAFdX9iEoJXrtFGF0SAeYSUXQ0
         uLpLnJj3oSyaZzDoffYnyijqbFaGgECmwQs8ad7mYaWDIxMHRu5Vgy27bCpv1z01FCR2
         Ky7zS8djdDVibRRsHR5GIkgr+J+mopaWGAlMM4metVJadbtt4mVF7fvE+dsISIzoOkFG
         WSzj6atzhJc35Qk1kUxxnZpP14VnKWpWSdIIs4Su8rGIWAlr38O0sWWGJt+XqGtkTZNm
         Kt3WT5hfDEN2Pm5dBPvP3L8OhsXrXej2mK4ZKqIra653wHrpo4ooo3HDoC/jET4eM4zX
         f8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XlA/s7tYmDkAS/6H8h6Ckw+VLfAJXqYxO/DzR4iJpOg=;
        b=nbjooihMh7spKslpBQcJjD7lhRdWirI1vjWWTzIeg5+iK5ZP5cQ9hqS2G+JbU18bbR
         O4+HQgabE61ZPuqM8Va6SqTeCVlcA4oEUBlIYPUqW7CO6uP9Ca6gUG1scYV2B5lv+Zj3
         3CYBn2B5EonckRJ7mOfO8EUSV8av3/8/VjUstpxaYE8h9spQ0vKksrDquDiWcyb65fhX
         XvzjKZgyVoaTyHmKmewY1f8YDaUbtJTP8EdbeV38mqUzxh4Xe1FuN9sQZRbwAza7wmOD
         gccQy6soYqIR5ubUqFJeMLcolZlfL70NreUyZKQlAWrvFJ3LL4TTmkZq9HuW/4Fh82Bv
         am/g==
X-Gm-Message-State: AOAM532V7eWNi282AWcX/JPotoGlybE4a0FBdGz/OM/IQFDK5MlSPuVh
        3x5XeYz7xDXp37CIHvLCyH5yZ4Qz+LZgS+5rOMbNUQpiog==
X-Google-Smtp-Source: ABdhPJy88RYm75MkdqNOeTJbmnnvgngw24M0SYTYMqwJNLvsk+QCT0uCx459iXqltY6TYL59ZRUX3GsPPZYVHgVGtUQ=
X-Received: by 2002:a05:6870:888a:b0:de:6122:2bea with SMTP id
 m10-20020a056870888a00b000de61222beamr3478531oam.130.1649228285541; Tue, 05
 Apr 2022 23:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com>
 <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net>
 <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net>
 <CANDfL1YiKq9aeUsrmdZyLb5Fy98Tifjcr_zZJY6a+LxyqKYKkA@mail.gmail.com> <1835444778.3678589.1649158202973.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <1835444778.3678589.1649158202973.JavaMail.zimbra@karlsbakk.net>
From:   Jorge Nunes <jorgebnunes@gmail.com>
Date:   Wed, 6 Apr 2022 07:57:54 +0100
Message-ID: <CANDfL1YZGU2BU0HySthiD84OBE4DH5zpki4Df-XFE5-Vna0BNg@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'll never forget to do a backup.

Thanks for your help.
Regards,
Jorge

Roy Sigurd Karlsbakk <roy@karlsbakk.net> escreveu no dia ter=C3=A7a,
5/04/2022 =C3=A0(s) 12:30:
>
> That's probably a good idea. Hope you get most of it out of there.
>
> And find a way to backup when you're done ;)
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
> > From: "Jorge Nunes" <jorgebnunes@gmail.com>
> > To: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
> > Cc: "Linux Raid" <linux-raid@vger.kernel.org>
> > Sent: Tuesday, 5 April, 2022 12:50:20
> > Subject: Re: RAID 1 to RAID 5 failure
>
> > Hi roy.
> >
> > Thank you for your time.
> >
> > Now, I'm doing a photorec on /dev/sda and /dev/sdd and I get better
> > results on (some) of the data recovered if I do it on top of /dev/md0.
> > I don't care anymore about recovering the filesystem, I just want to
> > maximize the quality of data recovered with photorec.
> >
> > Best regards,
> > Jorge
> >
> > Roy Sigurd Karlsbakk <roy@karlsbakk.net> escreveu no dia ter=C3=A7a,
> > 5/04/2022 =C3=A0(s) 10:17:
> >>
> >> I re-did these tests this morning, since I was unsure if I could have =
made some
> >> mistake last night - I was tired. There results were about the same - =
complete
> >> data loss.
> >>
> >> As for curiousity, I also tried to skip the expand phase after creatin=
g the
> >> initial raid5 on top of the raid1. After creating it, I stopped it and
> >> recreated the old raid1 with --assume-clean. This worked well - no err=
ors from
> >> mount or fsck.
> >>
> >> So I guess it was the mdadm --grow --raid-devices=3D4 that was the fin=
al nail in
> >> the coffin.
> >>
> >> I just hope you find a way to backup your files next time. I'm quite s=
ure we've
> >> all been there - thought we were smart enough or something and the shi=
t hit the
> >> fan and no - we weren't.
> >>
> >> Vennlig hilsen
> >>
> >> roy
> >> --
> >> Roy Sigurd Karlsbakk
> >> (+47) 98013356
> >> http://blogg.karlsbakk.net/
> >> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> >> --
> >> Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa=
 =C3=AD snj=C3=B3 rita.
> >>
> >> ----- Original Message -----
> >> > From: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
> >> > To: "Jorge Nunes" <jorgebnunes@gmail.com>
> >> > Cc: "Linux Raid" <linux-raid@vger.kernel.org>
> >> > Sent: Tuesday, 5 April, 2022 02:29:03
> >> > Subject: Re: RAID 1 to RAID 5 failure
> >>
> >> >> Didn't do a backup :-(
> >> >
> >> > First mistake=E2=80=A6 *Always* keep a backup (or three)
> >> >
> >> >>
> >> >> Unmount everything:
> >> >
> >> > No need - what you should have done, was just to grow the array by
> >> >
> >> > Partition the new drives exactly like the old ones
> >> > mdadm --add /dev/md0 /dev/sd[cd]1 # note that sd[cd] means sdc and s=
dd, but can
> >> > be written this way on the commandline
> >> > mdadm --grow --level=3D5 --raid-devices=3D4
> >> >
> >> > This would have grown and converted the array to raid5 without any d=
ata loss.
> >> >
> >> >> $ sudo mdadm --create /dev/md0 -a yes -l 5 -n 2 /dev/sda /dev/sdd
> >> >
> >> > As earlier mentioned, this is to create a new array, not a conversio=
n.
> >> >
> >> >> So, my question is: Is there a chance to redo the array correctly
> >> >> without losing the information inside? Is it possible to recover th=
e
> >> >> 'lost' partition that existed on RAID 1 to be able to do a convenie=
nt
> >> >> backup? Or the only chance is to have a correct disk alignment insi=
de
> >> >> the array to be able to use photorec to recover the files correctly=
?
> >> >
> >> > As mentioned, it doesn't look promising, but there are a few things =
that can be
> >> > tried.
> >> >
> >> > Your data may still reside on the sda1 and sdd1, but since it was co=
nverted to
> >> > RAID-5, the data would have been distributed among the two drives an=
d not being
> >> > the same on both. Further growing the raid, would move the data arou=
nd to the
> >> > other disks. I did a small test here on some vdisks to see if this c=
ould be
> >> > reversed somehow and see if I could find the original filesystem. I =
could - but
> >> > it was terribly corrupted, so not a single file remained.
> >> >
> >> > If this was valuable data, there might be a way to rescue them, but =
I fear a lot
> >> > is overwritten already. Others in here (or other places) may know mo=
re about
> >> > how to fix this, though. If you find out how, please tell. It'd be i=
nteresting
> >> > to learn :)
> >> >
> >> > PS: I have my personal notebook for technical stuff at
> >> > https://wiki.karlsbakk.net/index.php/Roy's_notes in case you might f=
ind that
> >> > interesting. There's quite a bit about storage there. Simply growing=
 a raid is
> >> > apparently forgotten, since I thought that was too simple. I'll add =
it.
> >> >
> >> > So hope you didn't lose too much valuable data
> >> >
> >> > Vennlig hilsen / Best regards
> >> >
> >> > roy
> >> > --
> >> > Roy Sigurd Karlsbakk
> >> > (+47) 98013356
> >> > --
> >> > I all pedagogikk er det essensielt at pensum presenteres intelligibe=
lt. Det er
> >> > et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 ek=
sessiv anvendelse av
> >> > idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adek=
vate og
> > > > relevante synonymer p=C3=A5 norsk.
