From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11
Date: Mon, 22 Aug 2005 15:55:34 +0200
Message-ID: <62b0912f050822065547a70a8e@mail.gmail.com>
References: <1124050204.3810.28.camel@localhost.localdomain>
	 <C0A1E607B5206F88D89CAF42@192.168.1.22>
	 <62b0912f0508220347135352ea@mail.gmail.com>
	 <1124711771.774.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1124711771.774.50.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pallai Roland wrote:
> Molle Bestefich wrote:
> > Claas Hilbrecht wrote:
> > > Pallai Roland schrieb:
> > > >  this is a feature patch that implements 'proactive raid5 disk
> > > > replacement' (http://www.arctic.org/~dean/raid-wishlist.html),
> > >
> > > After my experience with a broken raid5 (read the list) I think the
> > > "partially failed disks" feature you describe is really useful. I agree
> > > with you that this kind of error is rather common.
> >
> > Horrible idea.
> > Once you have a bad block on one disk, you have definitively lost your
> > data redundancy.
> > That's bad.
>
>  Hm, I think you don't understand the point, yes, that should be
> replaced as soon as you can, but the good sectors of that drive can be
> useful if some bad sectors are discovered on an another drive during the
> rebuilding. we must keep that drive in sync to keep that sectors useful,
> this is why the badblock tolerance is.

Ok, I misunderstood you.  Sorry, and thanks for the explanation.

>  It is the common error if you've lot of disks and can't do daily media
> checks because of the IO load.

Agreed.

> > What should be done about bad blocks instead of your suggestion is to
> > try and write the data back to the bad block before kicking the disk.
> > If this succeeds, and the data can then be read from the failed block,
> > the disk has automatically reassigned the sector to the spare sector
> > area.  You have redundancy again and the bad sector is "fixed".
> >
> > If you're having a lot of problems with disks getting kicked because
> > of bad blocks, then you need to diagnose some more to find out what
> > the actual problem is.
> >
> > My best guess would be that either you're using an old version of MD
> > that won't try to write to bad blocks, or the spare area on your disk
> > is full, in which case it should be replaced.  You can check the
> > status of spare areas on disks with 'smartctl' or similar.
>
>  Which version of md tries to rewrite bad blocks in raid5?

Haven't followed the discussions closely, but I sure hope that the
newest version does.  (After all, spare areas are a somewhat old
feature in harddrives..)

>  I've problem with "hidden" bad blocks (never mind if that's repairable
> or not), the rewrite can't help, cause you don't know if that's there
> until you don't try to rebuild the array from degraded state to a
> replaced disk. I want to avoid from the rebuiling from degraded state,
> this is why the 'proactive replacement' feature is.

Got it now.  Super.  Sounds good ;-).
(I hope that you're simply rebuilding to a spare before kicking the
drive, not doing something funky like remapping sectors or some
such..)
