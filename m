From: Eric Ramsey <tomoyodaidoji@gmail.com>
Subject: Re: Odd failure during reshape
Date: Tue, 1 Jun 2010 16:08:49 -0600
Message-ID: <AANLkTil_3BkoyzusqadGxihsIfgZGefsIAqteD9apesy@mail.gmail.com>
References: <AANLkTimeH3ETfqovI2NnccHiYN152IrDhSgRdCUbYIiP@mail.gmail.com>
	<AANLkTilhkRNFm3a7cGVYjPS5AA-zr_W_U3I0qTucjj1e@mail.gmail.com>
	<AANLkTin6s2qpfcowk0K61MJ9_cSEAwFfxgRy8T5ky6YU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin6s2qpfcowk0K61MJ9_cSEAwFfxgRy8T5ky6YU@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would appreciate any feedback on this as I am currently waiting
before doing anything that can change the raid to prevent any further
issues

On Tue, Jun 1, 2010 at 7:28 AM, Eric Ramsey <tomoyodaidoji@gmail.com> w=
rote:
> From my testing it seems the data is fine. it seems that the 400GB
> that wasn't reshapen is in the expanded area.
> would it be safe to just re-add the drives back into the array to get
> it to restore? Or will I have issues when I start writing to the last
> 400GB?
>
> On Tue, Jun 1, 2010 at 7:02 AM, Eric Ramsey <tomoyodaidoji@gmail.com>=
 wrote:
>> Linux The-Light 2.6.34sakura1 #1 SMP Sun May 30 02:27:44 MDT 2010
>> x86_64 GNU/Linux
>>
>> mdadm - v3.1.2 - 10th March 2010
>>
>> On Tue, Jun 1, 2010 at 6:43 AM, Eric Ramsey <tomoyodaidoji@gmail.com=
> wrote:
>>> My system locked up during the reshape to raid 6 and the system cam=
e
>>> back in a rather odd state. =A02 of the original drives were knocke=
d out
>>> of the array 400 GB short and all other drives indicate they are
>>> completley synced I would not be concerned if it was the drives I w=
as
>>> expanding too.
>>> SDD1 and SDE1 were the drives knocked out early, and the new drives
>>> are SDG1 and SDH1.
>>> I have tried to reassemble them correctly but I get the following e=
rror:
>>> mdadm --assemble /dev/md1 /dev/sdd1 =A0/dev/sde1 =A0/dev/sdc1 =A0/d=
ev/sdf1
>>> /dev/sdg1 =A0/dev/sdh1 =A0/dev/sdi1 =A0/dev/sdj1 =A0/dev/sdk1 =A0/d=
ev/sdl1
>>> mdadm: superblock on /dev/sdc1 doesn't match others - assembly abor=
ted
>>>
>>> I am testing with the raid readonly to see if I lost any data, is
>>> there any other tips you guys can provide?
>>>
>>> /dev/sdc1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c4722 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdd1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.91.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 10
>>> Preferred Minor : 1
>>>
>>> =A0Reshape pos'n : 6960011264 (6637.58 GiB 7127.05 GB)
>>> =A0Delta Devices : 2 (8->10)
>>>
>>> =A0 =A0Update Time : Mon May 31 11:24:20 2010
>>> =A0 =A0 =A0 =A0 =A0State : active
>>> =A0Active Devices : 9
>>> Working Devices : 9
>>> =A0Failed Devices : 1
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : cc00f986 - correct
>>> =A0 =A0 =A0 =A0 Events : 3007985
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sde1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.91.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 10
>>> Preferred Minor : 1
>>>
>>> =A0Reshape pos'n : 6960011264 (6637.58 GiB 7127.05 GB)
>>> =A0Delta Devices : 2 (8->10)
>>>
>>> =A0 =A0Update Time : Mon May 31 11:21:41 2010
>>> =A0 =A0 =A0 =A0 =A0State : active
>>> =A0Active Devices : 10
>>> Working Devices : 10
>>> =A0Failed Devices : 0
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : cc00f8d8 - correct
>>> =A0 =A0 =A0 =A0 Events : 3007979
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sde1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sde1
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdf1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c4756 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdg1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c4770 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdh1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c4782 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdi1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c478e - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdj1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c4798 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdk1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c47a0 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>> /dev/sdl1:
>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>> =A0 =A0 =A0 =A0 =A0 UUID : 78e59241:4bbafd48:2109fad5:2e345672
>>> =A0Creation Time : Fri Oct 16 00:19:20 2009
>>> =A0 =A0 Raid Level : raid6
>>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>> =A0 =A0 Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>>> =A0 Raid Devices : 10
>>> =A0Total Devices : 8
>>> Preferred Minor : 1
>>>
>>> =A0 =A0Update Time : Tue Jun =A01 06:24:19 2010
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0Active Devices : 8
>>> Working Devices : 8
>>> =A0Failed Devices : 2
>>> =A0Spare Devices : 0
>>> =A0 =A0 =A0 Checksum : 8e7c47b4 - correct
>>> =A0 =A0 =A0 =A0 Events : 3009686
>>>
>>> =A0 =A0 Chunk Size : 64K
>>>
>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>>
>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0faulty removed
>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0=
 =A0 =A0faulty removed
>>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
