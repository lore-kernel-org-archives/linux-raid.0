From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Growing RAID1 array with bitmaps enabled
Date: Fri, 19 Dec 2008 08:53:34 -0600
Message-ID: <20081219145334.GC29150@atlantis.cc.ndsu.NoDak.edu>
References: <20081219040730.GA6402@atlantis.cc.ndsu.NoDak.edu> <18763.10505.701483.494901@notabene.brown>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18763.10505.701483.494901@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2008 at 03:54:33PM +1100, Neil Brown wrote:

[snip...]
> =20
> > 1) Does the superblock increase in size when the array is grown=20
> > to make room for a larger bitmap?  (This doesn't seem possible=20
> > to me, particularly if using a v1.1 or v1.2 superblock).
>=20
> The bitmap does not live in the superblock.  It lives near the
> superblock. For 0.90, the superblock is 4K in size, and lives at=20
> least 60K from the end of the device.  The bitmap lives in that 60K.
>=20
> For 1.0, the superblock is 1K in size and lives between 8K and 12K
> from the end of the device.  There is usually some space reserved
> before the superblock which is not used for data.  The bitmap lives in
> one of these spaces.
>=20
> For 1.1 and 1.2, the superblock is 1K in size and lives near the start
> of the device.  There is usually some space reserved after the
> superblock and before the data.  The bitmap is stored there.
>
=20
Thanks for the explanation and correction.=20

[snip...]

> > With this in mind (and the adage that patches are welcome), has there=
=20
> > been any interest in being able to use a write-intent bitmap for this=
=20
> > kind of use case?  The benefit of this functionality would keep me=20
> > from eating two _full_ re-syncs on the array when growing the block=20
> > devices.
>=20
> I think you misunderstand.  There is no need for a full resync.
> You simply
>=20
>   mdadm --grow /dev/md0 --bitmap none
>   mdadm --grow /dev/md0 --size max
>   mdadm --wait /dev/md0
>   mdadm --grow /dev/md0 --bitmap internal
>=20
> The "--wait" will wait while the array syncs the data from 40GB to
> 100GB.

Before I can grow the array (using your example), I need to fail
and remove the devices from the array so they can be grown on the
FC target.  Something like this:

    # Fail and remove the device that is to be grown
    mdadm /dev/md0 --fail /dev/sdc1
    mdadm /dev/md0 --remove /dev/sdc1

    # Remove the device from the system
    echo '1' >| /sys/block/sdc/device/delete

Now that the exported device has been removed from the initiator,
I can grow the volume on the target.

    # Scan for the block device that is now 100GB
    echo "- - -" >| /sys/class/scsi_host/host3/scan

With the system now seeing the larger block device, I can resize
the partition (I'll need to use v1.1 or v1.2 suberblock to
prevent the superblock from getting clobbered).

    # Add device back into the array
    mdadm /dev/md0 --add /dev/sdc1

This is where I would like to use a write-intent bitmap.  When the=20
re-sync finishes, I would do the same to the other device (and
hopefully use the bitmap for its re-sync).  =20

Your email about the bitmap not growing has me a bit gun shy.  Can=20
I use a write-intent bitmap in this situation without shooting=20
myself in the foot?

After both devices have been grown, I would grow the array just
as you pointed out in your example:

   mdadm --grow /dev/md0 --bitmap none
   mdadm --grow /dev/md0 --size max
   mdadm --wait /dev/md0
   mdadm --grow /dev/md0 --bitmap internal

If I understand you correctly, its the "mdadm --grow /dev/md0
--size max" that will bite me if I have a bitmap enabled.  Thus,
you removed the bitmap from the array while growing.

Thanks in advance,

Bryan

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJS7VulSl3SAlkhEcRAgHNAJwKa2H53XsMKPurc3kVkvCDe5m11wCcDK64
Hg8d9SLhdPg7h0FnCvTrT+U=
=3YiW
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
