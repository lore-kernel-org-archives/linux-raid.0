From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 31 Mar 2010 12:26:22 +1100
Message-ID: <20100331122622.7c43ca88@notabene.brown>
References: <20100325113543.0e2124c5@notabene.brown>
	<20100325080108.GB20583@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100325080108.GB20583@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Mar 2010 09:01:08 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Thu, Mar 25, 2010 at 11:35:43AM +1100, Neil Brown wrote:
> >
> >       http://blogs.techrepublic.com.com/opensource/?p=1368
> >
> > The most significant thing I got from this was a complain in the comments
> > that managing md raid was too complex and hence error-prone.
> 
> well, i would not be upset by j. random jerk complaining in a blog
> comments, as soon as you make it one click you will find another one
> that complains because it is not is favorite colour :P

We can learn something from any opinion that different from our own.

It is clear to me that using mdadm requires a certain level of understanding
to be used effectively and safely.
I don't think that can be entirely address in mdadm: there is a place of a
higher level framework that encodes policies and gives advice.  But there is
still room to improve mdadm to make it more powerful, more informative, and
more forgiving.

> 
> > I see the issue as breaking down in to two parts.
> >  1/ When a device is hot plugged into the system, is md allowed to use it as
> >     a spare for recovery?
> >  2/ If md has a spare device, what set of arrays can it be used in if needed.
> >
> > A typical hot plug event will need to address both of these questions in
> > turn before recovery actually starts.
> >
> > Part 1.
> >
> >  A newly hotplugged device may have metadata for RAID (0.90, 1.x, IMSM, DDF,
> >  other vendor metadata) or LVM or a filesystem.  It might have a partition
> >  table which could be subordinate to or super-ordinate to other metadata.
> >  (i.e. RAID in partitions, or partitions in RAID).  The metadata may or may
> >  not be stale.  It may or may not match - either strongly or weakly -
> >  metadata on devices in currently active arrays.
> also the newly hotplugged device may have _data_ on it.
>

You mean completely raw data, no partitions, no filesystem structure etc?
Yes, that is possible.  People who are likely to handle devices like that
would choose more conservative configurations.

 
> >  Some how from all of that information we need to decide if md can use the
> >  device without asking, or possibly with a simple yes/no question, and we
> >  need to decide what to actually do with the device.
> how does the yes/no question part work?

I imagine an Email to the admin "Hey boss, I just noticed you plugged in a
drive that looks like it used to be part of some array.  We need a spare on
this other array and the new device is big enough.  Shall I huh huh huh?  Go
on let me..."

Then the admin can choose to run the command "make it so", or not.


> we can also make /usr/bin/md-create-spare ...

Yes, there is a place for something like that certainly.

NeilBrown
