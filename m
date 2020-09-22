Return-Path: <SRS0=RxpK=C7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30446C2D0E2
	for <linux-raid@archiver.kernel.org>; Tue, 22 Sep 2020 10:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F795208A9
	for <linux-raid@archiver.kernel.org>; Tue, 22 Sep 2020 10:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="wSJuA3tn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgIVK1q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Sep 2020 06:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgIVK1q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Sep 2020 06:27:46 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920EDC061755
        for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2020 03:27:45 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 6CC8C3C2751;
        Tue, 22 Sep 2020 12:27:42 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id XRAvFq7yUMjj; Tue, 22 Sep 2020 12:27:41 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id F34B73C27A0;
        Tue, 22 Sep 2020 12:27:40 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net F34B73C27A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1600770461;
        bh=AqPsaxYANAF7+LVy/U49bRUMwY66Dz9mDfyjwHrEuNE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=wSJuA3tnae1CYphE0amGRBDeoKB5inV1pUDtKAk16fS1lLRQu4SgiV0/zEEcmzKep
         4gkVsDlfmYLWdp5l5J9PJTuWXblkhn/DmTg4xTO4b/SDVWBZRwg9RXR6NZb9ZpvQqz
         I9dwhfIBEWq54qN+H4f1++yIYx86z45RBQIAHrIvJR2mGwxHPNZx2Qq4fkosk1JIqE
         BHp/6NPYCau+tXgx8zoRArMFh2MuJT8KEr0w0h/puKEkhsrh3/zK9EdRQNFaGWClgE
         CVKvlEaLFf1gqzgszYdbrZM6LiDPkbgnJIw+nER70GqlRL5vUR+TjOWUNo9orDeyBQ
         3Z6NRlKF3MiFw==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id n-c45oWWjP02; Tue, 22 Sep 2020 12:27:40 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id CEF463C2751;
        Tue, 22 Sep 2020 12:27:40 +0200 (CEST)
Date:   Tue, 22 Sep 2020 12:27:40 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Andy Smith <andy@strugglers.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <913919976.4679345.1600770460519.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <20200915102736.GE13298@bitfolk.com>
References: <20200915102736.GE13298@bitfolk.com>
Subject: Re: "--re-add for /dev/sdb1 to /dev/md0 is not possible"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:79c:cebf:61e4:19e9:53c:a2ad:5fc7]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF80 (Mac)/8.8.10_GA_3786)
Thread-Topic: "--re-add for /dev/sdb1 to /dev/md0 is not possible"
Thread-Index: kJ5MmErB0WGkEIvqk45LutzbUZdO2A==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> In my continuing goal to remove the bad blocks log from any of my
> arrays and not have one on any new arrays I create, I wrote this
> article:
>=20
>    https://strugglers.net/~andy/blog/2020/09/13/debian-installer-mdadm-co=
nfiguration-and-the-bad-blocks-controversy
>=20
> Shortly afterwards someone on Hacker News=C2=B9 said that it is possible
> to remove the BBL by failing and re-adding devices, like so:
>=20
> # mdadm /dev/md127 --fail /dev/sda --remove /dev/sda --re-add /dev/sda
> --update=3Dno-bbl
>=20
> I tried that on Ubuntu 18.04:
>=20
> $ mdadm --version
> mdadm - v4.1-rc1 - 2018-03-22
> $ sudo mdadm --fail /dev/md0 /dev/sdb1 --remove /dev/sdb1 --re-add /dev/s=
db1
> --update=3Dno-bbl
> mdadm: set /dev/sdb1 faulty in /dev/md0
> mdadm: hot removed /dev/sdb1 from /dev/md0
> mdadm: --re-add for /dev/sdb1 to /dev/md0 is not possible
> $ sudo mdadm --add /dev/md0 /dev/sdb1 --update=3Dno-bbl
> mdadm: --update in Manage mode only allowed with --re-add.
> $ sudo mdadm --add /dev/md0 /dev/sdb1
> mdadm: added /dev/sdb1
> $ sudo mdadm --examine-badblocks /dev/sdb1
> Bad-blocks list is empty in /dev/sdb1
>=20
> I tried it on Debian buster:
>=20
> $ mdadm --version
> mdadm - v4.1 - 2018-10-01
> $ sudo mdadm --fail /dev/md6 /dev/sdb1 --remove /dev/sdb1 --re-add /dev/s=
db1
> --update=3Dno-bbl
> mdadm: set /dev/sdb1 faulty in /dev/md6
> mdadm: hot removed /dev/sdb1 from /dev/md6
> mdadm: --re-add for /dev/sdb1 to /dev/md6 is not possible
>=20
> So, is that supposed to work and if so, why doesn't it work for me?
>=20
> In both cases these are simple two device RAID-1 metadata version
> 1.2 arrays. Neither has bitmaps.

I've tried this as well, and ran

mddev=3D/dev/md0
diskdev=3D/dev/sdm

mdadm --fail $mddev $diskdev
mdadm --remove $mddev $diskdev
mdadm --re-add $mddev $diskdev

All returned ok, but sdm was listed as a slave, thus not active anymore. Af=
ter this, a new --remove and --re-add didn't work, so it'll take some hours=
 to --add it again (yet another time).

It would be very nice if someone at linux-raid could prioritise this rather=
 obvious bug in the bbl code, where the bbl keeps replicating itself over a=
nd over, regardless of any actual failures on the disks. IMHO the whole BBL=
 should be scrapped, as mentioned earlier, since it really has no function.=
 Mapping out bad sectors is for the drive to decide and if it can't handle =
it, it should be kicked out of the array.

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
