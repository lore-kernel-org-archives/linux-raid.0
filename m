From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH -mm 0/4] raid5: stripe_queue (+20% to +90% write performance)
Date: Sat, 6 Oct 2007 14:34:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710061434090.30060@p34.internal.lan>
References: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, akpm@linux-foundation.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 6 Oct 2007, Dan Williams wrote:

> Neil,
>
> Here is the latest spin of the 'stripe_queue' implementation.  Thanks to
> raid6+bitmap testing done by Mr. James W. Laferriere there have been
> several cleanups and fixes since the last release.  Also, the changes
> are now spread over 4 patches to isolate one conceptual change per
> patch.  The most significant cleanup is removing the stripe_head back
> pointer from stripe_queue.  This effectively makes the queuing layer
> independent from the caching layer.
>
> Expansion support needs more testing.
>
> See the individual patch changelogs for details.  Patch 1 contains
> updated performance numbers.
>
> Andrew,
>
> These are updated in the git-md-accel tree, but I will work the
> finalized versions through Neil's 'Signed-off-by' path.
>
> Dan Williams (4):
>      raid5: add the stripe_queue object for tracking raid io requests (rev3)
>      raid5: split allocation of stripe_heads and stripe_queues
>      raid5: convert add_stripe_bio to add_queue_bio
>      raid5: use stripe_queues to prioritize the "most deserving" requests (rev7)
>
> drivers/md/raid5.c         | 1560 ++++++++++++++++++++++++++++++++------------
> include/linux/raid/raid5.h |   88 ++-
> 2 files changed, 1200 insertions(+), 448 deletions(-)
>
> --
> Dan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

These patches & data look very impressive, do we have an ETA of when they 
will be merged into mainline?

Justin.
