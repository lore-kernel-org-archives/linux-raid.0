From: Tim Nufire <linux-raid_tim@ibink.com>
Subject: Re: Recalculating the --size parameter when recovering a failed array
Date: Tue, 19 Jun 2012 13:33:37 -0700
Message-ID: <D7A190C6-B05F-4423-B569-D88D34FD076A@ibink.com>
References: <F4D18266-EDAB-4D31-B3F1-A91894C7E455@ibink.com> <20120617180341.39e2d384@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120617180341.39e2d384@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Thanks for your prompt response. I used the information below and was able to recover the array easily :-)

Has anyone written a tool/script to crunch all the metadata info and recommend the right mdadm --create parameters and drive order? I understand that figuring out which drives to mark as missing requires an understanding of the history of the array but it seems  the basic command would be easy to generate.

Cheers,
Tim

On Jun 17, 2012, at 1:03 AM, NeilBrown wrote:

> On Sat, 16 Jun 2012 06:09:47 -0700 Tim Nufire <linux-raid_tim@ibink.com>
> wrote:
> 
>> Hello,
>> 
>> An array that I created using a custom --size parameter has failed and needs to be recovered. I am very comfortable recovering arrays using --assume-clean but due to a typo at creation time I don't know the device size that was originally used. I am hoping this value can be recalculate from data in the superblocks but this calculation is not obvious to me. 
>> 
>> Here's what I know... I'm using metadata version 1.0 with an internal bitmap on all my arrays. I ran some experiments in the lab with 3TB drives and found that when I specified a device size of 2929687500 when creating an array, 'mdadm -D' reported a 'Used Dev Size' of 5859374976. The value specified on the command line is in kilobytes so I was expecting 3,000,000,000,000 bytes to be used on each device. The value reported by mdadm is in sectors (512 bytes) so turning this into bytes I get 2,999,999,987,712 bytes. This is off by 12,288 bytes (12kb) which I assume is used by the v1.0 superblock and/or the internal bitmap. I also tried creating an array with 2TB drives (Requested Size: 1953125000, Used Dev Size: 3906249984) and got a difference of 8kb (2,000,000,000,000 vs 1,999,999,991,8
 08 bytes) so clearly the amount of extra space used depends on the size of the device in some way.
>> 
>> The array that I'm trying to recover reports a 'Used Dev Size' of 5858574976. This is just 800,000 sectors less than I got when requesting an even 3 trillion bytes so I know the size to use on the command line is close to 2929687500. But I don't know how to calculate the exact size... Can someone help me? 
> 
> The "Used Dev Size" of the array should be exactly the same as the value you
> give to create with --size (metadata and bitmap are extra and not included in
> these counts) *provided* that the number you give is a multiple of the chunk
> size.  If it isn't the number is rounded down to a multiple of the chunk size.
> 
> So if you specify "-c 64 -z 2929287488", you should get the correct sized
> array.
> 
> NeilBrown
> 
> 
>> 
>> Once I know the size I will recreate the array using the following:
>> 
>> size=???
>> md11='/dev/sdc /dev/sdf /dev/sdi /dev/sdl /dev/sdo /dev/sdr /dev/sdu /dev/sdx missing missing /dev/sdag /dev/sdaj /dev/sdam /dev/sdap /dev/sdas'
>> mdadm --create /dev/md11 --metadata=1.0 --size=$size --bitmap=internal --auto=yes -l 6 -n 15 --assume-clean $md11
>> 
>> Just incase it helps, here's the full output from mdadm -D for the array I'm trying to recover and mdadm -E for the first device in that array:
>> 
>> mdadm -E /dev/sdc
>> /dev/sdc:
>>          Magic : a92b4efc
>>        Version : 1.0
>>    Feature Map : 0x1
>>     Array UUID : 560bd0d9:a8d4758c:9849143c:a2ef5b8e
>>           Name : sm345:11  (local to host sm345)
>>  Creation Time : Sat Dec 17 07:22:56 2011
>>     Raid Level : raid6
>>   Raid Devices : 15
>> 
>> Avail Dev Size : 5860532896 (2794.52 GiB 3000.59 GB)
>>     Array Size : 76161474688 (36316.62 GiB 38994.68 GB)
>>  Used Dev Size : 5858574976 (2793.59 GiB 2999.59 GB)
>>   Super Offset : 5860533152 sectors
>>          State : clean
>>    Device UUID : f3ad57be:c0835578:4f242111:fb465c0a
>> 
>> Internal Bitmap : -176 sectors from superblock
>>    Update Time : Sat Jun 16 05:45:17 2012
>>       Checksum : 4936d9a7 - correct
>>         Events : 187674
>> 
>>     Chunk Size : 64K
>> 
>>    Array Slot : 0 (empty, 1, 2, 3, 4, 5, 6, 7, failed, failed, 10, 11, 12, 13, 14)
>>   Array State : _uuuuuuu__uuuuu 2 failed
>> 
>> mdadm -D /dev/md11
>> /dev/md11:
>>        Version : 01.00
>>  Creation Time : Sat Dec 17 07:22:56 2011
>>     Raid Level : raid6
>>     Array Size : 38080737344 (36316.62 GiB 38994.68 GB)
>>  Used Dev Size : 5858574976 (5587.17 GiB 5999.18 GB)
>>   Raid Devices : 15
>>  Total Devices : 15
>> Preferred Minor : 11
>>    Persistence : Superblock is persistent
>> 
>>  Intent Bitmap : Internal
>> 
>>    Update Time : Sat Jun 16 05:45:17 2012
>>          State : active, degraded
>> Active Devices : 12
>> Working Devices : 15
>> Failed Devices : 0
>>  Spare Devices : 3
>> 
>>     Chunk Size : 64K
>> 
>>           Name : sm345:11  (local to host sm345)
>>           UUID : 560bd0d9:a8d4758c:9849143c:a2ef5b8e
>>         Events : 187674
>> 
>>    Number   Major   Minor   RaidDevice State
>>       0       0        0        0      removed
>>       1       8       80        1      active sync   /dev/sdf
>>       2       8      128        2      active sync   /dev/sdi
>>       3       8      176        3      active sync   /dev/sdl
>>       4       8      224        4      active sync   /dev/sdo
>>       5      65       16        5      active sync   /dev/sdr
>>       6      65       64        6      active sync   /dev/sdu
>>       7      65      112        7      active sync   /dev/sdx
>>       8       0        0        8      removed
>>       9       0        0        9      removed
>>      10      66        0       10      active sync   /dev/sdag
>>      11      66       48       11      active sync   /dev/sdaj
>>      12      66       96       12      active sync   /dev/sdam
>>      13      66      144       13      active sync   /dev/sdap
>>      14      66      192       14      active sync   /dev/sdas
>> 
>>       0       8       32        -      spare   /dev/sdc
>>      15      65      160        -      spare   /dev/sdaa
>>      16      65      208        -      spare   /dev/sdad
>> 
>> 
>> Thanks,
>> Tim
>> 
>> 
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

