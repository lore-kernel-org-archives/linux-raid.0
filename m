From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Mon, 10 Jul 2006 17:47:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607101747160.2603@p34.internal.lan>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
 <Pine.LNX.4.64.0607071037190.5153@p34.internal.lan> <17582.55703.209583.446356@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17582.55703.209583.446356@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 8 Jul 2006, Neil Brown wrote:

> On Friday July 7, jpiszcz@lucidpixels.com wrote:
>>>>
>>>> Jul  7 08:44:59 p34 kernel: [4295845.933000] raid5: reshape: not enough
>>>> stripes.  Needed 512
>>>> Jul  7 08:44:59 p34 kernel: [4295845.962000] md: couldn't update array
>>>> info. -28
>>>>
>>>> So the RAID5 reshape only works if you use a 128kb or smaller chunk size?
>>>>
>>
>> Neil,
>>
>> Any comments?
>>
>
> Yes.   This is something I need to fix in the next mdadm.
> You need to tell md/raid5 to increase the size of the stripe cache
> before the grow can proceed.  You can do this with
>
>  echo 600 > /sys/block/md3/md/stripe_cache_size
>
> Then the --grow should work.  The next mdadm will do this for you.
>
> NeilBrown
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
md3 : active raid5 sdc1[7] sde1[6] sdd1[5] hdk1[2] hdi1[4] hde1[3] hdc1[1] 
hda1[0]
       2344252416 blocks super 0.91 level 5, 512k chunk, algorithm 2 [8/8] 
[UUUUUUUU]
       [>....................]  reshape =  0.2% (1099280/390708736) 
finish=1031.7min speed=6293K/sec

It is working, thanks!

