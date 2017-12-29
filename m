From: Guoqing Jiang <gqjiang@suse.de>
Subject: Re: [PATCH] md/raid5: fix a potential deadlock of raid5 reshape
Date: Fri, 29 Dec 2017 14:42:42 +0800
Message-ID: <ac91af2e-57d6-7d25-a639-25882d607a3b@suse.de>
References: <612ff962d2c31459a88fedad314f19da@synology.com>
 <3321c473-5d17-3065-08bc-b5e51f906383@suse.com>
 <4f1dbb814cafc8dc21cc7c2d7f0af30c@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4f1dbb814cafc8dc21cc7c2d7f0af30c@synology.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: bingjingc <bingjingc@synology.com>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids



On 12/29/2017 02:02 PM, bingjingc wrote:
>
> Guoqing Jiang 於 2017-12-28 15:59 寫到:
>> On 12/27/2017 01:47 PM, bingjingc wrote:
>>>
>>> There is a potential deadlock if mount/umount happens when
>>> raid5_finish_reshape() tries to grow the size of emulated disk.
>>>
>>> How the deadlock happens?
>>> 1) The raid5 resync thread finished reshape (expanding array).
>>> 2) The mount or umount thread holds VFS sb->s_umount lock and tries to
>>>    write through critical data into raid5 emulated block device. So it
>>>    waits for raid5 kernel thread handling stripes in order to finish it
>>>    I/Os.
>>> 3) In the routine of raid5 kernel thread, md_check_recovery() will be
>>>    called first in order to reap the raid5 resync thread. That is,
>>>    raid5_finish_reshape() will be called. In this function, it will try
>>>    to update conf and call VFS revalidate_disk() to grow the raid5
>>>    emulated block device. It will try to acquire VFS sb->s_umount lock.
>>> The raid5 kernel thread cannot continue, so no one can handle mount/
>>> umount I/Os (stripes). Once the write-through I/Os cannot be finished,
>>> mount/umount will not release sb->s_umount lock. The deadlock happens.
>>>
>>> The raid5 kernel thread is an emulated block device. It is 
>>> responible to
>>> handle I/Os (stripes) from upper layers. The emulated block device
>>> should not request any I/Os on itself. That is, it should not call VFS
>>> layer functions. (If it did, it will try to acquire VFS locks to
>>> guarantee the I/Os sequence.) So we have the resync thread to send
>>> resync I/O requests and to wait for the results.
>>>
>>> For solving this potential deadlock, we can put the size growth of the
>>> emulated block device as the final step of reshape thread.
>>
>> Maybe another way to avoid the deadlock is to ensure the reshaping array
>> can't be mount at all. One reason is, if the reshaping is finished, 
>> but fs still
>> don't know about  the new array size since metadata is not refreshed. 
>> Just
>> my $0.02.
>>
>
> It may take hours or couples of days to expand an array. So I bet that 
> it's a
> feature that an expanding array can still serve fs requests. Once it 
> finished,
> the new array size for metadata can be passed to fs layer via 
> revalidate_disk().
> From then, fs is able to be expanded, too. There are no needs to 
> restart that
> array. Based on this point, I don't want to break this feature.

Sorry, the metadata which I mentioned before is the metadata for file 
system.
How fs know about the new size without update fs's metadata? Pls see the 
wiki:
https://raid.wiki.kernel.org/index.php/Growing#Extending_the_filesystem

Thanks,
Guoqing
