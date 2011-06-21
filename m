From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Tue, 21 Jun 2011 11:05:09 +0300
Message-ID: <BANLkTik+kjXHPzrp=bPDjZXz7N2j_n2NLw@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110605230014.14822hd7b50rcqww@cakebox.homeunix.net>
	<BANLkTinr_1GcbypCpxFKPXoid4DxTKvCag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinr_1GcbypCpxFKPXoid4DxTKvCag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anyone???...

On Mon, Jun 6, 2011 at 9:19 PM, Alexander Lyakas <alex.bolshoy@gmail.co=
m> wrote:
>
> Hello,
>
> the kernel version is:
>
> root@ubuntu:~# uname -a
> Linux ubuntu 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC
> 2011 x86_64 x86_64 x86_64 GNU/Linux
>
> mdadm version is:
> root@ubuntu:~# mdadm -V
> mdadm - v3.1.4 - 31st August 2010
>
> Examining the three array components:
>
> root@ubuntu:~# mdadm -E /dev/sd{a,b,c}
> /dev/sda:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
> =A0 =A0 =A0 =A0 =A0 Name : vc:zvp_1123
> =A0Creation Time : Mon Jun =A06 21:10:38 2011
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 3
>
> =A0Avail Dev Size : 41940992 (20.00 GiB 21.47 GB)
> =A0 =A0 Array Size : 83879936 (40.00 GiB 42.95 GB)
> =A0Used Dev Size : 41939968 (20.00 GiB 21.47 GB)
> =A0 =A0Data Offset : 2048 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : active
> =A0 =A0Device UUID : 8db90071:be80216e:09468262:1f5046b1
>
> Internal Bitmap : 8 sectors from superblock
> =A0 =A0Update Time : Mon Jun =A06 21:10:46 2011
> =A0 =A0 =A0 Checksum : 2e424556 - correct
> =A0 =A0 =A0 =A0 Events : 10
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 Device Role : Active device 0
> =A0 Array State : A.A ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdb:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
> =A0 =A0 =A0 =A0 =A0 Name : vc:zvp_1123
> =A0Creation Time : Mon Jun =A06 21:10:38 2011
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 3
>
> =A0Avail Dev Size : 41940992 (20.00 GiB 21.47 GB)
> =A0 =A0 Array Size : 83879936 (40.00 GiB 42.95 GB)
> =A0Used Dev Size : 41939968 (20.00 GiB 21.47 GB)
> =A0 =A0Data Offset : 2048 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 9f41313b:b1aa70f8:6cf0ca2f:c6ea0a64
>
> Internal Bitmap : 8 sectors from superblock
> =A0 =A0Update Time : Mon Jun =A06 21:10:44 2011
> =A0 =A0 =A0 Checksum : 2d23c61 - correct
> =A0 =A0 =A0 =A0 Events : 8
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 Device Role : Active device 1
> =A0 Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdc:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x3
> =A0 =A0 Array UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
> =A0 =A0 =A0 =A0 =A0 Name : vc:zvp_1123
> =A0Creation Time : Mon Jun =A06 21:10:38 2011
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 3
>
> =A0Avail Dev Size : 41940992 (20.00 GiB 21.47 GB)
> =A0 =A0 Array Size : 83879936 (40.00 GiB 42.95 GB)
> =A0Used Dev Size : 41939968 (20.00 GiB 21.47 GB)
> =A0 =A0Data Offset : 2048 sectors
> =A0 Super Offset : 8 sectors
> Recovery Offset : 999424 sectors
> =A0 =A0 =A0 =A0 =A0State : active
> =A0 =A0Device UUID : 61189a9d:ec082cea:a3ba32fb:800fe84b
>
> Internal Bitmap : 8 sectors from superblock
> =A0 =A0Update Time : Mon Jun =A06 21:10:46 2011
> =A0 =A0 =A0 Checksum : a47a059 - correct
> =A0 =A0 =A0 =A0 Events : 10
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 Device Role : Active device 2
> =A0 Array State : A.A ('A' =3D=3D active, '.' =3D=3D missing)
>
> Details about the array:
>
> root@ubuntu:~# =A0mdadm -Q --detail /dev/md1123
> /dev/md1123:
> =A0 =A0 =A0 =A0Version : 1.2
> =A0Creation Time : Mon Jun =A06 21:10:38 2011
> =A0 =A0 Raid Level : raid5
> =A0 =A0 Array Size : 41939968 (40.00 GiB 42.95 GB)
> =A0Used Dev Size : 20969984 (20.00 GiB 21.47 GB)
> =A0 Raid Devices : 3
> =A0Total Devices : 3
> =A0 =A0Persistence : Superblock is persistent
>
> =A0Intent Bitmap : Internal
>
> =A0 =A0Update Time : Mon Jun =A06 21:10:46 2011
> =A0 =A0 =A0 =A0 =A0State : active, FAILED
> =A0Active Devices : 1
> Working Devices : 2
> =A0Failed Devices : 1
> =A0Spare Devices : 1
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0 =A0 =A0 =A0 =A0 Name : vc:zvp_1123
> =A0 =A0 =A0 =A0 =A0 UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
> =A0 =A0 =A0 =A0 Events : 10
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
faulty spare rebuilding =A0 /dev/sdb
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
spare rebuilding =A0 /dev/sdc
>
>
> Basically, the thing is that the faulty (and the rebuilding spare)
> component are not kicked out of the array, and the array is stuck in
> this state.
>
> Thanks,
> =A0Alex.
>
>
> 2011/6/6 Nagilum <nagilum@nagilum.org>:
> > Make sure you provide all relevant details such as kernel version, =
mdadm
> > version and maybe also mdadm -E /dev/sd{a,b,c}, mdadm -Q --detail /=
dev/md0,
> > ..
> >
> > ----- Message from alex.bolshoy@gmail.com ---------
> > =A0 =A0Date: Sun, 5 Jun 2011 22:41:55 +0300
> > =A0 =A0From: Alexander Lyakas <alex.bolshoy@gmail.com>
> > =A0Subject: RAID5: failing an active component during spare rebuild=
 - arrays
