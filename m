Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CD7125DF;
	Fri,  6 Jun 2025 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749182778; cv=none; b=EwYEUGbCbPj6zS1sTLca4EwTZRsKHDSCYgqESehGo/RyOk9imlHryjuIX5+zj1kXqTYuyo6BbBVEGKO89+4boT1ebcJc3/5qTdWEKiFNqHlX5Dv2dIi7Vteq2RoiwpGMnE/Tc4Wg9/liRgBkKioaH+48kpYX1hiOqPup7gO90Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749182778; c=relaxed/simple;
	bh=PL9xF9ZvJ9u2fFOM+3gexCZlIb7kq7QvyOxiqDJJFmQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dowtxvPTbBZeLqhZHQNkV/sp70u4EYn/6qg3f0mCwUON4JbZImojKlCRnlO8HUSoMnDC4ARbiK8wo38HJWF5ga91TTDV9i9ixATag9oZVo9Mr/N0Q68p6/sJIvLtv73mznxqUMr9r8v8kkjkp7vU81vE61AaKigSjzPiWBGP6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bD6kV1tZ9zYQvKb;
	Fri,  6 Jun 2025 11:49:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4B1AE1A155C;
	Fri,  6 Jun 2025 11:49:05 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l4SZUJoy12ZOg--.51148S3;
	Fri, 06 Jun 2025 11:49:05 +0800 (CST)
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-16-yukuai1@huaweicloud.com>
 <4b1e7a50-f448-4e0f-a498-a8c6b0c7f97d@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7ef969ed-8468-5d63-a08d-886ca853f772@huaweicloud.com>
Date: Fri, 6 Jun 2025 11:48:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4b1e7a50-f448-4e0f-a498-a8c6b0c7f97d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l4SZUJoy12ZOg--.51148S3
X-Coremail-Antispam: 1UD129KBjvAXoWfCr48ur18Xr48XF1rtFyxZrb_yoW5GF48Go
	Wjkr18Jr1rJr1jgr1UJr15JF13u3WUKrnFyr1UGry7Jr1UZ3Wjg3yUGrW3K3yDJr18Gr17
	JF18JryYvFyUAr1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYX7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/06 11:21, Xiao Ni 写道:
> Hi Kuai
> 
> I've read some codes of llbitmap, but I don't figure out the 
> relationship of in memory bits and in storage bits. Does llbitmap have 
> the two types as old bitmap? For example, in llbitmap_create, there is a 
> argument ->bits_per_page which is calculated by 
> PAGE_SIZE/logical_block_size. As the graph bellow, bits_per_page is 8 
> (4K/512byte). What does the bit mean? And in the graph below, it talks 
> 512 bits in one block, what does this bit mean?  I haven't walked 
> through all codes, maybe I can get the answer myself. If you can give a 
> summary of how many types of bit and what's the usage of the bit, it can 
> help to understand it easier.

llbitmap bit is always 1 byte, it's the same in memory and on disk.

bits_per_page bit is used to track dirty sectors in the memory page.

For example, usually 4k page will contain 8 sectors, each sector is 512
bytes, if one llbitmap bit is dirty, then the related bits_per_page bit
will be set as well, and later will write the sector to disk.

Thanks,
kuai

