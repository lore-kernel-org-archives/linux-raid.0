From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Thu, 17 Sep 2009 17:46:33 -0400
Message-ID: <200909171746569.SM04116@trainer>
References: <20090917210148.GB19611@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090917210148.GB19611@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46irst off, lemme tell you the initial problem. I had a WD ShareSpace =
that
had one of the disk go bad. They sent a replacement and it was suppose =
to
rebuild on its own, however after the build, the array went bad and it =
was
no longer able to see any of the files.=20

I downloaded and tested the drives using windows data recovery tools I =
saw
that the ext3 was Linux FS and that using these tools would not help in=
 the
recovery. However through the tools I was able to see and recover some =
of
the files, but the files themselves were usable. I confirmed with WD th=
at
ext3 was in fact the FS and took steps to recover the data. These are t=
he
steps I took in order for me to assemble the raid.

Right now I have 3/4 drives with the data. I did #mdadm --assemble --sc=
an,
which let me assemble the raid. However at this point I was not able to=
 see
any of the files or mount the drive to the mount point it was once at. =
I
have also tried #mdadm --create with the array in the right order /w th=
e
missing disk.=20

Initially the --assemble --scan assembled the array /dev/md2 with the d=
isks
in the wrong order. I know because I physically saw where the disks wer=
e in
relation to the disk order and wrote down the disk order on every HD.

Here's everything I could find in terms of information that you asked f=
or.
It's a lot.

#dmesg
[  339.440187] raid5: device sdb4 operational as raid disk 1
[  339.440189] raid5: device sdd4 operational as raid disk 3
[  339.440192] raid5: device sdc4 operational as raid disk 2
[  339.440610] raid5: allocated 4219kB for md2
[  339.440612] raid5: raid level 5 set md2 active with 3 out of 4 devic=
es,
algorithm 2
[  339.440615] RAID5 conf printout:
[  339.440617]  --- rd:4 wd:3
[  339.440619]  disk 1, o:1, dev:sdb4
[  339.440620]  disk 2, o:1, dev:sdc4
[  339.440622]  disk 3, o:1, dev:sdd4
[  339.440817]  md2: unknown partition table
[  538.840033] kjournald starting.  Commit interval 5 seconds
[  538.891844] EXT3 FS on md0, internal journal
[  538.891849] EXT3-fs: mounted filesystem with ordered data mode.
[  581.585031] VFS: Can't find ext4 filesystem on dev md2.
[  587.056825] VFS: Can't find ext3 filesystem on dev md2.


#fdisk -l
WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fd=
isk
doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      243202  1953514583+  ee  GPT

Disk /dev/sdb: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0xdd07e5e3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1          26      208844+  fd  Linux raid
autodetect
/dev/sdb2              27         156     1044225   fd  Linux raid
autodetect
/dev/sdb3             157         182      208845   fd  Linux raid
autodetect
/dev/sdb4             183      243201  1952050117+  fd  Linux raid
autodetect

Disk /dev/sdc: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0xdd07e5e4

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1          26      208844+  fd  Linux raid
autodetect
/dev/sdc2              27         156     1044225   fd  Linux raid
autodetect
/dev/sdc3             157         182      208845   fd  Linux raid
autodetect
/dev/sdc4             183      243201  1952050117+  fd  Linux raid
autodetect

Disk /dev/sdd: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0xdd07e5e2

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1          26      208844+  fd  Linux raid
autodetect
/dev/sdd2              27         156     1044225   fd  Linux raid
autodetect
/dev/sdd3             157         182      208845   fd  Linux raid
autodetect
/dev/sdd4             183      243201  1952050117+  fd  Linux raid
autodetect

Disk /dev/md0: 213 MB, 213778432 bytes
2 heads, 4 sectors/track, 52192 cylinders
Units =3D cylinders of 8 * 512 =3D 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/md2: 5996.6 GB, 5996697747456 bytes
2 heads, 4 sectors/track, 1464037536 cylinders
Units =3D cylinders of 8 * 512 =3D 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md2 doesn't contain a valid partition table


#cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]=20
md2 : active raid5 sdb4[1] sdd4[3] sdc4[2]
      5856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]
     =20
md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
      208768 blocks [4/3] [UUU_]
     =20

#cat /etc/fstab
aufs / aufs rw 0 0
tmpfs /tmp tmpfs nosuid,nodev 0 0
/dev/sda2 swap swap defaults 0 0
/dev/sdb2 swap swap defaults 0 0
/dev/sdc2 swap swap defaults 0 0
/dev/sdd2 swap swap defaults 0 0


#mount -t ext3 /dev/md2 /media/disk/shares
mount: wrong fs type, bad option, bad superblock on /dev/md2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

#mdadm -Ds -v
ARRAY /dev/md0 level=3Draid1 num-devices=3D4 metadata=3D00.90
UUID=3D15e54255:f58be7ca:7f4a592f:038fedf2
   devices=3D/dev/sdd1,/dev/sdc1,/dev/sdb1
ARRAY /dev/md2 level=3Draid5 num-devices=3D4 metadata=3D00.90
UUID=3D0b23d5e1:f5a27618:e368bf24:bd0fce41
   devices=3D/dev/sdb4,/dev/sdc4,/dev/sdd4

#mdadm -Es -v
ARRAY /dev/md0 level=3Draid1 num-devices=3D4
UUID=3D15e54255:f58be7ca:7f4a592f:038fedf2
   devices=3D/dev/sdd1,/dev/sdc1,/dev/sdb1
ARRAY /dev/md1 level=3Draid1 num-devices=3D4
UUID=3D57cd5e76:0d56f114:50bd5336:4477d020
   devices=3D/dev/sdd2,/dev/sdc2,/dev/sdb2
ARRAY /dev/md2 level=3Draid5 num-devices=3D4
UUID=3D0b23d5e1:f5a27618:e368bf24:bd0fce41
   devices=3D/dev/sdd4,/dev/sdc4,/dev/sdb4

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Hill
Sent: Thursday, September 17, 2009 5:02 PM
To: linux-raid@vger.kernel.org
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.

On Thu Sep 17, 2009 at 04:20:16PM -0400, Sunpyo Hong wrote:

> I've contacted just about everyone that knows a thing about RAID5, bu=
t no
> one is really able to help me. Anyhow I've read up a lot on RAID5 arr=
ays
and
> how to properly assemble them. However I've run into a problem with a=
 NAS
> system from WD that I just can't seem to figure out.
>=20
> I have a =BE disks in the array, 1 went down and is out of commission=
=2E  I've
> been able to assemble my array through mdadm using --assemble --scan.
However
> I cannot access the array due to the fact that the array cannot read =
a
> filesystem. Everytime I try to mount I get mount: wrong fs type=85 et=
c. I
> know that the FS is an ext3 FS. However I cannot seem to get this
> thing going. I was wondering if anyone could point me in the right
> direction with this. I can't seem to find anyone that is capable of
> solving this. I would appreciate any help. Thanks!
>=20
What's the output of 'cat /proc/mdstat' after you assemble the array?
And what exact error (and dmesg output) do you get when trying to mount
it as ext3?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
