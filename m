From: CaT <cat@zip.com.au>
Subject: Re: raid5 stuck in degraded, inactive and dirty mode
Date: Fri, 11 Jan 2008 09:23:54 +1100
Message-ID: <20080110222354.GA3940@zip.com.au>
References: <20080109055544.GR3940@zip.com.au> <18308.28489.479077.86397@notabene.brown> <20080109081634.GS3940@zip.com.au> <20080110102919.GZ3940@zip.com.au> <18310.32342.80387.311569@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18310.32342.80387.311569@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 11, 2008 at 07:21:42AM +1100, Neil Brown wrote:
> On Thursday January 10, cat@zip.com.au wrote:
> > On Wed, Jan 09, 2008 at 07:16:34PM +1100, CaT wrote:
> > > > But I suspect that "--assemble --force" would do the right thing.
> > > > Without more details, it is hard to say for sure.
> > > 
> > > I suspect so aswell but throwing caution into the wind erks me wrt this
> > > raid array. :)
> > 
> > Sorry. Not to be a pain but considering the previous email with all the
> > examine dumps, etc would the above be the way to go? I just don't want
> > to have missed something and bugger the array up totally.
> 
> Yes, definitely.

Cool.

> The superblocks look perfectly normal for a single drive failure
> followed by a crash.  So "--assemble --force" is the way to go.
> 
> Technically you could have some data corruption if a write was under
> way at the time of the crash.  In that case the parity block of that

I'd expect so as I think the crash situation is one of rather severe
abruptness.

> stripe could be wrong, so the recovered data for the missing device
> could be wrong.
> This is why you are required to use "--force" - to confirm that you
> are aware that there could be a problem.

Right.

> It would be worth running "fsck" just to be sure that nothing critical
> has been corrupted.  Also if you have a recent backup, I wouldn't
> recycle it until I was fairly sure that all your data was really safe.

I'll be doing a fsck and checking what data I can over the weekend to
see what was fragged. I suspect it'll just be something rsynced due to
the time of the crash.

> But in my experience the chance of actual data corruption in this
> situation is fairly low.

Yaay. :)

Thanks. I'll now go and put humpty together again. For some reason
Johnny Cash's 'Ring of Fire' is playing in my head.

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
