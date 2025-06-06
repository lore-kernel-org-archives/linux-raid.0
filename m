Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1788B1DF725
	for <linux-raid@vger.kernel.org>; Fri,  6 Jun 2025 06:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749191076; cv=none; b=j4M4tk/SNWtLS7pJAh+DE6mJFK2XuQ5ecIiG4XEHuAAlsSQiKyLbJ/QxhlK5fI4S8zr1+CY24JXnUAjRrf7kO/97driGnOA7UKh6RnyYp2TM6RmJsjh7hMd3/9FXExy2RfHmBf9nNS74APjH7Op7GrpaOKroZwvjl91rH+/sYQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749191076; c=relaxed/simple;
	bh=8VNU7X/UpHjJ1b3+dd3BZ2upVoWtCjDEqdlH/0eBaRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5dOHICi505BqCvnkXkI/ggCNOsDEG6DKi9k9m84E0R7o4qDkTkncKtrAqdEw5ma74sEqRYHe0nE7792nuCY/eAKrhN78Egq5WpYNJhJvvLpQHwOnQ5NB3NmutUTNpIcK5+BsJpV3qEnC5Bv3H3Kjs4vY7hGXhhe+bp7cEHZqlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AaWWdufQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaWWdufQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749191073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPCo3hg7cYpHsrcl3rXE8ZbPS6eSun1veK4zy9KFNC8=;
	b=AaWWdufQL/PEein79niTBfVs3IQRHHROvAuysQm89YYYmC42NXjsOJ/xNKVC0rZd/H9+BK
	FsvzZo6B2DUSuJZV9G9rucb+tOlX1fYY/JpiG2fBdWAMp5sL1/HytqeuSWGBQv4oaV6vQh
	v+Ll+AjjsIUWnL/bhX+j54kEAss73nk=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-VOjugvSyOZecsxvgemjYtw-1; Fri, 06 Jun 2025 02:24:30 -0400
X-MC-Unique: VOjugvSyOZecsxvgemjYtw-1
X-Mimecast-MFC-AGG-ID: VOjugvSyOZecsxvgemjYtw_1749191070
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7394772635dso1315139b3a.0
        for <linux-raid@vger.kernel.org>; Thu, 05 Jun 2025 23:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749191070; x=1749795870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bPCo3hg7cYpHsrcl3rXE8ZbPS6eSun1veK4zy9KFNC8=;
        b=LYtaPnMmtgTI+vfcvOyH2IBsR7Zj5loWJbQfKLXqQTerGWA7VLs1SNW4uT5ZNunrmh
         aQFQED/6kNbXkCPVZOr53mMXNhrlmLtg+SNEQp3BCZwYwWPxu2VG4icS2qzU+yNVc2p1
         6V1pyAb1mXIJrXT70o2sgvblFSWSbaPQIXcA73dqyF4H5wPfN59GP7T9/RXxwy5Ti5Z0
         8F41hsiwINJM9Ogk4fSb/QEd+VL7fhBHqvsW8LeSGx8HuUaoKjBp8CAT+MSJtT4aklXy
         x+PTotNkRUTDBLb58B/x38ycUM4w/7smEjXJF2sGdA6zUFKa+VR0Ek4GLrUTDJnyJQi5
         49dw==
X-Forwarded-Encrypted: i=1; AJvYcCWSClZGR/Hg9eEkz2e+wBPMZKK+tNWvo/Kjd2CIbFCJLzp54719wpQTO3gPSSgI1tDAGqLV/cA9A8qt@vger.kernel.org
X-Gm-Message-State: AOJu0YwpzbHCwnJZMXlAEEHImf6aoS6o54c6f/iueBmIiBXRGcKCOOoH
	kj9kcIKsCJloeV7nKEd/PFRJTN8X2Sthi1p9Z5HySwUS0lNm+JrVR8Z/9Z/CNNrpz516G8Arvl6
	x9DfE7FiZk7rSjbhtbta7DOKeNxmmW3QryYthrbWiYYxdVgbNkP3DLToT9q9GX+8=
