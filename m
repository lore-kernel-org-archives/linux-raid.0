From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Mon, 21 Sep 2009 11:32:17 -0400
Message-ID: <200909211132543.SM05052@trainer>
References: <70ed7c3e0909171509k45d08dd6lbba9e15a710c3a43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909171509k45d08dd6lbba9e15a710c3a43@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's some more info:

Before
root@ubuntu:/home/ubuntu# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]=20
md2 : active raid5 sdb4[2] sdc4[1] sdd4[0]
      5856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
     =20
md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
      208768 blocks [4/3] [UUU_]

Now.
root@ubuntu:/home/ubuntu# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]=20
md2 : active raid5 sdd4[2] sdb4[1] sdc4[0]
      5856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
     =20
md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
      208768 blocks [4/3] [UUU_]

[58638.991719] RAID5 conf printout:
[58638.991720]  --- rd:4 wd:3
[58638.991722]  disk 0, o:1, dev:sdc4
[58638.991724]  disk 1, o:1, dev:sdb4
[58638.991726]  disk 2, o:1, dev:sdd4
[58638.993434]  md2: unknown partition table
[58672.600433] VFS: Can't find ext3 filesystem on dev md2.
[59137.799835] md: md2 stopped.
[59137.799848] md: unbind<sdd4>
[59137.800920] md: export_rdev(sdd4)
[59137.800961] md: unbind<sdb4>
[59137.804771] md: export_rdev(sdb4)
[59137.804778] md: unbind<sdc4>
[59137.804808] md: export_rdev(sdc4)
[59166.007689] md: bind<sdd4>
[59166.012173] md: bind<sdc4>
[59166.014076] md: bind<sdb4>
[59166.021627] raid5: device sdb4 operational as raid disk 2
[59166.021630] raid5: device sdc4 operational as raid disk 1
[59166.021633] raid5: device sdd4 operational as raid disk 0
[59166.022090] raid5: allocated 4219kB for md2
[59166.022092] raid5: raid level 5 set md2 active with 3 out of 4 devic=
es,
algorithm 2
[59166.022095] RAID5 conf printout:
[59166.022097]  --- rd:4 wd:3
[59166.022099]  disk 0, o:1, dev:sdd4
[59166.022100]  disk 1, o:1, dev:sdc4
[59166.022102]  disk 2, o:1, dev:sdb4
[59166.023663]  md2: unknown partition table
[59219.038548] VFS: Can't find ext3 filesystem on dev md2.
[59446.152543] kjournald starting.  Commit interval 5 seconds
[59446.153319] EXT3 FS on sda1, internal journal
[59446.153323] EXT3-fs: mounted filesystem with ordered data mode.
[59527.884970] VFS: Can't find ext3 filesystem on dev md2.
[60189.928644] VFS: Can't find ext3 filesystem on dev md2.
[60649.834143] VFS: Can't find ext4 filesystem on dev md2.

-Sunpyo

-----Original Message-----
=46rom: Majed B. [mailto:majedb@gmail.com]=20
Sent: Thursday, September 17, 2009 6:09 PM
To: Sunpyo Hong
Cc: linux-raid@vger.kernel.org
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.

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
in
the
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
to
see
> any of the files or mount the drive to the mount point it was once at=
=2E I
> have also tried #mdadm --create with the array in the right order /w =
the
> missing disk.
>
> Initially the --assemble --scan assembled the array /dev/md2 with the
disks
> in the wrong order. I know because I physically saw where the disks w=
ere
in
> relation to the disk order and wrote down the disk order on every HD.
>
> Here's everything I could find in terms of information that you asked=
 for.
> It's a lot.
>
> #dmesg
> [ =A0339.440187] raid5: device sdb4 operational as raid disk 1
> [ =A0339.440189] raid5: device sdd4 operational as raid disk 3
> [ =A0339.440192] raid5: device sdc4 operational as raid disk 2
> [ =A0339.440610] raid5: allocated 4219kB for md2
> [ =A0339.440612] raid5: raid level 5 set md2 active with 3 out of 4 d=
evices,
> algorithm 2
> [ =A0339.440615] RAID5 conf printout:
> [ =A0339.440617] =A0--- rd:4 wd:3
> [ =A0339.440619] =A0disk 1, o:1, dev:sdb4
> [ =A0339.440620] =A0disk 2, o:1, dev:sdc4
> [ =A0339.440622] =A0disk 3, o:1, dev:sdd4
> [ =A0339.440817] =A0md2: unknown partition table
> [ =A0538.840033] kjournald starting. =A0Commit interval 5 seconds
> [ =A0538.891844] EXT3 FS on md0, internal journal
> [ =A0538.891849] EXT3-fs: mounted filesystem with ordered data mode.
> [ =A0581.585031] VFS: Can't find ext4 filesystem on dev md2.
> [ =A0587.056825] VFS: Can't find ext3 filesystem on dev md2.
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
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0243202 =A019535145=
83+ =A0ee =A0GPT
>
> Disk /dev/sdb: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xdd07e5e3
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdb1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A026 =A0 =A0=
 =A0208844+ =A0fd =A0Linux raid
