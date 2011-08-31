From: CoolCold <coolthecold@gmail.com>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 31 Aug 2011 13:05:25 +0400
Message-ID: <CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Aug 27, 2011 at 1:58 PM, CoolCold <coolthecold@gmail.com> wrote=
:
> Hello!
> I have raid1 array with bitmap (md3), one disk has died, been replace=
d
> and array resynced:
>
> Aug 25 15:38:03 gamma2 kernel: [ =A0 =A05.986791] md: md3 stopped.
> Aug 25 15:38:03 gamma2 kernel: [ =A0 =A06.043306] raid1: raid set md3
> active with 1 out of 2 mirrors
> Aug 25 15:38:03 gamma2 kernel: [ =A0 =A06.044378] md3: bitmap initial=
ized
> from disk: read 2/2 pages, set 357 bits
> Aug 25 15:38:03 gamma2 kernel: [ =A0 =A06.044442] created bitmap (22
> pages) for device md3
> Aug 25 15:38:03 gamma2 kernel: [ =A0 =A06.070492] md3: detected capac=
ity
> change from 0 to 1478197903360
> Aug 25 15:38:03 gamma2 kernel: [ =A0 =A06.070862] =A0md3: unknown par=
tition table
> Aug 26 19:33:33 gamma2 kernel: [100325.814179] md: md3: recovery done=
=2E
>
> Now, /proc/mdstats still shows "dirty" bitmap, 16 of 22 pages:
>
> root@gamma2:~# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md3 : active raid1 sdc3[1] sdb3[0]
> =A0 =A0 =A01443552640 blocks [2/2] [UU]
> =A0 =A0 =A0bitmap: 16/22 pages [64KB], 32768KB chunk
>
> root@gamma2:~# mdadm -D /dev/md3
> /dev/md3:
> =A0 =A0 =A0 =A0Version : 00.90
> =A0Creation Time : Wed Oct 13 03:13:52 2010
> =A0 =A0 Raid Level : raid1
> =A0 =A0 Array Size : 1443552640 (1376.68 GiB 1478.20 GB)
> =A0Used Dev Size : 1443552640 (1376.68 GiB 1478.20 GB)
> =A0 Raid Devices : 2
> =A0Total Devices : 2
> Preferred Minor : 3
> =A0 =A0Persistence : Superblock is persistent
>
> =A0Intent Bitmap : Internal
>
> =A0 =A0Update Time : Sat Aug 27 13:53:57 2011
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 2
> Working Devices : 2
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 =A0 UUID : f5a9c1da:83dd4c40:d363f6aa:3cbcebe5
> =A0 =A0 =A0 =A0 Events : 0.1381014
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdb3
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc3
>
>
>
> That is strange as I can understand.
>
> distrib & mdadm info:
> Debian Lenny with openvz kernel from lenny-backports.
>
> root@gamma2:~# cat /proc/version
> Linux version 2.6.32-bpo.5-openvz-amd64 (Debian 2.6.32-35~bpo50+1)
> (norbert@tretkowski.de) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SM=
P
> Wed Jul 20 11:23:01 UTC 2011
> root@gamma2:~# mdadm --version
> mdadm - v2.6.7.2 - 14th November 2008
>
More details now:
Array still has 16/22 dirty pages:

root@gamma2:~# date;cat /proc/mdstat |head -n 5
Wed Aug 31 13:04:26 MSD 2011
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md3 : active raid1 sdc3[1] sdb3[0]
      1443552640 blocks [2/2] [UU]
      bitmap: 16/22 pages [64KB], 32768KB chunk


bitmap info:

root@gamma2:~# mdadm --examine-bitmap /dev/sdb3
        Filename : /dev/sdb3
           Magic : 6d746962
         Version : 4
            UUID : f5a9c1da:83dd4c40:d363f6aa:3cbcebe5
          Events : 1381014
  Events Cleared : 1381014
           State : OK
       Chunksize : 32 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1443552640 (1376.68 GiB 1478.20 GB)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
root@gamma2:~# mdadm --examine-bitmap /dev/sdc3
        Filename : /dev/sdc3
           Magic : 6d746962
         Version : 4
            UUID : f5a9c1da:83dd4c40:d363f6aa:3cbcebe5
          Events : 1381014
  Events Cleared : 1381014
           State : OK
       Chunksize : 32 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1443552640 (1376.68 GiB 1478.20 GB)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)


>
> --
> Best regards,
> [COOLCOLD-RIPN]
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
