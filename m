From: NeilBrown <neilb@suse.de>
Subject: Re: Help with corrupted MDADM Raid6
Date: Fri, 13 Jun 2014 20:25:41 +1000
Message-ID: <20140613202541.584dc8f1@notabene.brown>
References: <CAH4F3SZ4Q8MO5Ci8ihSrLf1myo8pTfJ8SNC5EwJZQHf_H44GPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iJuuaaM49JF0Hn5t/7pRN1P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH4F3SZ4Q8MO5Ci8ihSrLf1myo8pTfJ8SNC5EwJZQHf_H44GPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "ptschack ." <ptschack@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iJuuaaM49JF0Hn5t/7pRN1P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jun 2014 10:34:55 +0200 "ptschack ." <ptschack@googlemail.com>
wrote:

> Hi,
>=20
> I fear I may have messed up my MDADM RAID 6. Some info:
>=20
> The RAID consists of 11 hard drives (3 TB each), 2 of which are
> spares. It used to be 6 drives, no spares.
>=20
> This happened: one drive (/dev/sdg) kept giving me SMART warnings
> (failure imminent). As I was trying to do a fresh install at the time,
> i restored a backup of my system drive (an ssd which is is wholly
> independent of the RAID) and booted off of that.
> I hadn't realized that the backup was too old, from the time before i
> grew the raid... Apparently mdadm tried to mount the raid as it used
> to be (6 drives), and now it says the raid consists of 6 drives, all
> spares!

That doesn't make sense.  md store the important information about an array
on the drive of the array.  The information in /etc/mdadm.conf is largely
advisory.
The mdadm.conf that you attached looks perfectly OK and would work with
either the old 6-drive array or the new 9+2 drive array.

> Plus the drive /dev/sdg seems to have totally failed now :(
>=20
> I guess I somehow need to re-assemble (or re-create) the raid6 in a
> degraded state, since one drive failed, but I'm not entirely clear on
> how to do that. One question is if I should include the spares in a
> reassembly or add them later.
>=20
> Can anyone help?

Hopefully.

>=20
> I have attached the outputs of dumpe2fs and mdadm --examine of the
> drives, plus my mdadm.conf.

sdk1 is the only device to show an md superblock, and it was last updated on
6th April, so it is rather old.  That is presumably before you made the arr=
ay
larger.

sda1, sdb1 sdc1 sdd1 sde1 sdf1 sdh1 sdi1 sdj1 sdk1 all appear to contain
ext3fs or ext4fs superblocks.  I think some of those are from before the
devices were added into the array.  Quite possibly md doesn't over-write the
ext3 superblock.

I wonder if maybe the array is actually on the whole devices rather than on
the partitions.  What does

  mdadm --examine /dev/sd[abcdefghijk]

report?


Certainly *don't* try to create the array until you have tried all other
options.

If you do find mdadm superblocks on the whole devices, then you could try

 mdadm --assemble /dev/sd[a-k]

possibly remove devices from the list which don't work.  Possibly add
"--force" if not including "--force" doesn't work.

NeilBrown

--Sig_/iJuuaaM49JF0Hn5t/7pRN1P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5rRpjnsnt1WYoG5AQKvLg/+J026IN7DjrokpZLT83Fom4USuU8Ligfr
ytZSja0MszCLCUraa0ggLjkzv13MpTWhIrqdKP3lr4GnZBjfuOXuVzh6qh7MkRlQ
3JHRUVWtcpIrBGvzZP11nCfSFqlX+LoBiQsIHxmTbqGEY956vfqBT7P8yj/+OEGs
Ckn9BLC+0YWxIcNq6AdvkmSLla9VFd3uo7gFALDdECla8LjxnYBmnWVu2UC4GgCA
FG2QViBKjXsNPLThcxeIJLwryN2GOPUJEh+ZObHelRnbLZdioadNXdg26SCOvZW7
GwYjAivKx2+ezDEYSA5Fm1juF/d10ZYkp9hDCjXKnWZooBs+NBv4riFXCMgJ+yjc
KraRZt+Uwh9IAWZLI1nSnNOhwXVe0Z2rbnruIPw7RHvDyVD7pZIOEppGRB19cAOj
+A1Ih938XtkChxPViy+2Z5QardAJX59zUgxDqgYZM9oUeBm7yjeuCrSdP5sQIBXi
yk4cf5XG7b+UgvVeRCZzTxLBpoQxPpotynfPgeW3i9blzM45v/CzphzwxK6//WLe
p9u0wuCO4inGXN01zeVQAhOKljdAS9foBl5tBrYTBL0wX1JlYPqyXBkJItn/Lsyi
7+SK+Py5UA674QV/nLDO+z5Edmw3vUfeaQp+MGGx9hLaK0XXG/ZmQpYrSlCWSJKk
k+k+VvMjDxI=
=gau2
-----END PGP SIGNATURE-----

--Sig_/iJuuaaM49JF0Hn5t/7pRN1P--
