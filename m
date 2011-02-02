From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG 2.6.32] md/raid1: barrier disabling does not work
 correctly in all cases
Date: Wed, 2 Feb 2011 11:32:15 +1100
Message-ID: <20110202113215.3e106ccb@notabene.brown>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
	<AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
	<20110121072515.07dc2b74@notabene.brown>
	<AANLkTi=NqHV9p0rc4VBBNAzxwjvfA0DpKgkxQpsX9gsT@mail.gmail.com>
	<AANLkTimS00pyoN2f4E-2ZbSLq8-Xar3oj9DZ2sEfXzgs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimS00pyoN2f4E-2ZbSLq8-Xar3oj9DZ2sEfXzgs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@us.sios.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 1 Feb 2011 15:45:16 -0500 Paul Clements <paul.clements@us.sios.com>
wrote:

> On Wed, Jan 26, 2011 at 8:55 AM, Paul Clements
> <paul.clements@us.sios.com> wrote:
> 
> > Attached is a modified patch, which does the extra necessary work
> > (bitmap_endwrite, md_write_end) on the bio before failing it.
> >
> > Does this look correct? It seems to work.
> 
> Well, not quite...it's more complicated. From my reading of the code,
> it looks like behind writes and barrier retries just do not work
> correctly together. The issue is this:
> 
> - With behind writes, we signal the master_bio complete as soon as all
> non-write-behind writes are complete.
> 
> - With barrier retries, you don't know if you'll need to retry until
> you've completed all legs of the write (the last leg to complete might
> throw EOPNOTSUPP).
> 
> So in the case where the master_bio has been completed, we still try
> to do a retry for the leg that failed the barrier (but it's really too
> late to retry). In any case, raid1d is touching master_bio (looking at
> bi_size and bio_cloning it) during the retry, which causes a panic if
> master_bio is already being reused by someone else.
> 
> I can't think of a good way to do behind writes and barrier retries
> together. Seems we've got to disable behind writes for barriers, or
> we've got to disable barrier retries when doing behind writes...
> 
> Any thoughts?

I suspect you are right that barriers and behind writes are deeply
incompatible.  I suspect they could be made to work together in some vaguely
sane way, but I suspect it would be a lot of work and not worth the effort.

Disabling behind-writes for all barrier requests would be quite easy, but it
might negate a lot of the value of behind writes

We could simply ignore the barrier flag on writes to behind-write devices,
but that would risk them being even more inconsistent than they currently can
be, so I doubt that is a good direct - though it is a possibility.

I think the best option is to reject barrier writes if there are any
behind-write devices.  That would be reasonably safe and reasonably
consistent.

So maybe something like this??

NeilBrown

Index: linux-2.6.32.orig/drivers/md/bitmap.c
===================================================================
--- linux-2.6.32.orig.orig/drivers/md/bitmap.c	2009-12-03 14:51:21.000000000 +1100
+++ linux-2.6.32.orig/drivers/md/bitmap.c	2011-02-02 11:31:51.156585883 +1100
@@ -1676,6 +1676,8 @@ int bitmap_create(mddev_t *mddev)
 		pages, bmname(bitmap));
 
 	mddev->bitmap = bitmap;
+	if (bitmap->max_write_behind)
+		mddev->barriers_work = 0;
 
 	mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 
