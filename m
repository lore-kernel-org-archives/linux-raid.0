From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Date: Mon, 24 Nov 2008 15:47:51 +1100
Message-ID: <18730.12791.348848.849033@notabene.brown>
References: <20081124035516.3465.66413.stgit@notabene.brown>
	<20081124035530.3465.26724.stgit@notabene.brown>
	<20081124042421.GY28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Viro on Monday November 24
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Monday November 24, viro@ZenIV.linux.org.uk wrote:
> On Mon, Nov 24, 2008 at 02:55:30PM +1100, NeilBrown wrote:
> > Between the call
> >    __blkdev_get->get_gendisk->kobj_lookup->md_probe
> > and the call
> >    __blkdev_get->md_open
> > 
> > there is no obvious way to hold a reference on the mddev any more, so
> > unless something is done, it will disappear and gendisk will be
> > destroyed prematurely.
> > 
> > Also, once we decide to destroy the mddev, there will be an unlockable
> > moment before the gendisk is unlinked (blk_unregister_region) during
> > which a new reference to the gendisk can be created.  We need to
> > ensure that this reference can not be used.  i.e. the ->open must
> > fail.
> > 
> > So:
> >  1/  in md_probe we set a flag in the mddev (hold_active) which
> >      indicates that the array should be treated as active, even
> >      though there are no references, and no appearance of activity.
> >      This is cleared by md_release when the device is closed.
> >      This ensure that the gendisk will survive between md_probe and
> >      md_open.

Thanks for the reply.

> 
> That won't work.  Note that you are not guaranteed that md_release() will be
> called after md_probe(); there are failure exits in __blkdev_get() that do
> not reach ->open() at all.

I thought about those failure exits and concluded that they are the
sort the almost never happen in practice (I think -ENOMEM is the only
credible error) and the consequence is only that the gendisk will hang
around a until some future open/close, so it is no worse that the
current situation.
Resolving that would be nice but I didn't feel up to any major surgery.

> 
> What lifetime rules do you really want?  I never liked the tricks pulled
> by md wrt gendisk lifetimes and that might be a good time to sort that
> out for good...

I'm not sure what 'tricks' you are referring to.  Can you elaborate?

I want the gendisk to appear as soon as it is needed (not because I
think that is necessarily a good idea, but it is legacy functionality that I
don't think we can easily discard).  And I want them to disappear when
they contain no information and have nothing referring to them.

> 
> What should happen to things like pending IO, etc. on array destruction?
> AFAICS, that's the real question...

Pending IO should not be a possibility thanks to the sync_blockdev call
in __blkdev_put.
During that last close, nothing can generate new IO, and any old IO
will be flushed (won't it?).

NeilBrown
