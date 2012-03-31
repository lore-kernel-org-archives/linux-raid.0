From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 grow failed
Date: Sun, 1 Apr 2012 08:00:36 +1000
Message-ID: <20120401080036.355a8a23@notabene.brown>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/awSgCYtNzvsdto7Gu8DRc7U"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/awSgCYtNzvsdto7Gu8DRc7U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 15:38:23 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> I've had another md issue.  Not sure exactly what caused it but my
> array is offline again.  The reshape completed and I was about to
> insert a new drive to replace the one that failed on the initial
> reshape.
> /proc/mdstat contains
> md1 : inactive sdk1[13](S) sdh1[9](S) sdi1[10](S) sdc1[8](S)
> sdj1[11](S) sdb1[4](S) sdd1[6](S) sde1[7](S) sdl1[0](S) sdn1[2](S)
> sdo1[3](S)
>       21488647746 blocks super 1.2
>=20
> "mdadm -As --verbose /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb" ret=
urns
> mdadm: looking for devices for /dev/md1
> <cut>
> mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
> mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
> mdadm: Cannot open /dev/sdl1: Device or resource busy

Stop the array first. - it is half-started which confused mdadm.
i.e
   mdadm -S /dev/md1
   mdadm -As .......

NeilBrown


--Sig_/awSgCYtNzvsdto7Gu8DRc7U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3d+hDnsnt1WYoG5AQKqvQ//QvW/ckxL/Dxvc4d+wtIx4FHPEMxluaQf
NVvrxvo3wI9ZkmS9zarmMbOTDE6Pk7ByQKz17KeJPy/yOdMqTuaQn9eILaLqPSYq
WqS+MAmFhs5TcJq5ZG1YjwIEfOgBCceY85EmPk3cXHLIusyrRJnM9eLEQZORiTgt
Dks/8TN6kH0ckWxoktzhAp8fFY0RrL6nCimzLdg+oLXrvCk+tgzszEHRZTszndAV
7rjvUvpgxnCwkdbzRxAmJiwWfxBVfHdrXl6W34bBwlmMaA13kpCpMSkwEWF5kqt6
9hnZSHyZW0/Wm40MoLvCnrMkSledOTUjl34ZDNVXtz2fnsHjHSbm3hcSvvLw1/5Y
uonSnPsi2o9mj2iRPMw48zfppIjoCNmsXIwwiyruIfxZeIRUhg7NUiQ08rvD7pea
q77bIIk/1/RFdC9rgK7GzJdxjEHno1ygmu1Vvo7vQYKYwuchWscur3m8NiZ6H8pI
axcLIMla/XIsjf1Vd+gZv2koxsEVS8ZokMfRphPvQYtcf8LFAchBFj+5Np8tUP/j
cwTqe4dHnOiCeJHmFkqSQTUdZZmsjJ0f+djPYadGZrXxvZ/gOzfJCb4SRbDw+3WT
cztsb5Q4fcDEUkXs+WcRIyJLSLXh+vd7KUcnuaWxebdW7Ov1YvNFss+4LNEQ3FpE
msh1KHaofHU=
=2BUP
-----END PGP SIGNATURE-----

--Sig_/awSgCYtNzvsdto7Gu8DRc7U--
