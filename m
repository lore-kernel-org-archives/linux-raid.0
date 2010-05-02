From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: corrupted UUID or superblock prohibits assemby of prior created
	raid6
Date: Sun, 2 May 2010 02:36:31 -0700
Message-ID: <m2l4877c76c1005020236n3eda8eeciec5c852a340072ad@mail.gmail.com>
References: <4BDD2AAF.9070800@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDD2AAF.9070800@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: "christian (private)" <chr.graf@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 2, 2010 at 12:33 AM, christian (private) <chr.graf@gmx.de> =
wrote:
> Dear all,
>
> I am kindly asking for help please.
>
> The issue is the following:
> I am creating an mdadm raid6-array and after successful sync all look=
s fine.
> However after rebooting the raid6 refuses to start due to missing dis=
ks.
> To my understanding this is all related to incorrect UUID's, however =
I am
> kindly asking the experts to have alook into it:
>
> The error-message (similiar for all my 1TB-drives /dev/sd[abi]1)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> keeper:~# mdadm --assemble /dev/md10 /dev/sd[abi]1 /dev/md[1-3]
> mdadm: cannot open device /dev/sda1: Device or resource busy
> mdadm: /dev/sda1 has no superblock - assembly aborted
>
>
> systems basics
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> keeper:~# uname -a
> Linux keeper 2.6.30-2-amd64 #1 SMP Fri Dec 4 03:31:05 UTC 2009 x86_64
> GNU/Linux
>
> distro: debian testing
>
> ii =A0mdadm =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3.0.3-2
> =A0 =A0 =A0 =A0 =A0 =A0tool to administer Linux MD arrays (software
> ii =A0e2fslibs =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01.41.11-1
> =A0 =A0 =A0 =A0 =A0 =A0ext2/ext3/ext4 file system libraries
> ii =A0e2fsprogs =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.41.11-1
> =A0 =A0 =A0 =A0 =A0 =A0ext2/ext3/ext4 file system utilities
>
>
>
> creating the array (hint, after reboot its /dev/sd[abi]1 instead of
> /dev/sdb1 /dev/sdc1 /dev/sdi1)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 387 =A0mdadm --create /dev/md10 --name=3D10 --metadata=3D1.0 =A0--lev=
el=3D6
> --raid-devices=3D6 /dev/sdb1 /dev/sdc1 /dev/sdi1 /dev/md[1-3]
>
> the array gets created =A0- verifying after resync without =A0rebooti=
ng
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> /dev/md10:
> =A0 =A0 =A0 =A0Version : 1.00
> =A0Creation Time : Sat May =A01 19:41:39 2010
> =A0 =A0 Raid Level : raid6
> =A0 =A0 Array Size : 3907039232 (3726.04 GiB 4000.81 GB)
> =A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =A0 Raid Devices : 6
> =A0Total Devices : 6
> =A0 =A0Persistence : Superblock is persistent
>
> =A0 =A0Update Time : Sun May =A02 03:44:29 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 6
> Working Devices : 6
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0 =A0 =A0 Name : keeper:10 =A0(local to host keeper)
> *UUID : d9b9e76d:0113d173:39173474:7f43de08*
> =A0 =A0 =A0 =A0 Events : 35
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc1
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdi1
> =A0 =A0 =A0 3 =A0 =A0 =A0 9 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/md1
> =A0 =A0 =A0 4 =A0 =A0 =A0 9 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/md2
> =A0 =A0 =A0 5 =A0 =A0 =A0 9 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/md3
>
>
> keeper:~# cat /proc/mdstat
> This is looking fine as well
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Personalities : [raid6] [raid5] [raid4] [multipath] [faulty] [raid0]
> md10 : active raid6 md3[5] md2[4] md1[3] sdi1[2] sdc1[1] sdb1[0]
> =A0 =A0 =A03907039232 blocks super 1.0 level 6, 64k chunk, algorithm =
2 [6/6]
> [UUUUUU]
>
> md1 : active raid0 sdf1[0] sdg1[1]
> =A0 =A0 =A0976767872 blocks 64k chunks
>
> md2 : active raid0 sdh1[1] sda1[0]
> =A0 =A0 =A0976767872 blocks 64k chunks
>
> md3 : active raid0 sdd1[1] sde1[0]
> =A0 =A0 =A0976767872 blocks 64k chunks
>
>
> To my understanding all member-drives of md10 should have the same UU=
ID, but
> after a reboot this is not any longer the case. Please notice that I =
created
> the array with "/dev/sd[bci]1 /dev/md[1-3]" and after reboot its
> /dev/sd[abi]1 and /dev/md[1-3].
> But as you can see, the UUID's are not identical anyhow:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> keeper:~# blkid
> /dev/hda1: UUID=3D"3A60F2845E1B3C0F" TYPE=3D"ntfs"
> /dev/hda2: UUID=3D"e9a9b276-0530-42eb-8317-cd3999ff8b90" TYPE=3D"swap=
"
> /dev/hda3: UUID=3D"738eeb2f-fae4-40a0-b0de-fc188837e44c" TYPE=3D"ext3=
"
> /dev/sdb1: UUID=3D"d9b9e76d-0113-d173-3917-34747f43de08" LABEL=3D"kee=
per:10"
> TYPE=3D"linux_raid_member" << looks good
> /dev/sdc1: UUID=3D"f45cfa44-1770-7e1c-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member" LABEL=3D"keeper:10"
> /dev/sdd1: UUID=3D"f45cfa44-1770-7e1c-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member" LABEL=3D"keeper:11"
> /dev/sde1: UUID=3D"0805c25a-cf77-4fb6-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member"
> /dev/sdf1: UUID=3D"0805c25a-cf77-4fb6-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member"
> /dev/sdg1: UUID=3D"13d13245-3c7d-8682-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member"
> /dev/sdh1: UUID=3D"13d13245-3c7d-8682-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member"
> /dev/sdi1: UUID=3D"d9b9e76d-0113-d173-3917-34747f43de08"
> TYPE=3D"linux_raid_member" LABEL=3D"keeper:10" << looks good
> /dev/sda1: UUID=3D"c6f73dbb-528d-aa64-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7=
f43de08*
> /dev/md1: UUID=3D"058e47cd-e3ff-0fb9-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7=
f43de08*
> /dev/md2: UUID=3D"058e47cd-e3ff-0fb9-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7=
f43de08*
> /dev/md3: UUID=3D"058e47cd-e3ff-0fb9-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7=
f43de08*
>
>
> Can please anyone help me digging out whats going on here?
>
> What I can say, that if I create 2 * raid5 (/dev/sd[abi]1 and /dev/md=
[1-3])
> instead of combining them into a single raid6, then all is perfect.
> Maybe I should say, that /dev/md[1-3] are 2* striped 500G disks and
> /dev/sd[abi]1 are 1TB drives.
>
>
> any help is very much appreciated. The next step I am doing is manual=
ly
> setting the UUID to have it matched...
>
>
> further more I thoughts setting the UUID manually could solve the iss=
ue
>
> keeper:~# tune2fs -U d9b9e76d-0113-d173-3917-34747f43de08 /dev/sda1
> tune2fs 1.41.11 (14-Mar-2010)
> tune2fs: Filesystem revision too high while trying to open /dev/sda1
> Couldn't find valid filesystem superblock. <<< does not look good to =
me
>
>
> keeper:~# fdisk -l /dev/sda
>
> Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x00000000
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0121601 =A0 9767600=
01 =A0 83 =A0Linux
>
> keeper:~# blkid /dev/sda
> keeper:~# blkid /dev/sda1
> /dev/sda1: UUID=3D"c6f73dbb-528d-aa64-3e3a-de9f30eaa984"
> TYPE=3D"linux_raid_member"
>
> keeper:~# tune2fs -l /dev/sda1
> tune2fs 1.41.11 (14-Mar-2010)
> tune2fs: Filesystem revision too high while trying to open /dev/sda1
> Couldn't find valid filesystem superblock.
>
>
> Any idea why the superblock is giving me trouble here?
>
>
> many thanks
>
> christian
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I forgot to add, the blkid issue is probably related to caching.

blkid -g might be sufficient
blkid -p would bypass the cache entirely

man blkid for more info.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
