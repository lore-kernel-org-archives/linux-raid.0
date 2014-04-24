From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Thu, 24 Apr 2014 19:48:32 +0200
Message-ID: <20140424194832.2d0a867f@netstation>
References: <20140424070548.445497dd@netstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424070548.445497dd@netstation>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Up please :-(

Le Thu, 24 Apr 2014 07:05:48 +0200,
"L.M.J" <linuxmasterjedi@free.fr> a =E9crit :

> Hi,
>=20
> For the third time, I had to change a failed drive from my home linux=
 RAID5 box. Previous one went right and
> this time, I don't know what I did wrong, but I broke my RAID5. Well,=
 at least, he didn't want to
> start. /dev/sdb was the failed drive /dev/sdc and /dev/sdd are OK.
>=20
> I tried to reassemble the RAID with this command after I replace sdb =
and create a new partition :
>=20
>  ~# mdadm -Cv /dev/md0 --assume-clean --level=3D5 --raid-devices=3D3 =
/dev/sdc1 /dev/sdd1 /dev/sdb1
> -> '-C' was not a good idea here=20
>=20
> Well, I guess I did an another mistake here, I should have done this =
instead :
>  ~# mdadm -Av /dev/md0 --assume-clean --level=3D5 --raid-devices=3D3 =
/dev/sdc1 /dev/sdd1 missing
>=20
> Maybe this wipe out my data...
> Let's go futher, then, pvdisplay, pvscan, vgdisplay returns empty inf=
ormation=20
>=20
> Google helped me, and I did this :
>  ~# dd if=3D/dev/md0 bs=3D512 count=3D255 skip=3D1 of=3D/tmp/md0.txt
>=20
> 	[..]
> 	physical_volumes {
> 		pv0 {
> 			id =3D "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW"
> 			device =3D "/dev/md0"
> 			status =3D ["ALLOCATABLE"]
> 			flags =3D []
> 			dev_size =3D 7814047360
> 			pe_start =3D 384
> 			pe_count =3D 953863
> 		}
> 	}
> 	logical_volumes {
>=20
> 		lvdata {
> 			id =3D "JiwAjc-qkvI-58Ru-RO8n-r63Z-ll3E-SJazO7"
> 			status =3D ["READ", "WRITE", "VISIBLE"]
> 			flags =3D []
> 			segment_count =3D 1
> 	[..]
>=20
> Since I saw lvm information, I guess I haven't lost all information y=
et...
>=20
> I tried an unhoped command :
>  ~# pvcreate --uuid "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW"
> --restorefile /etc/lvm/archive/lvm-raid_00302.vg /dev/md0 Then,
>=20
>  ~# vgcfgrestore lvm-raid
>=20
>  ~# lvs -a -o +devices
>    LV     VG       Attr   LSize   Origin Snap%  Move Log Copy%  Conve=
rt  Devices
>    lvdata lvm-raid -wi-a- 450,00g                                    =
                 /dev/md0(148480)
>    lvmp   lvm-raid -wi-a-  80,00g                                    =
                 /dev/md0(263680)
> Then :
>  ~# lvchange -ay /dev/lvm-raid/lv*
>=20
> I was quite happy until now.
> Problem appears now when I try to mount those 2 LV (lvdata & lvmp) as=
 ext4 partition :
>  ~# mount /home/foo/RAID_mp/
>=20
>  ~# mount | grep -i mp
>       /dev/mapper/lvm--raid-lvmp on /home/foo/RAID_mp type ext4 (rw)
>=20
>  ~# df -h /home/foo/RAID_mp
>       Filesystem                            Size  Used Avail Use%   M=
ounted on
>       /dev/mapper/lvm--raid-lvmp   79G   61G   19G  77%   /home/foo/R=
AID_mp
>=20
> Here is the big problem
>  ~# ls -la /home/foo/RAID_mp
>       total 0
>=20
> I did a LVM R/W snapshot on the /dev/mapper/lvm--raid-lvmp LV, I fsck=
 it. I recover 50% of the files only,
> all located in lost-+found/ directory with names heading with #xxxxx.
>=20
> I would like to know if there is a last chance to recover my data ?
>=20
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
