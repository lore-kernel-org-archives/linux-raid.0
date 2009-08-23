From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid array not auto restarting
Date: Sun, 23 Aug 2009 14:55:30 +0100
Message-ID: <20090823135530.GA9860@cthulhu.home.robinhill.me.uk>
References: <5c45fce80908230649y4acc48acxefc8a4bef698e860@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5c45fce80908230649y4acc48acxefc8a4bef698e860@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Aug 23, 2009 at 07:19:44PM +0530, Anshuman Aggarwal wrote:

> Although its not a show stopper, would really appreciate some help on thi=
s.
>=20
> My raid arrays don't start up automatically like they used to after I
> grew them to include the 4th disk (yes, I DID modify the mdadm.conf so
> I'm not sure what's not working here)
> Kernel: 2.6.30.4; mdadm 3.0 (are there any other libraries whose
> version I should be checking also, since I manually upgraded Ubuntu
> Jaunty to mdadm 3.0)
>
<-snip->
>=20
> This array starts fine when I do the following:
>=20
> mdadm -S /dev/md_d1*
> mdadm -A -s
>=20
> So, if the scan works without any changes in the mdadm, then why
> doesn't it work at boot time?
>=20
Have you updated the initrd so the new mdadm.conf is available at boot?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqRSlEACgkQShxCyD40xBIshACgwAjTbULaM+Po86+C24xoipwd
tUsAoIirf4BHEyiiZj7k0xGiBHapZ00K
=ekIo
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
