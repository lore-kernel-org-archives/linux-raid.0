From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Raid5 to raid6 reshape or recreate?
Date: Wed, 13 Aug 2014 12:25:21 -0500
Message-ID: <CABY_QbU4KWwtqp-TfOz13QMO134WA1J7i5jEFDozwy8aQwV1QQ@mail.gmail.com>
References: <53EAB9F1.5030905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53EAB9F1.5030905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>.100G). I also took a fresh backup before the reshape and unmounted md0. Would it be faster if I trash the raid5 and create raid6 from scratch instead of reshape? Any guess on how much faster? I typically got 100+M on checkarray cron jobs. It would fire around 1-2AM and finish by 6-7AM on first Sun. Reshape has been running more than a day and has only about 45% done.
>>
>>
>>Creating a new array would be almost as fast as checkarray, much faster than reshape. Re-shape moves data around where when you create, it just writes parity blocks, so it's a lot faster.

So, it is the seek that kills the reshape. I know somewhere Neil had
said to use --layout switch to put Q parity on the new disk (and I do
not recall the exact switch value).
If we built the raid6 parity on the new drive and then did the
distribution, would it not be faster as we will simply be swapping two
(or more) blocks on the same stripe.
So there will be less seek. Also we will be protected at raid6 level
during this swap.

On a slightly different topic, will it be faster after a disk
fail/replacement as opposed to raid reshaping? I am asking because
when a disk fails, the other drives are likely to be aged also. If we
juggle them around this much for a couple of days (or more), are we
not risking more fails? In other words, by choosing this method are we
not increasing
our chances of failure?

Also on a different note, is there a reason to compute parity for
unused stripes? Would it not be possible to keep a list of written
stripes much like as SSD? Is this the bitmap?

Ramesh
