From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Crash while increasing RAID5 from 3 disks to 5, array won't
	build.
Date: Fri, 5 Dec 2008 09:35:55 +0000
Message-ID: <20081205093555.GA20317@cthulhu.home.robinhill.me.uk>
References: <fa037c550812030743i70236951g964b444163425d39@mail.gmail.com> <06bc99a2784b75f8d7c2a4e563f576c4.squirrel@neil.brown.name> <fa037c550812031245u594ffd56q4d0b701456d81f1b@mail.gmail.com> <fa037c550812041549w2f93239se43d39150fe2dd47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa037c550812041549w2f93239se43d39150fe2dd47@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Dec 04, 2008 at 06:49:02PM -0500, Sean Hildebrand wrote:

> On Wed, Dec 3, 2008 at 3:45 PM, Sean Hildebrand
> <silverwraithii@gmail.com> wrote:
>=20
> Having an issue right now, I am unsure of what's going on. When I
> resized my array from 5 disks to 3 some months ago, the filesystem was
> automatically made smaller.
>=20
Resized how?  I didn't think mdadm allowed shrinking of arrays.  Even if
it did, it couldn't do so unless the filesystem was smaller than the
final array size.

> I'd assume the same happens when growing the array. However, conky and
> my file manager report that the partition is 1.35TB. fdisk and gparted
> output the correct 2.73 TB.
>=20
> Does mdadm automatically resize the partition when increasing the
> number of disks?
>=20
I think you mean filesystem rather than partition here (unless you're
using a partitioned array).  mdadm doesn't resize the filesystem as the
means of doing this is filesystem-specific.  You'll need to use the
appropriate tool (resize2fs, resize_reiserfs, xfs_growfs) to do this
yourself.

HTH,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkk49fsACgkQShxCyD40xBL+jQCgv5UFtAFd8q9b7OpuDaEPBg7W
zfgAn24FK/OXplk978T3VkEpfhO1Mafl
=O1Lh
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
