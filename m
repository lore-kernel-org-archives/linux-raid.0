From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Thu, 14 Aug 2003 12:09:48 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16186.61292.498656.959026@gargle.gargle.HOWL>
References: <200308131236.44311.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arkadiusz Miskiewicz on Wednesday August 13
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 13, arekm@pld-linux.org wrote:
> After patching 2.4.21 kernel md0 resync started as you said but now I=
 have:
>=20
> [root@perfo root]# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Tue May  4 09:37:53 1999
>      Raid Level : raid5
>      Array Size : 9960064 (9.50 GiB 10.20 GB)
>     Device Size : 4980032 (4.75 GiB 5.10 GB)
>    Raid Devices : 3
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Wed Aug 13 12:24:12 2003
>           State : dirty, no-errors
>  Active Devices : 1
> Working Devices : -1
>  Failed Devices : 4
>   Spare Devices : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 32K
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      faulty   /dev/sdb2
>        2       0        0        2      faulty removed
>        3       8       34        3      spare   /dev/sdc2
>            UUID : c6839323:6d5bd707:731f0c8c:10e7b89b
>          Events : 0.161
>=20
> I've removed sdb2 and readded it as spare. Of course that didn't
> help.

Ouch.  Looks like you had an error on /dev/sdb2.  Is there anything
about that in the logs?

>=20
> I'm going to try ,,alternative method'' but I want to be sure of one =
thing -=20
> if I recreate array with the same parameters I wont loose any data
> on it?

This is correct.  If you recreate the array with the same parameters
you won't loose data.  Be sure to only include the up-to-date drives
in the array when you first create it.  i.e. not /dev/sdc2.

NeilBrown


>=20
> ps. I'm not getting your mails directly (no idea why) and read them v=
ia google=20
> (that's why there is no references or in-reply-to in headers).
>=20
> --=20
> Arkadiusz Mi=B6kiewicz    CS at FoE, Wroclaw University of Technology
> arekm@sse.pl   AM2-6BONE, 1024/3DB19BBD, arekm(at)ircnet, PLD/Linux
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
