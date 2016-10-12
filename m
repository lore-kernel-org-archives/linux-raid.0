From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH] badblocks: fix overlapping check for clearing
Date: Wed, 12 Oct 2016 12:26:21 +0200
Message-ID: <20161012102621.GA30839@proton.igk.intel.com>
References: <1473152338-30539-1-git-send-email-tomasz.majchrzak@intel.com>
 <87wphk3gpx.fsf@notabene.neil.brown.name>
 <CAA9_cmcnQjKv=tdBF+Jkd6WoFh+aKCVzq7NPQBStwtcv_j0Qyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmcnQjKv=tdBF+Jkd6WoFh+aKCVzq7NPQBStwtcv_j0Qyg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-block@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 10, 2016 at 03:32:58PM -0700, Dan Williams wrote:
> > On Tue, Sep 06 2016, Tomasz Majchrzak wrote:
> >> ---
> >>  block/badblocks.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/block/badblocks.c b/block/badblocks.c
> >> index 7be53cb..b2ffcc7 100644
> >> --- a/block/badblocks.c
> >> +++ b/block/badblocks.c
> >> @@ -354,7 +354,8 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> >>                * current range.  Earlier ranges could also overlap,
> >>                * but only this one can overlap the end of the range.
> >>                */
> >> -             if (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) {
> >> +             if ((BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) &&
> >> +                 (BB_OFFSET(p[lo]) <= target)) {
> >
> > hmmm..
> > 'target' is the sector just beyond the set of sectors to remove from the
> > list.
> > BB_OFFSET(p[lo]) is the first sector in a range that was found in the
> > list.
> > If these are equal, then are aren't clearing anything in this range.
> > So I would have '<', not '<='.
> >
> > I don't think this makes the code wrong as we end up assigning to p[lo]
> > the value that is already there.  But it might be confusing.
> >
> >
> >>                       /* Partial overlap, leave the tail of this range */
> >>                       int ack = BB_ACK(p[lo]);
> >>                       sector_t a = BB_OFFSET(p[lo]);
> >> @@ -377,7 +378,8 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> >>                       lo--;
> >>               }
> >>               while (lo >= 0 &&
> >> -                    BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
> >> +                    (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) &&
> >> +                    (BB_OFFSET(p[lo]) <= target)) {
> >
> > Ditto.
> >
> > But the code is, I think, correct. Just not how I would have written it.
> > So
> >
> >  Acked-by: NeilBrown <neilb@suse.com>
> 
> I agree with the comments to change "<=" to "<".  Tomasz, care to
> re-send with those changes?

I have just resent the patch with your suggestions included.

> > In the original md context, it would only ever be called on a block that
> > was already in the list.

Actually MD RAID10 calls it this way. See handle_write_completed, it iterates
over all copies and clears the bad block if error has not been returned. I have
a test case which fails for that reason - existing bad block is modified by
clear block. It is very unlikely to happen in real life as it depends on
specific layout of bad blocks and their discovery order, however it's a gap that
needs to be closed.

I had put some effort to see if clearing of non-existing bad block in RAID10 can
lead to some incorrect behaviour but I haven't found any. It seems that my patch
is sufficient to fix the problem.

Tomek
