From: martin f krafft <madduck@madduck.net>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 16:26:10 +1300
Message-ID: <20100218032610.GB1991@lapse.rw.madduck.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
 <20100218025809.GA20358@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100218025809.GA20358@khazad-dum.debian.net>
Sender: linux-raid-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, Nick Bowler <nbowler@elliptictech.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Henrique de Moraes Holschuh <hmh@hmh.eng.br> [2010.02.18.1558 +=
1300]:
> > Using user-space autodetection, you can plug "mdadm -I" into
> > udev, and have arrays assembled as they are found, and
> > filesystems mounted as arrays are assembled, and then you just
> > have to wait for the root filesystem to appear, not for "all
> > devices".
>=20
> Is this ready for testing somewhere?  initramfs+mdadm.conf is
> operator-error bait, proper auto-assemble that does away with the
> requirement of an up-to-date mdadm.conf inside the initrd would
> help a great deal, there.

Debian experimental. But so far, I was unable to get rid of
mdadm.conf because it only works without the info in that file if
the homehost is correctly encoded in the metadata. So the challenge
I am facing is http://bugs.debian.org/567468.

> It will need something like LVM has to blacklist/whitelist what
> device classes it will scan for superblocks though, or it will
> eventually cause a lot of trouble.

We rely on linux-base reporting the FS type as linux_raid_member and
mdadm -E finding the metadata if that's the case.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
sex an und f=FCr sich ist reine selbstbefriedigung.
=20
spamtraps: madduck.bogus@madduck.net

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt8s1IACgkQIgvIgzMMSnWHQwCgxsXATcFIh5XcQWyCGLHcTG14
hq0An2lCvJ56GV6uHkzw5p1cF2mnnrY1
=ag4b
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
