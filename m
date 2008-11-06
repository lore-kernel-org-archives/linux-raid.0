From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: metadata format 00.90 unknown, ignored
Date: Thu, 6 Nov 2008 20:37:29 +0000
Message-ID: <20081106203729.GA27449@cthulhu.home.robinhill.me.uk>
References: <837a927a0811061051heb9081fr51217068eede302e@mail.gmail.com> <49133ED8.4010409@rabbit.us> <837a927a0811061113t45d06a43m7a877d116fae735d@mail.gmail.com> <837a927a0811061213h5e2fa072s48986aab00d6e904@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <837a927a0811061213h5e2fa072s48986aab00d6e904@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 06, 2008 at 03:13:41PM -0500, Leandro Tracchia wrote:

> ok, i want to start from scratch with these two hard drives. i quickly
> learned formatting and removing them won't work. as soon as i put them
> back in, mdadm starts rebuilding them. what do i need to do to be able
> to create a new array with these two hard drives, if they are already
> part of an apparently existing array???
>=20
You'll need to wipe the superblocks:
    mdadm --zero-superblock /dev/sda
    mdadm --zero-superblock /dev/sdc

Then recheck the partitioning is still okay before continuing to create
the new array on the partitions.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkTVYkACgkQShxCyD40xBLFKgCg0IcvsUCR1sHWFUCUy+Q32/EN
l1AAn0BVvWWnVlefbaSV6vpEIQN7AUe3
=TzXs
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
