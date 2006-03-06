From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 performance question
Date: Tue, 7 Mar 2006 09:24:26 +1100
Message-ID: <17420.46746.365629.168649@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Monday March 6
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday March 6, raziebe@gmail.com wrote:
> Neil Hello .
> I have a performance question.
> 
> I am using raid5 stripe size 1024K over 4 disks.

I assume you mean a chunksize of 1024K rather than a stripe size.
With a 4 disk array, the stripe size will be 3 times the chunksize,
and so could not possibly by 1024K.

> I am benchmarking it with an asynchronous tester.
> This tester submits 100 IOs of size of 1024 K --> as the stripe size.
> It reads raw io from the device, no file system is involved.
> 
> I am making the following comparsion:
> 
> 1. Reading 4 disks at the same time using 1 MB buffer in random manner.
> 2. Reading 1 raid5 device using 1MB buffer in random manner.

If your chunk size is 1MB, then you will need larger sequential reads
to get good throughput.

You can also try increasing the size of the stripe cache in
   /sys/block/mdX/md/stripe_cache_size

The units are in pages (normally 4K) per device.  The default is 256 which fits
only one stripe with a 1 Meg chunk size.

Try 1024 ?

NeilBrown


> 
> I am getting terrible results in scenario 2. if scenario 1 gives 120 MB/s from
> 4 disks, the raid5 device gives 35 MB/s .
> it is like i am reading a single disk , but by looking at iostat i can
> see that all
> disks are active but with low throughput.
> 
> Any idea ?
> 
> Thank you.
> --
> Raz
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
