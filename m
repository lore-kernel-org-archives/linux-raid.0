From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 00/10] Simplify bio splitting and related code.
Date: Tue, 11 Apr 2017 19:51:57 -0700
Message-ID: <20170412025157.qlodbacq2afuvq6j@kernel.org>
References: <149136485390.25893.1797855041954158826.stgit@noble>
 <20170411170112.4txdyjdat63qpsi6@kernel.org>
 <871ssywmno.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871ssywmno.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 12, 2017 at 09:27:07AM +1000, Neil Brown wrote:
> On Tue, Apr 11 2017, Shaohua Li wrote:
> 
> > On Wed, Apr 05, 2017 at 02:05:50PM +1000, Neil Brown wrote:
> >> This is part of my little project to make bio splitting
> >> in Linux uniform and dead-lock free, in a way that will mean
> >> that we can get rid of all the bioset threads.
> >> 
> >> The basic approach is that when a bio needs to be split, we call
> >> bio_split(), bio_chain() and then generic_make_request().
> >> We then proceed to handle the remainder without further splitting.
> >> Recent changes to generic_make_request() ensure that this will
> >> be safe from deadlocks, providing each bioset is used only once
> >> in the stack.
> >> 
> >> This leads to simpler code in various places.  In particular, the
> >> splitting of bios that is needed to work around known bad blocks
> >> is now much less complex.  There is only ever one r1bio per bio.
> >> 
> >> As you can see from
> >>  10 files changed, 335 insertions(+), 540 deletions(-)
> >> there is a net reduction in code.
> >
> > Looks good and makes code simpler, applied, thanks Neil! The patch 1 and 6 need
> > comments in the code to explain how deadlock is avoided though. Care to send a
> > new patch?
> 
> It isn't clear to me what sort of comment you want, or where it should
> go.
> It might make sense to have a comment near bio_split() explaining how to
> use it (i.e. explaining the pattern used in various patches here), but
> I don't see what sort of comments would help in raid1.c or raid10.c
> ??

Both raid1.c and raid10.c have comments why we need offload the bio to
raid1d/raid10d to avoid deadlock before, we also have comments to explain why
we do bio_split() and then generic_make_request() before. Now these info are
lost, so I hope we can add it back why the new way (bio_split and follow
generic_make_request of next part) can avoid deadlock. That will be very
helpful for others.

Thanks,
Shaohua
