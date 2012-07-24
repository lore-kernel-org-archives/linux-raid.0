From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid1 repair: sync_request() aborts if one of the drives has bad
 block recorded
Date: Tue, 24 Jul 2012 22:30:33 +0300
Message-ID: <CAGRgLy5FXG9gFgq+QR_OknhNVtEMuSj6d-Hso5PYcjaD2rzXcQ@mail.gmail.com>
References: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
	<20120716133753.1a34e149@notabene.brown>
	<CAGRgLy6JZXiHFg11Z-_3krj8iKp_Wk7X_wz8OyikyvhLpxzcxg@mail.gmail.com>
	<20120717111753.178d53d5@notabene.brown>
	<CAGRgLy6jDTGXu1Yk2tCnHKDVTfCKjA2P6L-qgrD8EcPb8gCaBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6jDTGXu1Yk2tCnHKDVTfCKjA2P6L-qgrD8EcPb8gCaBA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
apparently you decided not to apply that patch?

Thanks,
Alex.


On Tue, Jul 17, 2012 at 4:17 PM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Thanks for your comments, I got confused with the REQUESTED bit.
> I prepared the patch, with couple of notes:
>
> 1/ I decided to be more careful and schedule a write only in case of
> resync or repair. I was not sure whether we should try to correct bad
> blocks on device X, when device Y is recovering. Pls change it if you
> feel otherwise.
>
> 2/ I tested and committed the patch on top of ubuntu-precise 3.2.0-25.
> I looked at your "for-next" branch, and saw that there is some new
> code, which handles hot-replace, which I am not familiar with at this
> point.
>
> From 2cf85226e76ab7f5d3c2bfdb207244cd9ed7ae19 Mon Sep 17 00:00:00 2001
> From: Alex Lyakas <alex.bolshoy@gmail.com>
> Date: Tue, 17 Jul 2012 15:47:35 +0300
> Subject: [PATCH] RAID1: When doing resync or repair, attempt to correct bad
>  blocks, according to WriteErrorSeen policy
>
> Signed-off-by: Alex Lyakas <alex.bolshoy@gmail.com>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7af60ec..62e4f44 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2257,6 +2257,18 @@ static sector_t sync_request(struct mddev
> *mddev, sector_t sector_nr, int *skipp
>                                 bio->bi_rw = READ;
>                                 bio->bi_end_io = end_sync_read;
>                                 read_targets++;
> +                       } else if (!test_bit(WriteErrorSeen, &rdev->flags) &&
> +                               test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> +                               !test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
> +                               /*
> +                                * The device is suitable for reading (InSync),
> +                                * but has bad block(s) here. Let's try to correct them,
> +                                * if we are doing resync or repair. Otherwise, leave
> +                                * this device alone for this sync request.
> +                                */
> +                               bio->bi_rw = WRITE;
> +                               bio->bi_end_io = end_sync_write;
> +                               write_targets++;
>                         }
>                 }
>                 if (bio->bi_end_io) {
> =================================
>
> Final note: I noticed that badblocks_show() fails if there are too
> many bad blocks. It returns value larger than PAGE_SIZE, and then the
> following linux code complains:
> fs/sysfs/file.c:fill_read_buffer()
>         /*
>          * The code works fine with PAGE_SIZE return but it's likely to
>          * indicate truncated result or overflow in normal use cases.
>          */
>         if (count >= (ssize_t)PAGE_SIZE) {
>                 print_symbol("fill_read_buffer: %s returned bad count\n",
>                         (unsigned long)ops->show);
>                 /* Try to struggle along */
>                 count = PAGE_SIZE - 1;
>         }
>
> So I am not sure how to solve it, but it would be good for
> user/application to receive the full list of bad blocks. Perhaps
> application can pass fd via some ioctl (I feel you don't like ioctls),
> and then kernel can use vfs_write() to print all the bad blocks to the
> fd. Or simply return the bad blocks list through the ioctl output to
> mdadm, and mdadm would print them. Perhaps some other way.
>
> Thanks for your help!
> Alex.
>
>
> On Tue, Jul 17, 2012 at 4:17 AM, NeilBrown <neilb@suse.de> wrote:
>> On Mon, 16 Jul 2012 11:45:12 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
>> wrote:
>>
>>> Hi Neil,
>>> thanks for your comments.
>>>
>>> > I don't see that MD_RECOVERY_REQUESTED is really an issue is it?
>>> > We the wrong thing happen in any case where there just one device with no bad
>>> > block, and at least one device with a bad block.  In that case we want to
>>> > skip forward by the number of bad blocks, not skip to the end of the array.
>>>
>>> I think that MD_RECOVERY_REQUESTED has some meaning here. Because
>>> there are only two places where we increase "write_targets":
>>> Here:
>>>               } else if (!test_bit(In_sync, &rdev->flags)) {
>>>                       bio->bi_rw = WRITE;
>>>                       bio->bi_end_io = end_sync_write;
>>>                       write_targets ++;
>>> and
>>>       if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
>>>               /* extra read targets are also write targets */
>>>               write_targets += read_targets-1;
>>>
>>> So if we'll see a device that is not In_sync, we will increase
>>> write_targets and won't fall into that issue. That's why I was
>>> thinking to check for MD_RECOVERY_REQUESTED.
>>
>> But neither of the code segements you have identified depend on
>> MD_RECOVERY_REQUESTED.
>>
>> The problem occurs with resync/repair/check but not with recover.
>>
>>
>>>
>>> >
>>> > So this?
>>> >
>>> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> > index 240ff31..c443f93 100644
>>> > --- a/drivers/md/raid1.c
>>> > +++ b/drivers/md/raid1.c
>>> > @@ -2422,7 +2422,10 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
>>> >                 /* There is nowhere to write, so all non-sync
>>> >                  * drives must be failed - so we are finished
>>> >                  */
>>> > -               sector_t rv = max_sector - sector_nr;
>>> > +               sector_t rv;
>>> > +               if (min_bad > 0)
>>> > +                       max_sector = sector_nr + min_bad;
>>> > +               rv = max_sector - sector_nr;
>>> >                 *skipped = 1;
>>> >                 put_buf(r1_bio);
>>> >                 return rv;
>>> >
>>>
>>> I tested it and it works. However, I have a question: shouldn't we try
>>> to clear bad blocks during "repair" in particular or during any
>>> kind-of-sync in general?
>>
>> Thanks for testing.
>>
>>
>>>
>>> Because currently the following is happening:
>>> - In sync_request devices are selected as candidates for READs and for
>>> WRITEs (using various criteria)
>>> - Then we issue the READs and eventually end up in sync_request_write()
>>> - Here we schedule WRITEs (without consulting bad blocks or WriteErrorSeen bit)
>>> - In end_sync_write, we check if we can clear some bad blocks, and if
>>> yes, eventually we end up in handle_sync_write_finished(), where we
>>> clear bad blocks
>>>
>>> So getting back to sync_request(), the issue is this: if we consider a
>>> device for READs, we check for badblocks. If we find a badblock, we
>>> skip it and don't consider this device neither for READs nor for
>>> WRITEs. How about:
>>> - We consider a device for READs
>>> - If it has a bad block, we consider it for WRITEs instead (so we have
>>> a 3rd place where we consider the device for WRITE).
>>> - We may consult WriteErrorSeen bit as we do in normal make_request(),
>>> but not sure, because right now on sync path, we don't consult it
>>
>> Good point.
>> I think we should consider WriteErrorSeen here.  We don't currently consult
>> it in sync because we avoid bad blocks completely.
>> So you patch would become:
>>
>>   } else if (!test_bit(WriteErrorSeen, &rdev->flags)) {
>>          bio->bi_rw = WRITE;
>>          bio->bi_end_io = end_sync_write;
>>          write_targets++;
>>   }
>>
>> If you could confirm that works and resubmit it with a 'Signed-off-by:' line
>> I'll apply it.
>> Thanks.
>> I've already included my previous patch in my queue and tagged it for -stable.
>>
>> NeilBrown
>>
>>>
>>> So this patch:
>>> --- c:/work/code_backups/psp13/raid1.c  Sun Jul 15 16:39:07 2012
>>> +++ ubuntu-precise/source/drivers/md/raid1.c    Mon Jul 16 11:35:40 2012
>>> @@ -2385,20 +2385,25 @@
>>>                                         if (wonly < 0)
>>>                                                 wonly = i;
>>>                                 } else {
>>>                                         if (disk < 0)
>>>                                                 disk = i;
>>>                                 }
>>>                                 bio->bi_rw = READ;
>>>                                 bio->bi_end_io = end_sync_read;
>>>                                 read_targets++;
>>>                         }
>>> +                       else {
>>> +                               bio->bi_rw = WRITE;
>>> +                               bio->bi_end_io = end_sync_write;
>>> +                               write_targets ++;
>>> +                       }
>>>                 }
>>>                 if (bio->bi_end_io) {
>>>                         atomic_inc(&rdev->nr_pending);
>>>                         bio->bi_sector = sector_nr + rdev->data_offset;
>>>                         bio->bi_bdev = rdev->bdev;
>>>                         bio->bi_private = r1_bio;
>>>                 }
>>>         }
>>>         rcu_read_unlock();
>>>         if (disk < 0)
>>>
>>>
>>> I tested this patch (together with yours) and it cleared the bad
>>> blocks, but not sure what else I might be missing. My Linux kernel
>>> programming skills are still ... questionable.
>>>
>>> Thanks,
>>> Alex.
>>>
>>>
>>>
>>> >
>>> > Thanks,
>>> > NeilBrown
>>> >
>>
