Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4525DC71156
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F2821527
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="Iio8aMdq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbgK1VuR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387662AbgK1UPo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 28 Nov 2020 15:15:44 -0500
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C303AC0613D2
        for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2020 12:15:03 -0800 (PST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 65FBB3C1B36;
        Sat, 28 Nov 2020 21:15:02 +0100 (CET)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id ZX3mdWdBL8Kh; Sat, 28 Nov 2020 21:15:01 +0100 (CET)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 0FB993C1B8A;
        Sat, 28 Nov 2020 21:15:01 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 0FB993C1B8A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1606594501;
        bh=dqnZj7+wGtNUt+fPRzuZH844YoTwZN4GExFbRiaNXck=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Iio8aMdqwGpJ2mcH0/OdJdjmH+hCzwIOwbt3F2wcmF/1gZX8ucS11cdzT6Ksy9fnA
         KG5ZS1MfP0rpfpF3dmJIctHkOxoJ29M2VEofId/XqlfpECRUC9PiQubRWYFA6zDdOh
         twBwEwWYEqak8AVvSQu9sQ79BkHh1fLREJnDFube8gKNFYlcnGmRRtX/WksJnZxVq+
         Vwj83yc/kmEPeHoEnH23fAk5YnNi0UIiGaBSN5Tj5BlKCK2CCunlN2AZuFMlRTQgYp
         jP9BLWTCuGVj9oAdR2zm3YamuYz/xHVKyQGXVZQqB+s8TpW8pIt5GNHi9x9XWcPHkq
         NF5uR258PtfCQ==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 7eFDxxiebwcO; Sat, 28 Nov 2020 21:15:00 +0100 (CET)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id DD6F23C1B36;
        Sat, 28 Nov 2020 21:15:00 +0100 (CET)
Date:   Sat, 28 Nov 2020 21:15:00 +0100 (CET)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Andy Smith <andy@strugglers.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <1375483028.8430464.1606594500693.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <20200904074557.GT13298@bitfolk.com>
References: <20200904074557.GT13298@bitfolk.com>
Subject: Re: Config option for removing bbl on assembly?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:79c:cebf:61e4:99f3:dbb4:8682:2601]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF83 (Mac)/8.8.10_GA_3786)
Thread-Topic: Config option for removing bbl on assembly?
Thread-Index: pEYn8me4GVFZ8jUdsnyAFXhuccTo3Q==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Will anyone look into this issue, please? It really is a problem.

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
> From: "Andy Smith" <andy@strugglers.net>
> To: "Linux Raid" <linux-raid@vger.kernel.org>
> Sent: Friday, 4 September, 2020 09:45:57
> Subject: Config option for removing bbl on assembly?

> Hi,
>=20
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
>=20
> Cheers,
> Andy
