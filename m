From: Joey Liao <joeyliao@qnap.com>
Subject: Re: Why does raid0 set max_hw_sectors as chunk size but the other
 raid types doesn't?
Date: Thu, 2 Jun 2016 17:30:25 +0800
Message-ID: <CAHvN=in+xM68+1+326cOFCNb+H-ZOX6HKPHMFkTRsfws6BM1+Q@mail.gmail.com>
References: <CAHvN=in80JrXO=tDyxNhq9d_wW1ZCCioENyTLu9tYuYYDof20w@mail.gmail.com>
	<87lh2op5mi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lh2op5mi.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi NeilBrown,

Thanks for your kindly reply.

Originally, I doubt that would it affect the performance or not, but I
agree with your point.

Thanks.

2016-06-02 12:38 GMT+08:00 NeilBrown <nfbrown@novell.com>:
> On Mon, May 30 2016, Joey Liao wrote:
>
>> Hi,
>>
>> I have no idea why does raid0_run() in raid0.c use
>> blk_queue_max_hw_sectors() to set max_hw_sectors as the chunk size,
>> but the other raid types doesn't?
>
> git is your friend.... admittedly you need the 'history' git tree to go
> back before 2.6.12, but it is available.
>
> http://git.kernel.org/cgit/linux/kernel/git/history/history.git/commit/?id=f556ef000efc90a45a285f4f0b4fd70bb70f
>
>
>
>>
>> What's the purpose to limit the max_hw_sectors in raid0?
>
> unfortunately the commit doesn't answer that question.  I think it was
> to ensure requests larger than one chunk were not created.  If they were
> they would just have to be split, so there is no much to gain.
>
>>
>> Is it related to the source code logic issue or the performance issue?
>>
>> Besides, I have an interesting observation. If I remove all the
>> following queue limitation codes in raid0_run() of raid0.c, the block
>> size in iostat is still the same as chunk size even the input block
>> size is much larger than the chunk size. Why???
>
> Because when you write to a RAID0 you *must* divide each request up into
> chunk-sizes sub-requests, and send them to different devices.
>
> NeilBrown
>
>
>>
>> -  blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>> -  blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>> +  //blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>> +  //blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>>
>> -  blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
>> -  blk_queue_io_opt(mddev->queue,
>> -                 (mddev->chunk_sectors << 9) * mddev->raid_disks);
>> +  //blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
>> +  /*blk_queue_io_opt(mddev->queue,
>> +              (mddev->chunk_sectors << 9) * mddev->raid_disks);*/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
