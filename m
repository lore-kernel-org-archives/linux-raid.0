From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: NAS Remote Side of a Mirror
Date: Tue, 6 Oct 2009 16:24:43 +0100
Message-ID: <20091006152443.GA3151@cthulhu.home.robinhill.me.uk>
References: <905067.19304.qm@web38806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <905067.19304.qm@web38806.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Oct 05, 2009 at 08:37:37AM -0700, adfas asd wrote:

> I'm looking at setting up my RAID mirrored array so that one side of
> the mirror is in the HTPC and the other is NASsed in the garage, in
> case of theft or fire.
>=20
> I am concerned about the boot process though, as the NASsed side will
> not be available until the network comes up.  Will the array be able
> to be patient for that and include that side once it comes up, and run
> not degraded?
>=20
The network can be brought up from within the initrd, so there's no need
for the array to wait (that's even more trivial if you just have /home
on the array as you suggest below).  Alternately, you could use
write-intent bitmaps, in which case the resync should be very quick (you
may want these anyway - depends how reliable the network connection and
NAS is).

> What if I lose my local side of the mirror?  Is failover possible to
> the NAS side?  (Assuming a separate boot disk with everything except
> /home, which is on the array)
>=20
Yes (providing you have the array set up properly so the remote holds a
complete data copy).

> The only other technology I am aware of which can remote drives at
> distance is fibrechannel, and that's too expensive, so it seems I'm
> stuck with GB ethernet.  Are there in fact any other options?
>=20
Not that I've used, no.

> Is it possible to bring up ethernet early in the boot process with
> initrd.img?
>=20
Yes - this is pretty common for network booting.

> Has anyone actually done any of this?
>=20
I've not anyway.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrLYTsACgkQShxCyD40xBKTTQCgkaqWXzAJoyWbeuMyYU8LZehh
ovsAnRV4CfGAoG2zqIO044nLwDjkVJg2
=3gYt
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
