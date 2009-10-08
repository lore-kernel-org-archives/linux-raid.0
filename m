From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Thu, 8 Oct 2009 08:50:15 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0910080840420.22913@diagnostix.dwd.de>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
 <19141.32211.742547.19481@notabene.brown> <1254875779.16798.10.camel@dwillia2-linux.ch.intel.com>
 <Pine.LNX.4.64.0910071141010.29237@diagnostix.dwd.de> <4ACCDEF3.5000804@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACCDEF3.5000804@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 7 Oct 2009, Asdo wrote:

> Holger Kiehl wrote:
>> On Tue, 6 Oct 2009, Dan Williams wrote:
>> 
>>> ....
>>> By downleveling the parallelism to raid_run_ops the pathological
>>> stripe_head bouncing is eliminated.  This version still exhibits an
>>> average 11% throughput....
>>> 
>>> So we don't need a revert, this fixes up the unpredictability of the
>>> original implementation.  It surprised me that the overhead of passing
>>> raid_run_ops to the async thread pool amounted to an 11% performance
>>> regression.  In any event I think this is a better baseline for future
>>> multicore experimentation than the current implementation.
>>> 
>> Just to add some more information, I did try this patch with
>> 2.6.32-rc3-git1 and with the testing I am doing I get appr. 125%
>> performance regression. 
> Hi Holger
>
> From the above sentence it seems you get worse performance now than with the 
> original multicore implementation, while from the numbers below it seems you 
> get better performances now.
>
> Which is correct?
>
I only wanted to express that with my testing I get a higher performance
regression then the test Dan did. So with the patch it is much better
then without, as the numbers below show.

> (BTW a performance regression higher than 100% is impossible :-) )
>
>> The tests I am doing is have several (appr. 60
>> process) sending via FTP or SFTP about 100000 small files (average size
>> below 4096 bytes) to localhost in a loop for 30 minutes. Here the
>> real numbers:
>>
>>  with multicore support enabled (with your patch)    3276.77 files per 
>> second
>>  with multicore support enabled (without your patch) 1014.47 files per 
>> second
>>  without multicore support                           7549.24 files per 
>> second
>> 
>> Holger
>
> Also, could you tell us some details about your machine and the RAID?
> Like the model of CPU (Nehalems and AMDs have much faster memory access than 
> earlier intels) and if it's a single-cpu or a dual cpu mainboard...
> Amount of RAM
>
Its a dual cpu mainboard with two Xeon X5460 and 32 GiB Ram.

> also: stripe_cache_size current setting for your RAID
> Raid level, number of disks, chunk size, filesystem...
>
Raid level is Raid6 over 8 disks (actually 16, which are made up of 8
HW Raid1 disks) and chunksize is 2048k. Here the output from /proc/mdstat

    md4 : active raid6 sdi1[2] sdl1[5] sdj1[3] sdn1[7] sdk1[4] sdm1[6] sdh1[1] sdg1[0]
          1754480640 blocks level 6, 2048k chunk, algorithm 2 [8/8] [UUUUUUUU]

Filesystem is ext4, here the details:

    dumpe2fs 1.41.4 (27-Jan-2009)
    Filesystem volume name:   <none>
    Last mounted on:          /home
    Filesystem UUID:          1e3ff0c9-07a0-412e-938c-b9a242ae7d42
    Filesystem magic number:  0xEF53
    Filesystem revision #:    1 (dynamic)
    Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
    Filesystem flags:         signed_directory_hash
    Default mount options:    (none)
    Filesystem state:         clean
    Errors behavior:          Continue
    Filesystem OS type:       Linux
    Inode count:              109658112
    Block count:              438620160
    Reserved block count:     0
    Free blocks:              429498966
    Free inodes:              109493636
    First block:              0
    Block size:               4096
    Fragment size:            4096
    Reserved GDT blocks:      919
    Blocks per group:         32768
    Fragments per group:      32768
    Inodes per group:         8192
    Inode blocks per group:   512
    RAID stride:              512
    RAID stripe width:        3072
    Flex block group size:    16
    Filesystem created:       Thu Sep 17 14:37:08 2009
    Last mount time:          Wed Oct  7 09:04:00 2009
    Last write time:          Wed Oct  7 09:04:00 2009
    Mount count:              12
    Maximum mount count:      -1
    Last checked:             Thu Sep 17 14:37:08 2009
    Check interval:           0 (<none>)
    Reserved blocks uid:      0 (user root)
    Reserved blocks gid:      0 (group root)
    First inode:              11
    Inode size:               256
    Required extra isize:     28
    Desired extra isize:      28
    Journal inode:            8
    Default directory hash:   half_md4
    Directory Hash Seed:      149fb3b1-2e99-46de-bd31-7031f677deb6
    Journal backup:           inode blocks
    Journal size:             768M

Thanks,
Holger
