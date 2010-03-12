From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Problems recovering from a raid1 failure
Date: Fri, 12 Mar 2010 00:22:22 -0800
Message-ID: <4877c76c1003120022t76ab64bcw1eb8659209f6acfd@mail.gmail.com>
References: <910019881003112351y2fb108abw55fef9da81a5435f@mail.gmail.com>
	 <4877c76c1003120017n34cb170awac2260d1abf1a7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003120017n34cb170awac2260d1abf1a7a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Gordon <jonathan.kinobe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 12, 2010 at 12:17 AM, Michael Evans <mjevans1983@gmail.com>=
 wrote:
> On Thu, Mar 11, 2010 at 11:51 PM, Jonathan Gordon
> <jonathan.kinobe@gmail.com> wrote:
>> Upon reboot, my machine began recovering from a raid1 failure.
>> Querying mdadm yielded the following:
>>
>> jgordon@kubuntu:~$ sudo mdadm --detail /dev/md0
>> [sudo] password for jgordon:
>> /dev/md0:
>> =A0 =A0 =A0 Version : 00.90
>> =A0Creation Time : Mon Sep 11 06:35:17 2006
>> =A0 =A0Raid Level : raid1
>> =A0 =A0Array Size : 242187776 (230.97 GiB 248.00 GB)
>> =A0Used Dev Size : 242187776 (230.97 GiB 248.00 GB)
>> =A0Raid Devices : 2
>> =A0Total Devices : 2
>> Preferred Minor : 0
>> =A0 Persistence : Superblock is persistent
>>
>> =A0 Update Time : Thu Mar 11 18:09:25 2010
>> =A0 =A0 =A0 =A0 State : clean, degraded, recovering
>> =A0Active Devices : 1
>> Working Devices : 2
>> =A0Failed Devices : 0
>> =A0Spare Devices : 1
>>
>> =A0Rebuild Status : 26% complete
>>
>> =A0 =A0 =A0 =A0 =A0UUID : 7fd22081:c39cb3e4:21109eec:10ecdf10
>> =A0 =A0 =A0 =A0Events : 0.5260272
>>
>> =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0spare rebuilding =A0 /dev/sda1
>> =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
>>
>> After some time, the rebuild seemed to complete, but the State seeme=
d
>> to switch alternately between "active, degraded" and "clean,
>> degraded". Addiontally, the state for /dev/sda1 seems to continue to
>> stay in "spare rebuilding". This is the current output:
>>
>> jgordon@kubuntu:~$ sudo mdadm -D /dev/md0
>> [sudo] password for jgordon:
>> /dev/md0:
>> =A0 =A0 =A0 Version : 00.90
>> =A0Creation Time : Mon Sep 11 06:35:17 2006
>> =A0 =A0Raid Level : raid1
>> =A0 =A0Array Size : 242187776 (230.97 GiB 248.00 GB)
>> =A0Used Dev Size : 242187776 (230.97 GiB 248.00 GB)
>> =A0Raid Devices : 2
>> =A0Total Devices : 2
>> Preferred Minor : 0
>> =A0 Persistence : Superblock is persistent
>>
>> =A0 Update Time : Thu Mar 11 23:07:59 2010
>> =A0 =A0 =A0 =A0 State : clean, degraded
>> =A0Active Devices : 1
>> Working Devices : 2
>> =A0Failed Devices : 0
>> =A0Spare Devices : 1
>>
>> =A0 =A0 =A0 =A0 =A0UUID : 7fd22081:c39cb3e4:21109eec:10ecdf10
>> =A0 =A0 =A0 =A0Events : 0.5273340
>>
>> =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0spare rebuilding =A0 /dev/sda1
>> =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
>>
>> Additionally, /var/log/kern.log is getting filled with the following=
:
>>
>> Mar 11 19:19:14 jigme kernel: [ 6596.236366] ata4: EH complete
>> Mar 11 19:19:16 jigme kernel: [ 6598.104676] ata4.00: exception Emas=
k
>> 0x0 SAct 0x0 SErr 0x0 action 0x0
>> Mar 11 19:19:16 jigme kernel: [ 6598.104683] ata4.00: BMDMA stat 0x2=
4
>> Mar 11 19:19:16 jigme kernel: [ 6598.104692] ata4.00: cmd
>> 25/00:08:ff:b0:e0/00:00:15:00:00/e0 tag 0 dma 4096 in
>> Mar 11 19:19:16 jigme kernel: [ 6598.104694] =A0 =A0 =A0 =A0 =A0res
>> 51/40:00:04:b1:e0/40:00:15:00:00/e0 Emask 0x9 (media error)
>> Mar 11 19:19:16 jigme kernel: [ 6598.104698] ata4.00: status: { DRDY=
 ERR }
>> Mar 11 19:19:16 jigme kernel: [ 6598.104702] ata4.00: error: { UNC }
>> Mar 11 19:19:16 jigme kernel: [ 6598.120352] ata4.00: configured for=
 UDMA/133
