From: martin f krafft <madduck@madduck.net>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Fri, 19 Feb 2010 13:42:37 +1300
Message-ID: <20100219004237.GC25162@lapse.rw.madduck.net>
References: <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
 <20100218025809.GA20358@khazad-dum.debian.net>
 <20100218032610.GB1991@lapse.rw.madduck.net>
 <1266465801.11568.183.camel@localhost.localdomain>
 <20100218044004.GC5136@lapse.rw.madduck.net>
 <20100218161012.704b43a6@notabene.brown>
 <20100218052145.GA7178@lapse.rw.madduck.net>
 <20100218163448.0d3f3107@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100218163448.0d3f3107@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>, 567468@bugs.debian.org
List-Id: linux-raid.ids


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2010.02.18.1834 +1300]:
> But it would be rather awkward to store the uuid of the root
> filesystem in the metadata for the array that stores the root
> filesystem (and so is created before the root filesystem)...

True. You'd have to update the superblock UUID right after creation
of the filesystem. That doesn't sound like a robust strategy to
making mdadm.conf optional.

> Are you suggesting that when mdadm finds some bits that looks like
> the form an array it should test-assemble it, look inside for
> a filesystem, extra the uuid of that filesystem and compare
> against some known uuid before deciding whether to assemble that
> array or not?  I hope not.

Hehe, that would be fun, wouldn't it? ;)

> So I don't think I know what is really being proposed.

I really would like to make mdadm.conf optional and still have
things work incrementally from initrd.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
stupidity management for the superuser
is a user space issue in unix systems.
                                                           -- alan cox
=20
spamtraps: madduck.bogus@madduck.net

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt93n0ACgkQIgvIgzMMSnWFfwCdEgxDjg29KjX1akVRbnt+9N9x
NO0An2qGJtjFpRrNLnp0JREG0I+9u5Qc
=fits
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
