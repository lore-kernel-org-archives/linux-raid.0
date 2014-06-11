From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md-raid paranoia mode?
Date: Wed, 11 Jun 2014 19:31:20 +0200
Message-ID: <20140611173120.GA2437@lazy.lzy>
References: <5397FBCE.3060009@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5397FBCE.3060009@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 10, 2014 at 11:48:46PM -0700, Bart Kus wrote:
> Hello,
> 
> As far as I understand, md-raid relies on the underlying devices to inform
> it of IO errors before it'll seek redundant/parity data to fulfill the read
> request.  I have, however, seen certain hard drives report successful reads
> while returning garbage data.
> 
> Is it possible to set md-raid into a paranoid mode, in which it reads all
> available data and confirms integrity?  Here's how it would work:
> 
> RAID6: read data + parity 1 + parity 2.  If 1 of the 3 mismatches, correct
> it, and write corrected data to the corrupt source.  Log the event.  If all
> 3 disagree, alert user somehow.
> RAID5: read data + parity.  If they mismatch, alert user somehow.
> RAID1: read data 1 + data 2.  If they mismatch, alert user somehow.
> 
> You can see this is mostly useful for RAID6 mode, where there is a chance at
> automated recovery.  However, it can also be used to prevent silent data
> corruption in the other modes, by making it not silent.

Hi Bart,

this was discussed some times ago, mainly for RAID6.
One compromise was "raid6check", which run in user space.

The main objection is the performance drop, that such a
reading method will have, which, of course, will require
an enable/disable switch.

I do not want to write for Neil, but I guess reasonable
patches, doing what you propose, will be accepted.

bye,

pg

> 
> --Bart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
