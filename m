From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 18:52:25 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402192352.i1JNqT010496@www.watkins-home.com>
References: <403539D7.30202@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <403539D7.30202@adaptec.com>
To: 'Scott Long' <scott_long@adaptec.com>, 'Ricky Beam' <jfbeam@bluetronic.net>
Cc: 'Michael' <michael@insulin-pumpers.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 14 18Gig disks in a RAID5.  When it re-builds I get just over
6Meg/sec.  That's 6M per disk, or 84Meg total I/O per second.  The CPU load
is less than 5%.  My system is a P3-500.  If I had a real computer I would
not be able to measure the CPU usage, it would be too low! :)
I have a 2.4 Kernel.

My SCSI buses are the limiting factor.
40MB bus with 6 disks, 80MB with 7, 80MB with 1.
I have only used a few hardware RAID cards, they are not this fast!

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Scott Long
Sent: Thursday, February 19, 2004 5:34 PM
To: Ricky Beam
Cc: Michael; linux-raid@vger.kernel.org
Subject: Re: 3ware escalade vs software raid, from a different jeff

Ricky Beam wrote:
> On Thu, 19 Feb 2004, Michael wrote:
>  >Bear in mind that what you are calling "true hardware raid" is really
>  >a microprocessor programmed to do the raid algorithims.
> 
> 3ware has custom designed matrix switch chips to handle each IDE drive.
> This *alone* is worth the cost of the card.  The RAID parity calculations
> are also done in hardware (not a bunch of CPU xor's.)  You'd be 
> surprised how
> much data a small "slow" processor can move when properly programmed.
> 

Are you talking about host-processor XOR or adapter card XOR?  The i960
processor used in practically every RAID card known to man right now has
an XOR engine in the memory controller.  It's not quite as efficient as
some higher-end implementations, but it's a heck of a lot better than
having that i960 core spin through an XOR software loop.

Scott

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


