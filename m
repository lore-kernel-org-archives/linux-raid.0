From: Davide Guarisco <guarisco@sbcglobal.net>
Subject: Recovering RAID set after OS disk failed
Date: Sun, 1 Jun 2014 22:37:54 -0700
Message-ID: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_DDD354AE-CC19-4705-9221-99761E3BD037"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_DDD354AE-CC19-4705-9221-99761E3BD037
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hello and sorry if this is not the place for a relatively =93newbie=94 =
question.

Five years ago I built a NAS box running on Ubuntu server then-current =
version. The NAS has 4 SATA drives (the RAID set) and a PATA system =
drive (for the OS). Now the system drive has failed (click of death). I =
believe the that RAID data is still safe and sound, but my question is =
how to proceed in such a scenario. (I do have a backup but it=92s fairly =
old). I do not remember exactly how I created the RAID set, other than =
being with mdadm and probably RAID 5.=20

I have now replaced the failed PATA drive with a new 32 GB PATA SSD, and =
installed Ubuntu Server 14.04. The system is up and running and it sees =
the four SATA drives. I have installed Webmin and I am ready to recover =
the RAID set.=20


I read the Wiki and it suggests running a =93permutation=94 Perl script. =
Is this a reasonable thing to do?=20
I could not find much information on a case like this in a Goole search, =
so any help appreciated.=20



--Apple-Mail=_DDD354AE-CC19-4705-9221-99761E3BD037
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJTjA2yAAoJEOP6S0R9UICWOIAP/j8gwG80T5phPtWHkySwhMaV
Fb3WR29dNbECvFWMU9OmeBxOOfrQdbiyL+ODdhk2VN4FbL2CMrjCYBgn97FpRbeM
uWJJmd/s2b2NM1AO+7/KMDXQMx6HUnfpuYIVNlIM5gjrKCbErUTtuO4YkMxqTJDW
eM2YpWKDkxxOX2MHTtRVstHsH6ojdP17BqZcZoHI9cLh0l5ATRyA2j4gnQZ8Uqar
aJkMJ/jsTVPdE2u0pqih0T423Lrf3PJpkmye38HzfhN1HJCj1DwuMNsZwj95qsCC
fRe7W9QPMc88gozZwfFT0LwvjmAy/bGEdxv+moVF82TWMuk7QOryd4vkCPe7eLxE
Atc11nQbo6W8leHEeq8Y6TJgzH2nLfkGWMCmbSNGxH61RWU4sr7w7X9+ovRx31Ek
pCQKdVFz2yUXX3hHJAe+Aie7W1QeHTaq2dqz0UGZZrsWnZhD6oDIw9ToGyzz3fM/
Xffjh3ZnU8HCWaUn9GKmdLYd+GClZT8tmALk9U+qhyeniS8p6BCXP8WkpwJ5zYDw
cxk0O77qhX27MJu5Bs59nQ8Pl31H7QjDUJgT8lv9ruN19I9LfvP90ZEDhIZaOku8
axz10eyQoZSXL6PlrXWxSzBwz+d1bjHMfda7RIyLX7GXlqCaXpFDMJZikhFkb8pM
NVr9MkV4jtStjpAnw9mn
=wZ45
-----END PGP SIGNATURE-----

--Apple-Mail=_DDD354AE-CC19-4705-9221-99761E3BD037--
