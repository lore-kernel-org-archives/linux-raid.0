From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/8] raid5: add a per-stripe lock
Date: Thu, 7 Jun 2012 14:29:39 +0800
Message-ID: <20120607062939.GA779@kernel.org>
References: <20120604080152.098975870@kernel.org>
 <20120604080300.519377228@kernel.org>
 <20120607105410.415d9fe6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120607105410.415d9fe6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, Jun 07, 2012 at 10:54:10AM +1000, NeilBrown wrote:
> On Mon, 04 Jun 2012 16:01:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > Add a per-stripe lock to protect stripe specific data, like dev->read,
> > written, ... The purpose is to reduce lock contention of conf->device_lock.
> 
> I'm not convinced that you need to add a lock.
> I am convinced that if you do add one you need to explain exactly what it is
> protecting.
> 
> The STRIPE_ACTIVE bit serves as a lock and ensures that only one process can
> be in handle_stripe at a time.
> So I don't think dev->read actually needs any protection (though I haven't
> checked thoroughly).
> 
> I think the only things that device_lock protects are things shared by
> multiple stripes, so adding a per-stripe spinlock isn't going to help remove
> device_lock.

This sounds not true to me. both the async callbacks and request completion
access stripe data, like dev->read. Such things are not protected by
STRIPE_ACTIVE bit. Thought we can delete STRIPE_ACTIVE bit with stripe lock
introduced.
