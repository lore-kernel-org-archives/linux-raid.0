From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Add disks and convert level 0 to level 5
Date: Wed, 17 Sep 2014 16:15:47 +0100
Message-ID: <20140917151547.GA7692@cthulhu.home.robinhill.me.uk>
References: <loom.20140831T143354-68@post.gmane.org>
 <20140901083137.4772c8c5@notabene.brown>
 <8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com>
 <20140911102719.053a5d5c@notabene.brown>
 <535A7DC1-0953-41D6-B149-DB038D1631D2@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <535A7DC1-0953-41D6-B149-DB038D1631D2@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Muratet <muratetm@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 17, 2014 at 09:59:00am -0500, Michael Muratet wrote:

>=20
> On Sep 10, 2014, at 7:27 PM, NeilBrown wrote:
>=20
> > On Wed, 10 Sep 2014 11:15:24 -0500 Michael Muratet <muratetm@gmail.com>=
 wrote:
> >=20
> >> I have a two-disk RAID0 system that is working splendidly, thanks
> >> to the list for the help.
> >>=20
> >> I managed to get my hands on more identical disks and since I have
> >> the disks and because I'm adding precious data, I'd like to add two
> >> more disks and grow to RAID5.
> >>=20
> >> I have partitioned the two new drives to type 'fd', /dev/sde and /dev/=
sdf
> >>=20
> >> I believe the command to accomplish the change is this:
> >>=20
> >> mdadm /dev/md0 --grow --level=3D5 --add /dev/sde /dev/sdf
> >>=20
> >> Following the old adage "measure twice, cut once", is this syntax
> >> correct? Is there any danger of data loss in such a conversion?
> >=20
> > I recommend creating a few loop-back devices and experimenting.
> > i.e.:
> >  create some 100M files.
> >  use "losetup" to turn them into block devices.
> >  create an 2-device raid0
> >  try converting it as you suggest.
> >=20
> > You find it doesn't do quite what you expected, but should be easy to f=
ix.
>=20
> In case anyone wants to do a similar thing...
>=20
> As predicted, it did not do as I expected. I have another identical
> server and disks and so I did the experiment there.
>=20
>   980  sudo fdisk /dev/sdc
>   981  sudo fdisk /dev/sdd
>   982  sudo fdisk /dev/sde
>   983  sudo fdisk /dev/sdf
>   988  sudo partprobe /dev/sdc
>   989  sudo partprobe /dev/sdd
>   990  sudo partprobe /dev/sde
>   991  sudo partprobe /dev/sdf
>   995  sudo mdadm --create /dev/md0 --level=3D0 --raid-disk=3D2 /dev/sdc1=
 /dev/sdd1
>   996  sudo mkfs -t ext3 /dev/md0
>   997  sudo mount -t ext3 /dev/md0 /db
>=20
> Same RAID0 system I created before. Now to grow
>=20
>  1004  sudo mdadm /dev/md0 --grow --level=3D5 --add /dev/sde1 /dev/sdf1
>=20
> Makes a RAID5 system, but sde1 was added as a spare
>=20
>  1022  sudo mdadm --grow /dev/md0 --raid-devices=3D4
>=20
You should be able to combine the above into a single command (it worked
for me on loopback devices anyway):
    sudo mdadm --grow /dev/md0 --level=3D5 --raid-devices=3D4 \
               --add /dev/sde1 /dev/sdf1

> It's now a four disk RAID, but smaller than expected. It spread the
> original space over four drives, which I think is the documented
> behavior.
>=20
As md has no knowledge of the filesystem or how to change the size of
it, then all it can do it redistribute the original data over the
additional disks. The md device size should have increased though, even
if the filesystem size hadn't.

>  1040  sudo umount /dev/md0
>  1045  sudo e2fsck -f /dev/md0
>  1046  sudo resize2fs -p /dev/md0
>  1048  sudo mount -t ext3 /dev/md0 /db
>  1049  df -h
>=20
> /dev/md0                      2.7T  202M  2.6T   1% /db
>=20
> which is what I wanted. I can't take my original system offline now,
> but when I can I will apply the same steps.
>=20
You shouldn't need to take it offline - resize2fs works perfectly well
online.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQZpaIACgkQShxCyD40xBK2sQCg2pM6MhfTFZHAeBNC7NDH/njr
oWEAoJJ4u6fC135vWcnaaP7Ux5rJX51k
=kAgw
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
