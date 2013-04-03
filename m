From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 03 Apr 2013 16:15:38 -0500
Message-ID: <515C9BFA.2010701@hardwarefreak.com>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com> <515C73B3.5060704@arcor.de>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515C73B3.5060704@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Peter Landmann <sfrazt@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/3/2013 1:23 PM, Martin Wilck wrote:
> On 04/03/2013 03:18 PM, Stan Hoeppner wrote:
> 
>> You didn't mention your stripe_cache_size value.  It'll make a lot of
>> difference.  Make sure it's at least 4096.  The default is 256.

Actually, the default is 128, not 256, at least with 3.2.6.  Not sure
about previous/later versions.

> I'm not getting it - why would stripe cache size matter in a random
> read/write test? 

It's very similar to the effect of a greater quantity of write back
cache on a hardware RAID controller.  Which is why it dramatically
affects write throughput but not read.  I believe the proper way to view
this is as a temporary workspace, where md can assemble the stripes to
be written out to the block layer, and store chunks which are read in
for RMW cycles.  As with many things in computing, increasing the size
of this working space allows the md driver to work more efficiently.
See below for exactly how it works.

> If the disks are large enough and the pattern is really
> random, the cache should hardly ever be hit (s_c_z = 4096 =^ 16MB cache
> per disk, that's 0.01% of disk size for a 160GB SSD).

You seem to be assuming the md "stripe cache" functions like some kind
of generic dumb filesystem cache.  It does not.

> I read that Peter confirmed the influence of stripe_cache_size, but I'd
> like to understand why it matters in this case.

If you think the throughput increase in this thread is impressive, see:
 http://marc.info/?l=linux-raid&m=136241443706663&w=2

About half way down there is a table showing the effects of
stripe_cache_size from 2048 to 32768.  Write throughput increased over
600MB/s, from 1018MB/s to 1628MB/s, simply by increasing
stripe_cache_size from 2048 to 4096, and decreased as the stripe cache
was made larger.  Thus every system has a sweet spot.  This was with 5
Intel 500GB SSDs w/the SandForce 2281 controller, attached to an LSI
9207-8i.  md/RAID5

I'd love to explain exactly how the stripe cache works, but to do that I
must first understand it.  And I've been unable to find documentation
describing the inner workings of the stripe cache.  And since I'm
neither a C nor kernel programmer, I can't look at the code and
understand it, nor then write a document for others.  So if you really
want that explanation you'll need to start another thread and bribe Neil
into explaining it.

-- 
Stan

