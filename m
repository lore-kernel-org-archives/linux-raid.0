From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
Date: Wed, 2 May 2007 11:55:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705021154410.25382@p34.internal.lan>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8DF4@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8DF4@azsmsx413.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, neilb@suse.de, akpm@linux-foundation.org, "Leech, Christopher" <christopher.leech@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 2 May 2007, Williams, Dan J wrote:

>> From: Nick Piggin [mailto:nickpiggin@yahoo.com.au]
>>> I am pleased to release this latest spin of the raid acceleration
>>> patches for merge consideration.  This release aims to address all
>>> pending review items including MD bug fixes and async_tx api changes
>>> from Neil, and concerns on channel management from Chris and others.
>>>
>>> Data integrity tests using home grown scripts and 'iozone -V' are
>>> passing.  I am open to suggestions for additional testing criteria.
>>
>> Do you have performance numbers?
>>
> Patch #4 outlines the throughput gains as reported by tiobench.  20-30%
> for sequential writes, and 40-55% for degraded reads.
>
> Here are some recent screen captures of a resync operation with and
> without offload, this is on an iop13xx platform:
>
> mdadm --create /dev/md0 /dev/sd[abc] missing -n 4 -l 5
> mdadm --add /dev/md0 /dev/sdd
>
> ---
> CONFIG_DMA_ENGINE = n
>
> top - 00:01:39 up 1 min,  1 user,  load average: 0.77, 0.20, 0.06
> Tasks:  50 total,   1 running,  49 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.3% us, 47.4% sy,  0.0% ni, 49.0% id,  0.0% wa,  0.7% hi,
> 2.6% si
> Mem:   2074836k total,    36276k used,  2038560k free,        0k buffers
> Swap:        0k total,        0k used,        0k free,    16560k cached
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 1307 root      11  -5     0    0    0 S 48.0  0.0   0:14.14 md0_raid5
> 1319 root      15   0  2260 1052  868 R  0.3  0.1   0:00.12 top
>
> iq81340mc:~# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid5 sda[0] sdd[4] sdc[2] sdb[1]
>      468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>      [>....................]  recovery =  0.7% (1104000/156290816)
> finish=108.1min speed=23919K/sec
>
> ---
> CONFIG_DMA_ENGINE = y && CONFIG_INTEL_IOP_ADMA = y
>
> top - 00:06:21 up 6 min,  1 user,  load average: 1.10, 0.68, 0.29
> Tasks:  51 total,   1 running,  50 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.5% us,  7.5% sy,  0.1% ni, 85.8% id,  1.9% wa,  0.5% hi,
> 3.5% si
> Mem:   2074776k total,    40520k used,  2034256k free,        0k buffers
> Swap:        0k total,        0k used,        0k free,    19448k cached
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 1354 root      10  -5     0    0    0 S 11.6  0.0   0:29.32 md0_raid5
> 1491 root      18   0  2256  964  780 R  1.9  0.0   0:00.03 top
>
> iq81340mc:/mnt# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid5 sdd[4] sdc[2] sdb[1] sda[0]
>      468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>      [>....................]  recovery =  3.5% (5474916/156290816)
> finish=52.2min speed=48061K/sec
>
> Some older iozone data is available here:
> https://sourceforge.net/project/showfiles.php?group_id=115074&package_id
> =203776
>
> Regards,
> Dan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I have not been following this closely, must you have an 
CONFIG_INTEL_IOP_ADMA piece of hardware and/or chipset to use this 
feature or can regular desktop users take hold of it as well?

Justin.
