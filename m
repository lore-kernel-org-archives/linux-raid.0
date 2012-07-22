From: NeilBrown <neilb@suse.de>
Subject: Re: "A Nasty md/raid bug"
Date: Mon, 23 Jul 2012 09:00:21 +1000
Message-ID: <20120723090021.3a2fa144@notabene.brown>
References: <20120721161607.8820D2C3@centrum.sk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hp.u.733jNoFemIvK8v/lZc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120721161607.8820D2C3@centrum.sk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Modrala <x3m2@centrum.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hp.u.733jNoFemIvK8v/lZc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jul 2012 16:16:07 +0200 "Peter Modrala" <x3m2@centrum.sk> wrote:

> Hi,
> =C2=A0
> I firstly installed ubuntu server 12.04 and set up LVM on top of RAID1. A=
fter several days the system wasn't able to boot. RAID array was broken. Th=
en I found this bug on your page:
> http://neil.brown.name/blog/20120615073245
> Then I decided to install newest ubuntu alternate which provides 3.5.0-5 =
version of kernel. After instalation's very first reboot I got the same mes=
sages as previously.
> I also installed linux-source-3.5.0 to verify the bug was fixed in this v=
ersion of kernel.

If I understand correctly you simply gave up on the original installation,
didn't want to recovery any data of the array, and just installed a new
version of Ubuntu.  Is that correct?

In that case this is definitely a different problem, and the further details
you provided seem to confirm this.

I gather that your aren't using the md/raid1 array for the root filesystem =
so
the machine boot ups reasonably OK, it is just that the array isn't assembl=
ed
properly.  Correct?

So we need to treat this as a new problem:
  You installed some new Ubuntu distro and it didn't set up the arrays
  properly.

I would suggest that your best bet is to ask for support in some Ubuntu for=
um.

However if you can provide the exact details of the error you receive when
you boot, then I might be able to suggest something.

Alternately if I misunderstood your problem description, please help me
understand exactly what happened.

> =C2=A0
> I can provide you root access if you want to check anything on my server.

I'd rather avoid that if possible.  Let's start with precise error messages.

NeilBrown






