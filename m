From: martin f krafft <madduck@madduck.net>
Subject: Re: why partition arrays?
Date: Wed, 18 Oct 2006 15:43:22 +0200
Message-ID: <20061018134322.GA910@piper.madduck.net>
References: <20061018124225.GA23653@piper.madduck.net> <1161178012.2917.529.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1161178012.2917.529.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Doug Ledford <dledford@redhat.com> [2006.10.18.1526 +0200]:
> There are a couple reasons I can think.

Thanks for your elaborate response. If you don't mind, I shall link
to it from the FAQ.

I have one other question: do partitionable and traditional arrays
actually differ in format? Put differently: can I assemble
a traditional array as a partitionable one simply by specifying:

  mdadm --create ... /dev/md0 ...
  mdadm --stop /dev/md0
  mdadm --assemble --auto=3Dpart ... /dev/md0 ...

? Or do the superblocks actually differ?

Thanks,

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
the images rushed around his mind and tried
to find somewhere to settle down and make sense.
            -- douglas adams, "the hitchhiker's guide to the galaxy"

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFNi96IgvIgzMMSnURAp4FAJ42TmEXJKIl5sryRnbdLCXFSmLc5wCg5YOr
05EBrPXyP+54TDbKs55f3GA=
=gmx1
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
