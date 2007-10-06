From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH -mm 0/4] raid5: stripe_queue (+20% to +90% write performance)
Date: Sat, 06 Oct 2007 10:06:39 -0700
Message-ID: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Here is the latest spin of the 'stripe_queue' implementation.  Thanks to
raid6+bitmap testing done by Mr. James W. Laferriere there have been
several cleanups and fixes since the last release.  Also, the changes
are now spread over 4 patches to isolate one conceptual change per
patch.  The most significant cleanup is removing the stripe_head back
pointer from stripe_queue.  This effectively makes the queuing layer
independent from the caching layer.

Expansion support needs more testing.

See the individual patch changelogs for details.  Patch 1 contains
updated performance numbers.

Andrew,

These are updated in the git-md-accel tree, but I will work the
finalized versions through Neil's 'Signed-off-by' path.

Dan Williams (4):
      raid5: add the stripe_queue object for tracking raid io requests (rev3)
      raid5: split allocation of stripe_heads and stripe_queues
      raid5: convert add_stripe_bio to add_queue_bio
      raid5: use stripe_queues to prioritize the "most deserving" requests (rev7)

 drivers/md/raid5.c         | 1560 ++++++++++++++++++++++++++++++++------------
 include/linux/raid/raid5.h |   88 ++-
 2 files changed, 1200 insertions(+), 448 deletions(-)

--
Dan
