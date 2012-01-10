From: Bobby Kent <bpkent@wholeworldwindow.net>
Subject: RE: Meaning of "Used Dev Space" in "mdadm --detail" output for a 6
 disk RAID10 array
Date: Tue, 10 Jan 2012 14:11:34 -0500
Message-ID: <00b901cccfcb$ab5225a0$01f670e0$@wholeworldwindow.net>
References: <007601cccf3e$72191470$564b3d50$@wholeworldwindow.net>
 <20120110140851.56f53921@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120110140851.56f53921@notabene.brown>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday, January 09, 2012 22:09 -0500 On Behalf Of NeilBrown <
linux-raid-owner@vger.kernel.org> wrote:

> On Mon, 09 Jan 2012 21:20:39 -0500 Bobby Kent
<bpkent@wholeworldwindow.net>
> wrote:
> 
>>  Is Used Dev Space a measure of the capacity on each member device used
by the array? 
> 
> Yes.
> 
> NeilBrown

Hey NeilBrown,

Many thanks for clearing that up. 

On the metadata question the mdadm man page at
http://linux.die.net/man/8/mdadm implies that the driving criteria for
upgrading from 0.90 is use of HDDs with > 2 TB capacity or > 28 HDDs within
a raid device, neither of which are in my current plans, though I imagine at
some point I'll purchase larger HDDs.  Are there any other factors I should
consider (e.g. kernel version compatibility)?

In my previous mail I might have been a little clearer in describing the
hangs/lock ups I was experiencing, as there may have been an unintended
implication that md was somehow at fault.  What I observed was that after
several hours of uptime the system would hang/lock up, nothing was written
to syslog, the desktop froze (mouse unresponsive, clock did not advance,
etc), network unresponsive (could not get a ping response), HDD access LED
was on.  Hitting the reset button appeared to be my only option to get back
to a working system (on one occasion my machine was left in this state for
90+ mins).  I am typically unwilling to hit the reset button, I probably did
it more times last week (3 times after the "downgrading" to 3.0.6 kernel)
than in the prior 18 months.

It was the LED that lead me to wonder about a resync following a hard stop,
and after discovering resyncs had not completed I left my machine booted to
the login prompt (rather than logged into in KDE) one night.  To further
muddy the waters the lock ups occurred while I was making some configuration
changes in order to implement real time processing for audio software.  I've
backed these out prior to the "login prompt boot", and, on balance, I
suspect these may have been the ultimate cause.  Speculation of course,
though without evidence to the contrary, I typically assume issues are of my
own creation rather than the fault of otherwise perfectly stable software
and hardware.  The original question about mdadm output was more a sanity
check that the arrays were configured consistent with expectations.

I'm thinking of setting both LOCKUP_DETECTOR and DETECT_HUNG_TASK in future
kernel builds, hopefully these will provide additional information should
something similar happen in the future.  Are there any other recommended
kernel settings I should implement?

Thanks again,

Bobby

