Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F44C433E1
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 18:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE298205CB
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 18:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="nNvlHhdJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHMSu1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 14:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHMSu1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Aug 2020 14:50:27 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8236C061757
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 11:50:26 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 6367C3C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 20:50:25 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id yYiJ9VW8Mml5 for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 20:50:24 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 2120D3C27A0
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 20:50:24 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 2120D3C27A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597344624;
        bh=BXDQ898IQJ+tkbrC7f7dAyraUCls+HqP+MlGdnbw+NE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=nNvlHhdJW3i8jAksbry4Lk3RzH7IXK2ANOT333AKceQufa8mcmnKrbvpHdsZHO2oZ
         xq/nJ6mRL99ziPg1mTPz5EHG7Glzb/ykqy4foklklKr2KLYUzML1w7Of/HxHWHOAEJ
         WhgtPtzWYqWl//dSHO3znaw+ruaAJZCPzq7bpRSTiFfZ2X4Y/dVO6Pd7l6s0glQ9IN
         H1gpUwWJwIlrFTjEohuySg3z+1u/JW8s8FMktPPDX1ZN9y6OLGtAkxx1Tybvll+O/x
         Da59UWjgbhweCDR/KNYH8jZohtua5MyJsm+vUt/KbbEJLwHsIcwtN9iTQBId+TIlp7
         i01hW/C4P5B3Q==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id yESyTTf-64TB for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 20:50:24 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 05E9E3C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 20:50:23 +0200 (CEST)
Date:   Thu, 13 Aug 2020 20:50:22 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Message-ID: <303847410.22535373.1597344622629.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net>
References: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net> <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net>
Subject: Re: Confusing output of --examine-badblocks1 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Topic: Confusing output of --examine-badblocks1 message
Thread-Index: 6fFysasCZBtSZ6hKL7EEKs2k82fW09O0JgJtymPdY0Q=
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> However, back to --examine-badblocks. It seems it's reporting the same s=
ector
>> numbers in the list for several (up to eight) drives. If I understand th=
is
>> correctly, something strange has hit and damanged all drives on fixed se=
ctor
>> numbers, such as this
>>=20
>> Bad-blocks on /dev/sdm:
>>           436362944 for 128 sectors
>>=20
>> It doesn't seem very likely, to be honest, that a lot of drives suddenly=
 damage
>> the same sector at once. I can see the same occur on a friend's server -
>> sectors with identical 'bad' sector numbers been listed on individual dr=
ives.
>=20
> It seems very likely the badblocks list is just replicated to new drives.=
 I just
> started
>=20
> # mdadm /dev/md0 --replace /dev/sdb --with /dev/sdk
>=20
> where sdk is a drive known to be good. It's about halfway through and it'=
s
> already copied part of the badblocks list. No I/O errors have been report=
ed in
> dmesg or otherwise.
>=20
> Any idea how to remove this list and start over?

I just tried another approach, mdadm --remove on the spares, mdadm --examin=
e on the removed spares, no superblock. Then madm --fail for one of the dri=
ves and mdadm --add for another, now spare for a few milliseconds until rec=
overy started. This runs as it should, slower than --replace, but I don't c=
are. After 12% or so, I checked with --examine-badblocks, and the same sect=
ors are popping up again. This was just a small test to see i --replace was=
 the "bad guy" here or if a full recovery would do the same. It does.

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

