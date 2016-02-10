From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Thu, 11 Feb 2016 00:13:45 +0200
Message-ID: <20160210221345.GB2461@reaktio.net>
References: <1670804.QnHtKWfib8@nell>
 <22200.46449.482559.914441@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <22200.46449.482559.914441@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Thomas Fjellstrom <thomas@fjellstrom.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 08, 2016 at 10:34:09AM -0500, John Stoffel wrote:
> 
> Thomas> I'm planning on setting up a dual raid5 array for hosting vm's
> Thomas> off LVM, I would like to add an ssd cache to help with typical
> Thomas> server system loads, and some mixed read/write loads for game
> Thomas> servers.
> 
> Thomas> I'm wondering what the "best" route for me to go is. There's a
> Thomas> few options that I know of, like flashcache, dm-cache, and
> Thomas> bcache. The question is which of those is better suited to my
> Thomas> use case?
> 
> I looked into both bcache and lvmcache and went with lvmcache because
> it made more sense to me.  But one restriction is that the cache LVs
> must be in the same VGs as the volume to cache.  So you might need to
> partition your SSD(s) and put the partitions into seperate VGs so that
> you can cache one or more LVs.
> 
> I'm using it at home to cache a RAID1 4tb VG, with a pair of mirrored
> SSDs.  I'm a big believer in mirroring, esp for critical stuff like
> this.
> 
> Unfortunately, I don't have a good performance measurements of how
> much help this actually gives me.  It *feels* faster, but since I
> don't have before/after measurements, I could just have wasted a bunch
> of money.
> 
> So I'd recommend lvmcache overall, since it does seem to help, but
> push for better performance metrics and measurement.  Heh, maybe it's
> time for me to start writing up lvmcachetop to help measure things.
> 

The other day I was benchmarking lvmcache (on CentOS 7.2),
but I couldn't get it to give much advantage for writeback caching use case.. 
even when I was using fast nvme/pcie cache device.

It just wouldn't cache writes properly for me. I tried both the smq and mq, 
and played with all of the parameters.. it just wouldn't help much for my use case.

YMMV.

> John


-- Pasi

