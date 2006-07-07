From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Fri, 7 Jul 2006 18:15:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607071814510.8499@p34.internal.lan>
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

Hey!  You're awake :)

I am going to try it with just 64kb to prove to myself it works with that, 
but then I will re-create the raid5 again like I had it before and attempt 
it again, I did not see that documented anywhere!! Also, how do you use 
the --backup-file option? Nobody seems to know!
