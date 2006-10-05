From: martin f krafft <madduck@madduck.net>
Subject: converting RAID5 to RAID10
Date: Thu, 5 Oct 2006 11:59:13 +0200
Message-ID: <20061005095913.GA2530@piper.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have a 1.5Tb RAID5 machine (3*750Gb disks + 1 spare) and need to
move some write-intensive services there. Unfortunately, the
performance is unacceptable. Thus, I wanted to convert the machine
to RAID10.

My theory was: backup, remove the spare, set one disk faulty, remove
it, create a degraded RAID10 on the two freed disks, copy data, kill
RAID5, add disks to new RAID10.

Unfortunately, mdadm (2.5.3) doesn't seem to agree; it complains
that it cannot assemble a RAID10 with 4 devices when I ask it to:

  mdadm --create -l 10 -n4 -pn2 /dev/md1 /dev/sd[cd] missing missing

I can kind of understand, but on the other hand I don't. After all,
if you'll allow me to think in terms of 1+0 instead of 10 for
a second, why doesn't mdadm just assemble /dev/sd[cd] as RAID0 and
make the couple one of the two components of the RAID1? What I mean
is: I could set up RAID1+0 that way; why doesn't it work for RAID10?

Do you know of a way in which I could migrate the data to RAID10?
Unfortunately, I do not have more 750Gb disks available nor
a budget, and the 1.5Tb are 96% full.

Cheers,

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"if a man treats life artistically, his brain is his heart."
                                                        -- oscar wilde

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFJNdxIgvIgzMMSnURAt75AKCbJT/KG7U1B7VWRCyNcTFZaziXegCdEkPV
uAA5yDSRpqu+S4yMjpHTsEE=
=vY4C
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
