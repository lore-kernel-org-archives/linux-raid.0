Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F95C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 08:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjKBIke (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Nov 2023 04:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKBIkd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Nov 2023 04:40:33 -0400
X-Greylist: delayed 332 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Nov 2023 01:40:27 PDT
Received: from truschnigg.info (truschnigg.info [89.163.150.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4304112D
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 01:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
        s=m22; t=1698914093;
        bh=hZufdBwI6NTlcG/ZvHyGgIYeMi+SikrgVC8TAaTzPEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TXDS41JXHCWxTEg5Yp/Sc8Kao6aCMO7PlX8QWkpSuFl2zCu5QUw/0XENjv0oIUVpY
         icDQ/NO+Gj+i3JtKXykqX+Rrxluk82QlokPqh6g0MFutgWeaz81qivgFznrlDqlLU7
         R9xXFpvTBzYESfNTSVfEEoLlFymUMaSaUzIuOLK36hxUChDPMGYxdpnrnhay5GGcT5
         yXN1RphgL371mefBvO0JUp14t7kVGOclSAYOLeGAMCReuythwdb3UvwFKt4PxNSEpa
         /akh/oou0l9D5lGm53b+xxoHo8Vix9A7i72rGTINolcZfnwv7C5MfuoNDLPhdupjZI
         8qy3tPforBjTA==
Received: from vault.lan (unknown [IPv6:2a02:1748:fafe:cf3f:1eb7:2cff:fe02:8261])
        by truschnigg.info (Postfix) with ESMTPSA id 1C5BE204D1;
        Thu,  2 Nov 2023 08:34:53 +0000 (UTC)
Date:   Thu, 2 Nov 2023 09:34:51 +0100
From:   Johannes Truschnigg <johannes@truschnigg.info>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     eyal@eyal.emu.id.au, linux-raid@vger.kernel.org
Subject: Re: problem with recovered array
Message-ID: <ZUNfK1jqBNsm97Q-@vault.lan>
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
 <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
 <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3v7EjBgRBF1kF+d8"
Content-Disposition: inline
In-Reply-To: <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--3v7EjBgRBF1kF+d8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list,

for the record, I do not think that any of the observations the OP made can=
 be
explained by non-pathological phenomena/patterns of behavior. Something is
very clearly wrong with how this system behaves (the reported figures do not
at all match the expected performance of even a degraded RAID6 array in my
experience) and how data written to the filesystem apparently fails to make=
 it
into the backing devices in acceptable time.

The whole affair reeks either of "subtle kernel bug", or maybe "subtle
hardware failure", I think.

Still, it'd be interesting to know what happens when writes to the array th=
ru
the file system are performed with O_DIRECT in effect, i.e., using `dd
oflag=3Ddirect status=3Dprogress ...` - does this yield any observable (via
`iostat` et al.) thruput to the disks beneath? What transfer speeds does `d=
d`
report this way with varying block sizes? Are there no concerning messages =
in
the debug ringbuffer (`dmesg`) at this time?

I'm not sure how we'd best learn more about what the participating busy ker=
nel
threads (Fedora 38 might have more convenient devices up its sleeve than
ftrace?) are spending their time on in particular, but I think that's what's
needed to be known to pin down the underlying cause of the problem.

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/
phone: +436502133337
xmpp:  johannes@truschnigg.info

--3v7EjBgRBF1kF+d8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAmVDXycACgkQ95W3jMsY
fLWvtQ//S9nmW4jdo0ixYgTNYsF6xwgPahk2Z28kw5BVMc9pJZMljL1WlaGgFoW0
sX2j4Sv+PY8u7g7Kd9SGqfBWPL0+QoAbhywdHVSo849AbmRx0ZRIzgxAmeNkZRvP
hV/xdrI3LgOf8UDz6qpOZ67NSjKFv7neBXB/KgWdqCUpuYxHyEwR6qpE8LDUIZ5b
EdLDLJaeth/7K0zsNu9lXrUK/7q527qrdotivjw+MKGNFCVU9XR8V3PUDa0oNp6W
gqY9hOrml2x3zD1cz8nx2u9cyhyUY8TjN/SMA7Ezf3OPlU0LOg6FJfoi7FQGY+UH
Xv/RO8mIBLu8xQjEXyM3fMLbZFi+9rDTieky8sr0bZJrC14/xjhAFGiQfZ6lw3/t
do8ftwSG6LGgJIkjyhQ/5ZahT1cOGbNxGGZYXd+Cmxq8OI1aGxxVP8nI5KoPYw1w
fEiISvx64jTScQjVnQ2SOBl7ZqI4bwvWkKbUbouYkztOsArOEZeyRasrlaN/H9Dg
9U+HFdE5H2jj4DcyZxJyXV12ffvNsJJrk00oQTvekVtMD25ObhlA8Ht3734FMIes
m1UcMtRSIoMvGZ2WPIGnVNrYTtYxNMMo9UN1xjKj4i+y5jvM7Emp+PbP2GkyrQRg
9+5jcfaRKOFCKcHtfYEYAC1FMyXr4vTtTXE7AGOmyCqaguzV9ck=
=Wg2+
-----END PGP SIGNATURE-----

--3v7EjBgRBF1kF+d8--
