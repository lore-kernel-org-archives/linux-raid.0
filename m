From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: 2.6.10-ac10 + 2.6.10udm1 + latest evms => not nice
Date: Fri, 21 Jan 2005 12:05:02 -0600
Message-ID: <200501211205.02213.kevcorry@us.ibm.com>
References: <87brbinaey.87acr2naey@878y6mnaey.message.id> <20050121144738.GM25714@marowsky-bree.de> <200501210901.11031.kevcorry@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-admin@lists.sourceforge.net>
In-Reply-To: <200501210901.11031.kevcorry@us.ibm.com>
Content-Disposition: inline
Sender: evms-devel-admin@lists.sourceforge.net
Errors-To: evms-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
To: evms-devel@lists.sourceforge.net
Cc: Lars Marowsky-Bree <lmb@suse.de>, syrius.ml@no-log.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 21 January 2005 9:01 am, Kevin Corry wrote:
> On Friday 21 January 2005 8:47 am, Lars Marowsky-Bree wrote:
> > This looks like md on DM breakage, which Jens has just fixed in our
> > kernel. I'm not sure whether he has submitted it upstream yet, but you
> > can give it a try.
> >
> > Does the attached patch apply & fix the problem for you?
> >
> >    If md resides on top of a driver using bio_clone() (such as dm), it
> > will oops the kernel due to md submitting a botched bio that has a
> > veclist but doesn't have bio->bi_max_vecs set.
>
> Is there a specific scenario that causes the kernel to oops if an MD device
> is made of DM devices? EVMS has been using this kind of configuration for a
> couple years, and we've never noticed a problem with it. Also, syrius
> mentioned on IRC that this problem only started occurring with -ac10, and
> that -ac8 worked fine. I'm checking out the diffs between those two
> versions to see what else might have changed.

Ok, here's the excerpt from the -ac10 patch that probably exposed the bug in 
MD. So it looks like a cloned bio no longer uses the original bio's bvec, 
which makes Lars' explination make a bit more sense. :) So, try Lars' patch 
with your -ac10 kernel and see if that fixes it. If so, we should forward 
that to Alan and make sure he includes it. I'll also check the latest -mm and 
-bk to see if these patches need to be merged upstream before 2.6.11 final.


diff -Naurp linux-2.6.10-ac9/fs/bio.c linux-2.6.10-ac10/fs/bio.c
--- linux-2.6.10-ac9/fs/bio.c 2004-12-24 15:35:00.000000000 -0600
+++ linux-2.6.10-ac10/fs/bio.c 2005-01-21 08:50:27.000000000 -0600
@@ -98,12 +98,7 @@ void bio_destructor(struct bio *bio)
 
  BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
 
- /*
-  * cloned bio doesn't own the veclist
-  */
- if (!bio_flagged(bio, BIO_CLONED))
-  mempool_free(bio->bi_io_vec, bp->pool);
-
+ mempool_free(bio->bi_io_vec, bp->pool);
  mempool_free(bio, bio_pool);
 }
 
@@ -210,7 +205,9 @@ inline int bio_hw_segments(request_queue
  */
 inline void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
- bio->bi_io_vec = bio_src->bi_io_vec;
+ request_queue_t *q = bdev_get_queue(bio_src->bi_bdev);
+
+ memcpy(bio->bi_io_vec, bio_src->bi_io_vec, bio_src->bi_max_vecs * 
sizeof(struct bio_vec));
 
  bio->bi_sector = bio_src->bi_sector;
  bio->bi_bdev = bio_src->bi_bdev;
@@ -222,21 +219,9 @@ inline void __bio_clone(struct bio *bio,
   * for the clone
   */
  bio->bi_vcnt = bio_src->bi_vcnt;
- bio->bi_idx = bio_src->bi_idx;
- if (bio_flagged(bio, BIO_SEG_VALID)) {
-  bio->bi_phys_segments = bio_src->bi_phys_segments;
-  bio->bi_hw_segments = bio_src->bi_hw_segments;
-  bio->bi_flags |= (1 << BIO_SEG_VALID);
- }
  bio->bi_size = bio_src->bi_size;
-
- /*
-  * cloned bio does not own the bio_vec, so users cannot fiddle with
-  * it. clear bi_max_vecs and clear the BIO_POOL_BITS to make this
-  * apparent
-  */
- bio->bi_max_vecs = 0;
- bio->bi_flags &= (BIO_POOL_MASK - 1);
+ bio_phys_segments(q, bio);
+ bio_hw_segments(q, bio);
 }
 
 /**
@@ -248,7 +233,7 @@ inline void __bio_clone(struct bio *bio,
  */
 struct bio *bio_clone(struct bio *bio, int gfp_mask)
 {
- struct bio *b = bio_alloc(gfp_mask, 0);
+ struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
 
  if (b)
   __bio_clone(b, bio);

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/


-------------------------------------------------------
This SF.Net email is sponsored by: IntelliVIEW -- Interactive Reporting
Tool for open source databases. Create drag-&-drop reports. Save time
by over 75%! Publish reports on the web. Export to DOC, XLS, RTF, etc.
Download a FREE copy at http://www.intelliview.com/go/osdn_nl
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