> > hangs
> > =A0 =A0 =A0To: linux-raid@vger.kernel.org
> >
> >
> >> Hello everybody,
> >> I am testing a scenario, in which I create a RAID5 with three devi=
ces:
> >> /dev/sd{a,b,c}. Since I don't supply --force to mdadm during creat=
ion,
> >> it treats the array as degraded and starts rebuilding the sdc as a
> >> spare. This is as documented.
> >>
> >> Then I do --fail on /dev/sda. I understand that at this point my d=
ata
> >> is gone, but I think should still be able to tear down the array.
> >>
> >> Sometimes I see that /dev/sda is kicked from the array as faulty, =
and
> >> /dev/sdc is also removed and marked as a spare. Then I am able to =
tear
> >> down the array.
> >>
> >> But sometimes, it looks like the system hits some kind of a deadlo=
ck.
> >> mdadm --detail produces:
> >>
> >> =A0=A0=A0 Update Time : Sun Jun=A0 5 21:54:34 2011
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active, FAILED
> >> =A0Active Devices : 1
> >> Working Devices : 2
> >> =A0Failed Devices : 1
> >> =A0 Spare Devices : 1
> >>
> >> =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> >> =A0=A0=A0=A0 Chunk Size : 512K
> >>
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : ubuntu:zvp_1123
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 48a15fb6:b6410bb9:a2ca173e:0=
092032c
> >> =A0=A0=A0=A0=A0=A0=A0=A0 Events : 67
> >>
> >> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> >> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 faulty spare rebuilding=A0=A0 /dev/=
sda
> >> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=
=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb
> >> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=
=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare rebuilding=A0=A0 /dev/sdc
> >>
> >> So the faulty device and the spare are not kicked out of the array=
=2E At
> >> this point I am unable to do anything with the array:
> >>
> >> root@ubuntu:~# sudo mdadm --stop /dev/md1123
> >> mdadm: failed to stop array /dev/md1123: Device or resource busy
> >> Perhaps a running process, mounted filesystem or active volume gro=
up?
> >> root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sda
> >> mdadm: hot remove failed for /dev/sda: Device or resource busy
> >> root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sdb
> >> mdadm: hot remove failed for /dev/sdb: Device or resource busy
> >> root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sdc
> >> mdadm: hot remove failed for /dev/sdc: Device or resource busy
> >>
> >> This is happening on ubuntu-natty, with mdadm - v3.1.4 - 31st Augu=
st 2010.
> >> Looking at some code in mdadm/Detail.c, it looks like /dev/sda has
> >> been marked only as MD_DISK_FAULTY, but has not yet been kicked ou=
t of
> >> the array. The "spare" and "rebuilding" prints also result from th=
at.
> >>
> >> Same thing also happens (sometimes) when I manually initiate resyn=
c
> >> (by writing 'repair' to 'sync_action'), and later manually failing=
 one
