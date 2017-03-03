From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 3/3] md/raid5: sort bios
Date: Fri, 3 Mar 2017 09:59:09 -0800
Message-ID: <20170303175909.q2t2hoxsorjhk77k@kernel.org>
References: <cover.1487373517.git.shli@fb.com>
 <01c6067566d787a815fc29aa07b36ad4dd0280f0.1487373517.git.shli@fb.com>
 <87k287m3d6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k287m3d6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

On Fri, Mar 03, 2017 at 02:43:49PM +1100, Neil Brown wrote:
> On Fri, Feb 17 2017, Shaohua Li wrote:
> 
> > Previous patch (raid5: only dispatch IO from raid5d for harddisk raid)
> > defers IO dispatching. The goal is to create better IO pattern. At that
> > time, we don't sort the deffered IO and hope the block layer can do IO
> > merge and sort. Now the raid5-cache writeback could create large amount
> > of bios. And if we enable muti-thread for stripe handling, we can't
> > control when to dispatch IO to raid disks. In a lot of time, we are
> > dispatching IO which block layer can't do merge effectively.
> >
> > This patch moves further for the IO dispatching defer. We accumulate
> > bios, but we don't dispatch all the bios after a threshold is met. This
> > 'dispatch partial portion of bios' stragety allows bios coming in a
> > large time window are sent to disks together. At the dispatching time,
> > there is large chance the block layer can merge the bios. To make this
> > more effective, we dispatch IO in ascending order. This increases
> > request merge chance and reduces disk seek.
> 
> I can see the benefit of batching and sorting requests.
> 
> I wonder if the extra complexity of grouping together 512 requests, then
> submitting the "first" 128 is really worth it.  Have you measured the
> value of that?

I'm pretty sure I tried. The whole point of dispatching the first 128 is we
don't have a better pipeline. Grouping 512 and then dispatching them together
definitely improve the IO patter, but the request accumulation takes time, we
will have no IO running in the window.

> If you just submitted every time you got 512 requests, you could use
> list_sort() on the bio list and wouldn't need an array.
> 
> If an array really is best, it would be really nice if "sort" could pass
> a 'void*' down to the cmp function,
> and it could sort all bios that are
> *after* last_bio_pos first, and then the others.  That would make the
> code much simpler.  I guess sort() could be changed (list_sort() already
> has a 'priv' argument like this).

Ok, I'll change this to a list. And add extra pointer to record the last sorted
entry. I didn't see the sort uses much time in my profile, but the merge sort
looks better. Will do the change.

> If we cannot change sort(), then maybe use lib/bsearch.c for the binary
> search.  Performing two comparisons in the loop of a binary search
> should get a *fail* in any algorithms class!!
> The "pending_data" array that you have added to the r5conf structure
> adds 4096 bytes.  This means it is larger than a page, which is best
> avoided (though it is unlikely to cause problems).  I would allocate it
> separately.

Yep, already fixed internally.

> 
> So there is a lot that I don't really like, but it seems like a good
> idea in principle.

ok, thanks for your time!

Thanks,
Shaohua
