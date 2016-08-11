From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PATCH] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Wed, 10 Aug 2016 20:44:53 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608102035180.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Ming Lin <mlin@kernel.org>, Vlad-Cosmin Miu <miuvlad@gmail.com>, rjones@redhat.com, Kent Overstreet <kent.overstreet@gmail.com>, jmoyer@redhat.com, axboe@fb.com, Sebastian Roesner <sroesner-kernelorg@roesner-online.de>, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 10 Apr 2016 20:01:30 +0200, Sebastian Roesner wrote:
> Am 01.04.2016 um 20:14 schrieb Eric Wheeler:
> > On Mon, 28 Mar 2016, Shaohua Li wrote:
> > > On Sat, Mar 26, 2016 at 05:46:16PM +0100, Sebastian Roesner wrote:
> > > > Hello Ming, Eric,
> > > > 
> > > > Am 26.03.2016 um 16:40 schrieb Ming Lei:
> > > > I was able to reproduce it on a non-productive system, but only after
> > > > copying the bcache superblocks/partition starts from the original system,
> > > > with new created ones it worked fine.
> > >
> > > 320 bvecs exceeds what bio-clone_set can handle. Could you please try below patch?
> > >
> > Hey Sebastian,
> > 
> > Have you had a chance to test the patch below from Shaohua Li?
> 
> I just tried the patch and it did not crash anymore.
 
Hello all,

It doesn't look like this made it into v4.8-rc1 and it is known to fix at 
least Sebastian's issue.

Can this get into v4.8?

--
Eric Wheeler


commit 92761dad7ff6e1bf25de247e0064dd398e797599
Author: Shaohua Li <shli@fb.com>
Date:   Mon Mar 28 10:54:35 2016 -0700

    block: don't make BLK_DEF_MAX_SECTORS too big
    
    bio_alloc_bioset() allocates bvecs from bvec_slabs which can only allocate
    maximum 256 bvec (eg, 1M for 4k pages). We can't bump BLK_DEF_MAX_SECTORS to
    exceed this value otherwise bio_alloc_bioset will fail.
    
    This fixes commit 30e2bc08b2bb7c069. We probably should make the bvec_slabs
    hold bigger bvecs if bigger bio size is required.
    
    Signed-off-by: Shaohua Li <shli@fb.com>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7e5d7e0..da64325 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1153,7 +1153,11 @@ extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
 	BLK_SAFE_MAX_SECTORS	= 255,
-	BLK_DEF_MAX_SECTORS	= 2560,
+	/*
+	 * if you change this, please also change bvec_alloc and BIO_MAX_PAGES.
+	 * Otherwise bio_alloc_bioset will break.
+	 */
+	BLK_DEF_MAX_SECTORS	= BIO_MAX_SECTORS,
 	BLK_MAX_SEGMENT_SIZE	= 65536,
 	BLK_SEG_BOUNDARY_MASK	= 0xFFFFFFFFUL,
 };
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
