From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: component device mismatches found: 9600
Date: Mon, 01 Aug 2011 12:44:39 -0700
Message-ID: <4E370227.2070804@vorgon.com>
References: <4E359DC0.5090608@vorgon.com> <CADNH=7H0+RP7yiE01NmxncTBapsMLRt1XkqAHxZr=FEAC9Zx1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7H0+RP7yiE01NmxncTBapsMLRt1XkqAHxZr=FEAC9Zx1A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 7/31/2011 11:32 AM, Mathias Bur=C3=A9n wrote:
> On 31 July 2011 19:24, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>> Looking through the logs, I found this in daemon.log.0. Is this a si=
gn of a
>> problem? Below is the entire log:
>>
>> Jul  3 00:57:01 x64VDR mdadm[2003]: RebuildStarted event detected on=
 md
>> device /dev/md0
>> Jul  3 00:57:02 x64VDR mdadm[2003]: RebuildStarted event detected on=
 md
>> device /dev/md3
>> Jul  3 01:02:10 x64VDR mdadm[2003]: RebuildStarted event detected on=
 md
>> device /dev/md1
>> Jul  3 01:02:10 x64VDR mdadm[2003]: RebuildFinished event detected o=
n md
>> device /dev/md0
>> Jul  3 01:03:01 x64VDR mdadm[2003]: RebuildStarted event detected on=
 md
>> device /dev/md2
>> Jul  3 01:03:01 x64VDR mdadm[2003]: RebuildFinished event detected o=
n md
>> device /dev/md1, component device  mismatches found: 9600
>> Jul  3 01:19:41 x64VDR mdadm[2003]: Rebuild29 event detected on md d=
evice
>> /dev/md3
>> Jul  3 01:19:41 x64VDR mdadm[2003]: Rebuild21 event detected on md d=
evice
>> /dev/md2
>> Jul  3 01:36:21 x64VDR mdadm[2003]: Rebuild50 event detected on md d=
evice
>> /dev/md3
>> Jul  3 01:36:21 x64VDR mdadm[2003]: Rebuild41 event detected on md d=
evice
>> /dev/md2
>> Jul  3 01:53:01 x64VDR mdadm[2003]: Rebuild67 event detected on md d=
evice
>> /dev/md3
>> Jul  3 02:09:41 x64VDR mdadm[2003]: Rebuild83 event detected on md d=
evice
>> /dev/md3
>> Jul  3 02:09:41 x64VDR mdadm[2003]: Rebuild75 event detected on md d=
evice
>> /dev/md2
>> Jul  3 02:26:21 x64VDR mdadm[2003]: Rebuild88 event detected on md d=
evice
>> /dev/md2
>> Jul  3 02:32:20 x64VDR mdadm[2003]: RebuildFinished event detected o=
n md
>> device /dev/md3
>> Jul  3 02:43:23 x64VDR mdadm[2003]: RebuildFinished event detected o=
n md
>> device /dev/md2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Could you post the output of:
>
> smartctl -a /dev/your_hdd (all HDDs used by the arrays)
> cat /proc/mdstat
> mdadm -D /dev/md(your arrays)
>
> /Mathias
>

Don't think I have smartctl installed. Tried with/out sudo
  vorg@x64VDR:~$ smartctl -a /dev/sda
  -bash: smartctl: command not found

----------------------------------------------------------
vorg@x64VDR:~$ cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
md1 : active raid1 sdb2[1] sda2[0]
       4891712 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       459073344 blocks [2/2] [UU]

md3 : active raid1 sdd1[1] sdc1[0]
       488383936 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
       24418688 blocks [2/2] [UU]

unused devices: <none>
-------------------------------------------------------------
vorg@x64VDR:~$ sudo mdadm -D /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Sat Oct  4 14:35:45 2008
      Raid Level : raid1
      Array Size : 24418688 (23.29 GiB 25.00 GB)
   Used Dev Size : 24418688 (23.29 GiB 25.00 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Aug  1 12:37:59 2011
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : e4926be6:8d6f08e5:0ab6b006:621c4ec0 (local to host=20
x64VDR)
          Events : 0.648843

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
---------------------------------------------------------------------
vorg@x64VDR:~$ sudo mdadm -D /dev/md1
/dev/md1:
         Version : 0.90
   Creation Time : Sat Oct  4 14:42:18 2008
      Raid Level : raid1
      Array Size : 4891712 (4.67 GiB 5.01 GB)
   Used Dev Size : 4891712 (4.67 GiB 5.01 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Sun Jul 31 11:45:49 2011
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : eac96451:66efa3ab:0ab6b006:621c4ec0 (local to host=20
x64VDR)
          Events : 0.550

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
---------------------------------------------------------------------
vorg@x64VDR:~$ sudo mdadm -D /dev/md2
/dev/md2:
         Version : 0.90
   Creation Time : Fri Jun  4 23:03:23 2010
      Raid Level : raid1
      Array Size : 459073344 (437.81 GiB 470.09 GB)
   Used Dev Size : 459073344 (437.81 GiB 470.09 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sun Jul 31 14:46:45 2011
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 934b5d12:5f83677f:0ab6b006:621c4ec0 (local to host=20
x64VDR)
          Events : 0.29054

     Number   Major   Minor   RaidDevice State
        0       8        3        0      active sync   /dev/sda3
        1       8       19        1      active sync   /dev/sdb3
---------------------------------------------------------------------
vorg@x64VDR:~$ sudo mdadm -D /dev/md3
/dev/md3:
         Version : 0.90
   Creation Time : Wed Jun  2 17:54:03 2010
      Raid Level : raid1
      Array Size : 488383936 (465.76 GiB 500.11 GB)
   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Sun Jul 31 14:46:45 2011
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 47b3c905:5121e149:0ab6b006:621c4ec0 (local to host=20
x64VDR)
          Events : 0.2406

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
---------------------------------------------------------------------
I do have it setup for email reports and last time a drive failed, that=
=20
worked. I also have gotten emails about failed syncing which only=20
happened a couple of times and it's been awhile since I got one of=20
those. Likely fixed during an update somewhere along the way. It was=20
thought to be a false report.

Received: by vorgon.com (sSMTP sendmail emulation); Sun, 13 Jun 2010=20
00:57:02 -0700
Date: Sun, 13 Jun 2010 00:57:02 -0700
=46rom: root (Cron Daemon)
To: root
Subject: Cron <root@x64VDR> [ -x /usr/share/mdadm/checkarray ] && [=20
$(date +%d) -le 7 ] && /usr/share/mdadm/checkarray --cron --all --quiet=
=20
(failed)
Content-Type: text/plain; charset=3DUTF-8
X-Cron-Env: <SHELL=3D/bin/sh>
X-Cron-Env: <HOME=3D/root>
X-Cron-Env: <PATH=3D/usr/bin:/bin>
X-Cron-Env: <LOGNAME=3Droot>
Message-Id: <0MRXn6-1OqP0O1vR2-00ShUl@mrelay.perfora.net>
X-Provags-ID: V01U2FsdGVkX1/bTJj+AQvAeW7xRwAd2EQ+S8duRn/uPMxwyFG
  T6yf7bTnrgufCTUjkhnj4mQsIilzGEu+VDKrLyFu7t2itTaVgM
  tshSGVhqbbiQbc1myOVEg=3D=3D
Envelope-To: tlenz@vorgon.com
X-Antivirus: avast! (VPS 100602-1, 06/02/2010), Inbound message
X-Antivirus-Status: Clean

command failed with exit status 1

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
