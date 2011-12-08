From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: system startup hangs
Date: Thu, 8 Dec 2011 12:21:54 +0000
Message-ID: <20111208122154.GA12445@cthulhu.home.robinhill.me.uk>
References: <4EDFEACD.3010806@kinfolk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EDFEACD.3010806@kinfolk.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Richard B. Pyne" <rpyne@kinfolk.org>
List-Id: linux-raid.ids


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 07, 2011 at 03:38:05PM -0700, Richard B. Pyne wrote:

> Please forgive me if I ask stupid questions, I am fairly new to linux=20
> raid and most of the documentation I can find is severely outdated=20
> and/or written for someone who already understands linux raid.
>=20
> I have successfully built a set raid 6 array with 4 drives and have=20
> copied my system partitions onto the raid drives. I then reboot with=20
> root=3D/dev/md0.
>=20
> Everything looks like it is working right up through:
>=20
> md/raid:md0 raid level 6 active with 4 out of 4 devices, algorithm 2
> md0: detected capacity change from 0 to 1000131788
> md: autorun DONE.
> md0: unknown partition table
> EXT3-fs (md0): error: couldn't mount because of unsupported optional=20
> features
> EXT2-fs (md0): error: couldn't mount because of unsupported optional=20
> features
> EXT4-fs (md0): mounted filesystem with ordered data mode.  Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
> freeing unused kernel memory: 472k freed
>=20
>=20
> at which point it just hangs. No more disk access, no more messages.
>=20
>=20
> The system has 5 WD Caviar Black 500GB drives. I did the linux install=20
> on the first drive and built the other 4 drives into the raid system,=20
> planning to move everything (except the /boot partition) on to the raid=
=20
> array and then repartition everything except the /boot partition on the=
=20
> first drive and add it to the raid.
>=20
> I currently have md0 for / md1 for /home md2 for /usr md3 for /var and=20
> md4 on which I plan on running lvm to allocate to other system needs.
>=20
> Any advice, insights and/or direction will be greatly appreciated.
>=20
>=20
I've been bitten by this one myself recently. I suspect you've failed to
copy over the required underlying /dev entries. You need at least
/dev/console and /dev/null on the rootfs - at this stage the tmpfs
hasn't been mounted on /dev and udev hasn't created all the dev nodes.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7gq+EACgkQShxCyD40xBIBCwCePvuNqbzORvBFbkRO+vuKcZv+
SZEAn1XVITJAGPkPC/YLVgXVe/hMQmlN
=GqPW
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
