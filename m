From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Fix data corruption when a degraded raid5 array is
	reshaped.
Date: Thu, 03 Jan 2008 16:40:52 -0700
Message-ID: <1199403652.9102.30.camel@dwillia2-linux.ch.intel.com>
References: <20080104094516.19216.patches@notabene>
	 A<1080103224636.19290@suse.de>
	 <1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Thu, 2008-01-03 at 16:00 -0700, Williams, Dan J wrote:
> On Thu, 2008-01-03 at 15:46 -0700, NeilBrown wrote:
> > This patch fixes a fairly serious bug in md/raid5 in 2.6.23 and
> 24-rc.
> > It would be great if it cold get into 23.13 and 24.final.
> > Thanks.
> > NeilBrown
> >
> > ### Comments for Changeset
> >
> > We currently do not wait for the block from the missing device
> > to be computed from parity before copying data to the new stripe
> > layout.
> >
> > The change in the raid6 code is not techincally needed as we
> > don't delay data block recovery in the same way for raid6 yet.
> > But making the change now is safer long-term.
> >
> > This bug exists in 2.6.23 and 2.6.24-rc
> >
> > Cc: stable@kernel.org
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Neil Brown <neilb@suse.de>
> >
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 

On closer look the safer test is:

	!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending).

The 'req_compute' field only indicates that a 'compute_block' operation
was requested during this pass through handle_stripe so that we can
issue a linked chain of asynchronous operations.

---

From: Neil Brown <neilb@suse.de>

md: Fix data corruption when a degraded raid5 array is reshaped.

We currently do not wait for the block from the missing device
to be computed from parity before copying data to the new stripe
layout.

The change in the raid6 code is not techincally needed as we
don't delay data block recovery in the same way for raid6 yet.
But making the change now is safer long-term.

This bug exists in 2.6.23 and 2.6.24-rc

Cc: stable@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5aad8c..e8c8157 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2865,7 +2865,8 @@ static void handle_stripe5(struct stripe_head *sh)
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3067,7 +3068,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);

