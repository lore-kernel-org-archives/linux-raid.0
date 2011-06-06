From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Mon, 6 Jun 2011 21:19:40 +0300
Message-ID: <BANLkTinr_1GcbypCpxFKPXoid4DxTKvCag@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110605230014.14822hd7b50rcqww@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110605230014.14822hd7b50rcqww@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

the kernel version is:

root@ubuntu:~# uname -a
Linux ubuntu 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC
2011 x86_64 x86_64 x86_64 GNU/Linux

mdadm version is:
root@ubuntu:~# mdadm -V
mdadm - v3.1.4 - 31st August 2010

Examining the three array components:

root@ubuntu:~# mdadm -E /dev/sd{a,b,c}
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
           Name : vc:zvp_1123
  Creation Time : Mon Jun  6 21:10:38 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 41940992 (20.00 GiB 21.47 GB)
     Array Size : 83879936 (40.00 GiB 42.95 GB)
  Used Dev Size : 41939968 (20.00 GiB 21.47 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 8db90071:be80216e:09468262:1f5046b1

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 21:10:46 2011
       Checksum : 2e424556 - correct
         Events : 10

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.A ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
           Name : vc:zvp_1123
  Creation Time : Mon Jun  6 21:10:38 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 41940992 (20.00 GiB 21.47 GB)
     Array Size : 83879936 (40.00 GiB 42.95 GB)
  Used Dev Size : 41939968 (20.00 GiB 21.47 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9f41313b:b1aa70f8:6cf0ca2f:c6ea0a64

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 21:10:44 2011
       Checksum : 2d23c61 - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x3
     Array UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
           Name : vc:zvp_1123
  Creation Time : Mon Jun  6 21:10:38 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 41940992 (20.00 GiB 21.47 GB)
     Array Size : 83879936 (40.00 GiB 42.95 GB)
  Used Dev Size : 41939968 (20.00 GiB 21.47 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 999424 sectors
          State : active
    Device UUID : 61189a9d:ec082cea:a3ba32fb:800fe84b

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 21:10:46 2011
       Checksum : a47a059 - correct
         Events : 10

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.A ('A' =3D=3D active, '.' =3D=3D missing)

Details about the array:

root@ubuntu:~#  mdadm -Q --detail /dev/md1123
/dev/md1123:
        Version : 1.2
  Creation Time : Mon Jun  6 21:10:38 2011
     Raid Level : raid5
     Array Size : 41939968 (40.00 GiB 42.95 GB)
  Used Dev Size : 20969984 (20.00 GiB 21.47 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Jun  6 21:10:46 2011
          State : active, FAILED
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : vc:zvp_1123
           UUID : b5802763:fd4790dd:ee8bdeb2:2418097f
         Events : 10

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      faulty spare rebuilding   /dev/=
sdb
       3       8       32        2      spare rebuilding   /dev/sdc


Basically, the thing is that the faulty (and the rebuilding spare)
component are not kicked out of the array, and the array is stuck in
this state.

Thanks,
  Alex.


2011/6/6 Nagilum <nagilum@nagilum.org>:
> Make sure you provide all relevant details such as kernel version, md=
adm
> version and maybe also mdadm -E /dev/sd{a,b,c}, mdadm -Q --detail /de=
v/md0,
> ..
>
> ----- Message from alex.bolshoy@gmail.com ---------
> =A0 =A0Date: Sun, 5 Jun 2011 22:41:55 +0300
> =A0 =A0From: Alexander Lyakas <alex.bolshoy@gmail.com>
> =A0Subject: RAID5: failing an active component during spare rebuild -=
 arrays
> hangs
> =A0 =A0 =A0To: linux-raid@vger.kernel.org
>
>
>> Hello everybody,
>> I am testing a scenario, in which I create a RAID5 with three device=
s:
>> /dev/sd{a,b,c}. Since I don't supply --force to mdadm during creatio=
n,
>> it treats the array as degraded and starts rebuilding the sdc as a
>> spare. This is as documented.
>>
>> Then I do --fail on /dev/sda. I understand that at this point my dat=
a
>> is gone, but I think should still be able to tear down the array.
>>
>> Sometimes I see that /dev/sda is kicked from the array as faulty, an=
d
>> /dev/sdc is also removed and marked as a spare. Then I am able to te=
ar
>> down the array.
>>
>> But sometimes, it looks like the system hits some kind of a deadlock=
=2E
>> mdadm --detail produces:
>>
>> =A0=A0=A0 Update Time : Sun Jun=A0 5 21:54:34 2011
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active, FAILED
>> =A0Active Devices : 1
>> Working Devices : 2
>> =A0Failed Devices : 1
>> =A0 Spare Devices : 1
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
>> =A0=A0=A0=A0 Chunk Size : 512K
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : ubuntu:zvp_1123
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 48a15fb6:b6410bb9:a2ca173e:009=
2032c
>> =A0=A0=A0=A0=A0=A0=A0=A0 Events : 67
>>
>> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 faulty spare rebuilding=A0=A0 /dev/sda
>> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb
>> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 spare rebuilding=A0=A0 /dev/sdc
>>
>> So the faulty device and the spare are not kicked out of the array. =
At
>> this point I am unable to do anything with the array:
>>
>> root@ubuntu:~# sudo mdadm --stop /dev/md1123
>> mdadm: failed to stop array /dev/md1123: Device or resource busy
>> Perhaps a running process, mounted filesystem or active volume group=
?
>> root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sda
>> mdadm: hot remove failed for /dev/sda: Device or resource busy
>> root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sdb
>> mdadm: hot remove failed for /dev/sdb: Device or resource busy
>> root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sdc
>> mdadm: hot remove failed for /dev/sdc: Device or resource busy
>>
>> This is happening on ubuntu-natty, with mdadm - v3.1.4 - 31st August=
 2010.
>> Looking at some code in mdadm/Detail.c, it looks like /dev/sda has
>> been marked only as MD_DISK_FAULTY, but has not yet been kicked out =
of
>> the array. The "spare" and "rebuilding" prints also result from that=
=2E
>>
>> Same thing also happens (sometimes) when I manually initiate resync
>> (by writing 'repair' to 'sync_action'), and later manually failing o=
ne
>> of the devices. Then I also saw messages like this in the syslog:
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350454] INFO: task
>> md1123_resync:7993 blocked for more than 120 seconds.
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350552] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350644] md1123_resync=A0=A0 =
D
>> 0000000000000000=A0=A0=A0=A0 0=A0 7993=A0=A0=A0=A0=A0 2 0x00000004
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350647]=A0 ffff8800b56b1cd0
>> 0000000000000046 ffff8800b56b1fd8 ffff8800b56b0000
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350649]=A0 0000000000013d00
>> ffff880036c09a98 ffff8800b56b1fd8 0000000000013d00
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350652]=A0 ffff8800b7f1adc0
>> ffff880036c096e0 ffff8800b56b1cb0 ffff880036c56610
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350654] Call Trace:
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350657]=A0 [<ffffffff8149288=
5>]
>> md_do_sync+0xb45/0xc90
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350660]=A0 [<ffffffff8108794=
0>] ?
>> autoremove_wake_function+0x0/0x40
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350663]=A0 [<ffffffff8107861=
b>] ?
>> recalc_sigpending+0x1b/0x50
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350665]=A0 [<ffffffff8148c51=
6>]
>> md_thread+0x116/0x150
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350667]=A0 [<ffffffff8148c40=
0>] ?
>> md_thread+0x0/0x150
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350669]=A0 [<ffffffff810871f=
6>]
>> kthread+0x96/0xa0
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350672]=A0 [<ffffffff8100cde=
4>]
>> kernel_thread_helper+0x4/0x10
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350674]=A0 [<ffffffff8108716=
0>] ?
>> kthread+0x0/0xa0
>> Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350676]=A0 [<ffffffff8100cde=
0>] ?
>> kernel_thread_helper+0x0/0x10
>>
>> This is pretty easy for me to reproduce.
>>
>> Basically, I would like to know what the user is expected to do when
>> more than one RAID5 array component fails during rebuild/resync.
>>
>> Thanks,
>> =A0 Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
> ----- End message from alex.bolshoy@gmail.com -----
>
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> # =A0 =A0_ =A0__ =A0 =A0 =A0 =A0 =A0_ __ =A0 =A0 http://www.nagilum.o=
rg/ \n icq://69646724 #
> # =A0 / |/ /__ ____ _(_) /_ ____ _ =A0nagilum@nagilum.org \n +4917764=
61165 #
> # =A0/ =A0 =A0/ _ `/ _ `/ / / // / =A0' \ =A0Amiga (68k/PPC): AOS/Net=
BSD/Linux =A0 #
> # /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/ =A0 Mac (PPC): MacOS-X / NetBSD /Li=
nux #
> # =A0 =A0 =A0 =A0 =A0 /___/ =A0 =A0 x86: FreeBSD/Linux/Solaris/Win2k =
=A0ARM9: EPOC EV6 #
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
>
> ----------------------------------------------------------------
> cakebox.homeunix.net - all the machine one needs..
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
