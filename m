From: Davide Guarisco <guarisco@sbcglobal.net>
Subject: Re: Recovering RAID set after OS disk failed
Date: Tue, 3 Jun 2014 22:00:06 -0700
Message-ID: <A5637DAF-91A1-4313-9314-13058D65F0C0@sbcglobal.net>
References: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net> <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu> <A2FAF98E-1CEC-41C5-8AA4-9CE707A477F6@sbcglobal.net> <538D65AC.1090706@eyal.emu.id.au>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6E089B25-5117-441D-A4AE-7BAB531FB3FA"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <538D65AC.1090706@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_6E089B25-5117-441D-A4AE-7BAB531FB3FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


On Jun 2, 2014, at 23:05, Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> Davide,
>=20
> Do you expect a partition table or do you use the whole disk as the fs =
(or whatever
> higher layers you have)?


I do not remember. It=E2=80=99s possible I originally setup two =
partitions, one for Time Machine and one as shared storage.=20


>=20
> What does your /etc/fstab entry say?


fstab is all new, so it says:

davide@gecko:/etc$ cat fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID=3D as a more robust way to name =
devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/mapper/gecko--vg-root /               ext4    errors=3Dremount-ro 0 =
      1
# /boot was on /dev/sda1 during installation
UUID=3D89a63dd3-93fb-4a37-acd5-34f6790ef3e7 /boot           ext2    =
defaults        0       2
/dev/mapper/gecko--vg-swap_1 none            swap    sw              0   =
    0




>=20
> Did you try a simple
> 	sudo mount /dev/md0
>=20
> You do not say if you rebooted (to let initrd) do its thing.
>=20
> Eyal


All right, I will reboot now=E2=80=A6

After reboot:

davide@gecko:~$ sudo fdisk -l
[sudo] password for davide:=20
no talloc stackframe at ../source3/param/loadparm.c:4864, leaking memory

Disk /dev/sda: 31.9 GB, 31937527808 bytes
255 heads, 63 sectors/track, 3882 cylinders, total 62377984 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000384c2

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      499711      248832   83  Linux
/dev/sda2          501758    62375935    30937089    5  Extended
/dev/sda5          501760    62375935    30937088   8e  Linux LVM

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xe3494e66

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63  1953520064   976760001   fd  Linux raid =
autodetect

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x6b47e429

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1              63  1953520064   976760001   fd  Linux raid =
autodetect

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xfdfcb365

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1              63  1953520064   976760001   fd  Linux raid =
autodetect

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x6303429f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1              63  1953520064   976760001   fd  Linux raid =
autodetect

Disk /dev/md0: 3000.6 GB, 3000606523392 bytes
2 heads, 4 sectors/track, 732569952 cylinders, total 5860559616 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 131072 bytes / 393216 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/mapper/gecko--vg-root: 29.5 GB, 29536288768 bytes
255 heads, 63 sectors/track, 3590 cylinders, total 57688064 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/mapper/gecko--vg-root doesn't contain a valid partition table

Disk /dev/mapper/gecko--vg-swap_1: 2139 MB, 2139095040 bytes
255 heads, 63 sectors/track, 260 cylinders, total 4177920 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/mapper/gecko--vg-swap_1 doesn't contain a valid partition =
table



Now trying to mount md0:

davide@gecko:~$ sudo mount /dev/md0
mount: can't find /dev/md0 in /etc/fstab or /etc/mtab


OK, I am lost now.=20

Davide












