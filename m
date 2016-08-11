From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH v2] block: make sure big bio is splitted into at most
 256 bvecs
Date: Wed, 10 Aug 2016 23:33:55 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608102132120.10662@mail.ewheeler.net>
References: <1459914212-9330-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1459914212-9330-1-git-send-email-ming.lei@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, Christoph Hellwig <hch@infradead.org>, Sebastian Roesner <sroesner-kernelorg@roesner-online.de>, "4.3+" <stable@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Fri, 10 Jun 2016, Christoph Hellwig wrote: 
> On Wed, 6 Apr 2016, Ming Lei wrote:
> >
> > After arbitrary bio size is supported, the incoming bio may
> > be very big. We have to split the bio into small bios so that
> > each holds at most BIO_MAX_PAGES bvecs for safety reason, such
> > as bio_clone().
> > 
> > This patch fixes the following kernel crash:
> > [  172.664813]  [<ffffffffa007f3be>] ? raid1_make_request+0x2e8/0xad7 [raid1]
> > [  172.664846]  [<ffffffff811f07da>] ? blk_queue_split+0x377/0x3d4
> > [  172.664880]  [<ffffffffa005fb5f>] ? md_make_request+0xf6/0x1e9 [md_mod]
> > [  172.664912]  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
> > [  172.664947]  [<ffffffffa0445c89>] ? prio_io+0x85/0x95 [bcache]
>
> The fixup to allow bio_clone support a larger size is the same one as to 
> allow everyone else submitting larger bios:  increase BIO_MAX_PAGES and 
> create the required mempools to back that new larger size.  Or just go 
> for multipage biovecs..

Hi Christoph, Ming, everyone:

I'm hoping you can help me get this off of a list of stability fixes 
related to changes around Linux 4.3.  Ming's patch [1] is known to fix an 
issue when a bio with bi_vcnt > BIO_MAX_PAGES is passed to 
generic_make_request and later hits bio_clone.  (Note that bi_vcnt can't 
be trusted since immutable biovecs and needs to be re-counted unless you 
own the bio, which Ming's patch does.)

The diffstat, 22 lines of which are commentary, 
seems relatively minor and would land in stable for v4.3+:
 block/blk-merge.c | 35 ++++++++++++++++++++++++++++++++---

I'm not sure I understood Christoph's suggestion; BIO_MAX_PAGES is a 
static #define and we don't know what the the bi_vcnt from an arbitrary 
driver might be.  Wouldn't increasing BIO_MAX_PAGES just push the problem 
further out into the future when bi_vcnt might again exceed BIO_MAX_PAGES?  

Perhaps you could elaborate if I have misunderstood. Are you suggesting 
that no driver should call generic_make_request when bi_vcnt > BIO_MAX_PAGES?


--
Eric Wheeler

[1] https://patchwork.kernel.org/patch/9169483/
    Pasted below:



After arbitrary bio size is supported, the incoming bio may
be very big. We have to split the bio into small bios so that
each holds at most BIO_MAX_PAGES bvecs for safety reason, such
as bio_clone().

This patch fixes the following kernel crash:

> [  172.660142] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [  172.660229] IP: [<ffffffff811e53b4>] bio_trim+0xf/0x2a
> [  172.660289] PGD 7faf3e067 PUD 7f9279067 PMD 0
> [  172.660399] Oops: 0000 [#1] SMP
> [...]
> [  172.664780] Call Trace:
> [  172.664813]  [<ffffffffa007f3be>] ? raid1_make_request+0x2e8/0xad7 [raid1]
> [  172.664846]  [<ffffffff811f07da>] ? blk_queue_split+0x377/0x3d4
> [  172.664880]  [<ffffffffa005fb5f>] ? md_make_request+0xf6/0x1e9 [md_mod]
> [  172.664912]  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
> [  172.664947]  [<ffffffffa0445c89>] ? prio_io+0x85/0x95 [bcache]
> [  172.664981]  [<ffffffffa0448252>] ? register_cache_set+0x355/0x8d0 [bcache]
> [  172.665016]  [<ffffffffa04497d3>] ? register_bcache+0x1006/0x1174 [bcache]

The issue can be reproduced by the following steps:
	- create one raid1 over two virtio-blk
	- build bcache device over the above raid1 and another cache device
	and bucket size is set as 2Mbytes
	- set cache mode as writeback
	- run random write over ext4 on the bcache device

Fixes: 54efd50(block: make generic_make_request handle arbitrarily sized bios)
Reported-by: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Reported-by: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: stable@vger.kernel.org (4.3+)
Cc: Shaohua Li <shli@fb.com>
Acked-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
V2:
	- don't mark as REQ_NOMERGE in case the bio is splitted
	for reaching the limit of bvecs count
V1:
        - Kent pointed out that using max io size can't cover
        the case of non-full bvecs/pages
 block/blk-merge.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index c265348..839529b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -85,7 +85,8 @@  static inline unsigned get_max_io_size(struct request_queue *q,
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
-					 unsigned *segs)
+					 unsigned *segs,
+					 bool *no_merge)
 {
 	struct bio_vec bv, bvprv, *bvprvp = NULL;
 	struct bvec_iter iter;
@@ -94,9 +95,34 @@  static struct bio *blk_bio_segment_split(struct request_queue *q,
 	bool do_split = true;
 	struct bio *new = NULL;
 	const unsigned max_sectors = get_max_io_size(q, bio);
+	unsigned bvecs = 0;
+
+	*no_merge = true;
 
 	bio_for_each_segment(bv, bio, iter) {
 		/*
+		 * With arbitrary bio size, the incoming bio may be very
+		 * big. We have to split the bio into small bios so that
+		 * each holds at most BIO_MAX_PAGES bvecs because
+		 * bio_clone() can fail to allocate big bvecs.
+		 *
+		 * It should have been better to apply the limit per
+		 * request queue in which bio_clone() is involved,
+		 * instead of globally. The biggest blocker is
+		 * bio_clone() in bio bounce.
+		 *
+		 * If bio is splitted by this reason, we should allow
+		 * to continue bios merging.
+		 *
+		 * TODO: deal with bio bounce's bio_clone() gracefully
+		 * and convert the global limit into per-queue limit.
+		 */
+		if (bvecs++ >= BIO_MAX_PAGES) {
+			*no_merge = false;
+			goto split;
+		}
+
+		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
 		 */
@@ -171,13 +197,15 @@  void blk_queue_split(struct request_queue *q, struct bio **bio,
 {
 	struct bio *split, *res;
 	unsigned nsegs;
+	bool no_merge_for_split = true;
 
 	if (bio_op(*bio) == REQ_OP_DISCARD)
 		split = blk_bio_discard_split(q, *bio, bs, &nsegs);
 	else if (bio_op(*bio) == REQ_OP_WRITE_SAME)
 		split = blk_bio_write_same_split(q, *bio, bs, &nsegs);
 	else
-		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
+		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs,
+				&no_merge_for_split);
 
 	/* physical segments can be figured out during splitting */
 	res = split ? split : *bio;
@@ -186,7 +214,8 @@  void blk_queue_split(struct request_queue *q, struct bio **bio,
 
 	if (split) {
 		/* there isn't chance to merge the splitted bio */
-		split->bi_rw |= REQ_NOMERGE;
+		if (no_merge_for_split)
+			split->bi_rw |= REQ_NOMERGE;
 
 		bio_chain(split, *bio);
 		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
