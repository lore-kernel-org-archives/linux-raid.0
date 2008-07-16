From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 14:14:16 +1000
Message-ID: <1216181656.5633.380.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <alpine.DEB.1.10.0807151042320.20094@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eqWGov+xheIdLAOn7Tit"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807151042320.20094@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-eqWGov+xheIdLAOn7Tit
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 10:42 -0400, Justin Piszcz wrote:
> What were the commands used when creating the XFS filesystem=20
> (sunit,swidth)?
>=20
> Justin.

I noticed that on the hardware card I had to use nobarrier to get decent
file metadata performance (create,del etc). I have noticed also recently
on an 32gb Mtron SSD that with barriers enabled with XFS on the SSD
metadata performance was an order of magnitude slower.

The below is a snippit from the hardware RAID testing config. The XFS
creation and mounting args are identical for software RAID.

#!/bin/bash

RAIDLEVEL=3D6
CHUNK_SZ_KB=3D256
PARITY_DRIVE_COUNT=3D2
NON_PARITY_DRIVE_COUNT=3D4
DEVICE=3D/dev/disk/by-id/scsi-SAdaptec_1024ktmpraid6
...
run_bonnie() {
    fsdev=3D$1
    mountopts=3D$2
    N=3D256

    mount -o "$mountopts" $DEVICE /mnt/tmpraid
    chown ben /mnt/tmpraid
    sync=20
    sleep 1
    sudo -u ben /usr/sbin/bonnie++ -q -m $fsdev -n $N -d \
         /mnt/tmpraid >>/T/adaptec-raid
${RAIDLEVEL}-${CHUNK_SZ_KB}kb-chunks-bonnie.csv
    umount /mnt/tmpraid
}

...

fsdev=3Dhardxfsdefaultnb
mkfs.xfs -f -l lazy-count=3D1 \
        $DEVICE
run_bonnie $fsdev "nobarrier"

fsdev=3Dhardxfsalign
mkfs.xfs -f -s size=3D4096 \
	-d sunit=3D$(($CHUNK_SZ_KB*2)),swidth=3D$(($CHUNK_SZ_KB*2*
$NON_PARITY_DRIVE_COUNT)) \
	-l lazy-count=3D1 \
        $DEVICE
run_bonnie $fsdev "nobarrier"

fsdev=3Dhardxfsdlalign
mkfs.xfs -f -s size=3D4096 \
	-d sunit=3D$(($CHUNK_SZ_KB*2)),swidth=3D$(($CHUNK_SZ_KB*2*
$NON_PARITY_DRIVE_COUNT)) \
        -l lazy-count=3D1,sunit=3D$((CHUNK_SZ_KB*2)),size=3D128m \
        $DEVICE
run_bonnie $fsdev "nobarrier"

# run iozone on it.
fsdev=3Dhardxfsalign
mkfs.xfs -f -s size=3D4096 \
	-d sunit=3D$(($CHUNK_SZ_KB*2)),swidth=3D$(($CHUNK_SZ_KB*2*
$NON_PARITY_DRIVE_COUNT)) \
	-l lazy-count=3D1 \
        $DEVICE
mount -o "nobarrier" $DEVICE /mnt/tmpraid
chown ben /mnt/tmpraid
sync=20
sleep 1
sudo -u ben iozone -a -g 4G -f /mnt/tmpraid/iozone_file  \
   >/T/adaptec-raid${RAIDLEVEL}-${CHUNK_SZ_KB}kb-chunks-iozone.txt
umount /mnt/tmpraid


>=20
> On Wed, 16 Jul 2008, Ben Martin wrote:
>=20
> > Hi,
> >  Apologies if posting this here is inappropriate but a recent article
> > of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> > card and might be of interest to list members:
> >
> > http://www.linux.com/feature/140734
> >
> >

--=-eqWGov+xheIdLAOn7Tit
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh9dZgACgkQsIKOrI+5WvME7wCgqDwC00Tb5gQlucvYwDJYdPEO
UDAAoKUZnIWfmI+qX4+O27Zvm7RISOyQ
=/Dwo
-----END PGP SIGNATURE-----

--=-eqWGov+xheIdLAOn7Tit--

