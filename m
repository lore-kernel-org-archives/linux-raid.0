Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF16C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jul 2021 10:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1571C60F9B
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jul 2021 10:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhG1Kje (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Jul 2021 06:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhG1Kjb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Jul 2021 06:39:31 -0400
X-Greylist: delayed 480 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jul 2021 03:39:30 PDT
Received: from poetics.madmonks.org (unknown [IPv6:2404:9400:3:0:216:3eff:fee0:d9b5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CD4FC061757
        for <linux-raid@vger.kernel.org>; Wed, 28 Jul 2021 03:39:30 -0700 (PDT)
Received: from poetics.madmonks.org (localhost [127.0.0.1])
        by poetics.madmonks.org (Postfix) with ESMTP id F3D878000D2;
        Wed, 28 Jul 2021 20:31:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=madmonks.org;
        s=default; t=1627468279;
        bh=t/u7e0XVWUPv/xzQdp+WMIDSn/z0vyugx/7WgEV1u5o=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=fRDOTXhq/lTFiM9XnavSqdnk759kLjE/00V1aA769p4DmLkHT4QNBLbDRxXITOyFP
         YkvWoM+Wp4eCcrWftjsawH4odQkN4r+frxmAVWTDlIaHe7TAlhGtMKir2rBnaMyKs3
         tjJJlB71wsd+muM3fnrWz+/bBWxc5TEeIK7jC8dzU6WFHDG6eBRoUYDhdU83wFobQi
         eFzKlxSdwBTxwSVidiKSGt3iZswATCskbW/qb4u5XxoZgVBStS+3beepbxIu+0jX6X
         K1pJViOvgiiot5IlNpP2hF/J29XexBgDS0KAA20PYhflh4G1kJFh91ryV8wT4bBpBX
         fYINLrntrKUOA==
Received: from smtpclient.apple (121-200-4-56.79c804.syd.nbn.aussiebb.net [121.200.4.56])
        by poetics.madmonks.org (Postfix) with ESMTPSA id DDABF8000AE;
        Wed, 28 Jul 2021 20:31:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=madmonks.org;
        s=default; t=1627468278;
        bh=t/u7e0XVWUPv/xzQdp+WMIDSn/z0vyugx/7WgEV1u5o=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=ntgKFQYARfqeRA9J9FxcvViNRx6KlBJ1RWK7xRjHYbHJjnmpbiskK0R5Gy+UQJ1uX
         bREAe9JhaFMrK9W+wR50NUGGlOa3THmDDbTC1adbOjD3pY9Jlh2pUHGcWPQvyDjohs
         myXQvZcPRZF8Tj5ShAXDW5OO2bbxXw5kYbSFJx6XdpUG5DpRJA743thAkPPa7bZ3eX
         gLJNJrIhOsjznkm2x+PmaDWpypgM64EJoTIxX7chhiq2ZTkLhurDX5XYAkwQ0X27MA
         rridrR1iObwg5QR7Wxo1/ODV/JiTzKkJE3mJoYjeKK+4DgFNhA8WwVa/cxHrNCRvhL
         alhv3zIFyxhHA==
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3686.0.1.2.1\))
Subject: Re: Can't get RAID5/RAID6  NVMe randomread  IOPS - AMD ROME what am I
 missing?????
From:   Matt Wallis <mattw@madmonks.org>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
Date:   Wed, 28 Jul 2021 20:31:44 +1000
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
X-Mailer: Apple Mail (2.3686.0.1.2.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jim,

> On 28 Jul 2021, at 06:32, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>=20
> Sorry, this will be a long email with everything I find to be =
relevant, but I can get over 110GB/s of 4kB random reads from individual =
NVMe SSDs, but I'm at a loss why mdraid can only do a very small  =
fraction of it.   I'm at my "organizational world record" for sustained =
IOPS, but I need protected IOPS to do something useful.     This is =
everything I do to a server to make the I/O crank.....My role is that of =
a lab researcher/resident expert/consultant.   I'm just stumped why I =
can't do better.   If there is a fine manual that somebody can point me =
to, I'm happy to read it=E2=80=A6

I am probably going to get corrected on some if not all of this, but =
from what I understand, and from my own little experiments on a similar =
Intel based system=E2=80=A6
1. NVMe is stupid fast, you need a good chunk of CPU performance to max =
it out.
2. Most block IO in the kernel is limited in terms of threading, it may =
even be essentially single threaded. (This is where I will get =
corrected)
3. AFAICT, this includes mdraid, there=E2=80=99s a single thread per =
RAID device handling all the RAID calculations. (mdX_raid6)

What I did to get IOPs up in a system with 24 NVMe, split up into 12 per =
NUMA domain.
1. Create 8 partitions on each drive (this may be overkill, I just =
started here for some reason)
2. Create 8 RAID6 arrays with 1 partition per drive.
3. Use LVM to create a single striped logical volume over all 8 RAID =
volumes. RAID 0+6 as it were.

You now have an LVM thread that is basically doing nothing more than =
chunking the data as it comes in, then, sending the chunks to 8 separate =
RAID devices, each with their own threads, buffers, queues etc, all of =
which can be spread over more cores.

I saw a significant (for me, significant is >20%) increase in IOPs doing =
this.=20

You still have RAID6 protection, but you might want to write a couple of =
scripts to help you manage the arrays, because a single failed drive now =
needs to be removed from 8 RAID volumes.=20

There=E2=80=99s not a lot of capacity lost doing this, pretty sure I =
lost less than 100MB to the partitions and the RAID overhead.

You would never consider this on spinning disk of course, way to slow =
and you=E2=80=99re just going to make it slower, NVMe as you noticed has =
the IOPs to spare, so I=E2=80=99m pretty sure it=E2=80=99s just that =
we=E2=80=99re not able to get the data to it fast enough.

Matt
