Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B281BC4167E
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 12:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiDEMzN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383042AbiDEMRx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 08:17:53 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B7CD4466
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 04:30:14 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 316493C1DC9;
        Tue,  5 Apr 2022 13:30:13 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id JDJFmhaeblPS; Tue,  5 Apr 2022 13:30:09 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 7EAB03C1DD6;
        Tue,  5 Apr 2022 13:30:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 7EAB03C1DD6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1649158209;
        bh=b/thDgml5bJLrJZ4mmPPdsu9YdHB4DWOVC+nFhE7ujM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=cwl6JJWkCuHUPALV1U3hDLYsQCoawllrFd1AUmQA9+fOuBaOgaZ+mHaZM+wQsQZgE
         qqJ9j5TmM95+5COokzMRPoKeVSFjj65YswaKmy4ak+z/k+OU2sFkc3DTiqQu4gcFZn
         gOV9OpzjmU3gDQK8Y54m7zyizxkZ3mD0t7dtbAqVEvgzfBa5BVQScgHSa/vedDqvGA
         A3bbOKCC0KuWCtZwV/aePL9lIIFSX/V7pCxSV5FENQXb0khV5SuZB2ruwrRwNBrMhI
         mTpNwmGq/sVJjIrZHUvUydfrMfKl36p1y/J6HnEBtZwybFiPV8P3Gl3CRsoW0HYdUS
         qhUtiwvLb0Qhg==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id GfW5RNa3lemu; Tue,  5 Apr 2022 13:30:08 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 83A1D3C1DD1;
        Tue,  5 Apr 2022 13:30:07 +0200 (CEST)
Date:   Tue, 5 Apr 2022 13:30:03 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Jorge Nunes <jorgebnunes@gmail.com>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <1835444778.3678589.1649158202973.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <CANDfL1YiKq9aeUsrmdZyLb5Fy98Tifjcr_zZJY6a+LxyqKYKkA@mail.gmail.com>
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com> <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net> <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net> <CANDfL1YiKq9aeUsrmdZyLb5Fy98Tifjcr_zZJY6a+LxyqKYKkA@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:700:700:403::8:10d2]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF98 (Mac)/8.8.10_GA_3786)
Thread-Topic: RAID 1 to RAID 5 failure
Thread-Index: roc84SVRQL9DDuvtAnq9EEvDgLPb4A==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

That's probably a good idea. Hope you get most of it out of there.

And find a way to backup when you're done ;)

Vennlig hilsen

roy
--=20
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.

----- Original Message -----
> From: "Jorge Nunes" <jorgebnunes@gmail.com>
> To: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
> Cc: "Linux Raid" <linux-raid@vger.kernel.org>
> Sent: Tuesday, 5 April, 2022 12:50:20
> Subject: Re: RAID 1 to RAID 5 failure

> Hi roy.
>=20
> Thank you for your time.
>=20
> Now, I'm doing a photorec on /dev/sda and /dev/sdd and I get better
> results on (some) of the data recovered if I do it on top of /dev/md0.
> I don't care anymore about recovering the filesystem, I just want to
> maximize the quality of data recovered with photorec.
>=20
> Best regards,
> Jorge
>=20
> Roy Sigurd Karlsbakk <roy@karlsbakk.net> escreveu no dia ter=C3=A7a,
> 5/04/2022 =C3=A0(s) 10:17:
>>
>> I re-did these tests this morning, since I was unsure if I could have ma=
de some
>> mistake last night - I was tired. There results were about the same - co=
mplete
>> data loss.
>>
>> As for curiousity, I also tried to skip the expand phase after creating =
the
>> initial raid5 on top of the raid1. After creating it, I stopped it and
>> recreated the old raid1 with --assume-clean. This worked well - no error=
s from
>> mount or fsck.
>>
>> So I guess it was the mdadm --grow --raid-devices=3D4 that was the final=
 nail in
>> the coffin.
>>
>> I just hope you find a way to backup your files next time. I'm quite sur=
e we've
>> all been there - thought we were smart enough or something and the shit =
hit the
>> fan and no - we weren't.
>>
>> Vennlig hilsen
>>
>> roy
>> --
>> Roy Sigurd Karlsbakk
>> (+47) 98013356
>> http://blogg.karlsbakk.net/
>> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
>> --
>> Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =
=C3=AD snj=C3=B3 rita.
>>
>> ----- Original Message -----
>> > From: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
>> > To: "Jorge Nunes" <jorgebnunes@gmail.com>
>> > Cc: "Linux Raid" <linux-raid@vger.kernel.org>
>> > Sent: Tuesday, 5 April, 2022 02:29:03
>> > Subject: Re: RAID 1 to RAID 5 failure
>>
>> >> Didn't do a backup :-(
>> >
>> > First mistake=E2=80=A6 *Always* keep a backup (or three)
>> >
>> >>
>> >> Unmount everything:
>> >
>> > No need - what you should have done, was just to grow the array by
>> >
>> > Partition the new drives exactly like the old ones
>> > mdadm --add /dev/md0 /dev/sd[cd]1 # note that sd[cd] means sdc and sdd=
, but can
>> > be written this way on the commandline
>> > mdadm --grow --level=3D5 --raid-devices=3D4
>> >
>> > This would have grown and converted the array to raid5 without any dat=
a loss.
>> >
>> >> $ sudo mdadm --create /dev/md0 -a yes -l 5 -n 2 /dev/sda /dev/sdd
>> >
>> > As earlier mentioned, this is to create a new array, not a conversion.
>> >
>> >> So, my question is: Is there a chance to redo the array correctly
>> >> without losing the information inside? Is it possible to recover the
>> >> 'lost' partition that existed on RAID 1 to be able to do a convenient
>> >> backup? Or the only chance is to have a correct disk alignment inside
>> >> the array to be able to use photorec to recover the files correctly?
>> >
>> > As mentioned, it doesn't look promising, but there are a few things th=
at can be
>> > tried.
>> >
>> > Your data may still reside on the sda1 and sdd1, but since it was conv=
erted to
>> > RAID-5, the data would have been distributed among the two drives and =
not being
>> > the same on both. Further growing the raid, would move the data around=
 to the
>> > other disks. I did a small test here on some vdisks to see if this cou=
ld be
>> > reversed somehow and see if I could find the original filesystem. I co=
uld - but
>> > it was terribly corrupted, so not a single file remained.
>> >
>> > If this was valuable data, there might be a way to rescue them, but I =
fear a lot
>> > is overwritten already. Others in here (or other places) may know more=
 about
>> > how to fix this, though. If you find out how, please tell. It'd be int=
eresting
>> > to learn :)
>> >
>> > PS: I have my personal notebook for technical stuff at
>> > https://wiki.karlsbakk.net/index.php/Roy's_notes in case you might fin=
d that
>> > interesting. There's quite a bit about storage there. Simply growing a=
 raid is
>> > apparently forgotten, since I thought that was too simple. I'll add it=
.
>> >
>> > So hope you didn't lose too much valuable data
>> >
>> > Vennlig hilsen / Best regards
>> >
>> > roy
>> > --
>> > Roy Sigurd Karlsbakk
>> > (+47) 98013356
>> > --
>> > I all pedagogikk er det essensielt at pensum presenteres intelligibelt=
. Det er
>> > et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 ekse=
ssiv anvendelse av
>> > idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekva=
te og
> > > relevante synonymer p=C3=A5 norsk.
