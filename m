From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Mon, 2 Feb 2015 17:36:01 +1100
Message-ID: <20150202173601.1ab02927@notabene.brown>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
	<20141117100349.1d1ae1fa@notabene.brown>
	<54B663EC.8090607@redhat.com>
	<20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com>
	<2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com>
	<20150116101031.30c04df3@jlaw-desktop.mno.stratus.com>
	<1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com>
	<20150129145217.1cb31d5c@notabene.brown>
	<371504811.2053160.1422533656432.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5B8_b_DAahHkizeNcaV1mdk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <371504811.2053160.1422533656432.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

--Sig_/5B8_b_DAahHkizeNcaV1mdk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Jan 2015 07:14:16 -0500 (EST) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "NeilBrown" <neilb@suse.de>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: "Joe Lawrence" <joe.lawrence@stratus.com>, linux-raid@vger.kernel.o=
rg, "Bill Kuzeja" <william.kuzeja@stratus.com>
> > Sent: Thursday, January 29, 2015 11:52:17 AM
> > Subject: Re: RAID1 removing failed disk returns EBUSY
> >=20
> > On Sun, 18 Jan 2015 21:33:50 -0500 (EST) Xiao Ni <xni@redhat.com> wrote:
> >=20
> > >=20
> > >=20
> > > ----- Original Message -----
> > > > From: "Joe Lawrence" <joe.lawrence@stratus.com>
> > > > To: "Xiao Ni" <xni@redhat.com>
> > > > Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bill
> > > > Kuzeja" <william.kuzeja@stratus.com>
> > > > Sent: Friday, January 16, 2015 11:10:31 PM
> > > > Subject: Re: RAID1 removing failed disk returns EBUSY
> > > >=20
> > > > On Fri, 16 Jan 2015 00:20:12 -0500
> > > > Xiao Ni <xni@redhat.com> wrote:
> > > > >=20
> > > > > Hi Joe
> > > > >=20
> > > > >    Thanks for reminding me. I didn't do that. Now it can remove
> > > > >    successfully after writing
> > > > > "idle" to sync_action.
> > > > >=20
> > > > >    I thought wrongly that the patch referenced in this mail is fi=
xed
> > > > >    for
> > > > >    the problem.
> > > >=20
> > > > So it sounds like even with 3.18 and a new mdadm, this bug still
> > > > persists?
> > > >=20
> > > > -- Joe
> > > >=20
> > > > --
> > >=20
> > > Hi Joe
> > >=20
> > >    I'm a little confused now. Does the patch
> > >    45eaf45dfa4850df16bc2e8e7903d89021137f40 from linux-stable
> > > resolve the problem?
> > >=20
> > >    My environment is:
> > >=20
> > > [root@dhcp-12-133 mdadm]# mdadm --version
> > > mdadm - v3.3.2-18-g93d3bd3 - 18th December 2014  (this is the newest
> > > upstream)
> > > [root@dhcp-12-133 mdadm]# uname -r
> > > 3.18.2
> > >=20
> > >=20
> > >    My steps are:
> > >=20
> > > [root@dhcp-12-133 mdadm]# lsblk
> > > sdb                       8:16   0 931.5G  0 disk
> > > =E2=94=94=E2=94=80sdb1                    8:17   0     5G  0 part
> > > sdc                       8:32   0 186.3G  0 disk
> > > sdd                       8:48   0 931.5G  0 disk
> > > =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part
> > > [root@dhcp-12-133 mdadm]# mdadm -CR /dev/md0 -l1 -n2 /dev/sdb1 /dev/s=
dd1
> > > --assume-clean
> > > mdadm: Note: this array has metadata at the start and
> > >     may not be suitable as a boot device.  If you plan to
> > >     store '/boot' on this device please ensure that
> > >     your boot-loader understands md/v1.x metadata, or use
> > >     --metadata=3D0.90
> > > mdadm: Defaulting to version 1.2 metadata
> > > mdadm: array /dev/md0 started.
> > >=20
> > >    Then I unplug the disk.
> > >=20
> > > [root@dhcp-12-133 mdadm]# lsblk
> > > sdc                       8:32   0 186.3G  0 disk
> > > sdd                       8:48   0 931.5G  0 disk
> > > =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part
> > >   =E2=94=94=E2=94=80md0                   9:0    0     5G  0 raid1
> > > [root@dhcp-12-133 mdadm]# echo faulty > /sys/block/md0/md/dev-sdb1/st=
ate
> > > [root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/st=
ate
> > > -bash: echo: write error: Device or resource busy
> > > [root@dhcp-12-133 mdadm]# echo idle > /sys/block/md0/md/sync_action
> > > [root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/st=
ate
> > >=20
> >=20
> > I cannot reproduce this - using linux 3.18.2.  I'd be surprised if mdadm
> > version affects things.
>=20
> Hi Neil
>=20
>    I'm very curious, because it can reproduce in my machine 100%.
>=20
> >=20
> > This error (Device or resoource busy) implies that rdev->raid_disk is >=
=3D 0
> > (tested in state_store()).
> >=20
> > ->raid_disk is set to -1 by remove_and_add_spares() providing:
> >   1/ it isn't Blocked (which is very unlikely)
> >   2/ hot_remove_disk succeeds, which it will if nr_pending is zero, and
> >   3/ nr_pending is zero.
>=20
>    I remember I have tired to check those reasons. But it's really is the=
 reason 1
> which is very unlikely.
>=20
>    I add some code in the function array_state_show
>=20
>     array_state_show(struct mddev *mddev, char *page) {
>         enum array_state st =3D inactive;
>         struct md_rdev *rdev;
>=20
>         rdev_for_each_rcu(rdev, mddev) {
>                 printk(KERN_ALERT "search for %s\n", rdev->bdev->bd_disk-=
>disk_name);
>                 if (test_bit(Blocked, &rdev->flags))
>                         printk(KERN_ALERT "rdev is Blocked\n");
>                 else
>                         printk(KERN_ALERT "rdev is not Blocked\n");
>     }
>=20
>   When I echo 1 > /sys/block/sdc/device/delete, then I ran command:
>=20
> [root@dhcp-12-133 md]# cat /sys/block/md0/md/array_state=20
> read-auto
  ^^^^^^^^^

I think that is half the explanation.
You must have the md_mod.start_ro parameter set to '1'.


> [root@dhcp-12-133 md]# dmesg=20
> [ 2679.559185] search for sdc
> [ 2679.559189] rdev is Blocked
> [ 2679.559190] search for sdb
> [ 2679.559190] rdev is not Blocked
>   =20
>   So sdc is Blocked

and that is the other half - thanks.
(yes, I was wrong.  Sometimes it is easier than being right, but still
yields results).

When a device fails, it is Blocked until the metadata is updated to record
the failure.  This ensures that no writes succeed without writing to that
device, until we a certain that no read will try reading from that device,
even after a crash/restart.

Blocked is cleared after the metadata is written, but read-auto (and
read-only) devices never write out their metadata.  So blocked doesn't get
cleared.

When you "echo idle > .../sync_action" one of the side effects is to with
from 'read-auto' to fully active.  This allows the metadata to be written,
Blocked to be cleared, and the device to be removed.

If you=20
  echo none > /sys/block/md0/md/dev-sdc/slot

first, then the remove will work.

We could possibly fix it with something like the following, but I'm not sure
I like it.  There is no guarantee that I can see which would ensure the
superblock got updated before the first write if the array switch to
read/write.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9233c71138f1..b3d1e8e5e067 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7528,7 +7528,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 	rdev_for_each(rdev, mddev)
 		if ((this =3D=3D NULL || rdev =3D=3D this) &&
 		    rdev->raid_disk >=3D 0 &&
-		    !test_bit(Blocked, &rdev->flags) &&
+		    (!test_bit(Blocked, &rdev->flags) || mddev->ro) &&
 		    (test_bit(Faulty, &rdev->flags) ||
 		     ! test_bit(In_sync, &rdev->flags)) &&
 		    atomic_read(&rdev->nr_pending)=3D=3D0) {



--Sig_/5B8_b_DAahHkizeNcaV1mdk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM8a0Tnsnt1WYoG5AQLc4BAAgTS7Sw7et4/3dPiiw4Ank1Q7ia3U/LBd
CloAYQw00NyAVg6FOBFswqgmTenzQUCxTaJKsoz86bzAlNQMkrg1Vc9qWDMGuH0V
AzrPUZOYTWoC7JK/Vhqlt73pYZ/0E2S8IOLigeRpuzjCoZn0G+q5wvlEn7M9mfE5
LfYs5aPsSa1XfN5iFwUUyghrLTCMMjY6Ng1/oJSIIJYpqAzP5TwFCBIv26F6WD6Q
zH7baVEJ0BqOdwNWcX7D0+OZGmntRcGrMPSqoRTn1oUGV7VCGiLQb+smrjojLigF
aCjdnyE9YoecLeqKU766vuu+go7RxpT2VQFzn/m2arIomB444KZoR8vi0TcSY9OM
mRdSTaxgrgqACvke3Xnvwxi8jAocLtqvp7yOeHEVYH99fxaRffU3aEIPaT+KM5Ut
YIbQW82tIn83AUI4uLFYryExMXvZa/e0jbbhjhR5e7OiRX5ur/w/Mo2X7PQzNwoh
MSJ1GUTow2JYjBvOcF041Lmdqg8YzXJnvl+ye0g1n1yDs9yoUWWTkwme0/4SgccO
isZ5YuJ0e9wwEil0b5a6m+ei8H4qm6buTavko3bLWuNaPOO9JPCcDqov2qr9gA1P
79gq5xDbwPYqOZKUhIcR3GfBR/NSU1j6vCoFFvCwBf9dHU6pVRUoBqMRhwpgMo9m
1Qxy+XqXi1k=
=vUhC
-----END PGP SIGNATURE-----

--Sig_/5B8_b_DAahHkizeNcaV1mdk--
