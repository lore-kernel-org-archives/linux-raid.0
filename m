From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed ??Mb/s) - new raid5 array
Date: Thu, 21 Jul 2011 19:05:23 -0500
Message-ID: <4E28BEC3.4000301@hardwarefreak.com>
References: <201107162140.58883.raid1@fuckaround.org> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org> <4E236A2D.3070307@hardwarefreak.com> <201107211907.36864.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107211907.36864.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/21/2011 12:07 PM, Pol Hallen wrote:
> Hello again :-)
> 
> I removed all partitions of my disks and do:
> 
> dd if=/dev/zero of=/dev/sdb bs=512 count=1 for all disks..
> 
> next, I created a new partition (non-fs data) starting of 64 like below (for 
> every devices)

Why did you create partitions?  The whole point of zeroing the first 512
bytes was to *eliminate* all the partitions...

>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              64  3907029167  1953514552   da  Non-FS data
> 
> created a new raid5 array:
> 
> mdadm --create --verbose /dev/md0 --level=raid5 --raid-devices=5 /dev/sdb 
> /dev/sdc /dev/sdd /dev/sde /dev/sdf

And now you create your array without using partitions...

> cat /proc/mdstat
> 
> md0 : active raid5 sdf[5] sde[3] sdd[2] sdc[1] sdb[0]
>       7814051840 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] 
> [UUUU_]
>       [>....................]  recovery =  0.3% (6625324/1953512960) 
> finish=971.1min speed=33411K/sec

You created aligned partitions on all disks, and then did not use those
partitions...

> Now, I've 5 identical disks (2Tb WD)
> 
> I've to wait rebuilding time after do new tests performance.
> 
> The procedure that I've done is correct?

No, you did not.  It seems you merged bits and pieces from each array
creation method.  The array may still function properly.  I've never
tried what you've done here.  Maybe others have the correct answer.

-- 
Stan
