Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0034BC388F3
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 10:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiDEKKK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 06:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiDEJah (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 05:30:37 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129BAE33AC
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 02:17:14 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id CDD833C1DC9;
        Tue,  5 Apr 2022 11:17:12 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id XzdUqyM_YV6W; Tue,  5 Apr 2022 11:17:11 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 11A333C1DCA;
        Tue,  5 Apr 2022 11:17:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 11A333C1DCA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1649150231;
        bh=iXDBKhoV0H43Aa5TLP4URcTiEqzXyK+Ru2Q7paRpGZQ=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=kDRWy53GcjhaRGRxXfB6RJLKJHJ3Hn8xpIzMLcj/F/7P+k4nCu/NU4Kqo76F+Gqq6
         ZZtc/lAoP/8gE5p0Iaxz6rnG3rIejAOgDl6w6/DLOSqP7PcKPa24TXxPyFDRP1bCbs
         1whFT2dJurIei4DwLv/ydTAqshPrTXOSTXelHmkLTE/a/8GZE61abyt1CAvePuHsX6
         w22uML8b/tcQW3v5zLxGFRLEXIjdnIcnfnvu9AoYut373Ba+62Sf+zkneyKqUclrw7
         PID1kJtqjVFZUlqMww9qhXIYyOfk+BKN94znoRyXwSXn8Vx7JFq+KHe0PuKYOvqJBo
         WJHqzaFEm1Cuw==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id fhIUwCM7fFkk; Tue,  5 Apr 2022 11:17:10 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id B39653C1DC9;
        Tue,  5 Apr 2022 11:17:10 +0200 (CEST)
Date:   Tue, 5 Apr 2022 11:17:10 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Jorge Nunes <jorgebnunes@gmail.com>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net>
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com> <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net>
Subject: Re: RAID 1 to RAID 5 failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:700:700:403::8:10d2]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF98 (Mac)/8.8.10_GA_3786)
Thread-Topic: RAID 1 to RAID 5 failure
Thread-Index: zbJcSRc3ib4HoPi+/Se2lY7m8Hjiin5bunMp
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I re-did these tests this morning, since I was unsure if I could have made =
some mistake last night - I was tired. There results were about the same - =
complete data loss.

As for curiousity, I also tried to skip the expand phase after creating the=
 initial raid5 on top of the raid1. After creating it, I stopped it and rec=
reated the old raid1 with --assume-clean. This worked well - no errors from=
 mount or fsck.

So I guess it was the mdadm --grow --raid-devices=3D4 that was the final na=
il in the coffin.

I just hope you find a way to backup your files next time. I'm quite sure w=
e've all been there - thought we were smart enough or something and the shi=
t hit the fan and no - we weren't.

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
> From: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
> To: "Jorge Nunes" <jorgebnunes@gmail.com>
> Cc: "Linux Raid" <linux-raid@vger.kernel.org>
> Sent: Tuesday, 5 April, 2022 02:29:03
> Subject: Re: RAID 1 to RAID 5 failure

>> Didn't do a backup :-(
>=20
> First mistake=E2=80=A6 *Always* keep a backup (or three)
>=20
>>=20
>> Unmount everything:
>=20
> No need - what you should have done, was just to grow the array by
>=20
> Partition the new drives exactly like the old ones
> mdadm --add /dev/md0 /dev/sd[cd]1 # note that sd[cd] means sdc and sdd, b=
ut can
> be written this way on the commandline
> mdadm --grow --level=3D5 --raid-devices=3D4
>=20
> This would have grown and converted the array to raid5 without any data l=
oss.
>=20
>> $ sudo mdadm --create /dev/md0 -a yes -l 5 -n 2 /dev/sda /dev/sdd
>=20
> As earlier mentioned, this is to create a new array, not a conversion.
>=20
>> So, my question is: Is there a chance to redo the array correctly
>> without losing the information inside? Is it possible to recover the
>> 'lost' partition that existed on RAID 1 to be able to do a convenient
>> backup? Or the only chance is to have a correct disk alignment inside
>> the array to be able to use photorec to recover the files correctly?
>=20
> As mentioned, it doesn't look promising, but there are a few things that =
can be
> tried.
>=20
> Your data may still reside on the sda1 and sdd1, but since it was convert=
ed to
> RAID-5, the data would have been distributed among the two drives and not=
 being
> the same on both. Further growing the raid, would move the data around to=
 the
> other disks. I did a small test here on some vdisks to see if this could =
be
> reversed somehow and see if I could find the original filesystem. I could=
 - but
> it was terribly corrupted, so not a single file remained.
>=20
> If this was valuable data, there might be a way to rescue them, but I fea=
r a lot
> is overwritten already. Others in here (or other places) may know more ab=
out
> how to fix this, though. If you find out how, please tell. It'd be intere=
sting
> to learn :)
>=20
> PS: I have my personal notebook for technical stuff at
> https://wiki.karlsbakk.net/index.php/Roy's_notes in case you might find t=
hat
> interesting. There's quite a bit about storage there. Simply growing a ra=
id is
> apparently forgotten, since I thought that was too simple. I'll add it.
>=20
> So hope you didn't lose too much valuable data
>=20
> Vennlig hilsen / Best regards
>=20
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibelt. D=
et er
> et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 eksessi=
v anvendelse av
> idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvate =
og
> relevante synonymer p=C3=A5 norsk.
