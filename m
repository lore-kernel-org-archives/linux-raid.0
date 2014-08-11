From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm misuse or bug ? mdadm: Cannot find 8:18: No such file or
 directory
Date: Mon, 11 Aug 2014 10:40:35 +1000
Message-ID: <20140811104035.5abbfe57@notabene.brown>
References: <53E54AC5.4010904@megasoft.be>
	<20140809104915.05b8da17@notabene.brown>
	<53E5D329.4040004@megasoft.be>
	<20140809182316.0c16ac48@notabene.brown>
	<53E5DCB6.4010809@megasoft.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kH0Ckik7lUbW3jwhIKx+W9b"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53E5DCB6.4010809@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kH0Ckik7lUbW3jwhIKx+W9b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 09 Aug 2014 10:32:54 +0200 Killian De Volder
<killian.de.volder@megasoft.be> wrote:

> sdb2 worked ! (And sorry for not trying sdb2, mdadm asks for /dev/md? so =
you naturally write /dev/sd? for the disk thereafter too :) )
> Now the question should -r failed work ?

Yes it "should", but it appears that I broke it for mdadm 3.3.
It'll be fixed in 3.3.2 by
  http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3Db47024f1c5fd=
e5d4fbc65807b9b29e06c056584e
and a couple of prior commits.

Thanks,
NeilBrown


>=20
> Killian De Volder
>=20
> On 09-08-14 10:23, NeilBrown wrote:
> > On Sat, 09 Aug 2014 09:52:09 +0200 Killian De Volder
> > <killian.de.volder@megasoft.be> wrote:
> >
> >> Doesn't work since sdb has been ejected. Strace below.
> >>
> >> package manager: mdadm 3.3-r2
> >> #mdadm -V: mdadm - v3.3 - 3rd September 2013
> >>
> >> Just tried 3.3-r3 and 3.2.6-r1 same issue.
> >> (There are no older in the package manager to try fast.)
> >>
> >> #strace mdadm /dev/md126 -r /dev/sdb2
> > I note that you put "/dev/sdb2" on the end of the line.
> >
> >
> >>> How about
> >>>    mdadm /dev/md127 -r sdb2
> > I note that I just put "sdb2" on the end of the line.  Perhaps I should=
 have
> > been explicit and say 'not "/dev/sdb2", just "sdb2"'.  It does make a
> > difference.
> >
> > NeilBrown
> >


--Sig_/kH0Ckik7lUbW3jwhIKx+W9b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+gRAznsnt1WYoG5AQK6Rw/8DGIU3f2uUpJ2EEzGVzJRMzYWpUJQpeZG
ndeb8xD+wfz1QAWAh3tWRyCsIqe/rLdPR25G8zYqs0XimPBUl+gLP5r81uPdciXx
gh2JvaR3gb7aPVXN/BdDJp1Hk4YrsZBxTA287Y9P8YJ4HGRrUBSZsOMRh/emkp8W
XnZUtObTPJmf3s58ymAJjWwOsY6o+vbJW0dFUt0u6s4GhNqIw4n8z/z9B2YOP+KE
KbYZONQ7hIdEuXcnkwYCYcaOQ43+/3Hg2Xot2kAb0dVcZ35aTFgM/WGDK42I2MYc
2vlyAn3C8bsn7d0/eciYc+Tr777CpCo/X3ygDSrcrqEYQ7QHiwUQS7nYiLz43OWk
9dtlXMrBsjqN9x9K4ZE5xtDk2IX7BH9ZkPON2obaaVCZA8+bFIk9Hk21in2kch/O
8uZG08F1Gm8UsK3EM5Km4jtppeIjTDO2VzCXQ7wGJ5CCTeFrOzM5Xza2GaT9zDb/
BVQPI1aCLcCzAVMIqW6drpgKzJ5+eVQAkTy/POwhI+kK2ecBSPmxpP17hnHvDpeT
zjFQOOUViFKVVXKSUtZdI14E4P6jZuiK0pfNQFERQa/0IO4i7e+KXaiB0tdl/fjE
9/fKynfRHAccy+ifM5d36oQGtJo2SuK6FyNpaBRVnwp8jVm3zOk6sPDZZhmdWk9T
+4MxEVpP4p0=
=To5F
-----END PGP SIGNATURE-----

--Sig_/kH0Ckik7lUbW3jwhIKx+W9b--
