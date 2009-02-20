From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 09:43:56 +0000
Message-ID: <20090220094356.GB26124@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Whoops, I didn't mean to send that previous half formed mail :) Sorry.

On Thu, Feb 19, 2009 at 08:38:38AM -0500, Justin Piszcz wrote:
> 
> I was curious if anyone had done any benchmarks and/or has conclusive 
> information, what is the best Linux scheduler to use with SSDs?
> 
> Noop?
> CFQ?
> AS?
> Deadline?

As mentioned in another mail there was a discussion on
http://lkml.org/lkml/2009/1/31/28 and long thread talking about the
introduction of the rotational flag here
http://lkml.org/lkml/2009/1/5/340 . Cheapo SSDs or even USB keys are not
auto detected as non-rotational devices by the kernel and after a bit of
poking about I've come up with the following udev rules for my
particular cases:

SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{model}=="ASUS-PHISON *", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="1606", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{manufacturer}=="SanDisk", ATTRS{product}=="Cruzer Micro", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"

Ever since the rotational option appeared I've been trying cfq but prior
to that I was using noop or deadline. However it doesn't look like
anyone has sat down and run the numbers to see what affect the
ioscheulder/rotational flag is having on cheapo SSDs - all the
suggestions are anecdotal. Could you run some benchmarks with these
different options and report back the results?

-- 
Sitsofe | http://sucs.org/~sits/
