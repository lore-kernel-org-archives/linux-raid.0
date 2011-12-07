From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Wed, 7 Dec 2011 20:51:38 +0000
Message-ID: <CADNH=7Fy=2jXn5br7gkMD2bOWFdrLNKjs4eia+1ycoHM2_-CaA@mail.gmail.com>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 December 2011 20:42, Eli Morris <ermorris@ucsc.edu> wrote:
> Hi All,
>
> =C2=A0I thought maybe someone could help me out. I have a 16 disk sof=
tware RAID that we use for backup. This is at least the second time thi=
s happened- all at once, four of the drives report as 'removed' when no=
ne of them actually were. These drives also disappeared from the 'lsscs=
i' list until I restarted the disk expansion chassis where they live.
>
> These are the dreaded Caviar Green drives. We bought 16 of them as an=
 upgrade for a hardware RAID originally, because the tech from that com=
pany said they would work fine. After running them for a while, four dr=
ives dropped out of that array. So I put them in the software RAID expa=
nsion chassis they are in now, thinking I might have better luck. In th=
is configuration, this happened once before. That time, the drives look=
ed to all have significant numbers of bad sectors, so I got those ones =
replaced and thought that that might have been the problem all along. N=
ow it has happened again. So I have two fairly predictable questions an=
d I'm hoping someone might be able to offer a suggestion:
>
> 1) Any ideas on how to get this array working again without starting =
from scratch? It's all backup data, so it's not do or die, but it is al=
so 30 TB and I really don't want to rebuild the whole thing again from =
scratch.
>
> I tried the re-add command and the error was something like 'not allo=
wed'
>
> 2) Any idea on how to stop this from happening again? I was thinking =
of playing with the disk timeout in the OS (not the one on the drive fi=
rmware).
>
> If anyway can help, I'd greatly appreciate it, because, at this point=
, I have no idea what to do about this mess.
>
> Thanks!
>
> Eli
>
>
> [root@stratus ~]# mdadm --detail /dev/md5
> /dev/md5:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
> =C2=A0Creation Time : Wed Oct 12 16:32:41 2011
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
> =C2=A0 Raid Devices : 16
> =C2=A0Total Devices : 13
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Mon Dec =C2=A05 12:52:46 2011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : active, FAILED, Not Started
> =C2=A0Active Devices : 12
> Working Devices : 13
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 1
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 512K
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : stratus.pmc.ucsc.edu:5 =C2=A0=
(local to host stratus.pmc.ucsc.edu)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 3189ca06:ccf973d0:7ef41366:=
98a75a32
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 32
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=
=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda1
> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc1
> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd1
> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 65=
 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sde1
> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 81=
 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdf1
> =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 97=
 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdg1
> =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0113=
 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdh1
> =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A08 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 =C2=A0 =C2=A0 9 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0145=
 =C2=A0 =C2=A0 =C2=A0 =C2=A09 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdj1
> =C2=A0 =C2=A0 =C2=A010 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0161=
 =C2=A0 =C2=A0 =C2=A0 10 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sd=
k1
> =C2=A0 =C2=A0 =C2=A011 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0177=
 =C2=A0 =C2=A0 =C2=A0 11 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sd=
l1
> =C2=A0 =C2=A0 =C2=A012 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0193=
 =C2=A0 =C2=A0 =C2=A0 12 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sd=
m1
> =C2=A0 =C2=A0 =C2=A013 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0209=
 =C2=A0 =C2=A0 =C2=A0 13 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sd=
n1
> =C2=A0 =C2=A0 =C2=A014 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 14 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 =C2=A0 =C2=A015 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 15 =C2=A0 =C2=A0 =C2=A0removed
>
> =C2=A0 =C2=A0 =C2=A016 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0225=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /dev/sdo=
1
> [root@stratus ~]#
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml



Hi,

To eliminate bad disks, can you post the smartctl -a output of all the
removed drives? (if you can get the OS to see them again)

Also, do you have any log files from when this happened? (kernel log,
dmesg, syslog etc)

Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
