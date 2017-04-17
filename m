From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Lost second disk during resync, can I recover?
Date: Mon, 17 Apr 2017 16:52:40 +1000
Message-ID: <a5f70110-1fff-e3df-5783-0311427bf108@eyal.emu.id.au>
References: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/04/17 10:30, Adam B wrote:
> I've got a synology ds1812+
> Could have sworn I did raid 6, but md says raid5 (dont recall
> personalities pre-failure)
> Lost disk 2, was rebuilding and disk 6 crashed.
>
> Booting from a fresh machine, and attempting to discover the arrays
> (md125 is the target)
>
> root@ds:~# mdadm --assemble --scan
> mdadm: /dev/md/DiskStation:2 assembled from 6 drives - not enough to
> start the array.
> mdadm: /dev/md/1_1 has been started with 7 drives (out of 8).
> mdadm: /dev/md/0_1 has been started with 7 drives (out of 8).
> mdadm: /dev/md/DiskStation:2 exists - ignoring
> mdadm: /dev/md125 assembled from 6 drives - not enough to start the array.
> root@ds:~# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md126 : active raid1 sda1[0] sdh1[7] sdg1[6] sde1[4] sdd1[3] sdc1[2] sdb1[1]
>       2490176 blocks [8/7] [UUUUU_UU]
>
> md127 : active raid1 sda2[0] sdb2[7] sdh2[6] sdg2[5] sde2[3] sdd2[2] sdc2[1]
>       2097088 blocks [8/7] [UUUU_UUU]
>
> md2 : active raid5 sdf3[5]
>       20478809792 blocks super 1.2 level 5, 64k chunk, algorithm 2
> [8/1] [_____U__]
>
> md1 : active raid1 sdf2[0]
>       2097088 blocks [8/1] [U_______]
>
> md0 : active raid1 sdf1[0]
>       2490176 blocks [8/1] [U_______]
>
> Attempting to assemble gives the same error:
> root@ds:~# mdadm --assemble --force /dev/md125 /dev/sda3 /dev/sdb3
> /dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdg3 /dev/sdh3
> mdadm: /dev/md125 assembled from 6 drives - not enough to start the array.
>
> but also yields:
> root@ds:~# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md125 : inactive sda3[8](S) sdh3[7](S) sdg3[6](S) sde3[4](S)
> sdd3[3](S) sdc3[2](S) sdb3[9](S)
>       20478810915 blocks super 1.2
>
> but:
>
> root@ds:~# mdadm --detail /dev/md125
> mdadm: md device /dev/md125 does not appear to be active.
>
> I attempt to run:
> root@ds:~# mdadm --manage --run /dev/md125
> mdadm: started /dev/md125
> root@ds:~# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md125 : active raid5 sda3[8] sdh3[7] sdg3[6] sde3[4] sdd3[3] sdc3[2]
>       20478809792 blocks super 1.2 level 5, 64k chunk, algorithm 2
> [8/6] [U_UUU_UU]
>
> Add back in the disk we were rebuilding (disk 2) before we lost disk 6:
> root@ds:~# mdadm --manage /dev/md125 --add /dev/sdb3

When  I have a disk kicked out, after a plug out/in I reintroduce it with
	# mdadm --re-add /dev/md125 /dev/sdb3
This triggers a recovery which is often very quick (assuming you have a bitmap).

This, of course, does not work when the disk is physically fully dead, a rare event
for me.

[trim]

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
