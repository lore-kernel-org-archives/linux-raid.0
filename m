From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Speed up reshape? (was Re: Cancel reshape?)
Date: Thu, 13 Jan 2011 13:44:11 +0000
Message-ID: <4D2F01AB.5090909@anonymous.org.uk>
References: <4D2D2BD2.7000601@anonymous.org.uk>	<4D2D32DF.9010002@anonymous.org.uk>	<20110112163258.699a6fe0@notabene.brown>	<4D2D41E4.1000109@anonymous.org.uk> <20110112170211.3e88fdcb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112170211.3e88fdcb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/01/2011 06:02, NeilBrown wrote:
> On Wed, 12 Jan 2011 05:53:40 +0000 John Robinson
[...]
> 1/ everything is read twice, once to back it up, once to relocate it.
>    That is unfortunate, but awkward to avoid.

OK... but why only one stripe at a time? I eventually worked out that 
the disc transactions (shown by iostat) were of 256KB at a time which is 
the chunk size of the array, and the ~120 transactions per second would 
relate to the spin speed of the discs, 7200rpm being 120 revolutions per 
second. Even at the slow end of the discs, there's at least 512KB of 
data per revolution, so slurping up at least a couple of revolutions' 
worth before rewriting it might save waiting for quite so many disc 
revolutions to finish.

I may test this by doing another in-place reshape, changing the chunk 
size to 512KB, which I expect will run at twice the speed of the reshape 
on 256KB chunks.

Also, would there be any way to allow the second read to come from cache 
rather than from the media surface again? Is this a side-effect of using 
O_DIRECT or something? Could O_DIRECT be used only for writing?

> 2/ try increasing the stripe_cache_size - it might help.

mdadm had already set it to 1071, I upped it to 8192, then 32768, but it 
didn't make any difference at all, and stripe_cache_active showed 8 or 
even 0 when I checked. I imagine this is because the in-place reshape 
needs to wait for writes to be sync'ed all the time (or written with 
O_DIRECT or whatever) so there's little or no scope for cacheing stripes 
outside the reshape process itself.

I'm now reshaping again, from 4 to 5 discs. That's whizzing along at a 
fairly healthy 35MB/s, which according to iostat breaks down as about 
50MB/s read from 4 drives and 35MB/s written to 5 drives and is as much 
as I could reasonably expect from these discs. stripe_cache_active shows 
~25000, CPU usage is 12% system, 14% iowait. I expect the speed to slow 
down a bit towards the end of the reshape, where the slowest of the 
drives can only manage 60MB/s streaming and the seeks between reading 
and writing are longer (further across the disc surface).

Anyway, quite apart from all my whingeing about the speed of the 
in-place reshape, it's all working perfectly which is after all the most 
important thing, so many thanks for all your hard work!

Cheers,

John.
