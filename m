From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3 v3] raid1: prevent merging too large request
Date: Wed, 4 Jul 2012 16:01:16 +0800
Message-ID: <CANejiEUN6_bUuZ+SqSRw-38A3rrn6fxrqAs=nk9G4wc6r7=CCQ@mail.gmail.com>
References: <20120702010840.197370335@kernel.org>
	<20120702011037.466764171@kernel.org>
	<20120704155907.560607d4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120704155907.560607d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

2012/7/4 NeilBrown <neilb@suse.de>:
> On Mon, 02 Jul 2012 09:08:43 +0800 Shaohua Li <shli@kernel.org> wrote:
>
>> For SSD, if request size exceeds specific value (optimal io size), request size
>> isn't important for bandwidth. In such condition, if making request size bigger
>> will cause some disks idle, the total throughput will actually drop. A good
>> example is doing a readahead in a two-disk raid1 setup.
>>
>> So when we should split big request? We absolutly don't want to split big
>> request to very small requests. Even in SSD, big request transfer is more
>> efficient. Below patch only consider request with size above optimal io size.
>>
>> If all disks are busy, is it worthy to do split? Say optimal io size is 16k,
>> two requests 32k and two disks. We can let each disk run one 32k request, or
>> split the requests to 4 16k requests and each disk runs two. It's hard to say
>> which case is better, depending on hardware.
>>
>> So only consider case where there are idle disks. For readahead, split is
>> always better in this case. And in my test, below patch can improve > 30%
>> thoughput. Hmm, not 100%, because disk isn't 100% busy.
>>
>> Such case can happen not just in readahead, for example, in directio. But I
>> suppose directio usually will have bigger IO depth and make all disks busy, so
>> I ignored it.
>>
>> Note: if the raid uses any hard disk, we don't prevent merging. That will make
>> performace worse.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>> ---
>>  drivers/md/raid1.c |   46 ++++++++++++++++++++++++++++++++++++++--------
>>  drivers/md/raid1.h |    1 +
>>  2 files changed, 39 insertions(+), 8 deletions(-)
>>
>> Index: linux/drivers/md/raid1.c
>> ===================================================================
>> --- linux.orig/drivers/md/raid1.c     2012-06-29 15:17:09.160691540 +0800
>> +++ linux/drivers/md/raid1.c  2012-06-29 15:57:54.993943576 +0800
>> @@ -489,6 +489,7 @@ static int read_balance(struct r1conf *c
>>       unsigned int min_pending;
>>       struct md_rdev *rdev;
>>       int choose_first;
>> +     int choose_idle;
>>
>>       rcu_read_lock();
>>       /*
>> @@ -502,6 +503,7 @@ static int read_balance(struct r1conf *c
>>       best_dist = MaxSector;
>>       min_pending = -1;
>>       best_good_sectors = 0;
>> +     choose_idle = 0;
>>
>>       if (conf->mddev->recovery_cp < MaxSector &&
>>           (this_sector + sectors >= conf->next_resync))
>> @@ -580,16 +582,35 @@ static int read_balance(struct r1conf *c
>>               nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
>>               pending = atomic_read(&rdev->nr_pending);
>>               dist = abs(this_sector - conf->mirrors[disk].head_position);
>> -             if (choose_first
>> -                 /* Don't change to another disk for sequential reads */
>> -                 || conf->mirrors[disk].next_seq_sect == this_sector
>> -                 || dist == 0
>> -                 /* If device is idle, use it */
>> -                 || pending == 0) {
>> -                     best_disk = disk;
>> -                     break;
>> +             if (choose_first)
>> +                     goto done;
>> +             /* Don't change to another disk for sequential reads */
>> +             if (conf->mirrors[disk].next_seq_sect == this_sector
>> +                 || dist == 0) {
>> +                     int opt_iosize = bdev_io_opt(rdev->bdev) >> 9;
>> +                     struct mirror_info *mirror = &conf->mirrors[disk];
>> +
>> +                     /*
>> +                      * If buffered sequential IO size exceeds optimal
>> +                      * iosize and there is idle disk, choose idle disk
>> +                      */
>> +                     if (nonrot && opt_iosize > 0 && choose_idle == 0 &&
>> +                         mirror->seq_start != MaxSector &&
>> +                         mirror->next_seq_sect > opt_iosize &&
>> +                         mirror->next_seq_sect - opt_iosize >=
>> +                         mirror->seq_start) {
>> +                             choose_idle = 1;
>> +                             best_disk = disk;
>> +                             continue;
>> +                     }
>> +                     goto done;
>>               }
>> +             /* If device is idle, use it */
>> +             if (pending == 0 && (!choose_idle || nonrot))
>> +                     goto done;
>
> That doesn't make sense to me.
> Ignoring the nonrot bit, it says:
>    if (this device is idle, and we haven't decided to choose an idle device)
>         then choose this device

The variable maybe misleading. choose_idle means an seq read
hit optimal request size in a disk and we check if other disks are idle.
In this case, we only consider idle disks.

> which is wrong.
>
> Also, what about the case where an idle device is found before we we find a
> device that the sequentially-previous read was from.  Will that still do the
> right thing?  It isn't clear.

This doesn't matter. Then the first disk will run, the second disk will idle.
When the first disk seq request exceeds optimal size, the second disk
will run.

Thanks,
Shaohua
