From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: 16 Apr 2003 17:52:26 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050540735.12119.50.camel@gregdell>
References: <1050536716.13739.6.camel@testlin.hades>
	 <16028.46697.488363.56989@notabene.cse.unsw.edu.au>
	 <1050544298.13739.9.camel@testlin.hades>
	 <16028.47242.348607.436021@notabene.cse.unsw.edu.au>
	 <1050545634.13739.14.camel@testlin.hades>
	 <16028.60532.659544.421715@notabene.cse.unsw.edu.au>
	 <16029.62844.25748.442530@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z5KmW1aEhVMCdGh+wMdb"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16029.62844.25748.442530@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-z5KmW1aEhVMCdGh+wMdb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2003-04-16 at 17:29, Neil Brown wrote:
> On Wednesday April 16, neilb@cse.unsw.edu.au wrote:
> >=20
> > Ok, this is wrong.  Bigtime.
> > The spare has taken up postion 0 instead of 2.
> >=20
> > I cannot immediately see what would be causing this.  The code looks
> > right, but obviously isn't.  I'll try to see if I can reproduce it
> > tomorrow.
> >=20
>=20
> I haven't managed to reproduce it, but I'm faily sure that I know what
> was happening.  I'll try to figure out the best way to fix it.
>=20
> In the mean time, you can avoid the problem by not using raidstart at
> all.=20
> Reboot your machine, with raidstart disabled (e.g. move /etc/raidtab
> out of the way) and then us mdadm to start the array.  I think you
> will need "mdadm --assemble --force" to start it.

On a related note, I've recently hacked on rc.sysinit so that it
recognizes /etc/mdadm.conf, in addition to /etc/raidtab.  I've sent to
patch upstream to my vendor of Linux, you can find it at
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D88785
	Greg


--=-z5KmW1aEhVMCdGh+wMdb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+nfq+nAkVXO6fw4sRAtdNAJ4lpbMHjnilKu6wfZmn9t8VBPW+hgCfXyV5
cwFJb+lMk91FkDzq350REGg=
=bp1I
-----END PGP SIGNATURE-----

--=-z5KmW1aEhVMCdGh+wMdb--

