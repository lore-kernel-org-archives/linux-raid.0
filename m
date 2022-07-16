Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBE8C43334
	for <linux-raid@archiver.kernel.org>; Sat, 16 Jul 2022 21:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiGPVo2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 16 Jul 2022 17:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiGPVo0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 16 Jul 2022 17:44:26 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED82DFCB
        for <linux-raid@vger.kernel.org>; Sat, 16 Jul 2022 14:44:23 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id A1B9A3C1200;
        Sat, 16 Jul 2022 23:44:21 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id GaXnUVHgZYGo; Sat, 16 Jul 2022 23:44:20 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id F05863C1E37;
        Sat, 16 Jul 2022 23:44:19 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net F05863C1E37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1658007860;
        bh=t2B4rpYM8ine4kIWqLOBpFxYYdHaThqD9iRRwMcUxfE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=ASIa/VYgUw9j0+Twf825Z4LTWCkN36vo5L+ngIcMN878DLiXJ8EoysJOBjpNldfs4
         tWpyPnCBAZv+4AV/PeWPPfGW7UoGKW9JqM4pgAW2Hz3935a2/Ipv93oQb90gnTkrvP
         mEVbP4sLrHMzSxaLg3++Rj6/FuetZAX9IEolPwvD3aLo7d5e1QSZkuIGM75reqqzTm
         HY4rSvHlBY80bkLVhtjMJpcMH2qyzWdMLPoUaEJmO4njxcy0rduQ03i0tlB153WZ4A
         uh5TTDvBML1Gi163eGvjRor8hmmScaw/59iZTPAftL1THTi4KyBeRww02qWEm7wB8W
         nj1V0l5Dnf8vg==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id jXWTIVtrPQGM; Sat, 16 Jul 2022 23:44:19 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 91C2C3C1200;
        Sat, 16 Jul 2022 23:44:19 +0200 (CEST)
Date:   Sat, 16 Jul 2022 23:44:19 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     esqychd2f5@liamekaens.com
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <194033058.14961297.1658007859117.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <4470-1658006245-486940@sneakemail.com>
References: <4470-1658006245-486940@sneakemail.com>
Subject: Re: Determining cause of md RAID 'recovery interrupted'
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:700:700:403::6:104b]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF102 (Mac)/8.8.10_GA_3786)
Thread-Topic: Determining cause of md RAID 'recovery interrupted'
Thread-Index: /OcvkItmF3YcbJHUEXxdHqcwkBvHQQ==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

hi

Could you check for Current_Pending_Sector and Reallocated_Sector_Ct for th=
e drives in the array? You'll find this with smartctl -a /dev/sdX. These sh=
ould be zero, but a few errors won't sink the ship. Also, check if there is=
 a populated badblocks list on either of the drives. I've written a bit abo=
ut these here https://wiki.karlsbakk.net/index.php?title=3DRoy%27s_notes#Th=
e_badblock_list. There's also https://raid.wiki.kernel.org/index.php/The_Ba=
dblocks_controversy for more info.

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
> From: esqychd2f5@liamekaens.com
> To: "Linux Raid" <linux-raid@vger.kernel.org>
> Sent: Saturday, 16 July, 2022 23:17:25
> Subject: Determining cause of md RAID 'recovery interrupted'

> Hi,
>=20
> I'm a long-time md raid user, and a big fan of the project.  I have run i=
nto an
> issue that I haven't been able to track down a solution to online.
>=20
> I have an md raid array using 12TB Seagate Iron Wolf NAS drives in a RAID=
6
> configuration.  This array grew from 4 drives to 10 drives over several y=
ears,
> and after the restripe to 10 drives it started occasionally dropping driv=
es
> without obvious errors (no read or write issues).
>=20
> The server is running Ubuntu 20.04.4 LTS (fully updated) and the drives a=
re
> connected using LSI SAS 9207-8i adapters.
>=20
> The dropping of drives has led to the array now being in a degraded state=
, and I
> can't get it to rebuild.  It fails with a 'recovery interrupted' message.=
 It
> did rebuild successfully a few times, but now fails consistently at the s=
ame
> point around 12% done.
>=20
> I have confirmed that I can read all data from all of my drives using the
> 'badblocks' tool to read all data from all drives.  No read errors are
> reported.
>=20
> The rebuild start up to failure looks like this in the system log:
> [  715.210403] md: md3 stopped.
> [  715.447441] md/raid:md3: device sdd operational as raid disk 1
> [  715.447443] md/raid:md3: device sdp operational as raid disk 9
> [  715.447444] md/raid:md3: device sdc operational as raid disk 7
> [  715.447445] md/raid:md3: device sdb operational as raid disk 6
> [  715.447446] md/raid:md3: device sdm operational as raid disk 5
> [  715.447447] md/raid:md3: device sdn operational as raid disk 4
> [  715.447448] md/raid:md3: device sdq operational as raid disk 3
> [  715.447449] md/raid:md3: device sdo operational as raid disk 2
> [  715.451780] md/raid:md3: raid level 6 active with 8 out of 10 devices,
> algorithm 2
> [  715.451839] md3: detected capacity change from 0 to 96000035258368
> [  715.452035] md: recovery of RAID array md3
> [  715.674492]  md3: p1
> [ 9803.487218] md: md3: recovery interrupted.
>=20
> I have the technical data about the drive, but it is very large (181K) so=
 I'll
> post it as a response to this post to minimize clutter.
> There are a few md RAID arrays shown in the logs, the one with the proble=
m is
> 'md3'.
>=20
> Initially, I'd like to figure out why the rebuild gets interrupted (later=
 I will
> look into why drives are being dropped).  I would expect an error message
> explaining the interruption, but I haven't been able to find it.  Maybe i=
t is
> in an unexpected system log file?
>=20
> One thing I notice is that one of my drives (/dev/sdc) has 'Bad Blocks Pr=
esent':
>  Bad Block Log : 512 entries available at offset 264 sectors - bad blocks
>  present.
>=20
> So, a few questions:
>=20
> - Would the 'Bad Blocks Present' for sdc lead to 'recovery interrupted'?
> - More generally, how do I find out what has interrupted the rebuild?
>=20
> Thanks in advance for your help!
>=20
> Joe
