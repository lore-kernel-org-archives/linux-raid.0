From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 5/9 v2] raid5: reduce chance release_stripe() taking
 device_lock
Date: Thu, 21 Jun 2012 09:34:36 +0800
Message-ID: <20120621013436.GA9154@kernel.org>
References: <20120619015941.891400722@kernel.org>
 <20120619020124.124186362@kernel.org>
 <CABE8wwuX3KT4ryd2MN9V9+DUaMraAOnyOSW9GdDxoyidhQjgRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABE8wwuX3KT4ryd2MN9V9+DUaMraAOnyOSW9GdDxoyidhQjgRg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Wed, Jun 20, 2012 at 05:56:25PM -0700, Dan Williams wrote:
> On Mon, Jun 18, 2012 at 6:59 PM, Shaohua Li <shli@kernel.org> wrote:
> > release_stripe() is a place conf->device_lock is heavily contended. We take the
> > lock even stripe count isn't 1, which isn't required. On the on the other hand,
> > decreasing count first and taking lock if count is 0 can expose races:
> > 1. bewteen dec count and taking lock, another thread hits the stripe in cache,
> > so increase count. The stripe will be deleted from any list. In this case
> > stripe count isn't 0.
> > 2. between dec count and taking lock, another thread hits the stripe in cache
> > and release it. In this case the stripe is already in specific list. We do
> > list_move to adjust its position.
> > So both cases are fixable to me.
> >
> 
> These "1" and "2" comments no longer apply right?  atomic_dec_and_lock
> is equivalently safe to lock+dec_and_test.

Oh, I misunderstand atomic_dec_and_lock is dec and lock instead of lock and
dec, so there is no race. The other two deletion isn't required too. I'll
repost this patch.

Thanks,
Shaohua
