From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: if (stripe_cache_size =< chunk_size) { BUG() }
Date: Tue, 26 Jun 2007 07:41:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706260741100.6396@p34.internal.lan>
References: <Pine.LNX.4.64.0706260704050.6396@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706260704050.6396@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is some kind of bug, also tried with 256 KiB, it ran 2 tests 
(bonnie++) OK but then on the third, BANG, bonnie++ is now in D-state, 
pretty nasty bug there.

On Tue, 26 Jun 2007, Justin Piszcz wrote:

> If you set the stripe_cache_size less than or equal to the chunk size of the 
> SW RAID5 array, the processes will hang in D-state indefinitely until you 
> change the stripe_cache_size to > chunk_size.
>
> Tested with 2.6.22-rc6 and a 128 KiB RAID5 Chunk Size, when I set it to 256 
> KiB, no problems.  128 KiB and below cause issues.
>
> Justin.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
