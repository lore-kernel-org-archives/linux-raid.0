From: Christian <cjs703@gmail.com>
Subject: Re: RAID6 array won't start
Date: Fri, 11 Feb 2011 16:51:54 -0500
Message-ID: <AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
	<20110212083224.6b1c2cee@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110212083224.6b1c2cee@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> True.
>
> Ok, being sure that the array is stopped first, try the "-Af" command again,
> but an a -v.
> Then post the results together with any kernel messages (dmesg | tail -50
> maybe)
>
> NeilBrown
>

 # mdadm -Af -v /dev/md1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdk1
/dev/sdl1 /dev/sdm1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1mdadm:
looking for devices for /dev/md1
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 9.
mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 7.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/sdm1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdq1 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdr1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sds1 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdt1 is identified as a member of /dev/md1, slot 1.
mdadm: added /dev/sdm1 to /dev/md1 as 0
mdadm: added /dev/sdr1 to /dev/md1 as 2
mdadm: added /dev/sds1 to /dev/md1 as 3
mdadm: added /dev/sdq1 to /dev/md1 as 4
mdadm: added /dev/sdk1 to /dev/md1 as 5
mdadm: added /dev/sdf1 to /dev/md1 as 6
mdadm: added /dev/sdg1 to /dev/md1 as 7
mdadm: added /dev/sdl1 to /dev/md1 as 8
mdadm: added /dev/sde1 to /dev/md1 as 9
mdadm: added /dev/sdt1 to /dev/md1 as 1
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error


[68107.441660] md/raid:md1: not clean -- starting background reconstruction
[68107.441669] md/raid:md1: device sdt1 operational as raid disk 1
[68107.441671] md/raid:md1: device sde1 operational as raid disk 9
[68107.441673] md/raid:md1: device sdl1 operational as raid disk 8
[68107.441674] md/raid:md1: device sdg1 operational as raid disk 7
[68107.441676] md/raid:md1: device sdf1 operational as raid disk 6
[68107.441678] md/raid:md1: device sdk1 operational as raid disk 5
[68107.441679] md/raid:md1: device sdq1 operational as raid disk 4
[68107.441681] md/raid:md1: device sdr1 operational as raid disk 2
[68107.442368] md/raid:md1: allocated 10572kB
[68107.442388] md/raid:md1: cannot start dirty degraded array.
[68107.442394] RAID conf printout:
[68107.442396]  --- level:6 rd:10 wd:8
[68107.442397]  disk 1, o:1, dev:sdt1
[68107.442399]  disk 2, o:1, dev:sdr1
[68107.442400]  disk 4, o:1, dev:sdq1
[68107.442402]  disk 5, o:1, dev:sdk1
[68107.442403]  disk 6, o:1, dev:sdf1
[68107.442404]  disk 7, o:1, dev:sdg1
[68107.442406]  disk 8, o:1, dev:sdl1
[68107.442407]  disk 9, o:1, dev:sde1
[68107.442692] md/raid:md1: failed to run raid set.
[68107.442693] md: pers->run() failed ...