> =C2=A0
> Thank You
> =C2=A0
> Martin
> =C2=A0
> ---
> =C2=A0
> # uname -a
> Linux rat 3.5.0-5-generic #5-Ubuntu SMP Tue Jul 17 16:17:55 UTC 2012 x86_=
64 x86_64 x86_64 GNU/Linux
> =C2=A0
> linux-source-3.5.0/drivers/md/md.c:
> ...
> static int md_notify_reboot(struct notifier_block *this,
>  unsigned long code, void *x)
> {
>  struct list_head *tmp;
>  struct mddev *mddev;
>  int need_delay =3D 0;
>=20
>  for_each_mddev(mddev, tmp) {
>  if (mddev_trylock(mddev)) {
>  if (mddev->pers)
>  __md_stop_writes(mddev);
>  mddev->safemode =3D 2;
>  mddev_unlock(mddev);
>  }
>  need_delay =3D 1;
>  }
>  /*
>  * certain more exotic SCSI devices are known to be
>  * volatile wrt too early system reboots. While the
>  * right place to handle this issue is the given
>  * driver, we do want to have a safe RAID driver ...
>  */
>  if (need_delay)
>  mdelay(1000*1);
>=20
>  return NOTIFY_DONE;
> }=C2=A0
> ...
> =C2=A0
> =C2=A0
> # update-grub
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> Generating grub.cfg ...
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> Found linux image: /boot/vmlinuz-3.5.0-5-generic
> Found initrd image: /boot/initrd.img-3.5.0-5-generic
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> Found linux image: /boot/vmlinuz-3.5.0-5-generic
> Found initrd image: /boot/initrd.img-3.5.0-5-generic
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> error: unknown LVM metadata header.
> Found memtest86+ image: /boot/memtest86+.bin
> done
> =C2=A0
> =C2=A0
> # mdadm -Evvvvs
> mdadm: No md superblock detected on /dev/dm-3.
> mdadm: No md superblock detected on /dev/dm-2.
> mdadm: No md superblock detected on /dev/dm-1.
> mdadm: No md superblock detected on /dev/dm-0.
> mdadm: No md superblock detected on /dev/md/0.
> mdadm: No md superblock detected on /dev/sdb5.
> /dev/sdb2:
>  MBR Magic : aa55
> Partition[0] : 683800576 sectors at 2 (type 8e)
> /dev/sdb1:
>  Magic : a92b4efc
>  Version : 1.2
>  Feature Map : 0x0
>  Array UUID : dec31ddc:13aa86e0:d0635ca8:b630b4a5
>  Name : rat:0 (local to host rat)
>  Creation Time : Fri Jul 20 23:11:14 2012
>  Raid Level : raid1
>  Raid Devices : 2
>=20
>  Avail Dev Size : 292704256 (139.57 GiB 149.86 GB)
>  Array Size : 146352000 (139.57 GiB 149.86 GB)
>  Used Dev Size : 292704000 (139.57 GiB 149.86 GB)
>  Data Offset : 262144 sectors
>  Super Offset : 8 sectors
>  State : clean
>  Device UUID : a9e91e4b:550235d5:de6f6a16:44d74be1
>=20
>  Update Time : Sat Jul 21 16:06:32 2012
>  Checksum : c91e067d - correct
>  Events : 26
>=20
>=20
>  Device Role : Active device 1
>  Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdb:
>  MBR Magic : aa55
> Partition[0] : 292966400 sectors at 2048 (type fd)
> Partition[1] : 683800578 sectors at 292970494 (type 05)
> mdadm: No md superblock detected on /dev/sda5.
> /dev/sda2:
>  MBR Magic : aa55
> Partition[0] : 683800576 sectors at 2 (type 8e)
> /dev/sda1:
>  Magic : a92b4efc
>  Version : 1.2
>  Feature Map : 0x0
>  Array UUID : dec31ddc:13aa86e0:d0635ca8:b630b4a5
>  Name : rat:0 (local to host rat)
>  Creation Time : Fri Jul 20 23:11:14 2012
>  Raid Level : raid1
>  Raid Devices : 2
>=20
>  Avail Dev Size : 292704256 (139.57 GiB 149.86 GB)
>  Array Size : 146352000 (139.57 GiB 149.86 GB)
>  Used Dev Size : 292704000 (139.57 GiB 149.86 GB)
>  Data Offset : 262144 sectors
>  Super Offset : 8 sectors
>  State : clean
>  Device UUID : 458f63c4:1a882d4d:1ce3c46c:b0da0244
>=20
>  Update Time : Sat Jul 21 16:06:32 2012
>  Checksum : 736ca887 - correct
>  Events : 26
>=20
>=20
>  Device Role : Active device 0
>  Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sda:
>  MBR Magic : aa55
> Partition[0] : 292966400 sectors at 2048 (type fd)
> Partition[1] : 683800578 sectors at 292970494 (type 05)
>=20
>=20
> =C2=A0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/hp.u.733jNoFemIvK8v/lZc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAyGBTnsnt1WYoG5AQL7vA//c2a0daTT7PrigRN2G/s66yNpCyseqiri
94RWupaDFRiBSQlBTdwnx+lRdNvTr9sL7Cs3SVKy5uwCVmaxv0FSTbaaHHE5KFDA
up07XvwXB1EzQtFVaS64ZsPxANIrWTvGNcfqy64KTorek8M3BmOXi/O8KzxLZ76v
6v4a+WgLMLZJ/SJ6OIDgNS9qRWY6Xv4EQNjw/3ktmLPF35bUpCirKGvszd+51SEe
lxAQfto5PVFNdxUi+d/iw/ogUcVRHTEiGj1HL8rAXS2j4KF3NCXlRlmqF9vCvEb+
uB/hbJ1JtjMsOo5ukCmsUm+1csYAjQ1sWnd7uVh2SThBafIs5CvAB9QpNJibhcYj
CFCmT4BtovOlnZf/HOK4kRwB4XaqEE6+jz00t469mX54sDUE6pNjMD8sUj7PDae7
lQBEb67qlfHcmp/cy75iYNowAvo2SqbdafJxlK8tJI5nxHa2iEMRs9wVYSHaQrbX
MkEzuhLNKuAYBL7+HgErmnEtksWfxQ9Ho+XPsO8Trk6HFoRd5P2nP2khoyA78qRl
qdE9VKPGpDG33YbVcd283QJrIbujBurbREmCKWhOO+SOtLIv1eI/C9Uh8J9CQtcQ
Bc1zp/0fv53023p+tL6OuQcKk71oFb2pWx9dUtPdPUDoVX6lGJsUEBh3GpnB61BJ
ejxgOoyXx/Y=
=4zab
-----END PGP SIGNATURE-----

--Sig_/hp.u.733jNoFemIvK8v/lZc--
