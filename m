From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 15:53:07 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812141552380.27065@p34.internal.lan>
References: <49450D04.8060703@nigelterry.net> <4945276E.1010405@ziu.info> <49456F94.8020100@nigelterry.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49456F94.8020100@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: nterry <nigel@nigelterry.net>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 14 Dec 2008, nterry wrote:

> Michal Soltys wrote:
>> nterry wrote:
>>> Hi.  I hope someone can tell me what I have done wrong.  I have a 4 disk 
>>> Raid 5 array running on Fedora9.  I've run this array for 2.5 years with 
>>> no issues.  I recently rebooted after upgrading to Kernel 2.6.27.7.  When 
>>> I did this I found that only 3 of my disks were in the array.  When I 
>>> examine the three active elements of the array (/dev/sdd1, /dev/sde1, 
>>> /dev/sdc1) they all show that the array has 3 drives and one missing. 
>>> When I examine the missing drive it shows that all members of the array 
>>> are present, which I don't understand! When I try to add the missing drive 
>>> back is says the device is busy.  Please see below and let me know what I 
>>> need to do to get this working again.  Thanks Nigel:
>>> 
>>> ==================================================================
>>> [root@homepc ~]# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid5 sdd1[0] sdc1[3] sde1[1]
>>>      735334656 blocks level 5, 128k chunk, algorithm 2 [4/3] [UU_U]
>>>     md_d0 : inactive sdb[2](S)
>>>      245117312 blocks
>>>      unused devices: <none>
>>> [root@homepc ~]#
>> 
>> For some reason, it looks like you have 2 raid arrays visible - md0 and 
>> md_d0. The latter took sdb (not sdb1) as its component.
>> 
>> sd{c,d,e}1 is in assembeld array (with appropriately updated superblocks), 
>> thus mdadm --examine calls show one device as removed, but sdb is part of 
>> another inactive array, and the superblock is untouched and shows "old" 
>> situation. Note that 0.9 superblock is stored at the end  of the device 
>> (see md(4) for details), so its position could be valid for both sdb and 
>> sdb1.
>> 
>> This might be an effect of --incremental assembly mode. Hard to tell more 
>> without seeing startup scripts, mdadm.conf, udev rules, partition layout... 
>> Did upgrade involve anything more besides kernel ?
>> 
>> Stop both arrays, check mdadm.conf, assemble md0 manually (mdadm -A 
>> /dev/md0 /dev/sd{c,d,e}1 ), verify situation with mdadm -D. If everything 
>> looks sane, add /dev/sdb1 to the array. Still, w/o checking out startup 
>> stuff, it might happen again after reboot. Adding DEVICE /dev/sd[bcde]1 to 
>> mdadm.conf might help though.
>> 
>> Wait a bit for other suggestions as well.
>> 
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> I don't think the Kernel upgrade actually caused the problem.  I tried 
> booting up on an older (2.6.27.5) kernel and that made no difference.  I 
> checked the logs for anything else that might have made a difference, but 
> couldn't see anything that made any sense to me.  I did note that on an 
> earlier update mdadm was upgraded:
> Nov 26 17:08:32 Updated: mdadm-2.6.7.1-1.fc9.x86_64
> and I did not reboot after that upgrade
>
> I included my mdadm.conf with the last email and it includes ARRAY /dev/md0 
> level=raid5 num-devices=4 devices=/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1
> My configuration is just vanilla Fedora9 with the mdadm.conf I sent
>
> I've never had a /dev/md_d0 array, so that must have been automatically 
> created.  I may have had other devices and partitions in /dev/md0 as I know I 
> had several attempts at getting it working 2.5 years ago, and I had other 
> issues when Fedora changed device naming, I think at FC7.  There is only one 
> partition on /dev/sdb, see below:
>
> (parted) select /dev/sdb 
> Using /dev/sdb
> (parted) print 
> Model: ATA Maxtor 6L250R0 (scsi)
> Disk /dev/sdb: 251GB
> Sector size (logical/physical): 512B/512B
> Partition Table: msdos
>
> Number  Start   End    Size   Type     File system  Flags    1      32.3kB 
> 251GB  251GB  primary               boot, raid
>
> So it looks like something is creating the /dev/md_d0 and adding /dev/sdb to 
> it before /dev/md0 gets started.
>
> So I tried:
> [root@homepc ~]# mdadm --stop /dev/md_d0
> mdadm: stopped /dev/md_d0
> [root@homepc ~]# mdadm --add /dev/md0 /dev/sdb1
> mdadm: re-added /dev/sdb1
> [root@homepc ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[4] sdd1[0] sdc1[3] sde1[1]
>     735334656 blocks level 5, 128k chunk, algorithm 2 [4/3] [UU_U]
>     [>....................]  recovery =  0.1% (299936/245111552) 
> finish=81.6min speed=49989K/sec
>    unused devices: <none>
> [root@homepc ~]#
>
> Great - All working.  Then I rebooted and was back to square one with only 3 
> drives in /dev/md0 and /dev/sdb in /dev/md_d0
>                                  So I am still not understanding where 
> /dev/md_d0 is coming from and although I know how to get things working after 
> a reboot, clearly this is not a long term solution...

What does:

mdadm --examine --scan

Say?

Are you using a kernel with an initrd+modules or is everything compiled 
in?

Justin.
