From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md
 array.
Date: Mon, 1 Nov 2004 21:33:33 -0800
Message-ID: <20041101213333.201769d0.akpm@osdl.org>
References: <20041102143440.12019.patches@notabene>
	<E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
	<20041101205735.5fc68d69.akpm@osdl.org>
	<20041101210044.20c4a8e0.akpm@osdl.org>
	<16775.3329.279178.375487@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16775.3329.279178.375487@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids


(Added Jens)

Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
> On Monday November 1, akpm@osdl.org wrote:
> > Andrew Morton <akpm@osdl.org> wrote:
> > >
> > > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > > >
> > > > As the unplug timer can potentially fire at any time, and
> > > >  and it access data that is released by the md ->stop function,
> > > >  we need to del_timer_sync before releasing that data.
> > > 
> > > raid really shouldn't know about unplug_timer.
> > > 
> > 
> > I mean, if we're actually destroying the queue then blk_cleanup_queue()
> > should have done the right thing here.  If we're not destroying the queue
> > then an unplug timer expiry should be benign.
> > 
> > Bit confused as to what's happening here.
> 
> Not surprising.  It's a bit ugly.
> 
> md has the misfortune of working in a way that doesn't fit very well
> with some aspects of the blkdev layer.
> 
> To create an md array, you open /dev/mdX, and use some ioctls to set
> up the array.  Thus the block device must exist internally as a block
> device before any details about it are available.
> 
> Similarly, to shut down an array, you open /dev/mdX and use an ioctl
> to shut it down.  This it will still be open (though only once) after
> it has been shut down.
> 
> (as I understand it) I can only safely use blk_cleanup_queue on the
> queue after (or during) the last close.  Thus I cannot use it while
> shutting down an array.
> However I need to release the md personality as part of shutting down
> the array, so I have to disable the unplug function (which is handled
> by the personality).
> 
> I could change ->unplug_fn to point to something safe, but there is
> still a race with the timer going off at just the wrong time.

hm, OK.  So perhaps using /dev/mdX as a control channel for creating and
destroying /dev/mdX was unfortunate design.  Ho hum.

> Maybe an API that allowed by to change ->make_request_fn and
> ->unplug_fn (and possibly others) and then call some interface, and be
> sure that no internal use of those functions would occur after given
> interface was called.
> This interface could then just do the del_timer_sync.

Something like that would be nicer, I think - a centralised point with
nicely apologetic commentary rather than mysterious open-coded poking at
block internals ;)

