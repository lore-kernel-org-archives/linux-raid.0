From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Fri, 25 Apr 2014 09:36:12 -0400
Message-ID: <CAK_KU4a0FCwG2fjAQYX4jM2xC9SbMc=qp_7T_v4hC5eztDFqOA@mail.gmail.com>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
	<20140424203506.5fdee0d3@netstation>
	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
	<CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com>
	<20140424215654.0447d300@netstation>
	<CAK_KU4YUejncX9yQk4HM5HE=1-qPPxOibuRauFheo3jaBc8SaQ@mail.gmail.com>
	<20140425071340.1ac35ded@netstation>
	<alpine.DEB.2.02.1404250802070.19744@uplift.swm.pp.se>
	<2ecef7f1-fde7-48c9-87bf-47ff617956b3@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ecef7f1-fde7-48c9-87bf-47ff617956b3@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: "L. M. J" <linuxmasterjedi@free.fr>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Drive B has bogus data on it., since it was resync'd with C & D in the
wrong order. Fortunately, your --add should have only have changed B,
not C & D.

As a last ditch effort, try the --create again but with the two
potentially good disks in the right order:

mdadm --create /dev/md0 --level=5 --raid-devices=3 missing /dev/sdc1 /dev/sdd1

Note: The following is where I have reproduced your problem with loop devices

#Create 3 200MB files
root@Breadman:/home/scott# mkdir raidtesting
root@Breadman:/home/scott# cd raidtesting/
root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdb
root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdc
root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdd
root@Breadman:/home/scott/raidtesting# losetup /dev/loop2 sdb
root@Breadman:/home/scott/raidtesting# losetup /dev/loop3 sdc
root@Breadman:/home/scott/raidtesting# losetup /dev/loop4 sdd
root@Breadman:/home/scott/raidtesting# mdadm --create /dev/md0 -n3 -l5
/dev/loop2 /dev/loop3 /dev/loop4
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
md0 : active raid5 loop4[3] loop3[1] loop2[0]
      388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

root@Breadman:/home/scott/raidtesting# mkfs.reiserfs /dev/md0
mkfs.reiserfs 3.6.21 (2009 www.namesys.com)
<SNIP>
ReiserFS is successfully created on /dev/md0.
root@Breadman:/home/scott/raidtesting# mkdir temp
root@Breadman:/home/scott/raidtesting# mount /dev/md0 temp/

#Then I copied a file to it:
root@Breadman:/home/scott/raidtesting# md5sum temp/systemrescuecd-x86-0.4.3.iso
b88ce25b156619a9a344889bc92b1833  temp/systemrescuecd-x86-0.4.3.iso

#And failed a disk
root@Breadman:/home/scott/raidtesting# umount temp/
root@Breadman:/home/scott/raidtesting# mdadm --fail /dev/md0 /dev/loop2
mdadm: set /dev/loop2 faulty in /dev/md0
root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
md0 : active raid5 loop4[3] loop3[1] loop2[0](F)
      388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]

#Stopped array, removed disk, replaced disk by creating a new file
root@Breadman:/home/scott/raidtesting# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@Breadman:/home/scott/raidtesting# losetup -d /dev/loop2
root@Breadman:/home/scott/raidtesting# rm sdb
root@Breadman:/home/scott/raidtesting# fallocate -l200000000 sdb-new
root@Breadman:/home/scott/raidtesting# losetup /dev/loop2 sdb-new

#WRONG: Create array in wrong order
root@Breadman:/home/scott/raidtesting# mdadm --create /dev/md0
--assume-clean -l5 -n3 /dev/loop3 /dev/loop4 /dev/loop2
mdadm: /dev/loop3 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Fri Apr 25 09:10:31 2014
mdadm: /dev/loop4 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Fri Apr 25 09:10:31 2014
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md0 : active raid5 loop2[2] loop4[1] loop3[0]
      388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

root@Breadman:/home/scott/raidtesting# mount /dev/md0 temp/
mount: you must specify the filesystem type

#Nope, doesn't mount, filesystem clobbered, or not?

root@Breadman:/home/scott/raidtesting# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

#Recreate the array, with missing disk in the right place
root@Breadman:/home/scott/raidtesting# mdadm --create /dev/md0 -l5 -n3
missing /dev/loop3 /dev/loop4
mdadm: /dev/loop3 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Fri Apr 25 09:17:38 2014
mdadm: /dev/loop4 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Fri Apr 25 09:17:38 2014
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@Breadman:/home/scott/raidtesting# mount /dev/md0 temp/
root@Breadman:/home/scott/raidtesting# ls temp/
systemrescuecd-x86-0.4.3.iso
root@Breadman:/home/scott/raidtesting# md5sum temp/systemrescuecd-x86-0.4.3.iso
b88ce25b156619a9a344889bc92b1833  temp/systemrescuecd-x86-0.4.3.iso

#Notice we are in degraded mode
root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
md0 : active raid5 loop4[2] loop3[1]
      388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]

#Add our replacement disk:
root@Breadman:/home/scott/raidtesting# mdadm --add /dev/md0 /dev/loop2
mdadm: added /dev/loop2

root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
md0 : active raid5 loop2[3] loop4[2] loop3[1]
      388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
      [============>........]  recovery = 62.1% (121316/194048)
finish=0.0min speed=12132K/sec

#After a while (short while with 200MB loop devices):
root@Breadman:/home/scott/raidtesting# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md0 : active raid5 loop2[3] loop4[2] loop3[1]
      388096 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
