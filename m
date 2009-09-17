From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Fri, 18 Sep 2009 01:09:09 +0300
Message-ID: <70ed7c3e0909171509k45d08dd6lbba9e15a710c3a43@mail.gmail.com>
References: <200909171754312.SM06100@trainer>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909171754312.SM06100@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: Sunpyo Hong <sunpyo.hong@amac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can you show the output of dmesg after you try to mount (and fail), to
see more details on what's going wrong with the filesystem?

On Fri, Sep 18, 2009 at 12:54 AM, Sunpyo Hong <sunpyo.hong@amac.com> wr=
ote:
> I am also able to see the filesystem of the NAS, however not the data
> partition. EX:
>
> I can see the filesystem on:
> #ls /media/disk (which is the mount of the filesystem in the NAS) Thi=
s is
> also considered to be my /dev/md0, /dev/md2 is the data partition
>
> -----Original Message-----
> From: Sunpyo Hong [mailto:sunpyo.hong@amac.com]
> Sent: Thursday, September 17, 2009 5:47 PM
> To: 'Robin Hill'; 'linux-raid@vger.kernel.org'
> Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
>
> First off, lemme tell you the initial problem. I had a WD ShareSpace =
that
> had one of the disk go bad. They sent a replacement and it was suppos=
e to
> rebuild on its own, however after the build, the array went bad and i=
t was
> no longer able to see any of the files.
>
> I downloaded and tested the drives using windows data recovery tools =
I saw
> that the ext3 was Linux FS and that using these tools would not help =
in the
> recovery. However through the tools I was able to see and recover som=
e of
> the files, but the files themselves were usable. I confirmed with WD =
that
> ext3 was in fact the FS and took steps to recover the data. These are=
 the
> steps I took in order for me to assemble the raid.
>
> Right now I have 3/4 drives with the data. I did #mdadm --assemble --=
scan,
> which let me assemble the raid. However at this point I was not able =
to see
> any of the files or mount the drive to the mount point it was once at=
=2E I
> have also tried #mdadm --create with the array in the right order /w =
the
> missing disk.
>
> Initially the --assemble --scan assembled the array /dev/md2 with the=
 disks
> in the wrong order. I know because I physically saw where the disks w=
ere in
> relation to the disk order and wrote down the disk order on every HD.
>
> Here's everything I could find in terms of information that you asked=
 for.
> It's a lot.
>
> #dmesg
> [ =C2=A0339.440187] raid5: device sdb4 operational as raid disk 1
> [ =C2=A0339.440189] raid5: device sdd4 operational as raid disk 3
> [ =C2=A0339.440192] raid5: device sdc4 operational as raid disk 2
> [ =C2=A0339.440610] raid5: allocated 4219kB for md2
> [ =C2=A0339.440612] raid5: raid level 5 set md2 active with 3 out of =
4 devices,
> algorithm 2
> [ =C2=A0339.440615] RAID5 conf printout:
> [ =C2=A0339.440617] =C2=A0--- rd:4 wd:3
> [ =C2=A0339.440619] =C2=A0disk 1, o:1, dev:sdb4
> [ =C2=A0339.440620] =C2=A0disk 2, o:1, dev:sdc4
> [ =C2=A0339.440622] =C2=A0disk 3, o:1, dev:sdd4
> [ =C2=A0339.440817] =C2=A0md2: unknown partition table
> [ =C2=A0538.840033] kjournald starting. =C2=A0Commit interval 5 secon=
ds
> [ =C2=A0538.891844] EXT3 FS on md0, internal journal
> [ =C2=A0538.891849] EXT3-fs: mounted filesystem with ordered data mod=
e.
> [ =C2=A0581.585031] VFS: Can't find ext4 filesystem on dev md2.
> [ =C2=A0587.056825] VFS: Can't find ext3 filesystem on dev md2.
>
>
> #fdisk -l
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util =
fdisk
> doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sda: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x00000000
>
> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0243202 =C2=A01953514583+ =C2=A0ee =C2=A0GPT
>
> Disk /dev/sdb: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xdd07e5e3
>
> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A026 =C2=A0 =C2=A0 =C2=A0208844+ =C2=A0fd =C2=A0L=
inux raid
> autodetect
> /dev/sdb2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A027 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 156 =C2=A0 =C2=A0 1044225 =C2=A0 fd =C2=A0Linux raid
> autodetect
> /dev/sdb3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 157 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 182 =C2=A0 =C2=A0 =C2=A0208845 =C2=A0 fd =C2=A0Linux rai=
d
> autodetect
> /dev/sdb4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 183 =C2=A0 =C2=A0=
 =C2=A0243201 =C2=A01952050117+ =C2=A0fd =C2=A0Linux raid
> autodetect
>
> Disk /dev/sdc: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xdd07e5e4
>
> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sdc1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A026 =C2=A0 =C2=A0 =C2=A0208844+ =C2=A0fd =C2=A0L=
inux raid
> autodetect
> /dev/sdc2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A027 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 156 =C2=A0 =C2=A0 1044225 =C2=A0 fd =C2=A0Linux raid
> autodetect
> /dev/sdc3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 157 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 182 =C2=A0 =C2=A0 =C2=A0208845 =C2=A0 fd =C2=A0Linux rai=
d
> autodetect
> /dev/sdc4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 183 =C2=A0 =C2=A0=
 =C2=A0243201 =C2=A01952050117+ =C2=A0fd =C2=A0Linux raid
