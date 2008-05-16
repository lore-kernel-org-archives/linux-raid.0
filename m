From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: [OT] Re: questions about softraid limitations
Date: Fri, 16 May 2008 08:05:31 +0200
Message-ID: <482D242B.7060908@rabbit.us>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs>	<482AC2BB.5010602@dgreaves.com>	<01be01c8b61a$6e616260$9300a8c0@dcccs> <18476.58840.602946.872085@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18476.58840.602946.872085@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Janos Haar <djani22@netcenter.hu>, David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday May 15, djani22@netcenter.hu wrote:
>> I only want to help for some people to get back the data.
>> I only need to build, not to create.
> 
> And this you can do ... but not with mdadm at the moment
> unfortunately.
> 
> What carefully :-)
> --------------------------------------------------------------
> /tmp# cd /sys/block/md0/md
> /sys/block/md0/md# echo 65536 > chunk_size 
> /sys/block/md0/md# echo 2 > layout 
> /sys/block/md0/md# echo raid5  > level 
> /sys/block/md0/md# echo none > metadata_version 
> /sys/block/md0/md# echo 5 > raid_disks 
> /sys/block/md0/md# ls -l /dev/sdb
> brw-rw---- 1 root disk 8, 16 2008-05-16 11:13 /dev/sdb
> /sys/block/md0/md# ls -l /dev/sdc
> brw-rw---- 1 root disk 8, 32 2008-05-16 11:13 /dev/sdc
> /sys/block/md0/md# echo 8:16 > new_dev 
> /sys/block/md0/md# echo 8:32 > new_dev 
> /sys/block/md0/md# echo 8:48 > new_dev 
> /sys/block/md0/md# echo 8:64 > new_dev 
> /sys/block/md0/md# echo 8:80 > new_dev 
> /sys/block/md0/md# echo 0 > dev-sdb/slot 
> /sys/block/md0/md# echo 1 > dev-sdc/slot 
> /sys/block/md0/md# echo 2 > dev-sdd/slot 
> /sys/block/md0/md# echo 3 > dev-sde/slot 
> /sys/block/md0/md# echo 4 > dev-sdf/slot 
> /sys/block/md0/md# echo 156250000 > dev-sdb/size 
> /sys/block/md0/md# echo 156250000 > dev-sdc/size 
> /sys/block/md0/md# echo 156250000 > dev-sdd/size 
> /sys/block/md0/md# echo 156250000 > dev-sde/size 
> /sys/block/md0/md# echo 156250000 > dev-sdf/size 
> /sys/block/md0/md# echo readonly > array_state 
> /sys/block/md0/md# cat /proc/mdstat 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty] 
> md0 : active (read-only) raid5 sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>       624999936 blocks super non-persistent level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>       
> unused devices: <none>
> ----------------------------------------------------------

Wow, this is big :) Is it correct to state that today most of mdadm's tasks 
can be carried out by toying with sysfs? Fascinating!