>=20
> On 06/03/14 15:49, Davide Guarisco wrote:
>> Peter, thanks for your help. Below are the answers.
>>=20
>>=20
>> On Jun 2, 2014, at 05:36, K=C5=91v=C3=A1ri P=C3=A9ter =
<peter@kovari.priv.hu> wrote:
>>=20
>>> Hi Davide,
>>>=20
>>> Open / ssh a console on your NAS box, and issue the following =
command and send us the results:
>>> $ cat /proc/mdstat
>>=20
>>=20
>> Personalities :
>> unused devices: <none>
>>=20
>>=20
>>=20
>>>=20
>>> Please also issue the following commands
>>>=20
>>> mdadm --examine /dev/sdX[Y]
>>=20
>> $ mdadm =E2=80=94examine /dev/sdb
>> mdadm: cannot open /dev/sdb: Permission denied
>>=20
>>=20
>> $ sudo mdadm =E2=80=94examine /dev/sdb
>> /dev/sdb:
>> 	MBR Magic : aa55
>> Partition[0] : 1953520002 sectors at       63 (type fd)
>>=20
>>=20
>> $ sudo mdadm =E2=80=94examine /dev/sdb1
>> /dev/sdb1:
>>           Magic : a92b4efc
>>         Version : 0.90.00
>>            UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host =
gecko)
>>   Creation Time : Tue Mar  3 23:27:50 2009
>>      Raid Level : raid5
>>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>      Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>> Preferred Minor : 0
>>=20
>>     Update Time : Wed May 28 21:52:54 2014
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : 2d5185d8 - correct
>>          Events : 46
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 128K
>>=20
>>       Number   Major   Minor   RaidDevice State
>> this     0       8       17        0      active sync   /dev/sdb1
>>=20
>>    0     0       8       17        0      active sync   /dev/sdb1
>>    1     1       8       33        1      active sync   /dev/sdc1
>>    2     2       8       49        2      active sync   /dev/sdd1
>>    3     3       8       65        3      active sync   /dev/sde1
>>=20
>>=20
>>> mdadm --examine /dev/sdc1
>>=20
>> /dev/sdc1:
>>           Magic : a92b4efc
>>         Version : 0.90.00
>>            UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host =
gecko)
>>   Creation Time : Tue Mar  3 23:27:50 2009
>>      Raid Level : raid5
>>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>      Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>> Preferred Minor : 0
>>=20
>>     Update Time : Wed May 28 21:52:54 2014
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : 2d5185ea - correct
>>          Events : 46
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 128K
>>=20
>>       Number   Major   Minor   RaidDevice State
>> this     1       8       33        1      active sync   /dev/sdc1
>>=20
>>    0     0       8       17        0      active sync   /dev/sdb1
>>    1     1       8       33        1      active sync   /dev/sdc1
>>    2     2       8       49        2      active sync   /dev/sdd1
>>    3     3       8       65        3      active sync   /dev/sde1
>>=20
>>=20
>> =E2=80=A6etc. So it seems to me that we are OK, with the RAID 5 set =
setup on /dev/sdb1, /dev/sdc1, /dev/sdd1, /dev/sde1.
>>=20
>>>=20
>>> Where X is one of the raid drive's name and Y is the partition =
number, if you created the raid set on partitions. (If not, then leave =
the number.) So, for example (assuming that your OS drive is /dev/sda, =
so your raid drives are /dev/sdb, /dev/sdc and so on) issue the =
following commands:
>>>=20
>>> $ mdadm --examine /dev/sdb
>>> or
>>> $ mdadm --examine /dev/sdb1
>>>=20
>>> and so on for all 4 drives. And send back the results.
>>>=20
>>> p.s.
>>> Before everything else,  you might try  auto assembling th eset by:
>>> $ mdadm -v --assemble =E2=80=94scan
>>=20
>> Trying this holding my breath=E2=80=A6.
>>=20
>>> mdadm -v --assemble --scan
>>=20
>> mdadm: looking for devices for /dev/md0
>> mdadm: no recogniseable superblock on /dev/dm-1
>> mdadm: no recogniseable superblock on /dev/dm-0
>> mdadm: no RAID superblock on /dev/sde
>> mdadm: no RAID superblock on /dev/sdd
>> mdadm: no RAID superblock on /dev/sdb
>> mdadm: no RAID superblock on /dev/sdc
>> mdadm: no RAID superblock on /dev/sda5
>> mdadm: no RAID superblock on /dev/sda2
>> mdadm: no RAID superblock on /dev/sda1
>> mdadm: no RAID superblock on /dev/sda
>> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
>> mdadm: added /dev/sdc1 to /dev/md0 as 1
>> mdadm: added /dev/sdd1 to /dev/md0 as 2
>> mdadm: added /dev/sde1 to /dev/md0 as 3
>> mdadm: added /dev/sdb1 to /dev/md0 as 0
>> mdadm: /dev/md0 has been started with 4 drives.
>>=20
>>=20
>> OK, this seems successful as well. My RAID is /dev/md0.
>>=20
>>=20
>>=20
>>=20
>>>=20
>>> It might assemble your raid set for you successfully out of the box. =
 (If not, send here the output.)
