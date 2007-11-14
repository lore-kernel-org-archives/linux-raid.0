From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Date: Tue, 13 Nov 2007 19:43:25 -0800
Message-ID: <20071114034325.GA25558@kroah.com>
References: <20071022171426.31103.patches@notabene> <20071114002214.GA31928@kroah.com> <20071114002308.GB31928@kroah.com> <e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, M@suse.de, linux-kernel@vger.kernel.org, Stable <stable@kernel.org>
List-Id: linux-raid.ids


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2007 at 08:36:05PM -0700, Dan Williams wrote:
> On Nov 13, 2007 5:23 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Nov 13, 2007 at 04:22:14PM -0800, Greg KH wrote:
> > > On Mon, Oct 22, 2007 at 05:15:27PM +1000, NeilBrown wrote:
> > > >
> > > > It appears that a couple of bugs slipped in to md for 2.6.23.
> > > > These two patches fix them and are appropriate for 2.6.23.y as well
> > > > as 2.6.24-rcX
> > > >
> > > > Thanks,
> > > > NeilBrown
> > > >
> > > >  [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
> > > >  [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
> > >
> > > I don't see these patches in 2.6.24-rcX, are they there under some other
> > > subject?
> >
> > Oh nevermind, I found them, sorry for the noise...
> >
> 
> Careful, it looks like you cherry picked commit 4ae3f847 "md: raid5:
> fix clearing of biofill operations" which ended up misapplied in
> Linus' tree,  You should either also pick up def6ae26 "md: fix
> misapplied patch in raid5.c" or I can resend the original "raid5: fix
> clearing of biofill operations."
> 
> The other patch for -stable "raid5: fix unending write sequence" is
> currently in -mm.

Hm, I've attached the two patches that I have right now in the -stable
tree so far (still have over 100 patches to go, so I might not have
gotten to them yet if you have sent them).  These were sent to me by
Andrew on their way to Linus.  if I should drop either one, or add
another one, please let me know.

thanks,

greg k-h

--h31gzZEtNLTqOjlF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v1.0-metadata.patch"

From stable-bounces@linux.kernel.org Mon Oct 22 20:45:35 2007
From: akpm@linux-foundation.org
Date: Mon, 22 Oct 2007 20:45:11 -0700
Subject: md: fix an unsigned compare to allow creation of bitmaps with v1.0 metadata
To: torvalds@linux-foundation.org
Cc: neilb@suse.de, akpm@linux-foundation.org, stable@kernel.org
Message-ID: <200710230345.l9N3jB65030288@imap1.linux-foundation.org>


From: NeilBrown <neilb@suse.de>

patch 85bfb4da8cad483a4e550ec89060d05a4daf895b in mainline.

As page->index is unsigned, this all becomes an unsigned comparison, which
 almost always returns an error.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -274,7 +274,7 @@ static int write_sb_page(struct bitmap *
 			if (bitmap->offset < 0) {
 				/* DATA  BITMAP METADATA  */
 				if (bitmap->offset
-				    + page->index * (PAGE_SIZE/512)
+				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					return -EINVAL;

--h31gzZEtNLTqOjlF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="md-raid5-fix-clearing-of-biofill-operations.patch"

From stable-bounces@linux.kernel.org Mon Oct 22 20:45:44 2007
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Oct 2007 20:45:11 -0700
Subject: md: raid5: fix clearing of biofill operations
To: torvalds@linux-foundation.org
Cc: joel.bertrand@systella.fr, neilb@suse.de, akpm@linux-foundation.org, dan.j.williams@intel.com, stable@kernel.org
Message-ID: <200710230345.l9N3jC2M030292@imap1.linux-foundation.org>

From: Dan Williams <dan.j.williams@intel.com>

patch 4ae3f847e49e3787eca91bced31f8fd328d50496 in mainline.

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only checks
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joel Bertrand <joel.bertrand@systella.fr>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -377,7 +377,12 @@ static unsigned long get_stripe_work(str
 		ack++;
 
 	sh->ops.count -= ack;
-	BUG_ON(sh->ops.count < 0);
+	if (unlikely(sh->ops.count < 0)) {
+		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
+			"ops.complete: %#lx\n", pending, sh->ops.pending,
+			sh->ops.ack, sh->ops.complete);
+		BUG();
+	}
 
 	return pending;
 }
@@ -551,8 +556,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
 
 	return_io(return_bi);
 
@@ -2903,6 +2907,13 @@ static void handle_stripe6(struct stripe
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;

--h31gzZEtNLTqOjlF--
