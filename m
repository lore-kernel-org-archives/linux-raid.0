From: Shaohua Li <shli@kernel.org>
Subject: Re: Resync of the degraded RAID10 array
Date: Wed, 10 May 2017 15:27:07 -0700
Message-ID: <20170510222325.e2yjzfm5rwbmxzvi@kernel.org>
References: <20170510140044.GA23565@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510140044.GA23565@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 04:00:44PM +0200, Tomasz Majchrzak wrote:
> Hi all,
> 
> I wonder what should be the resync behaviour for the degraded RAID10 array.
> 
> cat /proc/mdstat
> Personalities : [raid10] 
> md127 : active raid10 nvme3n1[3] nvme2n1[2] nvme1n1[1] nvme0n1[0]
>       2097152 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
> 	  [==>..................]  resync = 11.0% (232704/2097152) finish=0.1min speed=232704K/sec
> 
> mdadm -If nvme3n1
> mdadm: set nvme3n1 faulty in md127
> mdadm: hot removed nvme3n1 from md127
> 
> cat /proc/mdstat
> Personalities : [raid10] 
> md127 : active (auto-read-only) raid10 nvme2n1[2] nvme1n1[1] nvme0n1[0]
>       2097152 blocks super 1.2 512K chunks 2 near-copies [4/3] [UUU_]
> 	  resync=PENDING
> 
> cat /sys/block/md127/md/resync_start
> 465408
> 
> At the moment it stops the resync. When new disk is added to the array, the

Probably check why the resync is stopped. The resync can still continue in
degraded mode. After resync completes, the recovery will start.

Thanks,
Shaohua

> recovery starts and completes, however no resync for the first 2 disks takes
> place and array is reported as clean when it's really out-of-sync.
> 
> My kernel version is 4.11.
> 
> What is the expected behaviour? Shall resync continue on 3-disk RAID10 or
> shall it be restarted when recovery completes?
> 
> Regards,
> 
> Tomek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
