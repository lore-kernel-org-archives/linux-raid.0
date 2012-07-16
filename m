From: Shaohua Li <shli@kernel.org>
Subject: Re: Re: [PATCH 0/2] Improve odirect-write performance for block-device.
Date: Mon, 16 Jul 2012 07:21:38 -0600
Message-ID: <CANejiEXRqfFufuT0HeCc1r=4u6yu1soCDw3q3SOOX=JCpkUKOQ@mail.gmail.com>
References: <201207160929453906032@gmail.com>
	<CANejiEW6znDtKZ+d5BzHb9TSM4ywC2CKyWhM95rJZJRgMgUZKw@mail.gmail.com>
	<201207161343099841872@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201207161343099841872@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, viro <viro@zeniv.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

2012/7/15 majianpeng <majianpeng@gmail.com>:
> On 2012-07-16 11:29 Shaohua Li <shli@kernel.org> Wrote:
>>2012/7/15 majianpeng <majianpeng@gmail.com>:
>>> Create a raid5 using four disk and the chunksize is 512K.
>>> Test command is: dd if=/dev/zero of=/dev/md0 bs=1536K count=90000 oflag=direct
>>>
>>> In RHEL6(kernel 2.6.32):speed about 240MB/s
>>> In 3.5.0-rc5:speed about 77MB/S
>>> Add two patch in 3.5.0-rc5, speed about 200MB/S.
>>>
>>> So the performance of odirect-wrirte for block-deivce was obvious reduced.
>>> PATCH 1/2: Add blk_plug function for odirect-write block-device
>>> PATCH 2/2: Remove REQ_SYNC for odirect-write in raid456.
>>>
>>> PATCH 2/2 maybe not correct because it alse for odirect-write for regular file.
>>> Jianpeng Ma (2):
>>>   fs/block-dev.c:fix performance regression in O_DIRECT writes to
>>>     md block devices.
>>
>>In raid5, all requests are submitted by raid5d thread, which already has
>>plug. Why doesn't it work?
> No. the purpose of two patch is to reduce the read operation when write which was not full-write.
> I tested in RHEL6.The read operation is zero.But in 3.5.0-rc5, the read operaiton may equal to write-operation.
> And i used the bs was 1536k(3*512k(chunk-size)).

yes, I know. But I want to understand why we need the plug in your
test. The IO is dispatched from raid5d, it already has plug.

Fengguang used to post a patch to move the plug from generic_file_aio_write
to do_blockdev_direct_IO, which sounds better.

>>>   raid5: For write performance, remove REQ_SYNC when write was odirect.
>>
>>REQ_SYNC only impacts CFQ, this sounds not reasonable. So the disks
>>are using CFQ ioscheduler. Can you check if you can see the same issue
>>with deadline?
> I tested and the result is the same like cfq.
> But in RHEL6, the ioscheduler is also cfq.
>>
>>Let me guess, without REQ_SYNC, read will get higher priority against write
>>in CFQ, so in this case, write gets delayed, and maybe get better write
>>request merge. And now with REQ_SYNC, read and write has the same
>>priority, there is less request merge.
>>
>>Thanks,
>>Shaohua
> For harddisk,the read for not full-write will remarkly reduce the performance.
> So the first it to make write full-write as posible.

yes, this is the symptom, but I'd like to understand why REQ_SYNC makes
the difference.

Thanks,
Shaohua
