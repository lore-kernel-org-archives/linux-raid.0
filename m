From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: raidtab -> mdadm conf file?
Date: Wed, 19 Feb 2003 15:56:21 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030219205621.GE13439@rdlg.net>
References: <20030219202516.GC13439@rdlg.net> <20030219205355.542BD3B82A@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Nae48J/T25AfBN4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030219205355.542BD3B82A@jaded.cynicism.com>
To: Derek Vadala <derek@cynicism.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



What should the output of "mdadm --detail --scan" look like?

root@disk2:~# mdadm --detail --scan
mdadm: option s not valid in mode D


Thus spake Derek Vadala (derek@cynicism.com):

> On Wed, 19 Feb 2003, Robert L. Harris wrote:
>=20
> >   I currently have about 30 machines using raidtools and /etc/raidtab.
> > Does anyone have a script that will generate a complete mdadm conf
> > file based on a raidtab or output from mdadm --detail?  While mdadm may
>=20
> Assuming the arrays are operational you could do something like:
>=20
>=20
> # echo "DEVICES /dev/sd*" > /etc/mdadm.conf
> # mdadm --detail --scan >> /etc/mdadm.conf
>=20
> Just adjust the first command so that it has the desired device set.
>=20
> --
> Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--6Nae48J/T25AfBN4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+U+918+1vMONE2jsRAj/uAJ4hFEw5QqQwej/wvi0jg0tYzZG4uACghfNs
3y6Qgn5Fn7qZQieu8WToln4=
=7FbC
-----END PGP SIGNATURE-----

--6Nae48J/T25AfBN4--
