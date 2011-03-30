From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 14:42:29 +0100
Message-ID: <20110330134228.GA14556@cthulhu.home.robinhill.me.uk>
References: <20110330080823.GA9167@apartia.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110330080823.GA9167@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Mar 30, 2011 at 10:08:23AM +0200, Louis-David Mitterrand wrote:

> Hi,
>=20
> I am seeing horrific performance on a Dell T610 with a LSISAS2008 (Dell
> H200) card and 8 WD1002FAEX Caviar Black 1TB configured in mdadm raid6.
>=20
> Besides hardware, the other difference between servers is that the
> PE2900's MegaRAID has no JBOD mode so each disk must be configured as a
> "raid0" vdisk unit. On the T610 no configuration was necessary for the
> disks to "appear" in the OS. Would configuring them as raid0 vdisks
> change anything?
>=20
Several years ago I ran into a similar issue with a SCSI RAID controller
(may have been LSI MegaRAID, I can't recall now) and found that RAID0
vdisks were substantially faster than running it in JBOD mode. This
wasn't just down to the controller disabling caching/optimisations
either - in JBOD mode the performance was well below that on a non-RAID
controller.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2TM0MACgkQShxCyD40xBLbmQCcDfBwl4+2LGDCCcGvYeyh+EbK
FpsAoNlmKfDBOTzL7FvSBb45pbMITsM6
=HIbM
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
