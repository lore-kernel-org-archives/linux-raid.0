From: Dieter Stueken <stueken@conterra.de>
Subject: Re: raid and sleeping bad sectors
Date: Wed, 30 Jun 2004 10:44:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E27D7C.2040101@conterra.de>
References: <200406300219.i5U2JW327038@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406300219.i5U2JW327038@watkins-home.com>
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Guy wrote:
> I don't think plan b needs to be handled as stated.  If a cable is loose,
> the amount of data that needs to be written somewhere else could be vast.
> At least as big as 1 disk! 

agreed; any such "active" bad block replacement will only postpone the
problem. It will never be able to solve the problem absolutely reliable.
I also agree, that it makes the system more complex and may need some
manual intervention, too.

> That brings me back to:
> If the hard drive can't re-locate the bad block, then, accept that you have
> had a failure.

completely true. Kick off the bad disk and rebuild a new one sound
easy and save. But it is not! Before/during rebuild, your raid system runs
unprotected in a very fragile state, even more fragile than a single
disk system without raid! Thus the additional spare blocks may help
to bridge over this phase more safely. Thus this is not an alternative
of replacing the bad disk; you will do that, definitely!
Instead it is just an addition.

If you are hanging on a rope on a cliff, and notice, that the rope
shows a defect, what will you do? Cut it off, before it breaks
completely! and while falling, you may inspect your backpack to
find a spare rope to use.....

Dieter.
