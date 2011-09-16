From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting RAID1 to RAID5
Date: Fri, 16 Sep 2011 16:10:30 +0100
Message-ID: <20110916151030.GA14303@cthulhu.home.robinhill.me.uk>
References: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
 <20110911055703.73deb44d@notabene.brown>
 <CAB1R3siia=7u0fa=9Z02kXANW6z=KzRD2Fqfz9+e6=1Q5F9HPw@mail.gmail.com>
 <20110916055727.2cd356cc@notabene.brown>
 <CAB1R3sj7tPR-N91rJmrVOv1YqwpmC=E=zVxNmjCNYzKsS7mr9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAB1R3sj7tPR-N91rJmrVOv1YqwpmC=E=zVxNmjCNYzKsS7mr9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 16, 2011 at 09:56:58AM -0400, Alex wrote:

> Hi,
>=20
> For completeness, these are the steps I have followed, assuming a
> RAID1 array is md0:
>=20
> # mdadm --grow /dev/md0 --bitmap=3Dnone
> # mdadm --grow /dev/md0 --level=3D5 --raid-devices=3D3
> - wait for reshape to complete
> # mdadm --grow /dev/md0 --bitmap=3Dinternal
>=20
> I noticed there is a difference between one array and another:
>=20
> md125 : active raid5 sdb1[0] sda1[2] sdc1[1]
>       1023976 blocks super 1.0 level 5, 4k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> md126 : active raid5 sdb2[0] sda2[2] sdc2[1]
>       102397816 blocks super 1.1 level 5, 4k chunk, algorithm 2 [3/3] [UU=
U]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> Is that a reference to the superblock? Why would they be different?
> They were both created at the same time with the same fedora15
> versions. This is created at the time the filesystem is created,
> correct?
>=20
I assume md125 is /boot? This showed up as superblock 1.0 earlier
anyway. You need to use either 0.9 or 1.0 with grub (grub 1 anyway, I've
never used grub 2 so I'm not sure what that handles) as they place the
RAID metadata at the end of the drives. This means grub can access the
drives as though they were independent disks, ignoring the RAID. If you
set these up at install time then I assume Fedora automatically used the
correct superblock.

> It looks like this has also now affected grub, as the system no longer
> boots. Is this expected?
>=20
> When I try to reinstall grub, it fails with an error relating to /boot:
>=20
> # grub-install --recheck --root-directory=3D/mnt/disk /dev/sda
> Probing devices to guess BIOS drives. This may take a long time.
> /dev/md125 does not have any corresponding BIOS drive.
>=20
> Maybe /boot should be left as RAID1?
>=20
Yes, grub 1 can only boot from (what it sees as) standalone drives,
(so RAID1 with superblock 0.9 or 1.0 will work as the filesystem is in
exactly the same position as on a non-RAID drive). You'll need to
convert this back, though you can set it up as a 3-disk RAID1, giving
you extra redundancy. I doubt you'd need the extra space there anyway.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5zZuUACgkQShxCyD40xBKsCwCfekxYYzGYZuENuRWRJ6EXQ8xe
QyIAn19VG4r+ajyrBVco/Diz+HsuIyKM
=33MC
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
