From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v3 1/5] raid5: make release_stripe lockless
Date: Wed, 28 Aug 2013 22:29:08 +0800
Message-ID: <20130828142908.GA6355@kernel.org>
References: <20130827095038.303090029@kernel.org>
 <20130827095427.324728970@kernel.org>
 <20130828140422.GC9295@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130828140422.GC9295@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, dan.j.williams@gmail.com
List-Id: linux-raid.ids

On Wed, Aug 28, 2013 at 10:04:22AM -0400, Tejun Heo wrote:
> Hello, Shaohua.
> 
> On Tue, Aug 27, 2013 at 05:50:39PM +0800, Shaohua Li wrote:
> > release_stripe still has big lock contention. We just add the stripe to a llist
> > without taking device_lock. We let the raid5d thread to do the real stripe
> > release, which must hold device_lock anyway. In this way, release_stripe
> > doesn't hold any locks.
> > 
> > The side effect is the released stripes order is changed. But sounds not a big
> > deal, stripes are never handled in order. And I thought block layer can already
> > do nice request merge, which means order isn't that important.
> 
> I wrote this before but the order of requests is an important
> information to the elevator and the existing elevators will behave
> less effectively if you make the relative order and timing of
> processed IOs deviate from the original issuer's and the effect could
> be very noticeable depending on the workload and stacking drivers
> should always strive to preserve as much IO characteristics.
> 
> It doesn't make the changes unacceptable or anything but the patch
> description is quite misleading.  It'd be nice if you at least can
> note that the implemented behavior is far from optimal in the comment
> and description.

This order issue is fixed in the second patch.

It's true making raid5 multi-threading might change order, I mentioned this in
the third patch (the direct impact is request size)

Thanks,
Shaohua
