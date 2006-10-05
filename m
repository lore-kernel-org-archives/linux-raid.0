From: martin f krafft <madduck@madduck.net>
Subject: Re: converting RAID5 to RAID10
Date: Thu, 5 Oct 2006 12:20:28 +0200
Message-ID: <20061005102028.GA4945@piper.madduck.net>
References: <20061005095913.GA2530@piper.madduck.net> <17700.56082.745304.937160@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17700.56082.745304.937160@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2006.10.05.1214 +0200]:
> mdadm --create -l 10 -n 4 -pn2 /dev/md1 /dev/sdc missing /dev/sdd missing

Peter Samuelson of the Debian project already suggested this and it
seems to work.

Thanks a lot, Neil, for the quick and informative response.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"the ships hung in the sky in much the same way that bricks don't."
                                 -- hitchhiker's guide to the galaxy

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFJNxsIgvIgzMMSnURAmRyAKCf7FVOrrTf+7cvl5mhT7wSBlXyXQCglEvW
PnJAxOQ2JrbpVcDCvZQ+su0=
=EWlW
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
