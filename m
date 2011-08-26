From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 13:01:51 +0100
Message-ID: <CADNH=7HMgJ9+wCEH5i03L6UmQw2xnMopnx09z8W0nU-q6_0Dig@mail.gmail.com>
References: <4E5787A1.7080807@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5787A1.7080807@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26 August 2011 12:46, Stefan G. Weichinger <lists@xunil.at> wrote:
>
> Please help:
>
> Today I removed a defective hdd out of a RAID1-array and swapped in a
> new hdd instead.
>
> 3 arrays, to be true, md[012]
>
> 0 and 1 synced fine, in the process of syncing md2 the old sda threw
> errors (in sda4):
>
> md/raid1:md2: sda: unrecoverable I/O read error for block 643686144
> md: md2: recovery done.
>
> [...]
>
> md/raid1:md2: sda: unrecoverable I/O read error for block 643686272
>
> ----
>
> Did the system stop syncing or is "recovery done" the indication that
> md2 was fully recovered BEFORE the system threw sda4 out of the array=
??
>
> I hope for the second!
>
> See:
>
> # mdadm -D /dev/md2
> /dev/md2:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 0.90
> =C2=A0Creation Time : Thu Feb 11 19:40:11 2010
> =C2=A0 =C2=A0 Raid Level : raid1
> =C2=A0 =C2=A0 Array Size : 962454080 (917.87 GiB 985.55 GB)
> =C2=A0Used Dev Size : 962454080 (917.87 GiB 985.55 GB)
> =C2=A0 Raid Devices : 2
> =C2=A0Total Devices : 2
> Preferred Minor : 2
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Fri Aug 26 13:40:55 2011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean, degraded
> =C2=A0Active Devices : 1
> Working Devices : 2
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 1
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 0ee7bbc7:fc6b0172:d195d856:=
5f94e963
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 0.1833443
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=
=A04 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda4
> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0removed
>
> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 20=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /dev/sdb=
4
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdb3[1] sda3[0]
> =C2=A0 =C2=A0 =C2=A013679232 blocks [2/2] [UU]
>
> md2 : active raid1 sdb4[2](S) sda4[0]
> =C2=A0 =C2=A0 =C2=A0962454080 blocks [2/1] [U_]
>
> md0 : active raid1 sdb1[1] sda1[0]
> =C2=A0 =C2=A0 =C2=A0128384 blocks [2/2] [UU]
>
> unused devices: <none>
>
> ----
>
> The system seems to work OK, md2 which is a PV in a LVM-volumegroup i=
s
> there, etc
>
> I just wonder if should somehow re-add sda4 or not touch a thing unti=
l I
> have a new hdd at hand??
>
> Can/should I somehow test the integrity of md2?
>
> Pls help me to relax in this case ...
>
> btw:
>
> Linux version 2.6.36-gentoo-r5
> mdadm-3.1.4
>
> Thanks in advance, Stefan!
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hm,

Could you perhaps post the output of "smartctl -a /dev/sda" (and sdb
for completeness sake) here? You can find smartctl in the
smartmontools package.

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
