From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: "Robust Read"
Date: Sat, 19 Mar 2005 21:56:33 +0100
Message-ID: <19gug2-0bj.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru> <vvjtg2-t16.ln1@news.it.uc3m.es> <423C4E62.4070704@tls.msk.ru> <gj2ug2-9q3.ln1@news.it.uc3m.es> <423C897B.1030100@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> > Uh OK. As I recall one only needs to count, one doesn't need a bitwise
> > map of what one has dealt with.
> 
> Well.  I see read_balance() is now used to resubmit reads.  There's
> a reason to use it instead of choosing "next" disk, I think. 

I can't think of one myself!  We know what disk we want - the next
available one that's not the present one.  We don't need to calculate
which is needed according to head positions.

But your approach is fine - it's just that (a) I don't like to mess
with the struct sizes, as that makes modules binary incompatible,
instead of just having extra functionalities, and (b) I really think
it's not going to be easily maintainable to subvert read_balance, and
(c), it fragments the patch more, and (d), I really think you only need
to count and pray, not keep an exact map.

Maybe if you were to use the existing "remaining" field for the birmap,
you would get rid of objection (a)! :-). You could even rename it via a
#define :-).

> There's
> a reason to NOT use it too, as the "bitmap" will not be needed in
> that case, only the counter.  Both will do the task ofcourse, and
> the case wich requires only counter is preferred because it does
> not restrict number of disks in the array the way "bitmap" does.
> 
> Ok, so be it the "map" variant when.. and it's even simpler that way.

Well, either way is fine! Don't let me restrict you! Use your own
best judgment.

> > and then in the raid1d function:
> 
> BTW, what's the reason to use raid1d for retries in the first place?
> Why not just resubmit the request in reschedule_retry() directly,
> the same way it is done in raid1d?

No reason that I recall.  Isn't raid1d going to do it offline?  You want
to do it sync instead?  Anyway, the rerite code is completely
uninvestigated, so please try anything you like!

> > Yes, I don't think you should muck with read_balance at all! It's an
> > approach, but I don't think it's the right one. We just want to use the
> > function to change target disks with here.  Why not reinstate the old
> > "map" function which can do just that? Then no change to read_balancce
> > is needed. Rename map() to remap() if it sounds better!
> 
> The key point is that there should be not many read errors.  Given said
> that, I agree, simpler routine for retries is ok.
> 
> []
> >>@@ -545,6 +551,7 @@ static int make_request(request_queue_t 
> >>        r1_bio->sector = bio->bi_sector;
> >> 
> >>        r1_bio->state = 0;
> >>+       r1_bio->tried_disks = 0;
> > 
> > Hmm. Ditto. I suppose we are making the read request here. Yes we are.
> > I had set the "remaining" count instead.
> 
> BTW there's no reason to zero any fields in r1_bio because of the
> way it is allocated (with memset(0) all of it).

Somebody should mention it to Neil :-).

> > What do you think of my comments above?
> 
> Ok.
> 
> But..  It's very difficult to NOT go into numerous-cleanups mode now.

Don't.  Just the patch first. The aim of a patch is to make a minimal
change.

> I want to clean up the code, to make it better first!.. ;)  And I
> pretty much sure it will conflict with ongoing work Neil is doing... ;)

Exactly. Aim for the minimal patch.

Peter

