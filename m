From: Neil Brown <neilb@suse.de>
Subject: Re: devices get kicked from RAID about once a month
Date: Fri, 4 Jun 2010 07:33:04 +1000
Message-ID: <20100604073304.1d669f45@notabene.brown>
References: <87k4qho723.fsf@uwo.ca>
	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
	<876321o3lm.fsf@uwo.ca>
	<4C067AD6.7040700@anonymous.org.uk>
	<871vcpo0n6.fsf@uwo.ca>
	<4C069813.3010308@tmr.com>
	<87sk55mijx.fsf@uwo.ca>
	<4C07DA4E.70501@tmr.com>
	<87eigom5as.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eigom5as.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 03 Jun 2010 12:47:39 -0400
Dan Christensen <jdc@uwo.ca> wrote:

> Bill Davidsen <davidsen@tmr.com> writes:
> 
> > Those logs don't show any information useful to me which tells me how
> > long md waited, and I'm not able to parse any of the res: information
> > to gain clarity. It would be nice if someone can parse that, but I
> > can't. On timeout an elapsed time output would be nice to indicate
> > what the time limit is.
> 
> I agree.  It would also be nice to know whether there was in fact a read
> error at that time (in which case I may just replace the drives to avoid
> this problem) or whether it was some other communications glitch (in
> which case I may suspect the power supply, try a newer kernel, etc).
> With the information at hand, I'm not sure how to fix this, and since
> it often is a month or more between occurrences, trial and error is
> not likely to help.
> 
> > I sure would like to see a timeout in ms [md?] in
> > the /sys for the device and a flag for the array to not kick a drive
> > for timeout until some number of consecutive timeouts have
> > occurred. 
> 
> That could be useful.  And, as Neil said, if the SATA driver could be
> told to use longer timeouts, that might help.  Neil, if you think that's
> a good idea, maybe you could put the request in with the SATA folks?

It might be a good idea.
Seeing you have the error logs, you have the border-line drives, you are in
the best position to test anything they suggest, and you have the strongest
motivation to see a resolution, I recommend you put in the request.  Email
details should be available in the MAINTAINERS file.

NeilBrown


> 
> > I would hope that a drive with multiple partitions would get the
> > partitions kicked, not the whole drive at once. So one slow sector
> > wouldn't take out multiple arrays.
> 
> Only the partition gets kicked out.  Yesterday, this saved me, since I
> had timeouts on two drives in RAID5, but all the arrays stayed up because
> the partitions didn't happen to be in the same array.
> 
> Dan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

