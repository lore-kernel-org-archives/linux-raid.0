From: NeilBrown <neilb@suse.de>
Subject: Re: Latency issues with MD-RAID
Date: Wed, 2 Mar 2011 09:04:16 +1100
Message-ID: <20110302090416.4ed26e03@notabene.brown>
References: <FE279AF0CA06284B8C26150408F3EB12078DB4AA@CBSSEXM02P.crossbeamsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FE279AF0CA06284B8C26150408F3EB12078DB4AA@CBSSEXM02P.crossbeamsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jansen, Frank" <fjansen@CROSSBEAMSYS.COM>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 1 Mar 2011 21:13:46 +0000 "Jansen, Frank" <fjansen@CROSSBEAMSYS.COM>
wrote:

> We're doing some testing to determine performance of MD-RAID and suitability for our environment.

RAID0 ? RAID1?  RAID5 ? 
It helps to be specific.

> 
> One particular test is giving some cause for concern:
> 
> - Run heavy I/O to a raw partition:
>  # time dd if=/dev/zero of=/dev/md0p1 bs=131072 count=1000000
> - Run single sync I/Os to the partition:
>  # time dd if=/dev/zero of=/dev/md0p1 bs=4096 count=1 oflag=sync
> 
> When we run this, latency for the single I/O completion can go as high as 5-10 seconds
> 
> In investigating this, it looks like the following code in md_write_start causes most of the slow down:
> 
>         if (mddev->in_sync) {
>                 spin_lock_irq(&mddev->write_lock);
>                 if (mddev->in_sync) {
>                         mddev->in_sync = 0;
>                         set_bit(MD_CHANGE_CLEAN, &mddev->flags);
>                         set_bit(MD_CHANGE_PENDING, &mddev->flags);
>                         md_wakeup_thread(mddev->thread);
>                         did_change = 1;
>                 }
>                 spin_unlock_irq(&mddev->write_lock);
>         }
> 
> When we change this to run about once every 10 seconds, our latency goes way down to a reasonable number of milliseconds.

What did you change exactly.

This code can be tuned by changing
   /sys/block/mdXXX/md/safe_mode_timeout
which is measured in seconds and is the delay before marking a clean array
dirty.

> 
> Questions:
> - is the high latency for single sync I/Os something that we should expect?

Not necessarily.

> - the first time the thread runs, it was seen to take a lot longer.  Is this due to more outstanding metadata or similar?

No idea without a lot more details.  What is "the thread"?  How much is "a
lot longer"?


> - is the approach to run the thread less frequently reasonable, or does that open up huge problems?

Seeing you have said exactly what you mean by "run the thread less
frequently", that is a very hard question to answer.

NeilBrown



> 
> Thanks,
> 
> Frank
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

