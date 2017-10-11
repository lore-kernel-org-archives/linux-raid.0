From: Joseba Ibarra <wajalotnet@gmail.com>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Wed, 11 Oct 2017 13:56:53 +0200
Message-ID: <59DE0705.502@gmail.com>
References: <59DDF18A.9060800@gmail.com> <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org> <59DDFD19.1040700@gmail.com> <e6566c4a-2476-4554-549a-12b6c90b152f@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e6566c4a-2476-4554-549a-12b6c90b152f@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Adam

root@grafico:/mnt# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : inactive sdd1[3] sdb1[1] sdc1[2]
       2929889280 blocks super 1.2

unused devices: <none>


root@grafico:/mnt# mdadm --manage /dev/md0 --stop
mdadm: stopped /dev/md0


root@grafico:/mnt# mdadm --assemble /dev/md0 /dev/sd[bcd]1
mdadm: /dev/md0 assembled from 3 drives - not enough to start the array 
while not clean - consider --force.



root@grafico:/mnt# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
unused devices: <none>

At this point I´ve followed the advise using --force

root@grafico:/mnt# mdadm --assemble --force /dev/md0 /dev/sd[bcd]1
mdadm: Marking array /dev/md0 as 'clean'
mdadm: /dev/md0 has been started with 3 drives (out of 4).


root@grafico:/mnt# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active (auto-read-only) raid5 sdb1[1] sdd1[3] sdc1[2]
       2929889280 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/3] [_UUU]
       bitmap: 0/8 pages [0KB], 65536KB chunk

unused devices: <none>


Now I see the RAID, however can't be mounted. So, I'm not sure how to 
backup the data. Gparted shows the partition /dev/md0p1 with the used 
and free space.


If I try

mount /dev/md0 /mnt

again the output is

mount: wrong file system, bad option, bad superblock in /dev/md0, 
missing codepage or helper program, or other error

     In some cases useful info is found in syslog - try dmesg | tail or 
something like that.

I do dmesg | tail

If I try root@grafico:/mnt# mount /dev/md0p1 /mnt
mount: /dev/md0p1: can't read superblock

And


root@grafico:/mnt# dmesg | tail
[ 3263.411724] VFS: Dirty inode writeback failed for block device md0p1 
(err=-5).
[ 3280.486813]  md0: p1
[ 3280.514024]  md0: p1
[ 3452.496811] UDF-fs: warning (device md0): udf_fill_super: No 
partition found (2)
[ 3463.731052] JBD2: Invalid checksum recovering block 630194476 in log
[ 3464.933960] Buffer I/O error on dev md0p1, logical block 630194474, 
lost async page write
[ 3464.933971] Buffer I/O error on dev md0p1, logical block 630194475, 
lost async page write
[ 3465.928066] JBD2: recovery failed
[ 3465.928070] EXT4-fs (md0p1): error loading journal
[ 3465.936852] VFS: Dirty inode writeback failed for block device md0p1 
(err=-5).


Thanks a lot for your time


Joseba Ibarra
> Adam Goryachev <mailto:adam@websitemanagers.com.au>
> 11 de octubre de 2017, 13:29
> Hi Rudy,
>
> Please send the output of all of the following commands:
>
> cat /proc/mdstat
>
> mdadm --manage /dev/md0 --stop
>
> mdadm --assemble /dev/md0 /dev/sd[bcd]1
>
> cat /proc/mdstat
>
> mdadm --manage /dev/md0 --run
>
> mdadm --manage /dev/md0 --readwrite
>
> cat /proc/mdstat
>
>
> Basically the above is just looking at what the system has done 
> currently, stopping/clearing that, and then trying to assemble it 
> again, finally, we try to start it, even if it has one faulty disk.
>
> At this stage, chances look good for recovering all your data, though 
> I would advise to get yourself a replacement disk for the dead one so 
> that you can restore redundancy as soon as possible.
>
> Regards,Adam
>
>

