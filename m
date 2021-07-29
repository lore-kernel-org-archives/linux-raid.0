Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006E9C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jul 2021 00:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB97C6101C
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jul 2021 00:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhG2Axq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhG2Axq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Jul 2021 20:53:46 -0400
Received: from poetics.madmonks.org (unknown [IPv6:2404:9400:3:0:216:3eff:fee0:d9b5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AC5CC061757
        for <linux-raid@vger.kernel.org>; Wed, 28 Jul 2021 17:53:41 -0700 (PDT)
Received: from poetics.madmonks.org (localhost [127.0.0.1])
        by poetics.madmonks.org (Postfix) with ESMTP id 87E548000D2;
        Thu, 29 Jul 2021 10:53:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=madmonks.org;
        s=default; t=1627520015;
        bh=I2x4+QoJ17t/TqXjdYkyNVvOb2MhD4fYaJRw5dQJHCg=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=DXYHeyWIkH3z79cTux5p/Sgrn5sFxEtke/6UQR9D4byGEWwVekZgbB5UYXsQwMwXn
         0ZReu2u9Io168BNJ15ljY0yp2KZKr0OPdXXAzl47iEruoVoBdFra7A4jq8hFgJNFao
         g5BNHWjdwFBaWOnVOsKx/C2VOpy8NaCY0+PpeQnD8of+O8OY+wHxuq9I0o7GlQvwUW
         2tX9znzOAqKH42dInHdcYP2r6pD1vVnDKo73x2RR5stj1NRIXiv0KAu6lo0stIlrTT
         L1gwz4YF5zCZhz4IYXJk96w+KWKu+H4P0i6nyTBGcznlcES63REIrJnneE1EhduqwF
         bXmz3sVUPsxrQ==
Received: from smtpclient.apple (121-200-4-56.79c804.syd.nbn.aussiebb.net [121.200.4.56])
        by poetics.madmonks.org (Postfix) with ESMTPSA id 700928000AE;
        Thu, 29 Jul 2021 10:53:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=madmonks.org;
        s=default; t=1627520015;
        bh=I2x4+QoJ17t/TqXjdYkyNVvOb2MhD4fYaJRw5dQJHCg=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=DXYHeyWIkH3z79cTux5p/Sgrn5sFxEtke/6UQR9D4byGEWwVekZgbB5UYXsQwMwXn
         0ZReu2u9Io168BNJ15ljY0yp2KZKr0OPdXXAzl47iEruoVoBdFra7A4jq8hFgJNFao
         g5BNHWjdwFBaWOnVOsKx/C2VOpy8NaCY0+PpeQnD8of+O8OY+wHxuq9I0o7GlQvwUW
         2tX9znzOAqKH42dInHdcYP2r6pD1vVnDKo73x2RR5stj1NRIXiv0KAu6lo0stIlrTT
         L1gwz4YF5zCZhz4IYXJk96w+KWKu+H4P0i6nyTBGcznlcES63REIrJnneE1EhduqwF
         bXmz3sVUPsxrQ==
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3686.0.1.2.1\))
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS - AMD
 ROME what am I missing?????
From:   Matt Wallis <mattw@madmonks.org>
In-Reply-To: <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
Date:   Thu, 29 Jul 2021 10:54:01 +1000
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <21187A73-4000-4017-B016-15C03D19B799@madmonks.org>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
 <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
