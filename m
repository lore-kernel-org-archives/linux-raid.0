From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Mon, 22 Oct 2007 16:55:00 +1000
Message-ID: <18204.18756.505903.297754@notabene.brown>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	<18198.62670.605246.270516@notabene.brown>
	<170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
	<18200.6319.487833.714355@notabene.brown>
	<170fa0d20710182152i4763c347r704c9d939e0a4638@mail.gmail.com>
	<170fa0d20710182215v19756cabp30ddddeb7a7668a2@mail.gmail.com>
	<18200.17870.419986.530609@notabene.brown>
	<170fa0d20710191618s3e284d07q738662987acfe452@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Friday October 19
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 19, snitzer@gmail.com wrote:
> On 10/19/07, Neil Brown <neilb@suse.de> wrote:
> > On Friday October 19, snitzer@gmail.com wrote:
> 
> > > I'm using a stock 2.6.19.7 that I then backported various MD fixes to
> > > from 2.6.20 -> 2.6.23...  this kernel has worked great until I
> > > attempted v1.0 sb w/ bitmap=internal using mdadm 2.6.x.
> > >
> > > But would you like me to try a stock 2.6.22 or 2.6.23 kernel?
> >
> > Yes please.
> > I'm suspecting the code in write_sb_page where it tests if the bitmap
> > overlaps the data or metadata.  The only way I can see you getting the
> > exact error that you do get it for that to fail.
> > That test was introduced in 2.6.22.  Did you backport that?  Any
> > chance it got mucked up a bit?
> 
> I believe you're referring to commit
> f0d76d70bc77b9b11256a3a23e98e80878be1578.  That change actually made
> it into 2.6.23 AFAIK; but yes I actually did backport that fix (which
> depended on ab6085c795a71b6a21afe7469d30a365338add7a).
> 
> If I back-out f0d76d70bc77b9b11256a3a23e98e80878be1578 I can create a
> raid1 w/ v1.0 sb and an internal bitmap.  But clearly that is just
> because I removed the negative checks that you introduced ;)
> 
> For me this begs the question: what else would
> f0d76d70bc77b9b11256a3a23e98e80878be1578 depend on that I missed?  I
> included 505fa2c4a2f125a70951926dfb22b9cf273994f1 and
> 	ab6085c795a71b6a21afe7469d30a365338add7a too.
> 
> *shrug*...
> 

This is all very odd...
I definitely tested this last week and couldn't reproduce the
problem.  This week I can reproduce it easily.  And given the nature
of the bug, I cannot see how it ever worked.

Anyway, here is a fix that works for me.

NeilBrown

--------
Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.

As page->index is unsigned, this all becomes an unsigned comparison, which
 almost always returns an error.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-10-22 16:47:52.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-10-22 16:50:10.000000000 +1000
@@ -274,7 +274,7 @@ static int write_sb_page(struct bitmap *
 			if (bitmap->offset < 0) {
 				/* DATA  BITMAP METADATA  */
 				if (bitmap->offset
-				    + page->index * (PAGE_SIZE/512)
+				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					return -EINVAL;
