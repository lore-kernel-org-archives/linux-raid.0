From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Several steps to death
Date: Mon, 25 Jan 2010 17:35:58 -0800
Message-ID: <4877c76c1001251735t3b942312ud49a54e13e6579a6@mail.gmail.com>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 25, 2010 at 1:21 PM,  <aragonx@dcsnow.com> wrote:
> Hello all,
>
> I have a RAID 5 array that was created on Fedora 9 that just holds us=
er
> files (Samba share). =A0Everything was fine until a kernel upgrade an=
d
> motherboard failure made it impossible for me to boot. =A0After a new
> motherboard and an upgrade to Fedora 12, my array is toast.
>
> The problems are my own. =A0I was not paying enough attention to the =
data
> and more on the OS. =A0So what happened was what was originally a 5 d=
isk
> RAID 5 array was somehow detected as a RAID 5 array with 4 disks + 1
> spare. =A0It mounted and started a rebuild. =A0It was somewhere aroun=
d 40%
> before I noticed it.
>
> So my question is, can I get this data back or is it gone?
>
> If I try to mount it now, with the correct configuration I get the
> following error:
>
> mdadm --create /dev/md0 --level=3D5 --spare-devices=3D0 --raid-device=
s=3D5
> /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
>
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdf1[5] sde1[3] sdd1[2] sdc1[1] sdb1[0]
> =A0 =A0 =A02930287616 blocks level 5, 64k chunk, algorithm 2 [5/4] [U=
UUU_]
> =A0 =A0 =A0[>....................] =A0recovery =3D =A00.1% (1255864/7=
32571904)
> finish=3D155.2min speed=3D78491K/sec
>
> unused devices: <none>
>
> mount -t ext4 -o usrquota,grpquota,acl,user_xattr /dev/md0 /home/data
>
> mdadm -E /dev/sdb1
> /dev/sdb1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 18928390:76024ba7:d9fdb3bf:6408b6d2 (local=
 to host server)
> =A0Creation Time : Mon Jan 25 16:14:08 2010
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
> =A0 =A0 Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
> =A0 Raid Devices : 5
> =A0Total Devices : 6
> Preferred Minor : 0
>
> =A0 =A0Update Time : Mon Jan 25 16:14:08 2010
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 5
> =A0Failed Devices : 1
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : 382dc6ea - correct
> =A0 =A0 =A0 =A0 Events : 1
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sdb1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 4 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0spare
> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0spare =A0 /dev/sdf1
>
>
> Here is what is in /var/log/messages
>
> Jan 25 16:14:08 server kernel: md: bind<sdb1>
> Jan 25 16:14:08 server kernel: md: bind<sdc1>
> Jan 25 16:14:08 server kernel: md: bind<sdd1>
> Jan 25 16:14:08 server kernel: md: bind<sde1>
> Jan 25 16:14:08 server kernel: md: bind<sdf1>
> Jan 25 16:14:09 server kernel: raid5: device sde1 operational as raid=
 disk 3
> Jan 25 16:14:09 server kernel: raid5: device sdd1 operational as raid=
 disk 2
> Jan 25 16:14:09 server kernel: raid5: device sdc1 operational as raid=
 disk 1
> Jan 25 16:14:09 server kernel: raid5: device sdb1 operational as raid=
 disk 0
> Jan 25 16:14:09 server kernel: raid5: allocated 5332kB for md0
> Jan 25 16:14:09 server kernel: raid5: raid level 5 set md0 active wit=
h 4
> out of 5 devices, algorithm 2
> Jan 25 16:14:09 server kernel: RAID5 conf printout:
> Jan 25 16:14:09 server kernel: --- rd:5 wd:4
> Jan 25 16:14:09 server kernel: disk 0, o:1, dev:sdb1
> Jan 25 16:14:09 server kernel: disk 1, o:1, dev:sdc1
> Jan 25 16:14:09 server kernel: disk 2, o:1, dev:sdd1
> Jan 25 16:14:09 server kernel: disk 3, o:1, dev:sde1
> Jan 25 16:14:09 server kernel: md0: detected capacity change from 0 t=
o
> 3000614518784
> Jan 25 16:14:09 server kernel: md0: unknown partition table
> Jan 25 16:14:09 server kernel: RAID5 conf printout:
> Jan 25 16:14:09 server kernel: --- rd:5 wd:4
> Jan 25 16:14:09 server kernel: disk 0, o:1, dev:sdb1
> Jan 25 16:14:09 server kernel: disk 1, o:1, dev:sdc1
> Jan 25 16:14:09 server kernel: disk 2, o:1, dev:sdd1
> Jan 25 16:14:09 server kernel: disk 3, o:1, dev:sde1
> Jan 25 16:14:09 server kernel: disk 4, o:1, dev:sdf1
> Jan 25 16:14:09 server kernel: md: recovery of RAID array md0
> Jan 25 16:14:09 server kernel: md: minimum _guaranteed_ =A0speed: 100=
0
> KB/sec/disk.
> Jan 25 16:14:09 server kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Jan 25 16:14:09 server kernel: md: using 128k window, over a total of
> 732571904 blocks.
> Jan 25 16:15:12 server kernel: EXT4-fs (md0): VFS: Can't find ext4 fi=
lesystem
>
> Thank you in advance.
>
> ---
> Will Y.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Are you able to bring the 4 complete members up read only and read
your file-system?  In this case it sounds as if one disk was stale
when your system crashed (probably it's what didn't get data
written/synced to it) and thus is trying to regenerate the stale disk
(you previously had one distributed drive worth of parity thanks to
using raid-5 over raid-0).

Otherwise, I think you've probably obliterated enough data for any
recovery to be problematic at best.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