> autodetect
>
> Disk /dev/sdd: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xdd07e5e2
>
> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sdd1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A026 =C2=A0 =C2=A0 =C2=A0208844+ =C2=A0fd =C2=A0L=
inux raid
> autodetect
> /dev/sdd2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A027 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 156 =C2=A0 =C2=A0 1044225 =C2=A0 fd =C2=A0Linux raid
> autodetect
> /dev/sdd3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 157 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 182 =C2=A0 =C2=A0 =C2=A0208845 =C2=A0 fd =C2=A0Linux rai=
d
> autodetect
> /dev/sdd4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 183 =C2=A0 =C2=A0=
 =C2=A0243201 =C2=A01952050117+ =C2=A0fd =C2=A0Linux raid
> autodetect
>
> Disk /dev/md0: 213 MB, 213778432 bytes
> 2 heads, 4 sectors/track, 52192 cylinders
> Units =3D cylinders of 8 * 512 =3D 4096 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/md0 doesn't contain a valid partition table
>
> Disk /dev/md2: 5996.6 GB, 5996697747456 bytes
> 2 heads, 4 sectors/track, 1464037536 cylinders
> Units =3D cylinders of 8 * 512 =3D 4096 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/md2 doesn't contain a valid partition table
>
>
> #cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md2 : active raid5 sdb4[1] sdd4[3] sdc4[2]
> =C2=A0 =C2=A0 =C2=A05856150144 blocks level 5, 64k chunk, algorithm 2=
 [4/3] [_UUU]
>
> md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
> =C2=A0 =C2=A0 =C2=A0208768 blocks [4/3] [UUU_]
>
>
> #cat /etc/fstab
> aufs / aufs rw 0 0
> tmpfs /tmp tmpfs nosuid,nodev 0 0
> /dev/sda2 swap swap defaults 0 0
> /dev/sdb2 swap swap defaults 0 0
> /dev/sdc2 swap swap defaults 0 0
> /dev/sdd2 swap swap defaults 0 0
>
>
> #mount -t ext3 /dev/md2 /media/disk/shares
> mount: wrong fs type, bad option, bad superblock on /dev/md2,
> =C2=A0 =C2=A0 =C2=A0 missing codepage or helper program, or other err=
or
> =C2=A0 =C2=A0 =C2=A0 In some cases useful info is found in syslog - t=
ry
> =C2=A0 =C2=A0 =C2=A0 dmesg | tail =C2=A0or so
>
> #mdadm -Ds -v
> ARRAY /dev/md0 level=3Draid1 num-devices=3D4 metadata=3D00.90
> UUID=3D15e54255:f58be7ca:7f4a592f:038fedf2
> =C2=A0 devices=3D/dev/sdd1,/dev/sdc1,/dev/sdb1
> ARRAY /dev/md2 level=3Draid5 num-devices=3D4 metadata=3D00.90
> UUID=3D0b23d5e1:f5a27618:e368bf24:bd0fce41
> =C2=A0 devices=3D/dev/sdb4,/dev/sdc4,/dev/sdd4
>
> #mdadm -Es -v
> ARRAY /dev/md0 level=3Draid1 num-devices=3D4
> UUID=3D15e54255:f58be7ca:7f4a592f:038fedf2
> =C2=A0 devices=3D/dev/sdd1,/dev/sdc1,/dev/sdb1
> ARRAY /dev/md1 level=3Draid1 num-devices=3D4
> UUID=3D57cd5e76:0d56f114:50bd5336:4477d020
> =C2=A0 devices=3D/dev/sdd2,/dev/sdc2,/dev/sdb2
> ARRAY /dev/md2 level=3Draid5 num-devices=3D4
> UUID=3D0b23d5e1:f5a27618:e368bf24:bd0fce41
> =C2=A0 devices=3D/dev/sdd4,/dev/sdc4,/dev/sdb4
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Hill
> Sent: Thursday, September 17, 2009 5:02 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
>
> On Thu Sep 17, 2009 at 04:20:16PM -0400, Sunpyo Hong wrote:
>
>> I've contacted just about everyone that knows a thing about RAID5, b=
ut no
>> one is really able to help me. Anyhow I've read up a lot on RAID5 ar=
rays
> and
>> how to properly assemble them. However I've run into a problem with =
a NAS
>> system from WD that I just can't seem to figure out.
>>
>> I have a =C4=BE disks in the array, 1 went down and is out of commis=
sion. =C2=A0I've
>> been able to assemble my array through mdadm using --assemble --scan=
=2E
> However
>> I cannot access the array due to the fact that the array cannot read=
 a
>> filesystem. Everytime I try to mount I get mount: wrong fs type=E2=80=
=A6 etc. I
>> know that the FS is an ext3 FS. However I cannot seem to get this
>> thing going. I was wondering if anyone could point me in the right
>> direction with this. I can't seem to find anyone that is capable of
>> solving this. I would appreciate any help. Thanks!
>>
> What's the output of 'cat /proc/mdstat' after you assemble the array?
> And what exact error (and dmesg output) do you get when trying to mou=
nt
> it as ext3?
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
