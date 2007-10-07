From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH -mm 0/4] raid5: stripe_queue (+20% to +90% write performance)
Date: Sun, 7 Oct 2007 10:30:28 -0700
Message-ID: <e9c3a7c20710071030n1770f330y81ebce4311a79f40@mail.gmail.com>
References: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
	 <Pine.LNX.4.64.0710061434090.30060@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710061434090.30060@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: neilb@suse.de, akpm@linux-foundation.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/6/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Sat, 6 Oct 2007, Dan Williams wrote:
>
> > Neil,
> >
> > Here is the latest spin of the 'stripe_queue' implementation.  Thanks to
> > raid6+bitmap testing done by Mr. James W. Laferriere there have been
> > several cleanups and fixes since the last release.  Also, the changes
> > are now spread over 4 patches to isolate one conceptual change per
> > patch.  The most significant cleanup is removing the stripe_head back
> > pointer from stripe_queue.  This effectively makes the queuing layer
> > independent from the caching layer.
> >
> > Expansion support needs more testing.
> >
> > See the individual patch changelogs for details.  Patch 1 contains
> > updated performance numbers.
> >
> > Andrew,
> >
> > These are updated in the git-md-accel tree, but I will work the
> > finalized versions through Neil's 'Signed-off-by' path.
> >
> > Dan Williams (4):
> >      raid5: add the stripe_queue object for tracking raid io requests (rev3)
> >      raid5: split allocation of stripe_heads and stripe_queues
> >      raid5: convert add_stripe_bio to add_queue_bio
> >      raid5: use stripe_queues to prioritize the "most deserving" requests (rev7)
> >
> > drivers/md/raid5.c         | 1560 ++++++++++++++++++++++++++++++++------------
> > include/linux/raid/raid5.h |   88 ++-
> > 2 files changed, 1200 insertions(+), 448 deletions(-)
> >
> > --
> > Dan
>
> These patches & data look very impressive, do we have an ETA of when they
> will be merged into mainline?
>
> Justin.

The short answer is "when they are ready."  Jim reported that he is
seeing bonnie++ get stuck in D state on his platform, so the debug is
ongoing.  Additional testing is always welcome...

--
Dan
