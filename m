Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2527EC433E2
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 10:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BD72083E
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 10:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="Yd+x5CK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgILK67 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 06:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgILK66 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Sep 2020 06:58:58 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A08C061573
        for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2020 03:58:57 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 318BE3C2678;
        Sat, 12 Sep 2020 12:58:48 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id qCbu2EAVsGIr; Sat, 12 Sep 2020 12:58:46 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id D5D1F3C27C5;
        Sat, 12 Sep 2020 12:58:46 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net D5D1F3C27C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1599908326;
        bh=I+nbCY1fyefhsh6SxpqTvkCfEqun6iVeiYDlMtXqV0c=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Yd+x5CK/8cJG/C/IX3Ju8KTtPJ3QagrHcrWdmb760/yuu2CRsnnkVr2W1iDGq9GAj
         H4F1ZuOOtIrcLLPedRf0IYT55HJWSprbNnI2skjQ0yglUxYU093kmW6g7OwAKImi1/
         DyWkiF4EZU2q4Qf7MjdTHsDs/bigy3xJ4AlHdEkWYwlUzH01SW52vBo8HK1YdQi6sd
         Tb/a0sq4XEz/oDYmCSltdKAlNX5LYqPTdqRsjli83cbb4eNEgjI8TG8zj1WrVIawCF
         t7mxzvthVfMI5wXTy+uDFKf3Nk2+m0/NL7xi8v8d8Saxms4Lo2N4CAmmBI1NTzXeBW
         W/ADdOziBGXOg==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id IFGf0suRP6K8; Sat, 12 Sep 2020 12:58:46 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id B384C3C2678;
        Sat, 12 Sep 2020 12:58:46 +0200 (CEST)
Date:   Sat, 12 Sep 2020 12:58:45 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Andy Smith <andy@strugglers.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <583511729.466.1599908325671.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <20200904074557.GT13298@bitfolk.com>
References: <20200904074557.GT13298@bitfolk.com>
Subject: Re: Config option for removing bbl on assembly?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:31.45.35.118]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF80 (Mac)/8.8.10_GA_3786)
Thread-Topic: Config option for removing bbl on assembly?
Thread-Index: 8iRkZWXaxLfrHNbX9Deqveiu2dgyxA==
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Could we have a config setting for removing the bad blocks list on
> assembly?
>=20
> I'm aware that one could put:
>=20
> CREATE bbl=3Dno
>=20
> in mdadm.conf and then newly created arrays won't have a bad blocks
> list. But in many cases, system arrays are created before an
> mdadm.conf exists, so they get a bbl.
>=20
> So, to remove a bbl I know that you have to stop the array and
> assemble it like:
>=20
> # mdadm /dev/mdX --assemble --update=3Dno-bbl
>=20
> Again, for arrays with the actual system on it this is rather
> inconvenient. Even having to have some downtime of the service to do
> this is not great.
>=20
> So how about a config option telling mdadm to remove empty bbl the
> next time arrays are assembled? If there is a bbl with entries in it
> then it could warn and not remove it (so no force).

=E2=80=A6or just remove the whole bbl, since it has virtually no function a=
nd didn't even have it when it was introduced 10 years ago. Even back then,=
 drives had automatic reallocation of bad sectors and even if the docs say =
the bbl is built on write errors alone, this seems to not be the case. If a=
 drive is bad, it should get thrown out, not patched up in software in the =
belief that this will make things better. That the bbl is replicated to new=
 members and thus never removed, is part of this. I posted a thread about t=
his earlier.

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
