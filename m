Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214B4C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 06:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjKMGzC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 01:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjKMGzB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 01:55:01 -0500
Received: from truschnigg.info (truschnigg.info [89.163.150.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E473010E6
        for <linux-raid@vger.kernel.org>; Sun, 12 Nov 2023 22:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
        s=m22; t=1699858496;
        bh=+UsXkWyeooSPEnDs4mfW0PI5uLx1bkI3pMR5IBiidVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sBvXf9BFcRYHtwh03jWFWfYRImKtciqd/ASjvZ7wkfpnbcfxFXFUIQsiNzZ1oLCfT
         5chQB6QU76BDgvcW3gVhStLoK2TqbzW4fS5ZYuECOpkU384/HwRvLZhPZrU72DCwyX
         D4+yHIwDMiI525PAOP9/UYhdlh/ZrcbskLV1rGuaO+4S17brlDGlzaL9bNIwX54e+Y
         U2moflvuKtIsvxV0BckG1NyTiG/nobys12rnvqiUtctg282vHNTBDKGqLxj14wWprV
         3y4xYciTxAERuEesf9idZuAwSM/D7BQHe3b+8MV0oXBUr33G6NJ361s+wMBSegCub9
         pJcodmBRH9ytQ==
Received: from vault.lan (unknown [IPv6:2a02:1748:fafe:cf3f:1eb7:2cff:fe02:8261])
        by truschnigg.info (Postfix) with ESMTPSA id C47272037E;
        Mon, 13 Nov 2023 06:54:55 +0000 (UTC)
Date:   Mon, 13 Nov 2023 07:54:52 +0100
From:   Johannes Truschnigg <johannes@truschnigg.info>
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Subject: Re: extremely slow writes to array [now not degraded]
Message-ID: <ZVHIPNwC2RKTVmok@vault.lan>
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9FdvQO99FBlCSsWE"
Content-Disposition: inline
In-Reply-To: <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--9FdvQO99FBlCSsWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

You will need to generate some kind of call stack/graph info to start making
sense of the mess your running kernel gets itself into in the scenario you
described.

I imagine that looking at `perf` (`perf top` in particular; it should suffi=
ce
to paste a few instances of its topmost lines when the involved kernel thre=
ads
are spinning) would yield some useful data to kick off a potentially
productive debate about what could actually be going on.

On Fedora, I think `sudo dnf install perf` should set up everything you need
to get you going; then, look at `sudo perf top -F 999` for a while, and let
the list know what you see. (You can use your terminal emulator's flow cont=
rol
features, available via Ctrl+S to enable and Ctrl+Q to disable, to "freeze"
the output to make it easier to copy it into a clipboard buffer.)

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/
phone: +436502133337
xmpp:  johannes@truschnigg.info

--9FdvQO99FBlCSsWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAmVRyDkACgkQ95W3jMsY
fLUPGw/+MXtzahCqXAyXx2Xn60VBRpWjXeiT3MM5f0glsZ+HC3vVe1K4sNguH9Hi
hIwh73xovMj9lklXH4vgzShUGama0hqhuDrSVm7to/e8t/5RCAVTUWzvNekO8yNe
I49vUs/0huqMPm6EwXuS06pBDxHEHcHhuE8LUNqtW0mci7e4D/x2Wkn2VKcxnWZy
LS9Q7vr0c1mGPo/ji097gijmCxoo9aTexXDZqE+16fHKDNVsvpfPGw/dvXmC+0UL
n+du6V9HFKHtcn5uANuIMBadLM8o5G8xgyTEglrVo4UgX2O5HAWyF4b6EB3zjIs7
q+RF9ZVAopBiNmKKE3513ED1nzBSfvhmJH9Cb0RaJF56+6Nrcw5XyaXic1ubNI9v
kswmS3RHICHqoQ0ngwbDm6I6n2ZWk0bVFGZhDtFN24td8KEM3er8DW2OvDIv1QCl
OVYGUFIs6fLLmdy9eCGQ+czYgepCPLbjaBbyDRb49CEY8i/gJgi+Q+E7kjzTt4NL
un2d+aFqcgt4tGr+V+fvxWWG1OTHD2ZoRDL2ZnoOOw5VzlMfTrzgb4RVs6kudohH
/AQYKUs1oWHJoEIlThGOrfm5Ihc1Os3WLd1trQhL7Me8nJrWzvhXrn4qnC7QnBed
mapnK4erPA4bRFGPIhj42v05rJTc7obWzsgJ6XZNPY+6HVnLI8A=
=bGOb
-----END PGP SIGNATURE-----

--9FdvQO99FBlCSsWE--
