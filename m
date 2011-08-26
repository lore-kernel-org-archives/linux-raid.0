From: NeilBrown <neilb@suse.de>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Sat, 27 Aug 2011 08:45:35 +1000
Message-ID: <20110827084535.5e64bf5c@notabene.brown>
References: <4E57FE4D.5080503@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E57FE4D.5080503@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 26 Aug 2011 13:13:01 -0700 "Timothy D. Lenz" <tlenz@vorgon.com> wrote:

> I have 4 drives set up as 2 pairs.  The first part has 3 partitions on 
> it and it seems 1 of those drives is failing (going to have to figure 
> out which drive it is too so I don't pull the wrong one out of the case)
> 
> It's been awhile since I had to replace a drive in the array and my 
> notes are a bit confusing. I'm not sure which I need to use to remove 
> the drive:
> 
> 
> 	sudo mdadm --manage /dev/md0 --fail /dev/sdb
> 	sudo mdadm --manage /dev/md0 --remove /dev/sdb
> 	sudo mdadm --manage /dev/md1 --fail /dev/sdb
> 	sudo mdadm --manage /dev/md1 --remove /dev/sdb
> 	sudo mdadm --manage /dev/md2 --fail /dev/sdb
> 	sudo mdadm --manage /dev/md2 --remove /dev/sdb

sdb is not a member of any of these arrays so all of these commands will fail.

The partitions are members of the arrays.
> 
> or
> 
> sudo mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
> sudo mdadm /dev/md1 --fail /dev/sdb2 --remove /dev/sdb2

sd1 and sdb2 have already been marked as failed so there is little point in
marking them as failed again.  Removing them makes sense though.


> sudo mdadm /dev/md2 --fail /dev/sdb3 --remove /dev/sdb3

sdb3 hasn't been marked as failed yet - maybe it will soon if sdb is a bit
marginal.
So if you want to remove sdb from the machine this the correct thing to do.
Mark sdb3 as failed, then remove it from the array.

> 
> I'm not sure if I fail the drive partition or whole drive for each.

You only fail things that aren't failed already, and you fail the thing that
mdstat or mdadm -D tells you is a member of the array.

NeilBrown



> 
> -------------------------------------
> The mails I got are:
> -------------------------------------
> A Fail event had been detected on md device /dev/md0.
> 
> It could be related to component device /dev/sdb1.
> 
> Faithfully yours, etc.
> 
> P.S. The /proc/mdstat file currently contains the following:
> 
> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
> md1 : active raid1 sdb2[2](F) sda2[0]
>        4891712 blocks [2/1] [U_]
> 
> md2 : active raid1 sdb3[1] sda3[0]
>        459073344 blocks [2/2] [UU]
> 
> md3 : active raid1 sdd1[1] sdc1[0]
>        488383936 blocks [2/2] [UU]
> 
> md0 : active raid1 sdb1[2](F) sda1[0]
>        24418688 blocks [2/1] [U_]
> 
> unused devices: <none>
> -------------------------------------
> A Fail event had been detected on md device /dev/md1.
> 
> It could be related to component device /dev/sdb2.
> 
> Faithfully yours, etc.
> 
> P.S. The /proc/mdstat file currently contains the following:
> 
> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
> md1 : active raid1 sdb2[2](F) sda2[0]
>        4891712 blocks [2/1] [U_]
> 
> md2 : active raid1 sdb3[1] sda3[0]
>        459073344 blocks [2/2] [UU]
> 
> md3 : active raid1 sdd1[1] sdc1[0]
>        488383936 blocks [2/2] [UU]
> 
> md0 : active raid1 sdb1[2](F) sda1[0]
>        24418688 blocks [2/1] [U_]
> 
> unused devices: <none>
> -------------------------------------
> A Fail event had been detected on md device /dev/md2.
> 
> It could be related to component device /dev/sdb3.
> 
> Faithfully yours, etc.
> 
> P.S. The /proc/mdstat file currently contains the following:
> 
> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
> md1 : active raid1 sdb2[2](F) sda2[0]
>        4891712 blocks [2/1] [U_]
> 
> md2 : active raid1 sdb3[2](F) sda3[0]
>        459073344 blocks [2/1] [U_]
> 
> md3 : active raid1 sdd1[1] sdc1[0]
>        488383936 blocks [2/2] [UU]
> 
> md0 : active raid1 sdb1[2](F) sda1[0]
>        24418688 blocks [2/1] [U_]
> 
> unused devices: <none>
> -------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

