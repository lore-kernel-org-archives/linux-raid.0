From: Chad Walker <chad@chad-cat-lore-eddie.com>
Subject: Re: raid6 issues
Date: Sat, 18 Jun 2011 12:55:12 -0700
Message-ID: <BANLkTimZ28GKnq41T78NfVPg8s4d9eRkfw@mail.gmail.com>
References: <BANLkTi=ky+t1uM0p_HhQPScG78BFxE8Hjw@mail.gmail.com>
	<BANLkTinT48ryUV01cuveutM=mDHLzy0ggg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinT48ryUV01cuveutM=mDHLzy0ggg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

also output from "mdadm --assemble --scan --verbose"

mdadm: looking for devices for /dev/md1
mdadm: cannot open device /dev/sdp1: Device or resource busy
mdadm: /dev/sdp1 has wrong uuid.
mdadm: cannot open device /dev/sdo1: Device or resource busy
mdadm: /dev/sdo1 has wrong uuid.
mdadm: cannot open device /dev/sdn1: Device or resource busy
mdadm: /dev/sdn1 has wrong uuid.
mdadm: cannot open device /dev/sdm1: Device or resource busy
mdadm: /dev/sdm1 has wrong uuid.
mdadm: cannot open device /dev/sdl1: Device or resource busy
mdadm: /dev/sdl1 has wrong uuid.
mdadm: cannot open device /dev/sdk1: Device or resource busy
mdadm: /dev/sdk1 has wrong uuid.
mdadm: cannot open device /dev/sdj1: Device or resource busy
mdadm: /dev/sdj1 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdh1: Device or resource busy
mdadm: /dev/sdh1 has wrong uuid.
mdadm: cannot open device /dev/sdg1: Device or resource busy
mdadm: /dev/sdg1 has wrong uuid.
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.


-chad




On Sat, Jun 18, 2011 at 12:48 PM, Chad Walker
<chad@chad-cat-lore-eddie.com> wrote:
> Anyone? Please help. I've been searching for answers for the last fiv=
e
> days. The (S) after the drives in the /proc/mdstat means that it
> thinks they are all spares? I've seen some mention of an
> '--assume-clean' option but I can't find any documentation on it. I'm
> running 3.1.4 (what apt-get got), but I see on Neil Brown's site that
> in the release for 3.1.5 there are 'Fixes for "--assemble --force" in
> various unusual cases' and 'Allow "--assemble --update=3Dno-bitmap" s=
o
> an array with a corrupt bitmap can still be assembled', would either
> of these be applicable in my case? I will build 3.1.5 and see if it
> helps.
>
> -chad
>
>
>
>
> On Thu, Jun 16, 2011 at 1:28 PM, Chad Walker
> <chad@chad-cat-lore-eddie.com> wrote:
>> I have 15 drives in a raid6 plus a spare. I returned home after bein=
g
>> gone for 12 days and one of the drives was marked as faulty. The loa=
d
>> on the machine was crazy, and mdadm stop responding. I should've don=
e
>> an strace, sorry. Likewise cat'ing /proc/mdstat was blocking. I
>> rebooted and mdadm started recovering, but to the faulty drive. I
>> checked in on /proc/mdstat periodically over the 35-hour recovery.
>> When it was down to the last bit, /proc/mdstat and mdadm stopped
>> responding again. I gave it 28 hours, and then when I still couldn't
>> get any insight into it I rebooted again. Now /proc/mdstat says it's
>> inactive. And I don't appear to be able to assemble it. I issued
>> --examine on each of the 16 drives and they all agreed with each oth=
er
>> except for the faulty drive. I popped the faulty drive out and
>> rebooted again, still no luck assembling.
>>
>> This is what my /proc/mdstat looks like:
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md1 : inactive sdd1[12](S) sdm1[6](S) sdf1[0](S) sdh1[2](S) sdi1[7](=
S)
>> sdb1[14](S) sdo1[4](S) sdg1[1](S) sdl1[8](S) sdk1[9](S) sdc1[13](S)
>> sdn1[3](S) sdj1[10](S) sdp1[15](S) sde1[11](S)
>> =A0 =A0 =A029302715520 blocks
>>
>> unused devices: <none>
>>
>> This is what the --examine for /dev/sd[b-o]1 and /dev/sdq1 look like=
:
>> /dev/sdb1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 78e3f473:48bbfc34:0e051622:5c30970b
>> =A0Creation Time : Wed Mar 30 14:48:46 2011
>> =A0 =A0 Raid Level : raid6
>> =A0Used Dev Size : 1953514368 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 Array Size : 25395686784 (24219.21 GiB 26005.18 GB)
>> =A0 Raid Devices : 15
>> =A0Total Devices : 16
>> Preferred Minor : 1
>>
>> =A0 =A0Update Time : Wed Jun 15 07:45:12 2011
>> =A0 =A0 =A0 =A0 =A0State : active
>> =A0Active Devices : 14
>> Working Devices : 15
>> =A0Failed Devices : 1
>> =A0Spare Devices : 1
>> =A0 =A0 =A0 Checksum : e4ff038f - correct
>> =A0 =A0 =A0 =A0 Events : 38452
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A014 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 14 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0209 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdn1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0225 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdo1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A05 =A0 =
=A0 =A0faulty removed
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0193 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sdm1
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A010 =A0 =A010 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 10 =A0 =A0 =
=A0active sync =A0 /dev/sdj1
>> =A011 =A0 =A011 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 11 =A0 =A0 =
=A0active sync =A0 /dev/sde1
>> =A012 =A0 =A012 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 12 =A0 =A0 =
=A0active sync =A0 /dev/sdd1
>> =A013 =A0 =A013 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 13 =A0 =A0 =
=A0active sync =A0 /dev/sdc1
>> =A014 =A0 =A014 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 14 =A0 =A0 =
=A0active sync =A0 /dev/sdb1
>> =A015 =A0 =A015 =A0 =A0 =A065 =A0 =A0 =A0 =A01 =A0 =A0 =A0 15 =A0 =A0=
 =A0spare =A0 /dev/sdq1