> >> of the devices. Then I also saw messages like this in the syslog:
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350454] INFO: task
> >> md1123_resync:7993 blocked for more than 120 seconds.
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350552] "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350644] md1123_resync=A0=A0=
 D
> >> 0000000000000000=A0=A0=A0=A0 0=A0 7993=A0=A0=A0=A0=A0 2 0x00000004
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350647]=A0 ffff8800b56b1cd=
0
> >> 0000000000000046 ffff8800b56b1fd8 ffff8800b56b0000
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350649]=A0 0000000000013d0=
0
> >> ffff880036c09a98 ffff8800b56b1fd8 0000000000013d00
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350652]=A0 ffff8800b7f1adc=
0
> >> ffff880036c096e0 ffff8800b56b1cb0 ffff880036c56610
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350654] Call Trace:
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350657]=A0 [<ffffffff81492=
885>]
> >> md_do_sync+0xb45/0xc90
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350660]=A0 [<ffffffff81087=
940>] ?
> >> autoremove_wake_function+0x0/0x40
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350663]=A0 [<ffffffff81078=
61b>] ?
> >> recalc_sigpending+0x1b/0x50
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350665]=A0 [<ffffffff8148c=
516>]
> >> md_thread+0x116/0x150
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350667]=A0 [<ffffffff8148c=
400>] ?
> >> md_thread+0x0/0x150
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350669]=A0 [<ffffffff81087=
1f6>]
> >> kthread+0x96/0xa0
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350672]=A0 [<ffffffff8100c=
de4>]
> >> kernel_thread_helper+0x4/0x10
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350674]=A0 [<ffffffff81087=
160>] ?
> >> kthread+0x0/0xa0
> >> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350676]=A0 [<ffffffff8100c=
de0>] ?
> >> kernel_thread_helper+0x0/0x10
> >>
> >> This is pretty easy for me to reproduce.
> >>
> >> Basically, I would like to know what the user is expected to do wh=
en
> >> more than one RAID5 array component fails during rebuild/resync.
> >>
> >> Thanks,
> >> =A0 Alex.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >>
> >
> >
> > ----- End message from alex.bolshoy@gmail.com -----
> >
> >
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > # =A0 =A0_ =A0__ =A0 =A0 =A0 =A0 =A0_ __ =A0 =A0 http://www.nagilum=
=2Eorg/ \n icq://69646724 #
> > # =A0 / |/ /__ ____ _(_) /_ ____ _ =A0nagilum@nagilum.org \n +49177=
6461165 #
> > # =A0/ =A0 =A0/ _ `/ _ `/ / / // / =A0' \ =A0Amiga (68k/PPC): AOS/N=
etBSD/Linux =A0 #
> > # /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/ =A0 Mac (PPC): MacOS-X / NetBSD /=
Linux #
> > # =A0 =A0 =A0 =A0 =A0 /___/ =A0 =A0 x86: FreeBSD/Linux/Solaris/Win2=
k =A0ARM9: EPOC EV6 #
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> >
> >
> > ----------------------------------------------------------------
> > cakebox.homeunix.net - all the machine one needs..
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
