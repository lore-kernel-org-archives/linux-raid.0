From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Question about resync in RAID5
Date: Mon, 22 Apr 2013 11:16:13 +0200
Message-ID: <20130422091612.GB26360@frosties>
References: <20130416102452.GC25795@cthulhu.home.robinhill.me.uk>
 <4915289.2.1366127167165.JavaMail.root@zimbra>
 <20130416165522.GA14744@cthulhu.home.robinhill.me.uk>
 <CANsebLH0PcjV2nmcQ0TmEE_8XxF6pi53baSenV3qKwdRxioK+Q@mail.gmail.com>
 <20130422101552.4eed452c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130422101552.4eed452c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Robin Dong <robin.k.dong@gmail.com>, robin@robinhill.me.uk, linux-raid@vger.kernel.org, Tao Ma <tm@tao.ma>
List-Id: linux-raid.ids

On Mon, Apr 22, 2013 at 10:15:52AM +1000, NeilBrown wrote:
> On Wed, 17 Apr 2013 12:29:07 +0800 Robin Dong <robin.k.dong@gmail.com> wrote:
> 
> > 2013/4/17 Robin Hill <robin@robinhill.me.uk>
> > >
> > > On Tue Apr 16, 2013 at 05:46:07PM +0200, Roy Sigurd Karlsbakk wrote:
> > >
> > > > > > Is there any method to just resync WRITTEN data to new-added-disk ?
> > > > > > Or any developing plan to add this feature?
> > > > >
> > > > > No, because md is a block device it has no knowledge of what data has
> > > > > actually been written to the disk or where it is stored. This means it
> > > > > has to rebuild the entire disk.
> > > > >
> > > > > There are plans to improve this by keeping track of which stripes have
> > > > > been written to, which should help (and will also mean no need for an
> > > > > initial RAID sync). I don't know whether this has progressed beyond
> > > > > the idea stage yet though.
> > > >
> > > > Interesting - do you have any docs about this? I haven't seen any talk
> > > > on this list about it...
> > > >
> > > It's from Neil's 2011 MD/RAID roadmap:
> > >     http://neil.brown.name/blog/20110216044002
> > >
> > > The basic idea was mentioned in a 2009 roadmap as well, but is a lot
> > > more fleshed out in the above one.
> > 
> > 
> > Hi, Neil
> > 
> > Has anyone began to develope non-sync-bitmap feature? If not, I want to
> > take a chance.
> > Will the non-sync-bitmap be built on the write-intent-bitmap or I need to
> > create a new bitmap in 'array state info' of v1.x metadata?
> > 
> 
> Hi Robin et al,
> 
> No, no implementation has been started.
> 
> You cannot use the same bits as the write intent bitmap as they mean
> something different.  But you could possibly use the same storage space.
> i.e. have an alternate style of bitmap where there are two bits per 'chunk'.
> One bit maps "this was written recently, a resync might be needed after a
> crash" and the other means "This has been written since array create, so the
> chunk needs to be recovered to any spare".
> 
> I don't know if this is the best approach - I haven't really thought about it
> much.
> 
> There are several parts to this:
> 
>  1/ decide how to store the new bitmap on disk, and implement that
>  2/ decide how to store the new bitmap in memory and implement that.
>     It might be the same...
>  3/ Set a bit in the new bitmap on each write (if it isn't set), and
>     trigger a resync of that chunk.
>  4/ Update the recovery process for each level to honour this new bit
>  5/ Allow "discard" operations to clear these bits.
> 
> If you do proceed with this,  feel free to post a more concrete design before
> proceeding to code - or just post code if you prefer.
> 
> NeilBrown

I would suggest using two bitmaps instead of one with 2bits per chunk. Why?

- possibly different granularity for each bitmap
- write/rewrite of blocks independent of first write/discard, they
  change with different frequency. Esspecially when discarding from a
  cron job instead on-the-fly through the FS.

Maybe not even use a bitmap for discard. Some tree form that would be
able to handle both block sized chunks being discarded and gigabytes
of continious space being in the same state. Something that uses a
bitmap for parts that fragment down to block sized chunks and segments
for continious blocks.

MfG
	Goswin
