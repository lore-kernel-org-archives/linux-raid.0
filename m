From: NeilBrown <neilb@suse.de>
Subject: Re: v3.5 regression in IMSM support
Date: Wed, 18 Jul 2012 10:34:58 +1000
Message-ID: <20120718103458.70046aaf@notabene.brown>
References: <20120717090526.GF23042@glaurung.lavos.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lmSBS4fQC3=qYiI/BS7RlUo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120717090526.GF23042@glaurung.lavos.net>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Downing <bdowning@lavos.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lmSBS4fQC3=qYiI/BS7RlUo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jul 2012 04:05:26 -0500 Brian Downing <bdowning@lavos.net> wrote:

> I've noticed a regression in IMSM metadata support in v3.5-rc kernels.
> I have a two-disk laptop that I run an IMSM RAID0 on so I can dual-boot
> Windows:
>=20
> :; sudo mdadm --detail-platform
>        Platform : Intel(R) Matrix Storage Manager
>         Version : 8.0.0.1039
>     RAID Levels : raid0 raid1
>     Chunk Sizes : 4k 8k 16k 32k 64k 128k
>     2TB volumes : not supported
>       2TB disks : not supported
>       Max Disks : 4
>     Max Volumes : 2 per array, 2 per controller
>  I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
>=20
> :; cat /proc/mdstat=20
> Personalities : [raid0]=20
> md126 : active raid0 sda[1] sdb[0]
>       625137664 blocks super external:/md127/0 128k chunks
>      =20
> md127 : inactive sdb[1](S) sda[0](S)
>       4520 blocks super external:imsm
>       =20
> unused devices: <none>
>=20
> What's happened in v3.5 is that it's no longer possible to incrementally
> assemble this array, as for example udev rules do.  This breaks my
> initramfs, and I wind up at a recovery prompt.  'mdadm --assemble --scan'
> is still able to bring up the array enough to get lvm going, though I
> think it's still a little messed up; note the 0 length metadata partition
> reported here:
>=20
> :; cat mdstat.bad=20
> Personalities : [raid0]=20
> md126 : active raid0 sda[1] sdb[0]
>       625137664 blocks super external:/md127/0 128k chunks
>      =20
> md127 : inactive sdb[1](S) sda[0](S)
>       0 blocks super external:imsm
>       =20
> unused devices: <none>
>=20
> Manually running the incremental mdadm looks like this:
>=20
> # mdadm -I /dev/sda
> [   22.514509] md: bind<sda>
> mdadm: failed to add /dev/sda to /dev/md/imsm0: Invalid argument.
> [   22.516151] md: md127 stopped.
> [   22.516234] md: unbind<sda>
> [   22.536399] md: export_rdev(sda)
>=20
> The same "mdadm: ... Invalid argument." messages print out from the
> --assemble --scan, yet the array comes up (enough to mount, anyway).
>=20
> I bisected down to this commit:
>=20
>     commit c6563a8c38fde3c1c7fc925a10bde3ca20799301
>     Author: NeilBrown <neilb@suse.de>
>     Date:   Mon May 21 09:27:00 2012 +1000
>=20
>         md: add possibility to change data-offset for devices.

Thank you so much for a very thorough bug report!!

Fix is below - please test and confirm that it fixes your symptoms.

NeilBrown

=46rom a8969e09fd854e9ff302e443c6a185505c3a6624 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 18 Jul 2012 10:34:18 +1000
Subject: [PATCH] md: fix bug in handling of new_data_offset

commit c6563a8c38fde3c1c7fc925a10bde3ca20799301
    md: add possibility to change data-offset for devices.

introduced a 'new_data_offset' attribute which should normally
be the same as 'data_offset', but can be explicitly set to a different
value to allow a reshape operation to move the data.

Unfortunately when the 'data_offset' is explicitly set through
sysfs, the new_data_offset is not also set, so the two would become
out-of-sync incorrectly.

One result of this is that trying to set the 'size' after the
'data_offset' would fail because it is not permitted to set the size
when the 'data_offset' and 'new_data_offset' are different - as that
can be confusing.
Consequently when mdadm tried to do this while assembling an IMSM
array it would fail.

This bug was introduced in 3.5-rc1.

Reported-by: Brian Downing <bdowning@lavos.net>
Bisected-by: Brian Downing <bdowning@lavos.net>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bdc5c7b..775688e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2884,6 +2884,7 @@ offset_store(struct md_rdev *rdev, const char *buf, s=
ize_t len)
 		 * can be sane */
 		return -EBUSY;
 	rdev->data_offset =3D offset;
+	rdev->new_data_offset =3D offset;
 	return len;
 }
=20

--Sig_/lmSBS4fQC3=qYiI/BS7RlUo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAYEsjnsnt1WYoG5AQLxuA//Y79wL1mHwkwSr16qyZqy+QALmGRu41La
tEBp06oqMSoprpQ5a7bdVOJ/ARYRPIXWCbRjbnppxX+uvNfrgtK5r9T3a6QHsP03
UQ7yF5FsDtVYuucEIqXPOqQ911JPm3e8gsLhjbi3FHxP9CArRuBPLHzXk7oPQDhM
xaubaUV1sAzDHKAAC2CvTZMGKRTJE5ZAN7kf8rAEKHbkCELS63Mu6e2KVexRIiMQ
UdvvNIL4JdQa7ab3CUEYTaaz5tRv4TNBEEHuXSi4kZ4nzTdECFDkZBltRXQ8GOmr
X7vOjCQH8bzpXlIPHgV8nYLNt+gSyDxsnEfFGadMXA0lAa3FZKTKnk2x2VoFQHw6
AeYmWQXcp5SNrMk5B9d1tE54eXqtJM3pB+RZHCUkZyJPu0b3LlkvVRfuWXCXeD8o
JuNbz8faxMqVeLrxjwO4geUra+TnKalJBkSqSOklEY/xlyPNt39yQJtZPXj5CI9D
Sr3KqvGw7uUTcuXAwn4gob5AG9aT2Y/RmNM02NtkrGMRMcQYl2+rkE7OlvnBFU7N
EvzwNOBe2npTeef3PVNw/pPN7PdH0Y74i6aa0PnDSMJoF8zeE1O1TpqlKriRK4jA
l354m8gXbVLRrpduTu2qCh2tF9DFHBpIL1Y8efy8bHG2X9qek23HbeVqLl8cDDHV
WwLM/gv0RUE=
=edTc
-----END PGP SIGNATURE-----

--Sig_/lmSBS4fQC3=qYiI/BS7RlUo--