>> Mar 11 19:19:16 jigme kernel: [ 6598.120371] sd 3:0:0:0: [sdb]
>> Unhandled sense code
>> Mar 11 19:19:16 jigme kernel: [ 6598.120375] sd 3:0:0:0: [sdb] Resul=
t:
>> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>> Mar 11 19:19:16 jigme kernel: [ 6598.120380] sd 3:0:0:0: [sdb] Sense
>> Key : Medium Error [current] [descriptor]
>> Mar 11 19:19:16 jigme kernel: [ 6598.120388] Descriptor sense data
>> with sense descriptors (in hex):
>> Mar 11 19:19:16 jigme kernel: [ 6598.120392] =A0 =A0 =A0 =A0 72 03 1=
1 04 00 00
>> 00 0c 00 0a 80 00 00 00 00 00
>> Mar 11 19:19:16 jigme kernel: [ 6598.120412] =A0 =A0 =A0 =A0 15 e0 b=
1 04
>> Mar 11 19:19:16 jigme kernel: [ 6598.120420] sd 3:0:0:0: [sdb] Add.
>> Sense: Unrecovered read error - auto reallocate failed
>> Mar 11 19:19:16 jigme kernel: [ 6598.120428] end_request: I/O error,
>> dev sdb, sector 367046916
>> Mar 11 19:19:16 jigme kernel: [ 6598.120446] ata4: EH complete
>> Mar 11 19:19:16 jigme kernel: [ 6598.120744] raid1: sdb: unrecoverab=
le
>> I/O read error for block 367046784
>> Mar 11 19:19:17 jigme kernel: [ 6599.164052] md: md0: recovery done.
>> Mar 11 19:19:17 jigme kernel: [ 6599.460124] RAID1 conf printout:
>> Mar 11 19:19:17 jigme kernel: [ 6599.460145] =A0--- wd:1 rd:2
>> Mar 11 19:19:17 jigme kernel: [ 6599.460160] =A0disk 0, wo:1, o:1, d=
ev:sda1
>> Mar 11 19:19:17 jigme kernel: [ 6599.460170] =A0disk 1, wo:0, o:1, d=
ev:sdb1
>> Mar 11 19:19:17 jigme kernel: [ 6599.460178] RAID1 conf printout:
>> Mar 11 19:19:17 jigme kernel: [ 6599.460185] =A0--- wd:1 rd:2
>> Mar 11 19:19:17 jigme kernel: [ 6599.460195] =A0disk 0, wo:1, o:1, d=
ev:sda1
>> Mar 11 19:19:17 jigme kernel: [ 6599.460204] =A0disk 1, wo:0, o:1, d=
ev:sdb1
>> Mar 11 19:19:22 jigme kernel: [ 6604.165111] RAID1 conf printout:
>> Mar 11 19:19:22 jigme kernel: [ 6604.165117] =A0--- wd:1 rd:2
>> Mar 11 19:19:22 jigme kernel: [ 6604.165122] =A0disk 0, wo:1, o:1, d=
ev:sda1
>> Mar 11 19:19:22 jigme kernel: [ 6604.165125] =A0disk 1, wo:0, o:1, d=
ev:sdb1
>> Mar 11 19:19:22 jigme kernel: [ 6604.165128] RAID1 conf printout:
>> Mar 11 19:19:22 jigme kernel: [ 6604.165131] =A0--- wd:1 rd:2
>> Mar 11 19:19:22 jigme kernel: [ 6604.165134] =A0disk 0, wo:1, o:1, d=
ev:sda1
>> Mar 11 19:19:22 jigme kernel: [ 6604.165137] =A0disk 1, wo:0, o:1, d=
ev:sdb1
>> ...
>> Mar 11 23:16:28 jigme kernel: [20830.889380] RAID1 conf printout:
>> Mar 11 23:16:28 jigme kernel: [20830.889386] =A0--- wd:1 rd:2
>> Mar 11 23:16:28 jigme kernel: [20830.889391] =A0disk 0, wo:1, o:1, d=
ev:sda1
>> Mar 11 23:16:28 jigme kernel: [20830.889394] =A0disk 1, wo:0, o:1, d=
ev:sdb1
>> Mar 11 23:16:28 jigme kernel: [20830.889397] RAID1 conf printout:
>> Mar 11 23:16:28 jigme kernel: [20830.889399] =A0--- wd:1 rd:2
>> Mar 11 23:16:28 jigme kernel: [20830.889403] =A0disk 0, wo:1, o:1, d=
ev:sda1
>> Mar 11 23:16:28 jigme kernel: [20830.889406] =A0disk 1, wo:0, o:1, d=
ev:sdb1
>>
>> The "RAID1 conf printout:" messages appear every few seconds or so.
>>
>> Machine info:
>>
>> jgordon@kubuntu:~$ uname -a
>> Linux kubuntu 2.6.31-20-386 #57-Ubuntu SMP Mon Feb 8 11:42:49 UTC 20=
10
>> i686 GNU/Linux
>>
>> Any idea what I can do to resolve this?
>>
>> Thanks!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Replace your failing disk; from the look of the kernel log and the
> description of the issue I'd say your drive is out of spare sectors
> and would fail a S.M.A.R.T. test.
>
> If you require more proof start reading up on how to use the smartctl
> command from the smartmontools package (may have dashes/etc in your
> package manager).
>
> http://sourceforge.net/apps/trac/smartmontools/wiki/TocDoc
>

Reading more carefully, I notice you're in a most unfortunate
situation.  It's failing while trying to READ your 'ACTIVE' disc.

You should buy two NEW drives, attempt to copy the current active
member of the array to a NEW drive using something like
http://www.gnu.org/software/ddrescue/ddrescue.html

=46or anything that won't copy you /MIGHT/ try the other member of the
array if it used to be in place.  Chances are good that stale data
from a section MAY be better than no data at all.  You MUST perform an
=46SCK prior to mounting the newly re-created array; you should try to
determine which files occupy any 'recovered' sectors and validate that
they are intact or replace them from other duplicates.

How to do that depends very much on what filesystem you have on the arr=
ay.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
