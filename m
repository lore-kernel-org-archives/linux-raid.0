From: Neil Brown <neilb@suse.de>
Subject: Re: suns raid-z / zfs
Date: Mon, 18 Feb 2008 21:51:15 +1100
Message-ID: <18361.25379.998485.63488@notabene.brown>
References: <20080217160403.GA15710@rap.rap.dk>
	<18361.1168.473685.214133@notabene.brown>
	<20080218053319.GA18863@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Monday February 18
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 18, keld@dkuug.dk wrote:
> On Mon, Feb 18, 2008 at 03:07:44PM +1100, Neil Brown wrote:
> > On Sunday February 17, keld@dkuug.dk wrote:
> > > Hi
> > > 
> > 
> > > It seems like a good way to avoid the performance problems of raid-5
> > > /raid-6
> > 
> > I think there are better ways.
> 
> Interesting! What do you have in mind?

A "Log Structured Filesystem" always does large contiguous writes.
Aligning these to the raid5 stripes wouldn't be too hard and then you
would never have to do any pre-reading.

> 
> and what are the problems with zfs?

Recovery after a failed drive would not be an easy operation, and I
cannot imagine it being even close to the raw speed of the device.

> 
> > > 
> > > But does it stripe? One could think that rewriting stripes
> > > other places would damage the striping effects.
> > 
> > I'm not sure what you mean exactly.  But I suspect your concerns here
> > are unjustified.
> 
> More precisely. I understand that zfs always write the data anew.
> That would mean at other blocks on the partitions, for the logical blocks
> of the file in question. So the blocks on the partitions will not be
> adjacant. And striping will not be possible, generally.

The important part of striping is that a write is spread out over
multiple devices, isn't it.

If ZFS can choose where to put each block that it writes, it can
easily choose to write a series of blocks to a collection of different
devices, thus getting the major benefit of striping.


NeilBrown
