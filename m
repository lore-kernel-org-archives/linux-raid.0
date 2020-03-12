From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: keep bdi->io_pages in sync with max_sectors_kb for
 stacked devices
Date: Thu, 12 Mar 2020 07:40:39 -0600
Message-ID: <ecc07195-872b-1c49-d423-873cfd7243fe@kernel.dk>
References: <158290150891.4423.13566449569964563258.stgit@buzz>
 <7133c4fb-38d5-cf1f-e259-e12b50efcb32@oracle.com>
 <CAPhsuW6xJeX3=0j69_hdaUnYXPm7VeaXHB06JM=fRZsxPweQng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6xJeX3=0j69_hdaUnYXPm7VeaXHB06JM=fRZsxPweQng@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Bob Liu <bob.liu@oracle.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-block@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
List-Id: linux-raid.ids

On 3/10/20 3:40 PM, Song Liu wrote:
> On Mon, Mar 2, 2020 at 4:16 AM Bob Liu <bob.liu@oracle.com> wrote:
>>
>> On 2/28/20 10:51 PM, Konstantin Khlebnikov wrote:
>>> Field bdi->io_pages added in commit 9491ae4aade6 ("mm: don't cap request
>>> size based on read-ahead setting") removes unneeded split of read requests.
>>>
>>> Stacked drivers do not call blk_queue_max_hw_sectors(). Instead they setup
>>> limits of their devices by blk_set_stacking_limits() + disk_stack_limits().
>>> Field bio->io_pages stays zero until user set max_sectors_kb via sysfs.
>>>
>>> This patch updates io_pages after merging limits in disk_stack_limits().
>>>
>>> Commit c6d6e9b0f6b4 ("dm: do not allow readahead to limit IO size") fixed
>>> the same problem for device-mapper devices, this one fixes MD RAIDs.
>>>
>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>> ---
>>>  block/blk-settings.c |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>>> index c8eda2e7b91e..66c45fd79545 100644
>>> --- a/block/blk-settings.c
>>> +++ b/block/blk-settings.c
>>> @@ -664,6 +664,8 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
>>>               printk(KERN_NOTICE "%s: Warning: Device %s is misaligned\n",
>>>                      top, bottom);
>>>       }
>>> +
>>> +     t->backing_dev_info->io_pages = t->limits.max_sectors >> (PAGE_SHIFT-9);
>>>  }
>>>  EXPORT_SYMBOL(disk_stack_limits);
>>>
>>>
>>
>> Nitpick.. (PAGE_SHIFT - 9)
>> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> 
> Thanks for the fix. I fixed it based on the comments and applied it to md-next.
> 
> Jens, I picked the patch to md-next because md is the only user of
> disk_stack_limits().
> 
> Please let me know if you prefer routing it via the block tree.

That's fine, thanks.

-- 
Jens Axboe
