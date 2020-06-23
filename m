From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 18:16:51 -0500
Message-ID: <40bf8a08-61a6-2b50-b9c6-240e384de80d@gmail.com>
References: <rco1i8$1l34$1@ciao.gmane.io>
 <24305.24232.459249.386799@quad.stoffel.home>
 <1ba7c1be-4cb1-29a5-d49c-bb26380ceb90@gmail.com>
 <24306.29793.40893.422618@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24306.29793.40893.422618@quad.stoffel.home>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/23/20 4:30 PM, John Stoffel wrote:
> Well, as you add LVM volumes to a VG, I don't honestly know offhand if
> the areas are pre-allocated, or not, I think they are pre-allocated,
> but if you add/remove/resize LVs, you can start to get fragmentation,
> which will hurt performance.

LVs are pre-allocated, and they definitely can become fragmented.
That's orthogonal to whether the VG is on a single RAID device or a
set of smaller adjacent RAID devices.

> No, you still do not want the partitioned setup, becuase if you lose a
> disk, you want to rebuild it entirely, all at once.  Personally, 5 x
> 8Tb disks setup in RAID10 with a hot spare sounds just fine to me.
> You can survive a two disk failure if it doesn't hit both halves of
> the mirror.  But the hot spare should help protect you.

It depends on what sort of failure you're trying to protect against.  If
you lose the entire disk (because of an electronic/mechanical failure,
for example) your doing either an 8TB rebuild/resync or (for example)
16x 512GB rebuild/resyncs, which is effectively the same thing.

OTOH, if you have a patch of sectors go bad in the partitioned case,
the RAID layer is only going to automatically rebuild/resync one of the
partition-based RAID devices.  To my thinking, this will reduce the
chance of a double-failure.

I think it's important to state that this NAS is pretty actively
monitored/managed.  So if such a failure were to occur, I would
absolutely be taking steps to retire the drive with the failed sectors.
But that's something that I'd rather do manually, rather than kicking
off (for example) and 8TB rebuild with a hot-spare.

> One thing I really like to do is mix vendors in my array, just so I
> dont' get caught by a bad batch.  And the RAID10 performance advantage
> over RAID6 is big.  You'd only get 8Tb (only! :-) more space, but much
> worse interactive response.

Mixing vendors (or at least channels) is one of those things that I
know that I should do, but I always get impatient.

But do I need the better performance.  Choices, choices ...  :-)

> Physics sucks, don't it?  :-)

LOL!  Indeed it does!
> 
> What I do is have a pair of mirrored SSDs setup to cache my RAID1
> arrays, to give me more performance.  Not really sure if it's helping
> or hurting really.  dm-cache isn't really great at reporting stats,
> and I never bothered to test it hard.

I've played with both bcache and dm-cache, although it's been a few
years.  Neither one really did much for me, but that's probably because
I was using write-through caching, as I didn't trust "newfangled" SSDs
at the time.

> My main box is an old AMD Phenom(tm) II X4 945 Processor, which is now
> something like 10 years old.  It's fast enough for what I do.  I'm
> more concerned with data loss than I am performance.

Same here.  I mainly want to feel comfortable that I haven't crippled my
performance by doing something stupid, but as long as the NAS can stream
a movie to media room it's good enough.

My NAS has an Atom D2550, so it's almost certainly slower than your
Phenom.

> Get a bigger case then.  :-)

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================
