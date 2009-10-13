From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Tue, 13 Oct 2009 16:23:04 +0100
Message-ID: <20091013152304.GA19668@cthulhu.home.robinhill.me.uk>
References: <hb1udb$6t1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <hb1udb$6t1$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 13, 2009 at 09:13:13AM -0400, Antonio Perez wrote:

> 1.- Should the "rest of the disk" be only one partition?
> I have read that making several partitions and setting several md disks:
> 	sd[a..d]2 --> md1
> 	sd[a..d]3 --> md2
> 	sd[a..d]4 --> md3
> would help with the rebuild time of each md, which sounds correct. It is=
=20
> also proposed that the md on the outer area of the disk would be faster=
=20
> allowing for better control of performance, assigning faster mds to the m=
ore=20
> used filesystems.
>=20
> However, and this I don't know, those sda[2..4] are not really different=
=20
> devices (spindles) and reads to one md would conflict (or not?) with read=
s=20
> to the other mds.
>=20
Any reads to the same disk will conflict - whether they're on separate
arrays or within a single array shouldn't make any difference (the IO
elevator is set on the disk rather than the array, so I assume it will
gather requests across all arrays).  md itself knows that the arrays
share disks, so will ensure any maintenance tasks (resyncs, etc) only
run on a single array at a time.

> 2.- On the Raid 1: How many sectors to copy? 63?
> On an update of grub code, core.img could change, which means that the fi=
rst=20
> 63 sectors (to be on the safe side) of the disk which gets the update sho=
uld=20
> be copied to the other 3 disks.
> Or is it that the md code would mirror sectors 1-62 and only the MBR need=
s=20
> to be manually mirroed?
>=20
Not sure what you mean here.  If you have /boot on a RAID1 array then
it's mirrored, so the stage1.5 and stage2 bootloaders get mirrored via
that.  The stage1 bootloader is usually installed into the MBR, so only
that needs replicating separately.

> 2.- Is there a recomended way to trigger the said copy of question 2?
> Where should a call to copy the MBR should be placed? On update-grub?
>=20
I always just rerun the grub install for each disk manually (see
http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html
for example).  Automating it will depend on your distribution - if
update-grub is what's called after a grub update (and it isn't
overwritten by the update) then this would seem the logical place to do
it.

HTH,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrUm1cACgkQShxCyD40xBJd2gCePgw+7Hd1LpxFBVsWVO8OIHNb
g9EAnAhTu5VdbBM/Sf5LDc65N7QZFp6Z
=QmBT
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
