From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:44:03 +1100
Message-ID: <20110217084403.46b4d8ee@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5C2776.2080609@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C2776.2080609@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 14:37:26 -0500 Phil Turmel <philip@turmel.org> wrote:

> Hi Neil,
> 
> On 02/16/2011 05:27 AM, NeilBrown wrote:
> > 
> > I all,
> >  I wrote this today and posted it at
> > http://neil.brown.name/blog/20110216044002
> > 
> > I thought it might be worth posting it here too...
> > 
> > NeilBrown
> > 
> > 
> > -------------------------
> > 
> > 
> > It is about 2 years since I last published a road-map[1] for md/raid
> > so I thought it was time for another one.  Unfortunately quite a few
> > things on the previous list remain undone, but there has been some
> > progress.
> > 
> > I think one of the problems with some to-do lists is that they aren't
> > detailed enough.  High-level design, low level design, implementation,
> > and testing are all very different sorts of tasks that seem to require
> > different styles of thinking and so are best done separately.  As
> > writing up a road-map is a high-level design task it makes sense to do
> > the full high-level design at that point so that the tasks are
> > detailed enough to be addressed individually with little reference to
> > the other tasks in the list (except what is explicit in the road map).
> > 
> > A particular need I am finding for this road map is to make explicit
> > the required ordering and interdependence of certain tasks.  Hopefully
> > that will make it easier to address them in an appropriate order, and
> > mean that I waste less time saying "this is too hard, I might go read
> > some email instead".
> > 
> > So the following is a detailed road-map for md raid for the coming
> > months.
> > 
> > [1] http://neil.brown.name/blog/20090129234603
> > 
> > Bad Block Log
> > -------------
> [trim /]
> > Bitmap of non-sync regions.
> > ---------------------------
> [trim /]
> 
> It occurred to me that if you go to the trouble (and space and performance)
> to create and maintain metadata for lists of bad blocks, and separate
> metadata for sync status aka "trim", or hot-replace status, or reshape-status,
> or whatever features are dreamt up later, why not create an infrastructure to
> carry all of it efficiently?
> 
> David Brown suggested a multi-level metadata structure.  I concur, but somewhat
> more generic:
> 	Level 1:  Coarse bitmap, set bit indicates 'look at level 2'
> 	Level 2:  Fine bitmap, set bit indicates 'look at level 3'
> 	Level 3:  Extent list, with starting block, length, and feature payload
> 
> The bitmap levels are purely for hot-path performance.
> 
> As an option, it should be possible to spread the detailed metadata through the
> data area, possibly in chunk-sized areas spread out at some user-defined
> interval.  "meta-span", perhaps.  Then resizing partitions that compose an
> array would be less likely to bump up against metadata size limits.  The coarse
> bitmap should stay near the superblock, of course.

This is starting to sound a lot more like a filesystem than a RAID system.

I really don't want there to be so much metadata that I am tempted to spread
it out among the data.  I think that implies too much complexity.

Maybe that is a good place to draw the line:  If some metadata doesn't fit
easily at the start of end of the devices, it has no place in RAID - you
should add it to a filesystem instead.


> 
> Personally, I'd like to see the bad-block feature actually perform block
> remapping, much like hard drives themselves do, but with the option to unmap the
> block if a later write succeeds.  Using one retry per array restart as you
> described makes a lot of sense.  In any case, remapping would retain redundancy
> where applicable short of full drive failure or remap overflow.

If the hard drives already do this, why should md try to do it as well??
If a hard drive has had some many write errors that it has used up all of its
spare space, then it is long past time to replace it.


> 
> My $0.02, of course.

Here in .au, the smallest legal tender is $0.05 - but thanks anyway :-)

NeilBrown

> 
> Phil

