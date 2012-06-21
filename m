From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Thu, 21 Jun 2012 20:23:27 +0200
Message-ID: <20120621182326.GA2144@lazy.lzy>
References: <10900468.MPSjVn2C3J@peanut>
 <4FE315CE.9090201@anonymous.org.uk>
 <5100581.utCIcpy8f5@peanut>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5100581.utCIcpy8f5@peanut>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Buchholz <robert.buchholz@goodpoint.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Robert,

On Thu, Jun 21, 2012 at 04:58:33PM +0200, Robert Buchholz wrote:
> Hello John,
> 
> On Thursday, June 21, 2012 01:38:38 PM John Robinson wrote:
> > On 20/06/2012 18:41, Robert Buchholz wrote:
> > [...]
> > 
> > > When repairing a full raid6 with no missing drives
> > > (raid-devices=n+2), a single inconsistent data block could be
> > > detected
> > 
> > Yes, it could. See Neil Brown's blog post as to the many reasons why
> > this isn't implemented: http://neil.brown.name/blog/20100211050355
> 
> Thank you for the pointer, I did not find the article before.
> I agree with Neil's premise, this should not be run on a mounted raid as 
> changing data blocks can be a problem, and it should not be the default 
> for resync. However, as both Neil and commenters point out, this is a 
> valuable (offline) repair option.
> 
> Do you know whether the "smart" algorithm or the API necessary to 
> construct a user space program are on the agenda?

a tool is already available, albeit not too much
advertised (my fault, basically).

It is "raid6check" and it is included in "mdadm", at
least in the source repository.

It does *not* repair, but it will tell you which
disk (if possible) and which stripe is incorrect
from an non-degraded (of course) RAID-6.

Any improvement to the code is very very welcome.

Unfortunately I did not have time to follow up the
thing, but a "repair" option might be interesting.

bye,

pg

> 
> Cheers
> 
> Robert



-- 

piergiorgio
