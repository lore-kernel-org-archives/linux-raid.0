From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Doing 'echo repair >
 /sys/devices/virtual/block/md?/md/sync_action' does not result in
 mismatch_cnt of 0 on RAID-6?
Date: Tue, 15 Mar 2011 12:13:51 +0000
Message-ID: <20110315121351.GA7190@cthulhu.home.robinhill.me.uk>
References: <4D7F4DF3.7010804@tuxes.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D7F4DF3.7010804@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Mar 15, 2011 at 11:30:59AM +0000, Bas van Schaik wrote:

> All,
>=20
> I'm seeing a non-zero mismatch_cnt (in fact, it's 1704) on my RAID-6
> array consisting of 8 devices on kernel 2.6.38. After replacing some
> hardware, I decided to trigger a MD repair by issuing:
>   echo repair > /sys/devices/virtual/block/md5/md/sync_action
>=20
> Directly after issuing this command, the mismatch_cnt is reset to 0 and
> MD starts checking the array. However, the mismatch_cnt increases during
> this check - resulting in exactly the same count as seen before.
> Shouldn't 'repair' yield a zero mismatch_cnt? I think I have seen
> 'repair' work on other RAID-6 arrays?
>=20
The mismatch_cnt is incremented during repair to indicate how many
errors were repaired. If you want to be certain though, you'd need to
re-run 'check' afterwards.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk1/V/4ACgkQShxCyD40xBJQrACgklZxkXCpcEB/nWriO7bjbfYx
iIkAoNnwYdPDvgNRpnBPCxpkqW7VF1om
=kmif
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
