From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: mdadm -c magic?
Date: Thu, 20 Feb 2003 12:33:17 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030220173317.GH19609@rdlg.net>
References: <20030220164443.GG19609@rdlg.net> <20030220180014.2B2173B809@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030220180014.2B2173B809@jaded.cynicism.com>
To: Derek Vadala <derek@vadala.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Bingo.  Thank you very much.


Thus spake Derek Vadala (derek@vadala.com):

> On Thu, 20 Feb 2003, Robert L. Harris wrote:
>=20
> > Is it possible to have mdadm make the array and just leave the one spot
> > open anyway?  I tried a few options:
> >
> > root@legato-disk5.acs:~# mdadm -C -c 128  -l 5 -p left-asymmetric -n 4 =
-x 0=3D
> >  /dev/md3 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
> > [snip]
> > mdadm: create aborted
> > root@legato-disk5.acs:~# mdadm -C -c 128  -l 5 -p left-asymmetric -n 4 =
-x 0=3D
> >  /dev/md3 /dev/sdm1 /dev/sdn1 /dev/sdo1
> > mdadm: You haven't given enough devices (real or missing) to create thi=
s ar=3D
> > ray
>=20
> Try using the keyword 'missing' in place of a real disk or partition:
>=20
> # mdadm -C /dev/md3 -c 128 -l 5 -n 4 /dev/sdm1 /dev/sdn1 /dev/sdo1 missing
>=20
> That should give you a 3-disk RAID-5 in degraded mode. I think that's what
> you want. Add the fourth disk when it shows up and the array will
> resync.

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+VRFd8+1vMONE2jsRAv2tAKCOVShX0dUdGC0FJAG9HrBrqAaYuQCfeqSU
XKrfOZF3beT5ovvwp2THQUc=
=OxB7
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
