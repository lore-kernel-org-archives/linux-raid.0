From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 16:26:37 +0200
Message-ID: <20070718142637.GG13772@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan> <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan> <469DF8D3.8020908@theendofthetunnel.de> <20070718125116.GB29835@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070718125116.GB29835@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 18, 2007 at 01:51:16PM +0100, Robin Hill wrote:

> Just to pick up on this one (as I'm about to reformat my array as XFS) -
> does this actually work with a hardware controller?  Is there any
> assurance that the XFS stripes align with the hardware RAID stripes?  Or
> could you just end up offsetting everything so that every 128k chunk on
> the XFS side of things fits half-and-half into two hardware raid chunks
> (especially if the array has been partitioned)?

If you partition the device and does not explicitely align the
partitions on a stripe boundary then you'll get that effect. Also if you
do not use partitions but use LVM instead, then the stripe size should
be a power of 2 meaning the number of data disks should also be a power
of 2 to get the best performance.

> In which case would
> it be better (performance-wise) to provide the su,sw values or not?

Only testing can tell... But if one logical file system block spans
multiple stripes then you will lose some performance; if that will be
noticable or not depends on your usage pattern.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
