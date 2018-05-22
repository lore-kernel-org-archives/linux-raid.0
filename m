From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] convert block layer to
	bioset_init()/mempool_init()
Date: Tue, 22 May 2018 15:09:34 -0400
Message-ID: <20180522190933.GA25904@redhat.com>
References: <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
	<20180521150439.GA19379@redhat.com>
	<61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
	<20180521151817.GA19454@redhat.com>
	<d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
	<20180521160907.GA19553@redhat.com>
	<20180521173724.GG11495@kmo-pixel>
	<20180521182427.GA20013@redhat.com>
	<20180521233855.GI11495@kmo-pixel>
	<20180522064118.GA18704@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180522064118.GA18704-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, neilb-IBi9RG/b67k@public.gmane.org, bacik-b10kYP2dOMg@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On Tue, May 22 2018 at  2:41am -0400,
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Mon, May 21, 2018 at 07:38:55PM -0400, Kent Overstreet wrote:
> > On Mon, May 21, 2018 at 02:24:32PM -0400, Mike Snitzer wrote:
> > > Every single data structure change in this series should be reviewed for
> > > unforeseen alignment consequences.  Jens seemed to say that is
> > > worthwhile.  Not sure if he'll do it or we divide it up.  If we divide
> > > it up a temp topic branch should be published for others to inspect.
> > > 
> > > Could be alignment hasn't been a historic concern for a bunch of the
> > > data structures changed in this series.. if so then all we can do is fix
> > > up any obvious potential for false sharing.
> > 
> > Honestly, I almost never worry about alignment... the very few times I do care,
> > I use __cacheline_aligned_in_smp.
> 
> And that generally is the right stratgey.  If Mike really doesn't want
> a change we can just open code the kmalloc for the bio set there, the
> important point is that we should not keep the old API around for no
> good reason.

Again, I never said I didn't want these changes.  I just thought it
worthwhile to mention the potential for alignment quirks arising.

Reality is false sharing is quite uncommon.  So my concern was/is pretty
niche and unlikely to be applicable.

That said, I did take the opportunity to look at all the DM structures
that were modified.  The bio_set and mempool_t structs are so large that
they span multiple cachelines as is.  So I focused on eliminating
unnecessary spanning of cachelines (by non-bio_set and non-mempool_t
members) and eliminated most holes in DM structs.  This is the result:
http://people.redhat.com/msnitzer/dm-4.18-struct-reorg/

Compare before.txt vs after_kent.txt vs after_mike.txt

Nothing staggering or special.  Just something I'll add once Kent's
latest changes land.

But, I also eliminated 2 4-byte holes in struct bio_set, Jens please
feel free to pick this up (if you think it useful):

From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] block: eliminate 2 4-byte holes in bio_set structure

Signed-off-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5e472fc..e6fc692 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -735,7 +735,6 @@ static inline void bio_inc_remaining(struct bio *bio)
 
 struct bio_set {
 	struct kmem_cache *bio_slab;
-	unsigned int front_pad;
 
 	mempool_t bio_pool;
 	mempool_t bvec_pool;
@@ -743,6 +742,7 @@ struct bio_set {
 	mempool_t bio_integrity_pool;
 	mempool_t bvec_integrity_pool;
 #endif
+	unsigned int front_pad;
 
 	/*
 	 * Deadlock avoidance for stacking block drivers: see comments in
