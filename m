From: Jeff Wiegley <jeffw@csun.edu>
Subject: Is disk order relative or are the numbers absolute?
Date: Fri, 25 Apr 2014 11:37:32 -0700
Message-ID: <535AAB6C.3010603@csun.edu>
References: <20140424070548.445497dd@netstation>	<20140424194832.2d0a867f@netstation>	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>	<20140424203506.5fdee0d3@netstation>	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmailuplift.swm.pp.se>	<2ecef7f1-fde7-48c9-87bf-47ff617956b3@email.android.com> <CAK_KU4a0FCwG2fjAQYX4jM2xC9SbMc=qp_7T_v4hC5eztDFqOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4a0FCwG2fjAQYX4jM2xC9SbMc=qp_7T_v4hC5eztDFqOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm still trying to recover my array and I'm getting
close I think I just have to get the disk order
correct now.

Over the past year I've had a couple of failures.
and replaced disks. This changed drive numbers.

mdstat before everything went to hell was:
md4 : active raid6 sdf2[7](F) sda2[0] sdc2[2] sde2[4] sdb2[1] sdd2[6]
       10647314432 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[6/5] [UUUUU_]

Does this indicate an order of:
0: sda2
1: sdb2
2: sdc2
3: ???? (previous dead drive I replaced I'm guessing)
4: sde2
5: ???? (second previously dead/replaced drive )
6: sdd2
7: sdf2 (which is currently dead/failed)

I have to recreate the array due to zeroing the superblocks
during install (though I have not changed partition tables or
ever caused a resync of any drives.

My question is I know I can get the five good drives recreated
into an array. but I don't know how to give them specific
numbers. I can get their relative order correct with:

--create --assume-clean ... /dev/sd{a,b,c,e,d,f}2 but
sde2 will be numbered 3, not 4. sdd2 will be 4, not 5.

Will these number changes not make a difference because only
relative order is important? Or do I have to figure out some
way to force absolute positions/numbers to the drives?

Thank you,

- Jeff

On 4/25/2014 6:36 AM, Scott D'Vileskis wrote:
> Drive B has bogus data on it., since it was resync'd with C & D in the
> wrong order. Fortunately, your --add should have only have changed B,
> not C & D.
>
> As a last ditch effort, try the --create again but with the two
> potentially good disks in the right order:
>
> mdadm --create /dev/md0 --level=5 --raid-devices=3 missing /dev/sdc1 /dev/sdd1
>
> Note: The following is where I have reproduced your problem with loop devices
>
> #Create 3 200MB files
> root@Breadman:/home/scott# mkdir raidtesting
> root@Breadman:/home/scott# cd raidtesting/
> root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdb
> root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdc
> root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdd
> root@Breadman:/home/scott/raidtesting# losetup /dev/loop2 sdb
> root@Breadman:/home/scott/raidtesting# losetup /dev/loop3 sdc
> root@Breadman:/home/scott/raidtesting# losetup /dev/loop4 sdd
> root@Breadman:/home/scott/raidtesting# mdadm --create /dev/md0 -n3 -l5
> /dev/loop2 /dev/loop3 /dev/loop4
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
>
> root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
> md0 : active raid5 loop4[3] loop3[1] loop2[0]
>        388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>
> root@Breadman:/home/scott/raidtesting# mkfs.reiserfs /dev/md0
> mkfs.reiserfs 3.6.21 (2009 www.namesys.com)
> <SNIP>
> ReiserFS is successfully created on /dev/md0.
> root@Breadman:/home/scott/raidtesting# mkdir temp
> root@Breadman:/home/scott/raidtesting# mount /dev/md0 temp/
>
> #Then I copied a file to it:
> root@Breadman:/home/scott/raidtesting# md5sum temp/systemrescuecd-x86-0.4.3.iso
> b88ce25b156619a9a344889bc92b1833  temp/systemrescuecd-x86-0.4.3.iso
>
> #And failed a disk
> root@Breadman:/home/scott/raidtesting# umount temp/
> root@Breadman:/home/scott/raidtesting# mdadm --fail /dev/md0 /dev/loop2
> mdadm: set /dev/loop2 faulty in /dev/md0
> root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
> md0 : active raid5 loop4[3] loop3[1] loop2[0](F)
>        388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
>
> #Stopped array, removed disk, replaced disk by creating a new file
> root@Breadman:/home/scott/raidtesting# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> root@Breadman:/home/scott/raidtesting# losetup -d /dev/loop2
> root@Breadman:/home/scott/raidtesting# rm sdb
> root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdb-new
> root@Breadman:/home/scott/raidtesting# losetup /dev/loop2 sdb-new
>
> #WRONG: Create array in wrong order
> root@Breadman:/home/scott/raidtesting# mdadm --create /dev/md0
> --assume-clean -l5 -n3 /dev/loop3 /dev/loop4 /dev/loop2
> mdadm: /dev/loop3 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Fri Apr 25 09:10:31 2014
> mdadm: /dev/loop4 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Fri Apr 25 09:10:31 2014
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
> [raid1] [raid10]
> md0 : active raid5 loop2[2] loop4[1] loop3[0]
>        388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>
> root@Breadman:/home/scott/raidtesting# mount /dev/md0 temp/
> mount: you must specify the filesystem type
>
> #Nope, doesn't mount, filesystem clobbered, or not?
>
> root@Breadman:/home/scott/raidtesting# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
>
> #Recreate the array, with missing disk in the right place
> root@Breadman:/home/scott/raidtesting# mdadm --create /dev/md0 -l5 -n3
> missing /dev/loop3 /dev/loop4
> mdadm: /dev/loop3 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Fri Apr 25 09:17:38 2014
> mdadm: /dev/loop4 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Fri Apr 25 09:17:38 2014
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> root@Breadman:/home/scott/raidtesting# mount /dev/md0 temp/
> root@Breadman:/home/scott/raidtesting# ls temp/
> systemrescuecd-x86-0.4.3.iso
> root@Breadman:/home/scott/raidtesting# md5sum temp/systemrescuecd-x86-0.4.3.iso
> b88ce25b156619a9a344889bc92b1833  temp/systemrescuecd-x86-0.4.3.iso
>
> #Notice we are in degraded mode
> root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
> md0 : active raid5 loop4[2] loop3[1]
>        388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
>
> #Add our replacement disk:
> root@Breadman:/home/scott/raidtesting# mdadm --add /dev/md0 /dev/loop2
> mdadm: added /dev/loop2
>
> root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
> md0 : active raid5 loop2[3] loop4[2] loop3[1]
>        388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
>        [============>........]  recovery = 62.1% (121316/194048)
> finish=0.0min speed=12132K/sec
>
> #After a while (short while with 200MB loop devices):
> root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
> [raid1] [raid10]
> md0 : active raid5 loop2[3] loop4[2] loop3[1]
>        388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