X-Gm-Gg: ASbGncsOyuSad0H0wKd992gc3wz0lsZmBLvJa+NnctY8Ku+SgGSzvXPs1dlnGaL6Rj8
	ja/DDHxe+E39lA+9SkPFAHUru/ipY9p1coxSioHYSjoIPY4n+mIwQtc3Kc1s64jXnd7kGXCWJgc
	Gpoyi1Ubgz3sw06zUHEJZ6KILQEwPHMpARfzGOLe6q6w2rc7uqHz5Gtj+/rMFDwIea1+KogSXWo
	BoYriwqqTs2N0fBmiXW+m7W/zO9VrGRlSXTwddl4rAspsICacX5i1TrpA7hSaDMbSpCcL8JCY8o
	nNczyEj/EBPb1jNP2fuNRUxfGyTF
X-Received: by 2002:a05:6a00:228a:b0:736:ff65:3fcc with SMTP id d2e1a72fcca58-74827f14be7mr3090774b3a.16.1749191069436;
        Thu, 05 Jun 2025 23:24:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjIqcKWNA0hXuJVHG8V/iDrPx+vwHcKcEol9IVF/ghslOTF6YSeR53I9qgFdrBlF/qVMHoPg==
X-Received: by 2002:a05:6a00:228a:b0:736:ff65:3fcc with SMTP id d2e1a72fcca58-74827f14be7mr3090751b3a.16.1749191068960;
        Thu, 05 Jun 2025 23:24:28 -0700 (PDT)
Received: from [10.72.120.2] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0e9d57sm593483b3a.160.2025.06.05.23.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 23:24:27 -0700 (PDT)
Message-ID: <89b1283c-c256-4830-96dd-ef9e5a7ce355@redhat.com>
Date: Fri, 6 Jun 2025 14:24:21 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, colyli@kernel.org,
 song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-16-yukuai1@huaweicloud.com>
 <4b1e7a50-f448-4e0f-a498-a8c6b0c7f97d@redhat.com>
 <7ef969ed-8468-5d63-a08d-886ca853f772@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <7ef969ed-8468-5d63-a08d-886ca853f772@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/6/6 上午11:48, Yu Kuai 写道:
> Hi,
>
> 在 2025/06/06 11:21, Xiao Ni 写道:
>> Hi Kuai
>>
>> I've read some codes of llbitmap, but I don't figure out the 
>> relationship of in memory bits and in storage bits. Does llbitmap 
>> have the two types as old bitmap? For example, in llbitmap_create, 
>> there is a argument ->bits_per_page which is calculated by 
>> PAGE_SIZE/logical_block_size. As the graph bellow, bits_per_page is 8 
>> (4K/512byte). What does the bit mean? And in the graph below, it 
>> talks 512 bits in one block, what does this bit mean?  I haven't 
>> walked through all codes, maybe I can get the answer myself. If you 
>> can give a summary of how many types of bit and what's the usage of 
>> the bit, it can help to understand it easier.
>
> llbitmap bit is always 1 byte, it's the same in memory and on disk.


I c, thanks for the explanation.

>
> bits_per_page bit is used to track dirty sectors in the memory page.
>
> For example, usually 4k page will contain 8 sectors, each sector is 512
> bytes, if one llbitmap bit is dirty, then the related bits_per_page bit
> will be set as well, and later will write the sector to disk.


Maybe consider another name of bits_per_page? bits_per_page can easily 
let people to think the bitmat bits in one page. Through the graph 
below, maybe blocks_per_page?

Regards

Xiao