>>> If this assembles your set successfully, then you just need to save =
your config in /etc/mdam/mdadm.conf, do an initramfs update and you are =
good to go.
>>> So to save the config issue:
>>> $ mdadm --examine --scan >> /etc/mdadm/mdadm.conf
>>=20
>>> cat /etc/mdadm/mdadm.conf
>>=20
>> ARRAY /dev/md0 UUID=3Df8a943c7:2ffa13d0:9770de34:eca2e81c
>>=20
>>=20
>>=20
>>>=20
>>> then update initramfs so th eset will auto assmble on next boot:
>>> $ update-initramfs -k all -u
>>=20
>>> update-initramfs -k all -u
>>=20
>> update-initramfs: Generating /boot/initrd.img-3.13.0-24-generic
>>=20
>>=20
>>=20
>> But now:
>>=20
>>> sudo fdisk -l
>>=20
>> Disk /dev/md0: 3000.6 GB, 3000606523392 bytes
>> 2 heads, 4 sectors/track, 732569952 cylinders, total 5860559616 =
sectors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 131072 bytes / 393216 bytes
>> Disk identifier: 0x00000000
>>=20
>> Disk /dev/md0 doesn=E2=80=99t contain a valid partition table
>>=20
>>=20
>>=20
>> How do I fix this and how to I gain access to /dev/md0?
>>=20
>> Thanks,
>> 	Davide
>>=20
>>=20
>>=20
>>=20
>>=20
>>=20
>=20
> --=20
> Eyal Lebedinsky (eyal@eyal.emu.id.au)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html






--Apple-Mail=_6E089B25-5117-441D-A4AE-7BAB531FB3FA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJTjqfWAAoJEOP6S0R9UICWpl8P/3ZvK/PNI/ejG346Ce4Kdse/
nau4gIeL7jsZuxIcDNvhKz82efsIrryImGDxBySKqpEixUBFx21Ry98FeUHY4LoA
LAgB73FQmRihVrOMNh1e2zUMieULRfxdjX++Qn0DhA07F2Q9O+teJ+hc0So8bb2Z
TBBzWggii4Pij1tXWMnycggXC4vnIQCpkKbTxXtqrRqfzbApw4TW85XPEIODE1Vf
3ljYvxJfigJZwxUr9FY2WLlX9iDWvLIbmEbXfH+1+rplXlMoP96jN6Zk6RXsN1zF
iSHeVWAHdAd0NNsFY1A9PIlwODbzXbxop5Y0gvmxEDJAcwZrXumBIOXDCrRbsf6O
nZLadnIt/dCEqLd9gSpkAD5fXdUPfWKPbvEksV4LToQ0RwLEWbnAMR40XpXzL5e6
P113arSQ0+gm/TQlqN6M7dk1q9Ortotpz89xjcAGyGQC8twKveobBwn6Tj0Fpg4G
aKfrkZPHW/wrQrM+LIKtpqC7Ux1agFXa9EuZAGXOU6w0lMV6q8TIkyeTiO+0VFwh
mi4RzH520QH4rkOg5kHhwCRQZh39RozoEa+0Kqf3cwg1W7ITi8WHRYCzAwEghrf2
uuTJ29K5ZFDkunMoyYg+Ee3hv4BCE7/++lqPpUXzGLf2ufonQxoKYVkGfhJA6jJd
hJZlPCdxy9iFOiGnuIXo
=DDPX
-----END PGP SIGNATURE-----

--Apple-Mail=_6E089B25-5117-441D-A4AE-7BAB531FB3FA--