>>
>> And this is what --examine for /dev/sdp1 looked like:
>> /dev/sdp1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 78e3f473:48bbfc34:0e051622:5c30970b
>> =A0Creation Time : Wed Mar 30 14:48:46 2011
>> =A0 =A0 Raid Level : raid6
>> =A0Used Dev Size : 1953514368 (1863.02 GiB 2000.40 GB)
>> =A0 =A0 Array Size : 25395686784 (24219.21 GiB 26005.18 GB)
>> =A0 Raid Devices : 15
>> =A0Total Devices : 16
>> Preferred Minor : 1
>>
>> =A0 =A0Update Time : Tue Jun 14 07:35:56 2011
>> =A0 =A0 =A0 =A0 =A0State : active
>> =A0Active Devices : 15
>> Working Devices : 16
>> =A0Failed Devices : 0
>> =A0Spare Devices : 1
>> =A0 =A0 =A0 Checksum : e4fdb07b - correct
>> =A0 =A0 =A0 =A0 Events : 38433
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0241 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdp1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0209 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdn1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0225 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdo1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0241 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdp1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0193 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sdm1
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 9 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A09 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A010 =A0 =A010 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 10 =A0 =A0 =
=A0active sync =A0 /dev/sdj1
>> =A011 =A0 =A011 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 11 =A0 =A0 =
=A0active sync =A0 /dev/sde1
>> =A012 =A0 =A012 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 12 =A0 =A0 =
=A0active sync =A0 /dev/sdd1
>> =A013 =A0 =A013 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 13 =A0 =A0 =
=A0active sync =A0 /dev/sdc1
>> =A014 =A0 =A014 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 14 =A0 =A0 =
=A0active sync =A0 /dev/sdb1
>> =A015 =A0 =A015 =A0 =A0 =A065 =A0 =A0 =A0 =A01 =A0 =A0 =A0 15 =A0 =A0=
 =A0spare =A0 /dev/sdq1
>>
>> I was scared to run mdadm --build --level=3D6 --raid-devices=3D15 /d=
ev/md1
>> /dev/sdf1 /dev/sdg1....
>>
>> system information:
>> Ubuntu 11.04, kernel 2.6.38, x86_64, mdadm version 3.1.4, 3ware 9650=
SE
>>
>> Any advice? There's about 1TB of data on these drives that would cau=
se
>> my wife to kill me (and about 9TB of data would just irritate her to
>> loose).
>>
>> -chad
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