>
> Thanks,
> kuai
>
>>
>> Best Regards
>>
>> Xiao
>>
>> 在 2025/5/24 下午2:13, Yu Kuai 写道:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> READ
>>>
>>> While creating bitmap, all pages will be allocated and read for 
>>> llbitmap,
>>> there won't be read afterwards
>>>
>>> WRITE
>>>
>>> WRITE IO is divided into logical_block_size of the page, the dirty 
>>> state
>>> of each block is tracked independently, for example:
>>>
>>> each page is 4k, contain 8 blocks; each block is 512 bytes contain 
>>> 512 bit;
>>>
>>> | page0 | page1 | ... | page 31 |
>>> |       |
>>> |        \-----------------------\
>>> |                                |
>>> | block0 | block1 | ... | block 8|
>>> |        |
>>> |         \-----------------\
>>> |                            |
>>> | bit0 | bit1 | ... | bit511 |
>>>
>>>  From IO path, if one bit is changed to Dirty or NeedSync, the 
>>> corresponding
>>> subpage will be marked dirty, such block must write first before the 
>>> IO is
>>> issued. This behaviour will affect IO performance, to reduce the 
>>> impact, if
>>> multiple bits are changed in the same block in a short time, all 
>>> bits in
>>> this block will be changed to Dirty/NeedSync, so that there won't be 
>>> any
>>> overhead until daemon clears dirty bits.
>>>
>>> Also add data structure definition and comments.
>>>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> ---
>>>   drivers/md/md-llbitmap.c | 571 
>>> +++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 571 insertions(+)
>>>   create mode 100644 drivers/md/md-llbitmap.c
>>>
>>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>>> new file mode 100644
>>> index 000000000000..1a01b6777527
>>> --- /dev/null
>>> +++ b/drivers/md/md-llbitmap.c
>>> @@ -0,0 +1,571 @@
>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>> +
>>> +#ifdef CONFIG_MD_LLBITMAP
>>> +
>>> +#include <linux/blkdev.h>
>>> +#include <linux/module.h>
>>> +#include <linux/errno.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/init.h>
>>> +#include <linux/timer.h>
>>> +#include <linux/sched.h>
>>> +#include <linux/list.h>
>>> +#include <linux/file.h>
>>> +#include <linux/seq_file.h>
>>> +#include <trace/events/block.h>
>>> +
>>> +#include "md.h"
>>> +#include "md-bitmap.h"
>>> +
>>> +/*
>>> + * #### Background
>>> + *
>>> + * Redundant data is used to enhance data fault tolerance, and the 
>>> storage
>>> + * method for redundant data vary depending on the RAID levels. And 
>>> it's
>>> + * important to maintain the consistency of redundant data.
>>> + *
>>> + * Bitmap is used to record which data blocks have been 
>>> synchronized and which
>>> + * ones need to be resynchronized or recovered. Each bit in the bitmap
>>> + * represents a segment of data in the array. When a bit is set, it 
>>> indicates
>>> + * that the multiple redundant copies of that data segment may not be
>>> + * consistent. Data synchronization can be performed based on the 
>>> bitmap after
>>> + * power failure or readding a disk. If there is no bitmap, a full 
>>> disk
>>> + * synchronization is required.
>>> + *
>>> + * #### Key Features
>>> + *
>>> + *  - IO fastpath is lockless, if user issues lots of write IO to 
>>> the same
>>> + *  bitmap bit in a short time, only the first write have 
>>> additional overhead
>>> + *  to update bitmap bit, no additional overhead for the following 
>>> writes;
>>> + *  - support only resync or recover written data, means in the 
>>> case creating
>>> + *  new array or replacing with a new disk, there is no need to do 
>>> a full disk
>>> + *  resync/recovery;
>>> + *
>>> + * #### Key Concept
>>> + *
>>> + * ##### State Machine
>>> + *
>>> + * Each bit is one byte, contain 6 difference state, see 
>>> llbitmap_state. And
>>> + * there are total 8 differenct actions, see llbitmap_action, can 
>>> change state:
>>> + *
>>> + * llbitmap state machine: transitions between states
>>> + *
>>> + * |           | Startwrite | Startsync | Endsync | Abortsync|
>>> + * | --------- | ---------- | --------- | ------- | ------- |
>>> + * | Unwritten | Dirty      | x         | x       | x |
>>> + * | Clean     | Dirty      | x         | x       | x |
>>> + * | Dirty     | x          | x         | x       | x |
>>> + * | NeedSync  | x          | Syncing   | x       | x |
>>> + * | Syncing   | x          | Syncing   | Dirty   | NeedSync |
>>> + *
>>> + * |           | Reload   | Daemon | Discard   | Stale     |
>>> + * | --------- | -------- | ------ | --------- | --------- |
>>> + * | Unwritten | x        | x      | x         | x         |
>>> + * | Clean     | x        | x      | Unwritten | NeedSync  |
>>> + * | Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
>>> + * | NeedSync  | x        | x      | Unwritten | x         |
>>> + * | Syncing   | NeedSync | x      | Unwritten | NeedSync  |
>>> + *
>>> + * Typical scenarios:
>>> + *
>>> + * 1) Create new array
>>> + * All bits will be set to Unwritten by default, if --assume-clean 
>>> is set,
>>> + * all bits will be set to Clean instead.
>>> + *
>>> + * 2) write data, raid1/raid10 have full copy of data, while 
>>> raid456 doesn't and
>>> + * rely on xor data
>>> + *
>>> + * 2.1) write new data to raid1/raid10:
>>> + * Unwritten --StartWrite--> Dirty
>>> + *
>>> + * 2.2) write new data to raid456:
>>> + * Unwritten --StartWrite--> NeedSync
>>> + *
>>> + * Because the initial recover for raid456 is skipped, the xor data 
>>> is not build
>>> + * yet, the bit must set to NeedSync first and after lazy initial 
>>> recover is
>>> + * finished, the bit will finially set to Dirty(see 5.1 and 5.4);
>>> + *
>>> + * 2.3) cover write
>>> + * Clean --StartWrite--> Dirty
>>> + *
>>> + * 3) daemon, if the array is not degraded:
>>> + * Dirty --Daemon--> Clean
>>> + *
>>> + * For degraded array, the Dirty bit will never be cleared, prevent 
>>> full disk
>>> + * recovery while readding a removed disk.
>>> + *
>>> + * 4) discard
>>> + * {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
>>> + *
>>> + * 5) resync and recover
>>> + *
>>> + * 5.1) common process
>>> + * NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> 
>>> Clean
>>> + *
>>> + * 5.2) resync after power failure
>>> + * Dirty --Reload--> NeedSync
>>> + *
>>> + * 5.3) recover while replacing with a new disk
>>> + * By default, the old bitmap framework will recover all data, and 
>>> llbitmap
>>> + * implement this by a new helper, see llbitmap_skip_sync_blocks:
>>> + *
>>> + * skip recover for bits other than dirty or clean;
>>> + *
>>> + * 5.4) lazy initial recover for raid5:
>>> + * By default, the old bitmap framework will only allow new recover 
>>> when there
>>> + * are spares(new disk), a new recovery flag 
>>> MD_RECOVERY_LAZY_RECOVER is add
>>> + * to perform raid456 lazy recover for set bits(from 2.2).
>>> + *
>>> + * ##### Bitmap IO
>>> + *
>>> + * ##### Chunksize
>>> + *
>>> + * The default bitmap size is 128k, incluing 1k bitmap super block, 
>>> and
>>> + * the default size of segment of data in the array each 
>>> bit(chunksize) is 64k,
>>> + * and chunksize will adjust to twice the old size each time if the 
>>> total number
>>> + * bits is not less than 127k.(see llbitmap_init)
>>> + *
>>> + * ##### READ
>>> + *
>>> + * While creating bitmap, all pages will be allocated and read for 
>>> llbitmap,
>>> + * there won't be read afterwards
>>> + *
>>> + * ##### WRITE
>>> + *
>>> + * WRITE IO is divided into logical_block_size of the array, the 
>>> dirty state
>>> + * of each block is tracked independently, for example:
>>> + *
>>> + * each page is 4k, contain 8 blocks; each block is 512 bytes 
>>> contain 512 bit;
>>> + *
>>> + * | page0 | page1 | ... | page 31 |
>>> + * |       |
>>> + * |        \-----------------------\
>>> + * |                                |
>>> + * | block0 | block1 | ... | block 8|
>>> + * |        |
>>> + * |         \-----------------\
>>> + * |                            |
>>> + * | bit0 | bit1 | ... | bit511 |
>>> + *
>>> + * From IO path, if one bit is changed to Dirty or NeedSync, the 
>>> corresponding
>>> + * subpage will be marked dirty, such block must write first before 
>>> the IO is
>>> + * issued. This behaviour will affect IO performance, to reduce the 
>>> impact, if
>>> + * multiple bits are changed in the same block in a short time, all 
>>> bits in this
>>> + * block will be changed to Dirty/NeedSync, so that there won't be 
>>> any overhead
>>> + * until daemon clears dirty bits.
>>> + *
>>> + * ##### Dirty Bits syncronization
>>> + *
>>> + * IO fast path will set bits to dirty, and those dirty bits will 
>>> be cleared
>>> + * by daemon after IO is done. llbitmap_page_ctl is used to 
>>> synchronize between
>>> + * IO path and daemon;
>>> + *
>>> + * IO path:
>>> + *  1) try to grab a reference, if succeed, set expire time after 
>>> 5s and return;
>>> + *  2) if failed to grab a reference, wait for daemon to finish 
>>> clearing dirty
>>> + *  bits;
>>> + *
>>> + * Daemon(Daemon will be waken up every daemon_sleep seconds):
>>> + * For each page:
>>> + *  1) check if page expired, if not skip this page; for expired page:
>>> + *  2) suspend the page and wait for inflight write IO to be done;
>>> + *  3) change dirty page to clean;
>>> + *  4) resume the page;
>>> + */
>>> +
>>> +#define BITMAP_SB_SIZE 1024
>>> +
>>> +/* 64k is the max IO size of sync IO for raid1/raid10 */
>>> +#define MIN_CHUNK_SIZE (64 * 2)
>>> +
>>> +/* By default, daemon will be waken up every 30s */
>>> +#define DEFAULT_DAEMON_SLEEP 30
>>> +
>>> +/*
>>> + * Dirtied bits that have not been accessed for more than 5s will 
>>> be cleared
>>> + * by daemon.
>>> + */
>>> +#define BARRIER_IDLE 5
>>> +
>>> +enum llbitmap_state {
>>> +    /* No valid data, init state after assemble the array */
>>> +    BitUnwritten = 0,
>>> +    /* data is consistent */
>>> +    BitClean,
>>> +    /* data will be consistent after IO is done, set directly for 
>>> writes */
>>> +    BitDirty,
>>> +    /*
>>> +     * data need to be resynchronized:
>>> +     * 1) set directly for writes if array is degraded, prevent 
>>> full disk
>>> +     * synchronization after readding a disk;
>>> +     * 2) reassemble the array after power failure, and dirty bits are
>>> +     * found after reloading the bitmap;
>>> +     * 3) set for first write for raid5, to build initial xor data 
>>> lazily
>>> +     */
>>> +    BitNeedSync,
>>> +    /* data is synchronizing */
>>> +    BitSyncing,
>>> +    nr_llbitmap_state,
>>> +    BitNone = 0xff,
>>> +};
>>> +
>>> +enum llbitmap_action {
>>> +    /* User write new data, this is the only action from IO fast 
>>> path */
>>> +    BitmapActionStartwrite = 0,
>>> +    /* Start recovery */
>>> +    BitmapActionStartsync,
>>> +    /* Finish recovery */
>>> +    BitmapActionEndsync,
>>> +    /* Failed recovery */
>>> +    BitmapActionAbortsync,
>>> +    /* Reassemble the array */
>>> +    BitmapActionReload,
>>> +    /* Daemon thread is trying to clear dirty bits */
>>> +    BitmapActionDaemon,
>>> +    /* Data is deleted */
>>> +    BitmapActionDiscard,
>>> +    /*
>>> +     * Bitmap is stale, mark all bits in addition to BitUnwritten to
>>> +     * BitNeedSync.
>>> +     */
>>> +    BitmapActionStale,
>>> +    nr_llbitmap_action,
>>> +    /* Init state is BitUnwritten */
>>> +    BitmapActionInit,
>>> +};
>>> +
>>> +enum llbitmap_page_state {
>>> +    LLPageFlush = 0,
>>> +    LLPageDirty,
>>> +};
>>> +
>>> +struct llbitmap_page_ctl {
>>> +    char *state;
>>> +    struct page *page;
>>> +    unsigned long expire;
>>> +    unsigned long flags;
>>> +    wait_queue_head_t wait;
>>> +    struct percpu_ref active;
>>> +    /* Per block size dirty state, maximum 64k page / 1 sector = 
>>> 128 */
>>> +    unsigned long dirty[];
>>> +};
>>> +
>>> +struct llbitmap {
>>> +    struct mddev *mddev;
>>> +    struct llbitmap_page_ctl **pctl;
>>> +
>>> +    unsigned int nr_pages;
>>> +    unsigned int io_size;
>>> +    unsigned int bits_per_page;
>>> +
>>> +    /* shift of one chunk */
>>> +    unsigned long chunkshift;
>>> +    /* size of one chunk in sector */
>>> +    unsigned long chunksize;
>>> +    /* total number of chunks */
>>> +    unsigned long chunks;
>>> +    unsigned long last_end_sync;
>>> +    /* fires on first BitDirty state */
>>> +    struct timer_list pending_timer;
>>> +    struct work_struct daemon_work;
>>> +
>>> +    unsigned long flags;
>>> +    __u64    events_cleared;
>>> +
>>> +    /* for slow disks */
>>> +    atomic_t behind_writes;
>>> +    wait_queue_head_t behind_wait;
>>> +};
>>> +
>>> +struct llbitmap_unplug_work {
>>> +    struct work_struct work;
>>> +    struct llbitmap *llbitmap;
>>> +    struct completion *done;
>>> +};
>>> +
>>> +static struct workqueue_struct *md_llbitmap_io_wq;
>>> +static struct workqueue_struct *md_llbitmap_unplug_wq;
>>> +
>>> +static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
>>> +    [BitUnwritten] = {
>>> +        [BitmapActionStartwrite]    = BitDirty,
>>> +        [BitmapActionStartsync]        = BitNone,
>>> +        [BitmapActionEndsync]        = BitNone,
>>> +        [BitmapActionAbortsync]        = BitNone,
>>> +        [BitmapActionReload]        = BitNone,
>>> +        [BitmapActionDaemon]        = BitNone,
>>> +        [BitmapActionDiscard]        = BitNone,
>>> +        [BitmapActionStale]        = BitNone,
>>> +    },
>>> +    [BitClean] = {
>>> +        [BitmapActionStartwrite]    = BitDirty,
>>> +        [BitmapActionStartsync]        = BitNone,
>>> +        [BitmapActionEndsync]        = BitNone,
>>> +        [BitmapActionAbortsync]        = BitNone,
>>> +        [BitmapActionReload]        = BitNone,
>>> +        [BitmapActionDaemon]        = BitNone,
>>> +        [BitmapActionDiscard]        = BitUnwritten,
>>> +        [BitmapActionStale]        = BitNeedSync,
>>> +    },
>>> +    [BitDirty] = {
>>> +        [BitmapActionStartwrite]    = BitNone,
>>> +        [BitmapActionStartsync]        = BitNone,
>>> +        [BitmapActionEndsync]        = BitNone,
>>> +        [BitmapActionAbortsync]        = BitNone,
>>> +        [BitmapActionReload]        = BitNeedSync,
>>> +        [BitmapActionDaemon]        = BitClean,
>>> +        [BitmapActionDiscard]        = BitUnwritten,
>>> +        [BitmapActionStale]        = BitNeedSync,
>>> +    },
>>> +    [BitNeedSync] = {
>>> +        [BitmapActionStartwrite]    = BitNone,
>>> +        [BitmapActionStartsync]        = BitSyncing,
>>> +        [BitmapActionEndsync]        = BitNone,
>>> +        [BitmapActionAbortsync]        = BitNone,
>>> +        [BitmapActionReload]        = BitNone,
>>> +        [BitmapActionDaemon]        = BitNone,
>>> +        [BitmapActionDiscard]        = BitUnwritten,
>>> +        [BitmapActionStale]        = BitNone,
>>> +    },
>>> +    [BitSyncing] = {
>>> +        [BitmapActionStartwrite]    = BitNone,
>>> +        [BitmapActionStartsync]        = BitSyncing,
>>> +        [BitmapActionEndsync]        = BitDirty,
>>> +        [BitmapActionAbortsync]        = BitNeedSync,
>>> +        [BitmapActionReload]        = BitNeedSync,
>>> +        [BitmapActionDaemon]        = BitNone,
>>> +        [BitmapActionDiscard]        = BitUnwritten,
>>> +        [BitmapActionStale]        = BitNeedSync,
>>> +    },
>>> +};
>>> +
>>> +static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, 
>>> loff_t pos)
>>> +{
>>> +    unsigned int idx;
>>> +    unsigned int offset;
>>> +
>>> +    pos += BITMAP_SB_SIZE;
>>> +    idx = pos >> PAGE_SHIFT;
>>> +    offset = offset_in_page(pos);
>>> +
>>> +    return llbitmap->pctl[idx]->state[offset];
>>> +}
>>> +
>>> +/* set all the bits in the subpage as dirty */
>>> +static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
>>> +                       struct llbitmap_page_ctl *pctl,
>>> +                       unsigned int bit, unsigned int offset)
>>> +{
>>> +    bool level_456 = raid_is_456(llbitmap->mddev);
>>> +    unsigned int io_size = llbitmap->io_size;
>>> +    int pos;
>>> +
>>> +    for (pos = bit * io_size; pos < (bit + 1) * io_size; pos++) {
>>> +        if (pos == offset)
>>> +            continue;
>>> +
>>> +        switch (pctl->state[pos]) {
>>> +        case BitUnwritten:
>>> +            pctl->state[pos] = level_456 ? BitNeedSync : BitDirty;
>>> +            break;
>>> +        case BitClean:
>>> +            pctl->state[pos] = BitDirty;
>>> +            break;
>>> +        };
>>> +    }
>>> +
>>> +}
>>> +
>>> +static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int 
>>> idx,
>>> +                    int offset)
>>> +{
>>> +    struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
>>> +    unsigned int io_size = llbitmap->io_size;
>>> +    int bit = offset / io_size;
>>> +    int pos;
>>> +
>>> +    if (!test_bit(LLPageDirty, &pctl->flags))
>>> +        set_bit(LLPageDirty, &pctl->flags);
>>> +
>>> +    /*
>>> +     * The subpage usually contains a total of 512 bits. If any 
>>> single bit
>>> +     * within the subpage is marked as dirty, the entire sector 
>>> will be
>>> +     * written. To avoid impacting write performance, when multiple 
>>> bits
>>> +     * within the same sector are modified within a short time 
>>> frame, all
>>> +     * bits in the sector will be collectively marked as dirty at 
>>> once.
>>> +     */
>>> +    if (test_and_set_bit(bit, pctl->dirty)) {
>>> +        llbitmap_infect_dirty_bits(llbitmap, pctl, bit, offset);
>>> +        return;
>>> +    }
>>> +
>>> +    for (pos = bit * io_size; pos < (bit + 1) * io_size; pos++) {
>>> +        if (pos == offset)
>>> +            continue;
>>> +        if (pctl->state[pos] == BitDirty ||
>>> +            pctl->state[pos] == BitNeedSync) {
>>> +            llbitmap_infect_dirty_bits(llbitmap, pctl, bit, offset);
>>> +            return;
>>> +        }
>>> +    }
>>> +}
>>> +
>>> +static void llbitmap_write(struct llbitmap *llbitmap, enum 
>>> llbitmap_state state,
>>> +               loff_t pos)
>>> +{
>>> +    unsigned int idx;
>>> +    unsigned int offset;
>>> +
>>> +    pos += BITMAP_SB_SIZE;
>>> +    idx = pos >> PAGE_SHIFT;
>>> +    offset = offset_in_page(pos);
>>> +
>>> +    llbitmap->pctl[idx]->state[offset] = state;
>>> +    if (state == BitDirty || state == BitNeedSync)
>>> +        llbitmap_set_page_dirty(llbitmap, idx, offset);
>>> +}
>>> +
>>> +static struct page *llbitmap_read_page(struct llbitmap *llbitmap, 
>>> int idx)
>>> +{
>>> +    struct mddev *mddev = llbitmap->mddev;
>>> +    struct page *page = NULL;
>>> +    struct md_rdev *rdev;
>>> +
>>> +    if (llbitmap->pctl && llbitmap->pctl[idx])
>>> +        page = llbitmap->pctl[idx]->page;
>>> +    if (page)
>>> +        return page;
>>> +
>>> +    page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>>> +    if (!page)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    rdev_for_each(rdev, mddev) {
>>> +        sector_t sector;
>>> +
>>> +        if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>>> +            continue;
>>> +
>>> +        sector = mddev->bitmap_info.offset +
>>> +             (idx << PAGE_SECTORS_SHIFT);
>>> +
>>> +        if (sync_page_io(rdev, sector, PAGE_SIZE, page, REQ_OP_READ,
>>> +                 true))
>>> +            return page;
>>> +
>>> +        md_error(mddev, rdev);
>>> +    }
>>> +
>>> +    __free_page(page);
>>> +    return ERR_PTR(-EIO);
>>> +}
>>> +
>>> +static void llbitmap_write_page(struct llbitmap *llbitmap, int idx)
>>> +{
>>> +    struct page *page = llbitmap->pctl[idx]->page;
>>> +    struct mddev *mddev = llbitmap->mddev;
>>> +    struct md_rdev *rdev;
>>> +    int bit;
>>> +
>>> +    for (bit = 0; bit < llbitmap->bits_per_page; bit++) {
>>> +        struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
>>> +
>>> +        if (!test_and_clear_bit(bit, pctl->dirty))
>>> +            continue;
>>> +
>>> +        rdev_for_each(rdev, mddev) {
>>> +            sector_t sector;
>>> +            sector_t bit_sector = llbitmap->io_size >> SECTOR_SHIFT;
>>> +
>>> +            if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>>> +                continue;
>>> +
>>> +            sector = mddev->bitmap_info.offset + rdev->sb_start +
>>> +                 (idx << PAGE_SECTORS_SHIFT) +
>>> +                 bit * bit_sector;
>>> +            md_write_metadata(mddev, rdev, sector,
>>> +                      llbitmap->io_size, page,
>>> +                      bit * llbitmap->io_size);
>>> +        }
>>> +    }
>>> +}
>>> +
>>> +static void active_release(struct percpu_ref *ref)
>>> +{
>>> +    struct llbitmap_page_ctl *pctl =
>>> +        container_of(ref, struct llbitmap_page_ctl, active);
>>> +
>>> +    wake_up(&pctl->wait);
>>> +}
>>> +
>>> +static void llbitmap_free_pages(struct llbitmap *llbitmap)
>>> +{
>>> +    int i;
>>> +
>>> +    if (!llbitmap->pctl)
>>> +        return;
>>> +
>>> +    for (i = 0; i < llbitmap->nr_pages; i++) {
>>> +        struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
>>> +
>>> +        if (!pctl || !pctl->page)
>>> +            break;
>>> +
>>> +        __free_page(pctl->page);
>>> +        percpu_ref_exit(&pctl->active);
>>> +    }
>>> +
>>> +    kfree(llbitmap->pctl[0]);
>>> +    kfree(llbitmap->pctl);
>>> +    llbitmap->pctl = NULL;
>>> +}
>>> +
>>> +static int llbitmap_cache_pages(struct llbitmap *llbitmap)
>>> +{
>>> +    struct llbitmap_page_ctl *pctl;
>>> +    unsigned int nr_pages = DIV_ROUND_UP(llbitmap->chunks + 
>>> BITMAP_SB_SIZE,
>>> +                         PAGE_SIZE);
>>> +    unsigned int size = struct_size(pctl, dirty,
>>> + BITS_TO_LONGS(llbitmap->bits_per_page));
>>> +    int i;
>>> +
>>> +    llbitmap->pctl = kmalloc_array(nr_pages, sizeof(void *),
>>> +                       GFP_KERNEL | __GFP_ZERO);
>>> +    if (!llbitmap->pctl)
>>> +        return -ENOMEM;
>>> +
>>> +    size = round_up(size, cache_line_size());
>>> +    pctl = kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
>>> +    if (!pctl) {
>>> +        kfree(llbitmap->pctl);
>>> +        return -ENOMEM;
>>> +    }
>>> +
>>> +    llbitmap->nr_pages = nr_pages;
>>> +
>>> +    for (i = 0; i < nr_pages; i++, pctl = (void *)pctl + size) {
>>> +        struct page *page = llbitmap_read_page(llbitmap, i);
>>> +
>>> +        llbitmap->pctl[i] = pctl;
>>> +
>>> +        if (IS_ERR(page)) {
>>> +            llbitmap_free_pages(llbitmap);
>>> +            return PTR_ERR(page);
>>> +        }
>>> +
>>> +        if (percpu_ref_init(&pctl->active, active_release,
>>> +                    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>>> +            __free_page(page);
>>> +            llbitmap_free_pages(llbitmap);
>>> +            return -ENOMEM;
>>> +        }
>>> +
>>> +        pctl->page = page;
>>> +        pctl->state = page_address(page);
>>> +        init_waitqueue_head(&pctl->wait);
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +#endif /* CONFIG_MD_LLBITMAP */
>>
>>
>> .
>>
>