X-Mailer: Apple Mail (2.3686.0.1.2.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jim,

Totally get the Frankenstein=E2=80=99s monster aspect, I try not to =
build those where I can, but at the moment I don=E2=80=99t think =
there=E2=80=99s much that can be done about it.
Not sure if LVM is better than MDRAID 0, it just gives you more control =
over the volumes that can be created, instead of having it all in one =
big chunk. If you just need one big chunk, then MDRAID 0 is probably =
fine.

I think if you can create a couple of scripts that allows the admin to =
fail a drive out of all the arrays that it=E2=80=99s in at once, then =
it's not that much worse than managing an MDRAID is normally.=20

Matt.

> On 28 Jul 2021, at 20:43, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>=20
> Matt,
> I have put as many as 32 partitions on a drive (based upon great =
advice from this list) and done RAID6 over them, but I was concerned =
about our sustainability long term.     As a researcher, I can do these =
cool science experiments, but I still have to hand designs  to =
sustainment folks.  I was also running into an issue of doing a mdraid =
RAID0 on top of the RAID6's so I could toss one  xfs file system on top =
each of the numa node's drives and the last RAID0 stripe of all of the =
RAID6's couldn't generate the queue depth needed.    We even recompiled =
the kernel to change the mdraid nr_request max from 128 to 1023. =20
>=20
> I will have to try the LVM experiment.  I'm an LVM  neophyte, so it =
might take me the rest of today/tomorrow to get new results as I tend to =
let mdraid do all of its volume builds without forcing, so that will =
take a bit of time also.  Once might be able to argue that configuration =
isn't too much of a "Frankenstein's monster" for me to hand it off.
>=20
> Thanks,
> Jim
>=20
>=20
>=20
>=20
> -----Original Message-----
> From: Matt Wallis <mattw@madmonks.org>=20
> Sent: Wednesday, July 28, 2021 6:32 AM
> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Cc: linux-raid@vger.kernel.org
> Subject: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread =
IOPS - AMD ROME what am I missing?????
>=20
> Hi Jim,
>=20
>> On 28 Jul 2021, at 06:32, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>>=20
>> Sorry, this will be a long email with everything I find to be =
relevant, but I can get over 110GB/s of 4kB random reads from individual =
NVMe SSDs, but I'm at a loss why mdraid can only do a very small  =
fraction of it.   I'm at my "organizational world record" for sustained =
IOPS, but I need protected IOPS to do something useful.     This is =
everything I do to a server to make the I/O crank.....My role is that of =
a lab researcher/resident expert/consultant.   I'm just stumped why I =
can't do better.   If there is a fine manual that somebody can point me =
to, I'm happy to read it=E2=80=A6
>=20
> I am probably going to get corrected on some if not all of this, but =
from what I understand, and from my own little experiments on a similar =
Intel based system=E2=80=A6 1. NVMe is stupid fast, you need a good =
chunk of CPU performance to max it out.
> 2. Most block IO in the kernel is limited in terms of threading, it =
may even be essentially single threaded. (This is where I will get =
corrected) 3. AFAICT, this includes mdraid, there=E2=80=99s a single =
thread per RAID device handling all the RAID calculations. (mdX_raid6)
>=20
> What I did to get IOPs up in a system with 24 NVMe, split up into 12 =
per NUMA domain.
> 1. Create 8 partitions on each drive (this may be overkill, I just =
started here for some reason) 2. Create 8 RAID6 arrays with 1 partition =
per drive.
> 3. Use LVM to create a single striped logical volume over all 8 RAID =
volumes. RAID 0+6 as it were.
>=20
> You now have an LVM thread that is basically doing nothing more than =
chunking the data as it comes in, then, sending the chunks to 8 separate =
RAID devices, each with their own threads, buffers, queues etc, all of =
which can be spread over more cores.
>=20
> I saw a significant (for me, significant is >20%) increase in IOPs =
doing this.=20
>=20
> You still have RAID6 protection, but you might want to write a couple =
of scripts to help you manage the arrays, because a single failed drive =
now needs to be removed from 8 RAID volumes.=20
>=20
> There=E2=80=99s not a lot of capacity lost doing this, pretty sure I =
lost less than 100MB to the partitions and the RAID overhead.
>=20
> You would never consider this on spinning disk of course, way to slow =
and you=E2=80=99re just going to make it slower, NVMe as you noticed has =
the IOPs to spare, so I=E2=80=99m pretty sure it=E2=80=99s just that =
we=E2=80=99re not able to get the data to it fast enough.
>=20
> Matt