> 
> Best Regards
> 
> Xiao
> 
> 在 2025/5/24 下午2:13, Yu Kuai 写道:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> READ
>>
>> While creating bitmap, all pages will be allocated and read for llbitmap,
>> there won't be read afterwards
>>
>> WRITE
>>
>> WRITE IO is divided into logical_block_size of the page, the dirty state
>> of each block is tracked independently, for example:
>>
>> each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 
>> bit;
>>
>> | page0 | page1 | ... | page 31 |
>> |       |
>> |        \-----------------------\
>> |                                |
>> | block0 | block1 | ... | block 8|
>> |        |
>> |         \-----------------\
>> |                            |
>> | bit0 | bit1 | ... | bit511 |
>>
>>  From IO path, if one bit is changed to Dirty or NeedSync, the 
>> corresponding
>> subpage will be marked dirty, such block must write first before the 
>> IO is
>> issued. This behaviour will affect IO performance, to reduce the 
>> impact, if
>> multiple bits are changed in the same block in a short time, all bits in
>> this block will be changed to Dirty/NeedSync, so that there won't be any
>> overhead until daemon clears dirty bits.
>>
>> Also add data structure definition and comments.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md-llbitmap.c | 571 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 571 insertions(+)
>>   create mode 100644 drivers/md/md-llbitmap.c
>>
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> new file mode 100644
>> index 000000000000..1a01b6777527
>> --- /dev/null
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -0,0 +1,571 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#ifdef CONFIG_MD_LLBITMAP
>> +
>> +#include <linux/blkdev.h>
>> +#include <linux/module.h>
>> +#include <linux/errno.h>
>> +#include <linux/slab.h>
>> +#include <linux/init.h>
>> +#include <linux/timer.h>
>> +#include <linux/sched.h>
>> +#include <linux/list.h>
>> +#include <linux/file.h>
>> +#include <linux/seq_file.h>
>> +#include <trace/events/block.h>
>> +
>> +#include "md.h"
>> +#include "md-bitmap.h"
>> +
>> +/*
>> + * #### Background
>> + *
>> + * Redundant data is used to enhance data fault tolerance, and the 
>> storage
>> + * method for redundant data vary depending on the RAID levels. And it's
>> + * important to maintain the consistency of redundant data.
>> + *
>> + * Bitmap is used to record which data blocks have been synchronized 
>> and which
>> + * ones need to be resynchronized or recovered. Each bit in the bitmap
>> + * represents a segment of data in the array. When a bit is set, it 
>> indicates
>> + * that the multiple redundant copies of that data segment may not be
>> + * consistent. Data synchronization can be performed based on the 
>> bitmap after
>> + * power failure or readding a disk. If there is no bitmap, a full disk
>> + * synchronization is required.
>> + *
>> + * #### Key Features
>> + *
>> + *  - IO fastpath is lockless, if user issues lots of write IO to the 
>> same
>> + *  bitmap bit in a short time, only the first write have additional 
>> overhead
>> + *  to update bitmap bit, no additional overhead for the following 
>> writes;
>> + *  - support only resync or recover written data, means in the case 
>> creating
>> + *  new array or replacing with a new disk, there is no need to do a 
>> full disk
>> + *  resync/recovery;
>> + *
>> + * #### Key Concept
>> + *
>> + * ##### State Machine
>> + *
>> + * Each bit is one byte, contain 6 difference state, see 
>> llbitmap_state. And
>> + * there are total 8 differenct actions, see llbitmap_action, can 
>> change state:
>> + *
>> + * llbitmap state machine: transitions between states
>> + *
>> + * |           | Startwrite | Startsync | Endsync | Abortsync|
>> + * | --------- | ---------- | --------- | ------- | -------  |
>> + * | Unwritten | Dirty      | x         | x       | x        |
>> + * | Clean     | Dirty      | x         | x       | x        |
>> + * | Dirty     | x          | x         | x       | x        |
>> + * | NeedSync  | x          | Syncing   | x       | x        |
>> + * | Syncing   | x          | Syncing   | Dirty   | NeedSync |
>> + *
>> + * |           | Reload   | Daemon | Discard   | Stale     |
>> + * | --------- | -------- | ------ | --------- | --------- |
>> + * | Unwritten | x        | x      | x         | x         |
>> + * | Clean     | x        | x      | Unwritten | NeedSync  |
>> + * | Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
>> + * | NeedSync  | x        | x      | Unwritten | x         |
>> + * | Syncing   | NeedSync | x      | Unwritten | NeedSync  |
>> + *
>> + * Typical scenarios:
>> + *
>> + * 1) Create new array
>> + * All bits will be set to Unwritten by default, if --assume-clean is 
>> set,
>> + * all bits will be set to Clean instead.
>> + *
>> + * 2) write data, raid1/raid10 have full copy of data, while raid456 
>> doesn't and
>> + * rely on xor data
>> + *
>> + * 2.1) write new data to raid1/raid10:
>> + * Unwritten --StartWrite--> Dirty
>> + *
>> + * 2.2) write new data to raid456:
>> + * Unwritten --StartWrite--> NeedSync
>> + *
>> + * Because the initial recover for raid456 is skipped, the xor data 
>> is not build
>> + * yet, the bit must set to NeedSync first and after lazy initial 
>> recover is
>> + * finished, the bit will finially set to Dirty(see 5.1 and 5.4);
>> + *
>> + * 2.3) cover write
>> + * Clean --StartWrite--> Dirty
>> + *
>> + * 3) daemon, if the array is not degraded:
>> + * Dirty --Daemon--> Clean
>> + *
>> + * For degraded array, the Dirty bit will never be cleared, prevent 
>> full disk
>> + * recovery while readding a removed disk.
>> + *
>> + * 4) discard
>> + * {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
>> + *
>> + * 5) resync and recover
>> + *
>> + * 5.1) common process
>> + * NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean
>> + *
>> + * 5.2) resync after power failure
>> + * Dirty --Reload--> NeedSync
>> + *
>> + * 5.3) recover while replacing with a new disk
>> + * By default, the old bitmap framework will recover all data, and 
>> llbitmap
>> + * implement this by a new helper, see llbitmap_skip_sync_blocks:
>> + *
>> + * skip recover for bits other than dirty or clean;
>> + *
>> + * 5.4) lazy initial recover for raid5:
>> + * By default, the old bitmap framework will only allow new recover 
>> when there
>> + * are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER 
>> is add
>> + * to perform raid456 lazy recover for set bits(from 2.2).
>> + *
>> + * ##### Bitmap IO
>> + *
>> + * ##### Chunksize
>> + *
>> + * The default bitmap size is 128k, incluing 1k bitmap super block, and
>> + * the default size of segment of data in the array each 
>> bit(chunksize) is 64k,
>> + * and chunksize will adjust to twice the old size each time if the 
>> total number
>> + * bits is not less than 127k.(see llbitmap_init)
>> + *
>> + * ##### READ
>> + *
>> + * While creating bitmap, all pages will be allocated and read for 
>> llbitmap,
>> + * there won't be read afterwards
>> + *
>> + * ##### WRITE
>> + *
>> + * WRITE IO is divided into logical_block_size of the array, the 
>> dirty state
>> + * of each block is tracked independently, for example:
>> + *
>> + * each page is 4k, contain 8 blocks; each block is 512 bytes contain 
>> 512 bit;
>> + *
>> + * | page0 | page1 | ... | page 31 |
>> + * |       |
>> + * |        \-----------------------\
>> + * |                                |
>> + * | block0 | block1 | ... | block 8|
>> + * |        |
>> + * |         \-----------------\
>> + * |                            |
>> + * | bit0 | bit1 | ... | bit511 |
>> + *
>> + * From IO path, if one bit is changed to Dirty or NeedSync, the 
>> corresponding
>> + * subpage will be marked dirty, such block must write first before 
>> the IO is
>> + * issued. This behaviour will affect IO performance, to reduce the 
>> impact, if
>> + * multiple bits are changed in the same block in a short time, all 
>> bits in this
>> + * block will be changed to Dirty/NeedSync, so that there won't be 
>> any overhead
>> + * until daemon clears dirty bits.
>> + *
>> + * ##### Dirty Bits syncronization
>> + *
>> + * IO fast path will set bits to dirty, and those dirty bits will be 
>> cleared
>> + * by daemon after IO is done. llbitmap_page_ctl is used to 
>> synchronize between
>> + * IO path and daemon;
>> + *
>> + * IO path:
>> + *  1) try to grab a reference, if succeed, set expire time after 5s 
>> and return;
>> + *  2) if failed to grab a reference, wait for daemon to finish 
>> clearing dirty
>> + *  bits;
>> + *
>> + * Daemon(Daemon will be waken up every daemon_sleep seconds):
>> + * For each page:
>> + *  1) check if page expired, if not skip this page; for expired page:
>> + *  2) suspend the page and wait for inflight write IO to be done;
>> + *  3) change dirty page to clean;
>> + *  4) resume the page;
>> + */
>> +
>> +#define BITMAP_SB_SIZE 1024
>> +
>> +/* 64k is the max IO size of sync IO for raid1/raid10 */
>> +#define MIN_CHUNK_SIZE (64 * 2)
>> +
>> +/* By default, daemon will be waken up every 30s */
>> +#define DEFAULT_DAEMON_SLEEP 30
>> +
>> +/*
>> + * Dirtied bits that have not been accessed for more than 5s will be 
>> cleared
>> + * by daemon.
>> + */
>> +#define BARRIER_IDLE 5
>> +
>> +enum llbitmap_state {
>> +    /* No valid data, init state after assemble the array */
>> +    BitUnwritten = 0,
>> +    /* data is consistent */
>> +    BitClean,
>> +    /* data will be consistent after IO is done, set directly for 
>> writes */
>> +    BitDirty,
>> +    /*
>> +     * data need to be resynchronized:
>> +     * 1) set directly for writes if array is degraded, prevent full 
>> disk
>> +     * synchronization after readding a disk;
>> +     * 2) reassemble the array after power failure, and dirty bits are
>> +     * found after reloading the bitmap;
>> +     * 3) set for first write for raid5, to build initial xor data 
>> lazily
>> +     */
>> +    BitNeedSync,
>> +    /* data is synchronizing */
>> +    BitSyncing,
>> +    nr_llbitmap_state,
>> +    BitNone = 0xff,
>> +};
>> +
>> +enum llbitmap_action {
>> +    /* User write new data, this is the only action from IO fast path */
>> +    BitmapActionStartwrite = 0,
>> +    /* Start recovery */
>> +    BitmapActionStartsync,
>> +    /* Finish recovery */
>> +    BitmapActionEndsync,
>> +    /* Failed recovery */
>> +    BitmapActionAbortsync,
>> +    /* Reassemble the array */
>> +    BitmapActionReload,
>> +    /* Daemon thread is trying to clear dirty bits */
>> +    BitmapActionDaemon,
>> +    /* Data is deleted */
>> +    BitmapActionDiscard,
>> +    /*
>> +     * Bitmap is stale, mark all bits in addition to BitUnwritten to
>> +     * BitNeedSync.
>> +     */
>> +    BitmapActionStale,
>> +    nr_llbitmap_action,
>> +    /* Init state is BitUnwritten */
>> +    BitmapActionInit,
>> +};
>> +
>> +enum llbitmap_page_state {
>> +    LLPageFlush = 0,
>> +    LLPageDirty,
>> +};
>> +
>> +struct llbitmap_page_ctl {
>> +    char *state;
>> +    struct page *page;
>> +    unsigned long expire;
>> +    unsigned long flags;
>> +    wait_queue_head_t wait;
>> +    struct percpu_ref active;
>> +    /* Per block size dirty state, maximum 64k page / 1 sector = 128 */
>> +    unsigned long dirty[];
>> +};
>> +
>> +struct llbitmap {
>> +    struct mddev *mddev;
>> +    struct llbitmap_page_ctl **pctl;
>> +
>> +    unsigned int nr_pages;
>> +    unsigned int io_size;
>> +    unsigned int bits_per_page;
>> +
>> +    /* shift of one chunk */
>> +    unsigned long chunkshift;
>> +    /* size of one chunk in sector */
>> +    unsigned long chunksize;
>> +    /* total number of chunks */
>> +    unsigned long chunks;
>> +    unsigned long last_end_sync;
>> +    /* fires on first BitDirty state */
>> +    struct timer_list pending_timer;
>> +    struct work_struct daemon_work;
>> +
>> +    unsigned long flags;
>> +    __u64    events_cleared;
>> +
>> +    /* for slow disks */
>> +    atomic_t behind_writes;
>> +    wait_queue_head_t behind_wait;
>> +};
>> +
>> +struct llbitmap_unplug_work {
>> +    struct work_struct work;
>> +    struct llbitmap *llbitmap;
>> +    struct completion *done;
>> +};
>> +
>> +static struct workqueue_struct *md_llbitmap_io_wq;
>> +static struct workqueue_struct *md_llbitmap_unplug_wq;
>> +
>> +static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
>> +    [BitUnwritten] = {
>> +        [BitmapActionStartwrite]    = BitDirty,
>> +        [BitmapActionStartsync]        = BitNone,
>> +        [BitmapActionEndsync]        = BitNone,
>> +        [BitmapActionAbortsync]        = BitNone,
>> +        [BitmapActionReload]        = BitNone,
>> +        [BitmapActionDaemon]        = BitNone,
>> +        [BitmapActionDiscard]        = BitNone,
>> +        [BitmapActionStale]        = BitNone,
>> +    },
>> +    [BitClean] = {
>> +        [BitmapActionStartwrite]    = BitDirty,
>> +        [BitmapActionStartsync]        = BitNone,
>> +        [BitmapActionEndsync]        = BitNone,
>> +        [BitmapActionAbortsync]        = BitNone,
>> +        [BitmapActionReload]        = BitNone,
>> +        [BitmapActionDaemon]        = BitNone,
>> +        [BitmapActionDiscard]        = BitUnwritten,
>> +        [BitmapActionStale]        = BitNeedSync,
>> +    },
>> +    [BitDirty] = {
>> +        [BitmapActionStartwrite]    = BitNone,
>> +        [BitmapActionStartsync]        = BitNone,
>> +        [BitmapActionEndsync]        = BitNone,
>> +        [BitmapActionAbortsync]        = BitNone,
>> +        [BitmapActionReload]        = BitNeedSync,
>> +        [BitmapActionDaemon]        = BitClean,
>> +        [BitmapActionDiscard]        = BitUnwritten,
>> +        [BitmapActionStale]        = BitNeedSync,
>> +    },
>> +    [BitNeedSync] = {
>> +        [BitmapActionStartwrite]    = BitNone,
>> +        [BitmapActionStartsync]        = BitSyncing,
>> +        [BitmapActionEndsync]        = BitNone,
>> +        [BitmapActionAbortsync]        = BitNone,
>> +        [BitmapActionReload]        = BitNone,
>> +        [BitmapActionDaemon]        = BitNone,
>> +        [BitmapActionDiscard]        = BitUnwritten,
>> +        [BitmapActionStale]        = BitNone,
>> +    },
>> +    [BitSyncing] = {
>> +        [BitmapActionStartwrite]    = BitNone,
>> +        [BitmapActionStartsync]        = BitSyncing,
>> +        [BitmapActionEndsync]        = BitDirty,
>> +        [BitmapActionAbortsync]        = BitNeedSync,
>> +        [BitmapActionReload]        = BitNeedSync,
>> +        [BitmapActionDaemon]        = BitNone,
>> +        [BitmapActionDiscard]        = BitUnwritten,
>> +        [BitmapActionStale]        = BitNeedSync,
>> +    },
>> +};
>> +
>> +static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, 
>> loff_t pos)
>> +{
>> +    unsigned int idx;
>> +    unsigned int offset;
>> +
>> +    pos += BITMAP_SB_SIZE;
>> +    idx = pos >> PAGE_SHIFT;
>> +    offset = offset_in_page(pos);
>> +
>> +    return llbitmap->pctl[idx]->state[offset];
>> +}
>> +
>> +/* set all the bits in the subpage as dirty */
>> +static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
>> +                       struct llbitmap_page_ctl *pctl,
>> +                       unsigned int bit, unsigned int offset)
>> +{
>> +    bool level_456 = raid_is_456(llbitmap->mddev);
>> +    unsigned int io_size = llbitmap->io_size;
>> +    int pos;
>> +
>> +    for (pos = bit * io_size; pos < (bit + 1) * io_size; pos++) {
>> +        if (pos == offset)
>> +            continue;
>> +
>> +        switch (pctl->state[pos]) {
>> +        case BitUnwritten:
>> +            pctl->state[pos] = level_456 ? BitNeedSync : BitDirty;
>> +            break;
>> +        case BitClean:
>> +            pctl->state[pos] = BitDirty;
>> +            break;
>> +        };
>> +    }
>> +
>> +}
>> +
>> +static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx,
>> +                    int offset)
>> +{
>> +    struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
>> +    unsigned int io_size = llbitmap->io_size;
>> +    int bit = offset / io_size;
>> +    int pos;
>> +
>> +    if (!test_bit(LLPageDirty, &pctl->flags))
>> +        set_bit(LLPageDirty, &pctl->flags);
>> +
>> +    /*
>> +     * The subpage usually contains a total of 512 bits. If any 
>> single bit
>> +     * within the subpage is marked as dirty, the entire sector will be
>> +     * written. To avoid impacting write performance, when multiple bits
>> +     * within the same sector are modified within a short time frame, 
>> all
>> +     * bits in the sector will be collectively marked as dirty at once.
>> +     */
>> +    if (test_and_set_bit(bit, pctl->dirty)) {
>> +        llbitmap_infect_dirty_bits(llbitmap, pctl, bit, offset);
>> +        return;
>> +    }
>> +
>> +    for (pos = bit * io_size; pos < (bit + 1) * io_size; pos++) {
>> +        if (pos == offset)
>> +            continue;
>> +        if (pctl->state[pos] == BitDirty ||
>> +            pctl->state[pos] == BitNeedSync) {
>> +            llbitmap_infect_dirty_bits(llbitmap, pctl, bit, offset);
>> +            return;
>> +        }
>> +    }
>> +}
>> +
>> +static void llbitmap_write(struct llbitmap *llbitmap, enum 
>> llbitmap_state state,
>> +               loff_t pos)
>> +{
>> +    unsigned int idx;
>> +    unsigned int offset;
>> +
>> +    pos += BITMAP_SB_SIZE;
>> +    idx = pos >> PAGE_SHIFT;
>> +    offset = offset_in_page(pos);
>> +
>> +    llbitmap->pctl[idx]->state[offset] = state;
>> +    if (state == BitDirty || state == BitNeedSync)
>> +        llbitmap_set_page_dirty(llbitmap, idx, offset);
>> +}
>> +
>> +static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int 
>> idx)
>> +{
>> +    struct mddev *mddev = llbitmap->mddev;
>> +    struct page *page = NULL;
>> +    struct md_rdev *rdev;
>> +
>> +    if (llbitmap->pctl && llbitmap->pctl[idx])
>> +        page = llbitmap->pctl[idx]->page;
>> +    if (page)
>> +        return page;
>> +
>> +    page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>> +    if (!page)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    rdev_for_each(rdev, mddev) {
>> +        sector_t sector;
>> +
>> +        if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>> +            continue;
>> +
>> +        sector = mddev->bitmap_info.offset +
>> +             (idx << PAGE_SECTORS_SHIFT);
>> +
>> +        if (sync_page_io(rdev, sector, PAGE_SIZE, page, REQ_OP_READ,
>> +                 true))
>> +            return page;
>> +
>> +        md_error(mddev, rdev);
>> +    }
>> +
>> +    __free_page(page);
>> +    return ERR_PTR(-EIO);
>> +}
>> +
>> +static void llbitmap_write_page(struct llbitmap *llbitmap, int idx)
>> +{
>> +    struct page *page = llbitmap->pctl[idx]->page;
>> +    struct mddev *mddev = llbitmap->mddev;
>> +    struct md_rdev *rdev;
>> +    int bit;
>> +
>> +    for (bit = 0; bit < llbitmap->bits_per_page; bit++) {
>> +        struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
>> +
>> +        if (!test_and_clear_bit(bit, pctl->dirty))
>> +            continue;
>> +
>> +        rdev_for_each(rdev, mddev) {
>> +            sector_t sector;
>> +            sector_t bit_sector = llbitmap->io_size >> SECTOR_SHIFT;
>> +
>> +            if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>> +                continue;
>> +
>> +            sector = mddev->bitmap_info.offset + rdev->sb_start +
>> +                 (idx << PAGE_SECTORS_SHIFT) +
>> +                 bit * bit_sector;
>> +            md_write_metadata(mddev, rdev, sector,
>> +                      llbitmap->io_size, page,
>> +                      bit * llbitmap->io_size);
>> +        }
>> +    }
>> +}
>> +
>> +static void active_release(struct percpu_ref *ref)
>> +{
>> +    struct llbitmap_page_ctl *pctl =
>> +        container_of(ref, struct llbitmap_page_ctl, active);
>> +
>> +    wake_up(&pctl->wait);
>> +}
>> +
>> +static void llbitmap_free_pages(struct llbitmap *llbitmap)
>> +{
>> +    int i;
>> +
>> +    if (!llbitmap->pctl)
>> +        return;
>> +
>> +    for (i = 0; i < llbitmap->nr_pages; i++) {
>> +        struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
>> +
>> +        if (!pctl || !pctl->page)
>> +            break;
>> +
>> +        __free_page(pctl->page);
>> +        percpu_ref_exit(&pctl->active);
>> +    }
>> +
>> +    kfree(llbitmap->pctl[0]);
>> +    kfree(llbitmap->pctl);
>> +    llbitmap->pctl = NULL;
>> +}
>> +
>> +static int llbitmap_cache_pages(struct llbitmap *llbitmap)
>> +{
>> +    struct llbitmap_page_ctl *pctl;
>> +    unsigned int nr_pages = DIV_ROUND_UP(llbitmap->chunks + 
>> BITMAP_SB_SIZE,
>> +                         PAGE_SIZE);
>> +    unsigned int size = struct_size(pctl, dirty,
>> +                    BITS_TO_LONGS(llbitmap->bits_per_page));
>> +    int i;
>> +
>> +    llbitmap->pctl = kmalloc_array(nr_pages, sizeof(void *),
>> +                       GFP_KERNEL | __GFP_ZERO);
>> +    if (!llbitmap->pctl)
>> +        return -ENOMEM;
>> +
>> +    size = round_up(size, cache_line_size());
>> +    pctl = kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
>> +    if (!pctl) {
>> +        kfree(llbitmap->pctl);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    llbitmap->nr_pages = nr_pages;
>> +
>> +    for (i = 0; i < nr_pages; i++, pctl = (void *)pctl + size) {
>> +        struct page *page = llbitmap_read_page(llbitmap, i);
>> +
>> +        llbitmap->pctl[i] = pctl;
>> +
>> +        if (IS_ERR(page)) {
>> +            llbitmap_free_pages(llbitmap);
>> +            return PTR_ERR(page);
>> +        }
>> +
>> +        if (percpu_ref_init(&pctl->active, active_release,
>> +                    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> +            __free_page(page);
>> +            llbitmap_free_pages(llbitmap);
>> +            return -ENOMEM;
>> +        }
>> +
>> +        pctl->page = page;
>> +        pctl->state = page_address(page);
>> +        init_waitqueue_head(&pctl->wait);
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +#endif /* CONFIG_MD_LLBITMAP */
> 
> 
> .
> 