> autodetect
> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 =A0 =A027 =A0 =A0 =A0 =A0 156 =A0 =A0 1=
044225 =A0 fd =A0Linux raid
> autodetect
> /dev/sdb3 =A0 =A0 =A0 =A0 =A0 =A0 157 =A0 =A0 =A0 =A0 182 =A0 =A0 =A0=
208845 =A0 fd =A0Linux raid
> autodetect
> /dev/sdb4 =A0 =A0 =A0 =A0 =A0 =A0 183 =A0 =A0 =A0243201 =A01952050117=
+ =A0fd =A0Linux raid
> autodetect
>
> Disk /dev/sdc: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xdd07e5e4
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A026 =A0 =A0=
 =A0208844+ =A0fd =A0Linux raid
> autodetect
> /dev/sdc2 =A0 =A0 =A0 =A0 =A0 =A0 =A027 =A0 =A0 =A0 =A0 156 =A0 =A0 1=
044225 =A0 fd =A0Linux raid
> autodetect
> /dev/sdc3 =A0 =A0 =A0 =A0 =A0 =A0 157 =A0 =A0 =A0 =A0 182 =A0 =A0 =A0=
208845 =A0 fd =A0Linux raid
> autodetect
> /dev/sdc4 =A0 =A0 =A0 =A0 =A0 =A0 183 =A0 =A0 =A0243201 =A01952050117=
+ =A0fd =A0Linux raid
> autodetect
>
> Disk /dev/sdd: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0xdd07e5e2
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdd1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A026 =A0 =A0=
 =A0208844+ =A0fd =A0Linux raid
> autodetect
> /dev/sdd2 =A0 =A0 =A0 =A0 =A0 =A0 =A027 =A0 =A0 =A0 =A0 156 =A0 =A0 1=
044225 =A0 fd =A0Linux raid
> autodetect
> /dev/sdd3 =A0 =A0 =A0 =A0 =A0 =A0 157 =A0 =A0 =A0 =A0 182 =A0 =A0 =A0=
208845 =A0 fd =A0Linux raid
> autodetect
> /dev/sdd4 =A0 =A0 =A0 =A0 =A0 =A0 183 =A0 =A0 =A0243201 =A01952050117=
+ =A0fd =A0Linux raid
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
> =A0 =A0 =A05856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [_=
UUU]
>
> md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
> =A0 =A0 =A0208768 blocks [4/3] [UUU_]
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
> =A0 =A0 =A0 missing codepage or helper program, or other error
> =A0 =A0 =A0 In some cases useful info is found in syslog - try
> =A0 =A0 =A0 dmesg | tail =A0or so
>
> #mdadm -Ds -v
> ARRAY /dev/md0 level=3Draid1 num-devices=3D4 metadata=3D00.90
> UUID=3D15e54255:f58be7ca:7f4a592f:038fedf2
> =A0 devices=3D/dev/sdd1,/dev/sdc1,/dev/sdb1
> ARRAY /dev/md2 level=3Draid5 num-devices=3D4 metadata=3D00.90
> UUID=3D0b23d5e1:f5a27618:e368bf24:bd0fce41
> =A0 devices=3D/dev/sdb4,/dev/sdc4,/dev/sdd4
>
> #mdadm -Es -v
> ARRAY /dev/md0 level=3Draid1 num-devices=3D4
> UUID=3D15e54255:f58be7ca:7f4a592f:038fedf2
> =A0 devices=3D/dev/sdd1,/dev/sdc1,/dev/sdb1
> ARRAY /dev/md1 level=3Draid1 num-devices=3D4
> UUID=3D57cd5e76:0d56f114:50bd5336:4477d020
> =A0 devices=3D/dev/sdd2,/dev/sdc2,/dev/sdb2
> ARRAY /dev/md2 level=3Draid5 num-devices=3D4
> UUID=3D0b23d5e1:f5a27618:e368bf24:bd0fce41
> =A0 devices=3D/dev/sdd4,/dev/sdc4,/dev/sdb4
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
>> I have a =B5 disks in the array, 1 went down and is out of commissio=
n.
=A0I've
>> been able to assemble my array through mdadm using --assemble --scan=
=2E
> However
>> I cannot access the array due to the fact that the array cannot read=
 a
>> filesystem. Everytime I try to mount I get mount: wrong fs type. etc=
=2E I
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
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
       Majed B.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
