From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Hot adding active disk to RAID1? [PATCH]
Date: Mon, 16 Feb 2004 10:40:45 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16432.893.793634.755458@notabene.cse.unsw.edu.au>
References: <20040207152948.GA17368@fscked.org>
	<20040207173716.GA10996@fscked.org>
	<1076178191.3328.32.camel@picard.intra.techwiz.ca>
	<20040210075406.GB15112@fscked.org>
	<16424.38075.333116.361351@notabene.cse.unsw.edu.au>
	<20040210150041.GA4868@fscked.org>
	<16425.23445.174722.587863@notabene.cse.unsw.edu.au>
	<20040211014709.GA28357@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Perry on Tuesday February 10
To: Mike Perry <mikepery@fscked.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 10, mikepery@fscked.org wrote:
> Thus spake Neil Brown (neilb@cse.unsw.edu.au):
> 
> > > Is there a preferred version/cvs repository that I should diff against? The
> > > raidtools are kinda helter-skelter in their net presence, it seems..
> > 
> > Sorry, I should have been more specific.
> > Patches *against mdadm* are welcome.
> > I have no interest in "raid-tools" - it seems to be unmaintained.
> > Patches against the lastest source tar-ball are fine.
> 
> Attached. Any plans to port that raidreconf tool into mdadm? Cause for
> now, the new manpage refers people to the deprecated raidtools.

Thanks, though I'm not sure I want to mention raidreconf there.  Maybe
in a "see also" section.

I have thought about adding raidreconf functionality, but I think I'm
more included to put it in the kernel, so you can reconfigure a live
array.

I've just been testing some new that
a/ allows you to upgrade your raid1/5 to bigger drives on-line.
    i.e. one at a time you
        fail a drive, remove it, plug in a larger drive, and hot add
	it.
     Once all the drives are larger, you can now tell the kernel to
     use the extra space.
b/ add/remove live drives from a raid1.  It will automatically rebuild
   onto an added drive, but won't automatically make a removed drive a
   spare yet (you can only reduce the size of a raid1 if the highest
   numbered slot is empty).  So there is still a bit more work to do.

resizing a raid5 online wouldn't be too hard providing the chunk size
isn't too big. but I'm not in any great hurry to do it just yet.
(Converting raid0 to raid4, and then reshaping to raid5 would be
interesting too :-)

NeilBrown
