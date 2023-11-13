Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE0C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 10:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjKMKJl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjKMKJj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 05:09:39 -0500
Received: from truschnigg.info (truschnigg.info [89.163.150.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F4810C2
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 02:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
        s=m22; t=1699870174;
        bh=Q42oWjUoIWyENQdwAqemkYJ5SIL8YslqTTx4TXyzfrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y3IV1J0A+Hs8qaGQwCsvGN3qTUw60NDTs/3I5LRxP/RlCpALR6LAQHdAWT2ho3Dzr
         AlBU3RidR7cpCNdtQm8UzZLXdNnhuIGj9xz/FanR2q19+hocyk1s+l9XD+x62gQPPP
         amRbBN4sflnxr3WttD6m8LEJ3tLzp9z/YH7LGyNiuDFSbIxLjcRVewWr2ZytVewI/A
         2HAWRPUeEwDx/uUC0MnaM8sL7N9TNTq88ysLJ7YCtRO2sLm7WMmAP7G/WdWH+izEgo
         fRNIsnPV3RsPAiwlxy4kRkE21sFiz2T0x0vDM9/iuce81pj8haqxReTv24yPJPDvlL
         ODYgbZbAcWViA==
Received: from vault.lan (unknown [IPv6:2a02:1748:fafe:cf3f:1eb7:2cff:fe02:8261])
        by truschnigg.info (Postfix) with ESMTPSA id F176E2035C;
        Mon, 13 Nov 2023 10:09:33 +0000 (UTC)
Date:   Mon, 13 Nov 2023 11:09:32 +0100
From:   Johannes Truschnigg <johannes@truschnigg.info>
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Subject: Re: extremely slow writes to array [now not degraded]
Message-ID: <ZVH13JX6q-5CsQNN@vault.lan>
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
 <ZVHIPNwC2RKTVmok@vault.lan>
 <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au>
 <ZVHqbnFRU4bXBDNQ@vault.lan>
 <60e4892e-f6b3-4f0a-956d-09555d8ee147@eyal.emu.id.au>
 <09d9848d-8ef4-488c-8719-7ad451c9e36b@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g1hl2ZCKRa1WuKqq"
Content-Disposition: inline
In-Reply-To: <09d9848d-8ef4-488c-8719-7ad451c9e36b@eyal.emu.id.au>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--g1hl2ZCKRa1WuKqq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2023 at 08:58:55PM +1100, eyal@eyal.emu.id.au wrote:
> [trimmed]
> > > [0]: https://bugzilla.kernel.org/show_bug.cgi?id=3D217965
>=20
> Reading this bugzilla, an extra info bit. This has not changed for years =
(I have daily records).
>=20
> $ mount|grep data1
> /dev/md127 on /data1 type ext4 (rw,noatime,stripe=3D640)

Yeah, afaiui, one of the theories in the bug suggests that a recently
introduced block allocation improvement made matters worse for any kind of
stride/stripe setting <> 0. So if you dial your kernel version back to befo=
re
that was made (6.4 seems to be unaffacted, iirc), you will probably regain =
the
performance loss you observe and reported here on list.

FWIW, I briefly played around with an artificial dataset on tmpfs-backed lo=
op
devices configured in RAID5 where I was (re)setting the superblock-configur=
ed
stride-setting, and did not lose any data by toggling it between 0 and
<some_other_value> (256 in my case) multiple times. So I would assume that =
to
be a safe operation in principle ;)

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/
phone: +436502133337
xmpp:  johannes@truschnigg.info

--g1hl2ZCKRa1WuKqq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAmVR9dkACgkQ95W3jMsY
fLUTyRAAuFk4O4exRw09kQh0z11LMUsUhhGz/Diyp0NdOM4DsLOmkHQ7kv/vZ+03
AZHVssq2o4vO8e5CLMU0AnPyQ9hd/Nsv+V0YmWuFIBKbfDxxbTAOLNhYIx/V9ND9
nwqVjPoIBlGa9ip/ss2sGcofQHAuhzYF7zkgLGRC1VI0xgZXXevqkO5HwLAaOeFz
gH/SWwAovGkmkZsdeWCuFuOshZY+tU2vysiuOdWcirYmNwsmVPwaHnoIuWjDCRoY
Y22X0Ik79sj6dlJ76mr6d9wdr4kIw1bdVdv53+LhQVoPjWlGGAgmUdY++JvF59WY
xauIVFZ4A6D029FRaLq7X5d5WyJYzDkdfhuoNqnANC3MW1RajpeTbich9KaYNenN
krZ5fTzmVP0dzpFMJ2yKkDjxBrIULFOpySGupt6twu6r8MM4vw0RxrlxT8snrTlt
EqDV6VaamvgrWaDAlhX60tJpga39utqjKahtx4frx3ZarLDmlgf4TUQeCjnmHzhI
68Qjui0lD1RGXuQyzLqKSr0QEuJLHhJh5XJRmectE3HRdfHfxBxtmhxg/ZJAGPAO
jKtClqdwgmZHscdkEbw5LT6O5hmYU4NKLlDw38L/ZtJ3ASnDlvk9/F4XNhFF8y/L
kkOLMdf4Mpaizgh8dFxhATjWF6ZIxC8gSGA9CCMF8s3oDxXyHuc=
=rnUA
-----END PGP SIGNATURE-----

--g1hl2ZCKRa1WuKqq--
