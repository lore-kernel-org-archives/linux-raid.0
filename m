From: Bruce Lowekamp <brucelowekamp@gmail.com>
Subject: Re: Bad blocks are killing us!
Date: Wed, 17 Nov 2004 16:58:21 -0500
Message-ID: <e9132f82041117135873807c77@mail.gmail.com>
References: <200411150522.iAF5MNN18341@www.watkins-home.com>
	 <16793.11589.337840.541169@cse.unsw.edu.au>
Reply-To: Bruce Lowekamp <brucelowekamp@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16793.11589.337840.541169@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy Watkins <guy@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2: Thanks for devoting the time for getting this done.  Personally,
for the PATA arrays I use, this approach is a bit overkill---if the
rewrite succeeds, it's ok (unless I start to see repeated errors, in
which case I yank the drive), if the rewrite doesn't succeed, it's
dead and I have to yank the drive.   I don't have any useful
diagnostic tools at linux user-level other than smart badblocks scans,
which would just confirm the bad sectors.  Personally, I wouldn't go
to the effort to keep (parts of) the drive in the array if it can't be
rewritten successfully---I've never seen a drive last long in that
situation, and I think that drive is really dead.  The only problems
I've had in practice have been with mutliple accumulated read
errors---and rewriting those would make them go away quickly.  I would
just want the data rewritten at user level, and log the event so I can
monitor the array for failures and look at the smart output or take a
drive offline for testing (with vendor diag tools) if it starts to
have frequent errors.  Naturally, as long as the more complex approach
of kicking to user level allows the user-level to return immediately
to let the kernel rewrite the stripe, I think it's fine.

I agree that writing several megabytes is not an issue in any way. 
IMHO, feel free to hang the whole system for a few seconds if
necessary---no one should be using md in an RT-critical application,
and bad blocks are relatively rare.

3: The data scans is an interesting idea.  Right now I run daily smart
short scans and weekly smart long scans to try to catch any bad blocks
before I get multiple errors.  Assuming there aren't any uncaught CRC
errors, I feel comfortable with that approach, but the md-level
approach might be better.  But I'm not sure I see the point of
it---unless you have raid 6 with multiple parity blocks, if a disk
actually has the wrong information recorded on it I don't think you
can detect which drive is bad, just that one of them is.  So I don't
think you gain anything beyond what a standard smart long scan or just
cat'ing the raw device would give you in terms of forcing the whole
drive to be read.

Bruce


On Tue, 16 Nov 2004 09:27:17 +1100, Neil Brown <neilb@cse.unsw.edu.au> wrote:

>  2/ Look at recovering from failed reads that can be fixed by a
>     write.  I am considering leveraging the "bitmap resync" stuff for
>     this.  With the bitmap stuff in place, you can let the kernel kick
>     out a drive that has a read error, let user-space have a quick
>     look at the drive and see if it might be a recoverable error, and
>     then give the drive back to the kernel.  It will then do a partial
>     resync based on the bitmap information, thus writing the bad
>     blocks, and all should be fine.  This would mean re-writing
>     several megabytes instead of a few sectors, but I don't think that
>     is a big cost.  There are a few issues that make it a bit less
>     trivial than that, but it will probably be my starting point.
>     The new "faulty" personality will allow this to be tested easily.

-- 
Bruce Lowekamp  (lowekamp@cs.wm.edu)
Computer Science Dept, College of William and Mary
