Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AC8C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 09:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjKMJUx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 04:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjKMJUw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 04:20:52 -0500
Received: from truschnigg.info (truschnigg.info [89.163.150.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDAFD4A
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 01:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
        s=m22; t=1699867248;
        bh=vMpdGrDz7zrnyauEbasXDnPt2eS6MY+C0IU36Xhfd5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LT+pxlRc99RVzYDaFjSujrJU/aR9RR1X0kSqMObnv8ZZNPbzMZHTGnLl5iQObnLIR
         kM+M2y7aitkvPGdG9RyO/VsKWA3YaVaxQGGLNmZlUAhfs6I/wUvyYhbtzH1+54QTV7
         34Oqclz5uXuI7zWzGLAd5TigaFX82ssRXQA1cinNy42ugyrPTLcIMS2MeTL+rRijFE
         vvb3KOIRybBlHN8jK324g5MA13XTq15/zEJqk0FWar2zno8BbWuVaBRizG6Y/uoGZL
         rKNe80Zl2uRSfkl10TQ1PnzDZrgsmmGM4ugkzctgGy/c/xoivgphgDQoo4qsfIRr6V
         2jqzw7GtoQLHQ==
Received: from vault.lan (unknown [IPv6:2a02:1748:fafe:cf3f:1eb7:2cff:fe02:8261])
        by truschnigg.info (Postfix) with ESMTPSA id CC6D0202CE;
        Mon, 13 Nov 2023 09:20:47 +0000 (UTC)
Date:   Mon, 13 Nov 2023 10:20:46 +0100
From:   Johannes Truschnigg <johannes@truschnigg.info>
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Subject: Re: extremely slow writes to array [now not degraded]
Message-ID: <ZVHqbnFRU4bXBDNQ@vault.lan>
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
 <ZVHIPNwC2RKTVmok@vault.lan>
 <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dm9JcGHMXdst5WQV"
Content-Disposition: inline
In-Reply-To: <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--Dm9JcGHMXdst5WQV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Interesting data; thanks for providing it. Unfortunately, I am not familiar
with that part of kernel code at all, but there's two observations that I c=
an
contribute:

According to kernel source, `ext4_mb_scan_aligned` is a "special case for
storages like raid5", where "we try to find stripe-aligned chunks for
stripe-size-multiple requests" - and it seems that on your system, it might=
 be
trying a tad too hard. I don't have a kernel source tree handy right now to
take a look at what might have changed in the function and any of its
calle[er]s during recent times, but it's the first place I'd go take a clos=
er
look at.

Also, there's a recent Kernel bugzilla entry[0] that observes a similarly
pathological behavior from ext4 on a single disk of spinning rust where that
particular function appears in the call stack, and which revolves around an
mkfs-time-enabled feature which will, afaik, happen to also be set if
mke2fs(8) detects md RAID in the storage stack beneath the device it is
supposed to format (and which SHOULD get set, esp. for parity-based RAID).

Chances are you may be able to disable this particular optimization by runn=
ing
`tune2fs -E stride=3D0` against the filesystem's backing array (be warned t=
hat I
did NOT verify if that might screw your data, which it very well could!!) a=
nd
remounting it afterwards, to check if that is indeed (part of) the underlyi=
ng
cause to the poor performance you see. If you choose to try that, make sure=
 to
record the current stride-size, so you may re-apply it at a later time
(`tune2fs -l` should do).

[0]: https://bugzilla.kernel.org/show_bug.cgi?id=3D217965

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/
phone: +436502133337
xmpp:  johannes@truschnigg.info

--Dm9JcGHMXdst5WQV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAmVR6msACgkQ95W3jMsY
fLXj1BAAk0L8CRaMlqaZUzO2UmYcYQ7nIo9WtA6uYp2OK0TtLagONh4X16/k0X6B
UAAS+6JgSeviPyu7FICP07/lXEuRC0rTQwoZ2wZm9SEkYZYYX2Ldnd5bGwAwZCRf
w3hnYffQrDYFozNqrJGl3pa9BDrXD7MscqmVTmo7CvGhSTRzBFTimbjbTubP6gXB
m34LGZgn0HHWaJJH2ATDbv+iBfgtfaZ3pUHuxM1d1jI7IZBzG5BEFUWjEQ8mRx2N
xKQOjSY8PEQz5CWjOiFR/hjfHev8siPmsHH/pxzOPEm1Qrtkguyiphbpt1BLh0U1
qker6DaGR1iHLuhjwdxfkyVWiuP1/sspAqKqS8W9ziNseczUt6o6LLQOzVKuLJpK
q/9hT3dGGfSYIjeb91Cces8Vnh1e/rk/v5JNRN3Z5lZnPlVivI7tOGbWYkHAo0B8
98a2+kbXoX2XCpREkeJlMBqbtSEw2akGYI9xg5wEW+x7qCiAeNwrHTbJTjTQj5eh
LAX877+ba4i48qVs+lQZbeirDVApAs9KdRP/Ky1RrLL+RDrVWxYbQS//Qx/W3CLY
qqzPApPUPm/sbXO4XLegYJV5mWwfUklWBWWsoVckkep4k4LAfBQac7oMgC4JDQSl
FOAS3ZgW8PKIqVBFb0VZkwebOHHPmrHN5kwdiR4vnRFuyxJHq1M=
=ACWF
-----END PGP SIGNATURE-----

--Dm9JcGHMXdst5WQV--
