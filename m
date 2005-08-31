From: jmerkey <jmerkey@utah-nac.org>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 31 Aug 2005 09:59:39 -0600
Message-ID: <4315D3EB.4000601@utah-nac.org>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de> <20050829202529.GA32214@midnight.suse.cz> <Pine.LNX.4.61.0508301919250.25574@diagnostix.dwd.de> <20050831071126.GA7502@midnight.ucw.cz> <20050831072644.GF4018@suse.de> <Pine.LNX.4.61.0508311029170.16574@diagnostix.dwd.de> <20050831120714.GT4018@suse.de> <Pine.LNX.4.61.0508311339140.16574@diagnostix.dwd.de> <20050831162053.GG4018@suse.de> <4315C9EB.2030506@utah-nac.org> <20050831171124.GH4018@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050831171124.GH4018@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Vojtech Pavlik <vojtech@suse.cz>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


512 is not enough. It has to be larger. I just tried 512 and it still 
limits the data rates.

Jeff


Jens Axboe wrote:

>On Wed, Aug 31 2005, jmerkey wrote:
>  
>
>>I have seen an 80GB/sec limitation in the kernel unless this value is 
>>changed in the SCSI I/O layer
>>for 3Ware and other controllers during testing of 2.6.X series kernels.
>>
>>Change these values in include/linux/blkdev.h and performance goes from 
>>80MB/S to over 670MB/S on the 3Ware controller.
>>
>>
>>//#define BLKDEV_MIN_RQ    4
>>//#define BLKDEV_MAX_RQ    128    /* Default maximum */
>>#define BLKDEV_MIN_RQ    4096
>>#define BLKDEV_MAX_RQ    8192    /* Default maximum */
>>    
>>
>
>That's insane, you just wasted 1MiB of preallocated requests on each
>queue in the system!
>
>Please just do
>
># echo 512 > /sys/block/dev/queue/nr_requests
>
>after boot for each device you want to increase the queue size too. 512
>should be enough with the 3ware.
>
>  
>

