From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: Good, recent FS comparison?
Date: Tue, 27 Dec 2005 17:45:52 -0800
Message-ID: <20051227174552.4d19ab6f.rdunlap@xenotime.net>
References: <6d5bedd8050915131148b8108a@mail.gmail.com>
	<432A37BF.7060305@dtbb.net>
	<200509162258.37730.a1426z@gawab.com>
	<432D3024.3080302@dtbb.net>
	<002c01c60b3d$ea98c970$c60c150a@zero>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <002c01c60b3d$ea98c970$c60c150a@zero>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Northrup <jim@grrrrr.gotdns.com>
Cc: pml@dtbb.net, a1426z@gawab.com, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On Tue, 27 Dec 2005 15:33:18 -0800 James Northrup wrote:

> late reply... but ...
> 
> this is a benchmark I performed for grins sometime about February using two 
> PATA udma5 volumes as software raid0.
> 
> http://kiwi.io-informatics.com/~jnorthrup/filesystem%20benchresults.xls
> 
> 
> the uname -a isn't anywhere to be found but it was circa 2.6.8
> 
> the script is rpesumably still useful, for an experienced data groomer.
> 
> http://kiwi.io-informatics.com/~jnorthrup/fsbench

Do you have a URL that works?


> ----- Original Message ----- 
> From: "Tyler" <pml@dtbb.net>
> To: "Al Boldi" <a1426z@gawab.com>
> Cc: <linux-fsdevel@vger.kernel.org>; "Linux RAID Mailing List" 
> <linux-raid@vger.kernel.org>; <linux-xfs@oss.sgi.com>
> Sent: Sunday, September 18, 2005 1:15 AM
> Subject: Re: Good, recent FS comparison?
> 
> 
> >
> > Al Boldi wrote:
> >
> >>Tyler wrote:
> >>
> >>>Ewan Grantham wrote:
> >>>
> >>>>I've just setup a nice, 6-disk, USB-2 300 Gig/disk array, and was
> >>>>prepared to follow my normal pattern of installing ext3 as the
> >>>>filesystem. However, I saw the interview with Hans Reiser about
> >>>>ReiserFS4, and am now wondering if reiser has really improved enough
> >>>>to use it, or if ext3 is still the way to go?
> >>>>
> >>>You'd be best off trying some tests of your own, using files of the size
> >>>and quantity you expect to use on a regular basis.  I would consider
> >>>ext3, xfs, and reiser3/4... and run some tests with them.  We've had
> >>>really good luck using XFS on large raids, I personally had a bad
> >>>experience with reiserfs 3, it lost data on a USB based drive, as if it
> >>>were never even there, even after trying the recovery tools.
> >>>
> >>
> >>Don't touch anything that doesn't do ordered-mode journaling, especially 
> >>if you use raid, unless your data-consistency requirements don't require 
> >>this.
> >>
> >>XFS is best, but does not support ordered-mode.
> >>reiser4 is still new.
> >>ext3 is rock-solid!
> >>
> >>--
> >>Al
> >>
> >>-
> >>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > Al... you've given us some "do's" .. can you give us some "why's" to go 
> > along with them? :)  I would appreciate a run-down with some more specific 
> > info as to what/why.
> >
> > Thanks,
> > Tyler.


---
~Randy
