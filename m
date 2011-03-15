From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Doing 'echo repair >
 /sys/devices/virtual/block/md?/md/sync_action' does not result in
 mismatch_cnt of 0 on RAID-6?
Date: Tue, 15 Mar 2011 14:13:42 +0000
Message-ID: <20110315141342.GB7190@cthulhu.home.robinhill.me.uk>
References: <4D7F4DF3.7010804@tuxes.nl>
 <20110315121351.GA7190@cthulhu.home.robinhill.me.uk>
 <4D7F6CE5.4010303@tuxes.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D7F6CE5.4010303@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Mar 15, 2011 at 01:43:01PM +0000, Bas van Schaik wrote:

> My other question is still standing:
> > Furthermore, theoretically it should be possible to indicate which
> > device in the RAID-6 array contains the inconsistent data, or am I
> > mistaking? If so, that would certainly be a nice feature to see
> > implemented, as it would help diagnosing problems.
> Am I indeed correct in thinking this?
>=20
I'm not sure. If it's a single data block that's failed then you should
be able to, for each disk, re-generate the data using the other disks
and the P parity, then validate against the Q parity (if it matches then
that disk is the incorrect one). You should also be able to detect
errors in either the P or Q parity (if one is valid for the data and the
other isn't).  If there's multiple disks which are incorrect then I
don't think there's any way you can tell which (or even avoid having one
of the correct disks flagged as incorrect).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk1/dBUACgkQShxCyD40xBL1WgCgglJseN25pr3wRU5tIsqGktnB
UCUAoKIDOwJBistgAdb2ivvWX1WHVeOR
=9px6
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
