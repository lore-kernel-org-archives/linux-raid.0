From: "Colin Simpson" <csimpson@csl.co.uk>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Sun, 25 Feb 2007 12:24:03 +0000
Message-ID: <1172406243.3765.29.camel@cowie>
References: <1172258378.21648.51.camel@cowie>  <45DF46B7.3040707@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45DF46B7.3040707@maine.edu>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-02-23 at 14:55 -0500, Steve Cousins wrote:
> Yes, this is an important thing to keep on top of, both for hardware 
> RAID and software RAID.  For md:
> 
> 	echo check > /sys/block/md0/md/sync_action
> 
> This should be done regularly. I have cron do it once a week.
> 
> Check out: http://neil.brown.name/blog/20050727141521-002
> 
> Good luck,
> 
> Steve

Thanks for all the info. 

A further search around seems to reveal the seriousness of this issue. 
So called "Disk/Data Scrubbing" seems to be vital for keeping a modern
large RAID healthy.

I've found a few interesting links. 

http://www.ashtech.net/~syntax/blog/archives/53-Data-Scrub-with-Linux-RAID-or-Die.html

The link of particular interest from the above is

http://www.nber.org/sys-admin/linux-nas-raid.html

The really scary item is entitled, "Why do drive failures come in
pairs?", it has the following :

===
Let's repeat the reliability calculation with our new knowledge of the
situation. In our experience perhaps half of drives have at least one
unreadable sector in the first year. Again assume a 6 percent chance of
a single failure. The chance of at least one of the remaining two drives
having a bad sector is 75% (1-(1-.5)^2). So the RAID 5 failure rate is
about 4.5%/year, which is .5% MORE than the 4% failure rate one would
expect from a two drive RAID 0 with the same capacity. Alternatively, if
you just had two drives with a partition on each and no RAID of any
kind, the chance of a failure would still be 4%/year but only half the
data loss per incident, which is considerably better than the RAID 5 can
even hope for under the current reconstruction policy even with the most
expensive hardware.
===

That's got my attention! My RAID 5 is worse than a 2 disk RAID 0. It
goes on about a surface scan being used to mitigate this problem. The
article also talks about how on reconstruction perhaps the md driver
should not just give up is it finds bad blocks on the disk but do
something cleverer. I don't know if that's valid or not.

But this all leaves me with a big problem. As the systems I have
Software RAID running are fully supported RH 4 ES systems (running the
2.6.9-42.0.8 kernel, I can't really change it without losing RH
support). 

They therefore do not have the "check" option in the kernel. Is there
anything else I can do? Would forcing a resync achieve the same result
(or is that down right dangerous as the array is not considered
consistent for a while). Any thoughts apart from my one being to upgrade
them to RH5 when that appears with a probably 2.6.18 kernel (which will
presumably have "check")? Any thoughts?

Is this something that should be added to the "Software-RAID-HOWTO"? 

Just for reference the current Dell Perc 5i controllers has a thing
called "Patrol Read", which goes off and does a scrub in the background.

Thanks again

Colin


This email and any files transmitted with it are confidential and are intended solely for the use of the individual or entity to whom they are addressed.  If you are not the original recipient or the person responsible for delivering the email to the intended recipient, be advised that you have received this email in error, and that any use, dissemination, forwarding, printing, or copying of this email is strictly prohibited. If you received this email in error, please immediately notify the sender and delete the original.


