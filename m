From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using
 snprintf() in md_check_recovery()
Date: Sun, 13 Feb 2011 21:18:52 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1102132118360.18930@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net> <4D56541D.3030409@uw.no> <4D568FCA.90902@msgid.tls.msk.ru> <4D5693E7.2010000@uw.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5693E7.2010000@uw.no>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel K." <dk@uw.no>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Sat, 12 Feb 2011, Daniel K. wrote:

> Michael Tokarev wrote:
> > 12.02.2011 12:34, Daniel K. wrote:
> > > Jesper Juhl wrote:
> > > > sprintf() is dangerous - given the wrong source string it will
> > > > overflow the destination. snprintf() is safer in that at least we'll
> > > > never overflow the destination. Even if overflow will never happen
> > > > today, code changes over time and snprintf() is just safer in the long
> > > > run.
> > > > -                        sprintf(nm,"rd%d", rdev->raid_disk);
> > > > +                        snprintf(nm, sizeof(nm), "rd%d",
> > > > rdev->raid_disk);
> > > >                          sysfs_remove_link(&mddev->kobj, nm);
> > > What if "rd1234" get truncated to "rd123" and you remove the wrong link.
> > > (No, I didn't actually bother to check how much room was allocated.)
> > 
> > That allocation is in the line above first sprintf which you deleted.
> > Sure, didn't bother, it's very difficult.
> 
> Yeah, early morning, I cut to much, and I didn't bother to look it up again,
> sorry for being lazy. Nevertheless, the actual size is of the allocation is of
> no particular importance. As you've shown, the current allocation of 20 bytes
> is more than enough.
> 
> > C'mon guys, this is pointless.  20 bytes allocated for the device
> > name, and this is for raid disk number.  It is impossible to have
> > more than 10^17 (20 bytes total, 2 for "rd" and on for the zero
> > terminator) drives in a single array.
> 
> Agreed, and this was sort of the point.
> 
> In all probability it would not overflow, and if it did, it would be better
> for it to crash and burn, than to unlink the wrong files.
> 

Point taken. Ignore the patch.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

