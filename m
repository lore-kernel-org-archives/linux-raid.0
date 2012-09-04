From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Safe disk replace
Date: Tue, 4 Sep 2012 16:33:42 +0100
Message-ID: <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
References: <20120904041447.GB14445@onthe.net.au>
 <5045D7D9.9000108@hesbynett.no>
 <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 04, 2012 at 02:26:24PM +0200, Mikael Abrahamsson wrote:

> On Tue, 4 Sep 2012, David Brown wrote:
>=20
> > The "raid1" copy you mention will one day be possible with "hot replace"
> > <http://neil.brown.name/blog/20110216044002#2>
> >
> > I don't know how far along this idea is at the moment.
>=20
> https://lwn.net/Articles/465048/
>=20
> "hot-replace support for RAID4/5/6:
>=20
> In order to activate hot-replace you need to mark the device as=20
> 'replaceable'. This happens automatically when a write error is recorded=
=20
> in a bad-block log (if you happen to have one).
>=20
> It can be achieved manually by
>     echo replaceable > /sys/block/mdXX/md/dev-YYY/state
>=20
> This makes YYY, in XX, replaceable."
>=20
> I don't know if it actually made it into 3.2, I believe I saw somewhere=
=20
> that it was available for 3.3, but Neil Brown should know more.
>=20
I'm currently upgrading my RAID-6 arrays via hot-replacement. The
process I followed (to replace device YYY in array mdXX) is:
    - add the new disk to the array as a spare
    - echo want_replacement > /sys/block/mdXX/md/dev-YYY/state

That kicks off the recovery (a straight disk-to-disk copy from YYY to
the new disk). After the rebuild is complete, YYY gets failed in the
array, so can be safely removed:
    - mdadm -r /dev/mdXX /dev/mdYYY

That's worked fine so far, and looks to run at the single disk write
speed. There were no errors on the old disks though, so I've not seen
how that gets handled (it _should_ just do a parity-based recovery from
the remaining disks and continue).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBGH1QACgkQShxCyD40xBLxqQCfTYjQz0dUjan3gHZQ7SnELf2Z
Xk4AoLLU4gQtj7AAPTWekySfF1obgyhv
=rn1j
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
