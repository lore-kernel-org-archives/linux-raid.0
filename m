From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Fri, 24 Jan 2014 02:24:09 -0600
Message-ID: <52E22329.7070903@hardwarefreak.com>
References: <20140121073540.GF10140@merlins.org>	<20140121163755.GG10140@merlins.org>	<52DF7976.6070808@hardwarefreak.com>	<20140122174854.GF26014@merlins.org>	<52E051A3.3050103@hardwarefreak.com>	<21217.9977.5869.747472@quad.stoffel.home>	<52E1BB9D.5000204@hardwarefreak.com> <20140124140729.6cf73745@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140124140729.6cf73745@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Stoffel <john@stoffel.org>, Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/23/2014 9:07 PM, NeilBrown wrote:
> On Thu, 23 Jan 2014 19:02:21 -0600 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> On 1/23/2014 8:28 AM, John Stoffel wrote:
>>
>>> But more importantly, maybe it would make sense to have this number
>>> automatically scale with memory size?  If you only have 1gig stay at
>>> 256, but then jump more aggresively to 1024, 2048, 4196 and 8192 and
>>> then (for now) capping at 8192.  
>>
>> Setting the default based strictly on memory capacity won't work.  See
>> this discussion for background.
>>
>> http://www.spinics.net/lists/raid/msg45364.html
>>
> 
> I would like to see the stripe cache grow on demand, shrink when idle, and
> use the "shrinker" interface to shrink even when not idle if there is memory
> pressure.
> So if someone wants a project....
> 
> NeilBrown


I'm a user, not a kernel hacker, and I don't know C.  Three strikes
right there. :(  Otherwise I'd love to tackle it.  I do have some
comments/ideas on the subject.

Progressively growing and shrinking the cache should be relatively
straightforward.  We can do it dynamically today by modifying a system
variable.  What's needed is code to track data input volume or rate to
md and to interface with the shrinker.

I think the difficult aspect of this will be determining the upper bound
on the cache size for a given system, as the optimum cache size directly
correlates to the throughput of the hardware.  With the current power of
2 restrictions, less than thorough testing indicates that disk based
arrays seem to prefer a value of 1024-2048 for max throughput whereas
SSD arrays seem to prefer 4096.  In either case, going to the next legal
value decreases throughput and eats double the RAM while doing so.

So here we need some way to determine device throughput or at least
device class, and set an upper bound accordingly.  I also think we
should consider unhitching our wagon from powers of 2 if we're going to
be dynamically growing/shrinking the cache.  I think grow/shrink should
be progressive with smaller jumps.  With 5 drives growing from 2048 to
4096 is going to grab 40MB of pages, likewise dumping 40MB for the
impending shrink iteration, then 20MB, 10MB, and finally dumping 5MB
arriving back at the 1MB/drive default.  This may cause a lot of memory
thrashing on some systems and workloads, evicting application data from
L2/L3 caches.  So we may want to be careful about how much memory we're
shuffling and how often.

-- 
Stan


