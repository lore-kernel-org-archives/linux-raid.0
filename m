From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: md faster than h/w?
Date: Fri, 13 Jan 2006 09:46:40 -0500
Message-ID: <20060113144640.GA10566@lug.udel.edu>
References: <dq7jii$n1c$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dq7jii$n1c$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 13, 2006 at 03:06:54PM +0800, Max Waterman wrote:
> One further strangeness is that our best results have been while using a 
> uni-processor kernel - 2.6.8. We would prefer it if our best results 
> were with the most recent kernel we have, which is 2.6.15, but no.

Sounds like this is probably a bug.  If you have some time to play
around with it, I'd try kernels in between and find out exactly where
the regression happened.  The bug will probably be cleaned up quickly
and performance will be back where it should be.

> So, any advice on how to obtain best performance (mainly web and mail 
> server stuff)?
> Is 180MB/s-200MB/s a reasonable number for this h/w?
> What numbers do other people see on their raid0 h/w?
> Any other advice/comments?

My employer usues the 1850 more than the 2850, though we do have a few
in production.  My feeling is that 180-200MB/sec is really excellent
throughput.

We're comparing apples to oranges, but it'll at least give you an
idea.  The Dell 1850s are sortof our highest class of machine that we
commonly deploy.    We have a Supermicro chassis that's exactly like
the 1850 but SATA instead of SCSI.  On the low-end, we have various P4
Prescott chassis.

Just yesterday I was testing disk performance on a low-end box.  SATA
on a 3Ware controller, RAID1.  I was quite pleased to be getting
70-80MB/sec.

So my feeling is that your numbers are fairly close to where they
should be.  Faster procs, SCSI, and a better RAID card.  However, I'd
also try RAID1 if you're mostly interested in read speed.  Remember
that RAID1 lets you balance reads across disks, whereas RAID0 will
require each disk in the array to retrieve the data.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
