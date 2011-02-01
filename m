From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: [BUG 2.6.32] md/raid1: barrier disabling does not work correctly
 in all cases
Date: Tue, 1 Feb 2011 15:45:16 -0500
Message-ID: <AANLkTimS00pyoN2f4E-2ZbSLq8-Xar3oj9DZ2sEfXzgs@mail.gmail.com>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
	<AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
	<20110121072515.07dc2b74@notabene.brown>
	<AANLkTi=NqHV9p0rc4VBBNAzxwjvfA0DpKgkxQpsX9gsT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=NqHV9p0rc4VBBNAzxwjvfA0DpKgkxQpsX9gsT@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 26, 2011 at 8:55 AM, Paul Clements
<paul.clements@us.sios.com> wrote:

> Attached is a modified patch, which does the extra necessary work
> (bitmap_endwrite, md_write_end) on the bio before failing it.
>
> Does this look correct? It seems to work.

Well, not quite...it's more complicated. From my reading of the code,
it looks like behind writes and barrier retries just do not work
correctly together. The issue is this:

- With behind writes, we signal the master_bio complete as soon as all
non-write-behind writes are complete.

- With barrier retries, you don't know if you'll need to retry until
you've completed all legs of the write (the last leg to complete might
throw EOPNOTSUPP).

So in the case where the master_bio has been completed, we still try
to do a retry for the leg that failed the barrier (but it's really too
late to retry). In any case, raid1d is touching master_bio (looking at
bi_size and bio_cloning it) during the retry, which causes a panic if
master_bio is already being reused by someone else.

I can't think of a good way to do behind writes and barrier retries
together. Seems we've got to disable behind writes for barriers, or
we've got to disable barrier retries when doing behind writes...

Any thoughts?

--
Paul
