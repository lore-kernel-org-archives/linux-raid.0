From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid5 Construction Question
Date: Thu, 19 Aug 2004 17:55:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408192155.i7JLtq314497@watkins-home.com>
References: <200408192350.35339.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408192350.35339.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have Seagate disks.  I use a built for Linux tool supplied by Seagate
(seatoolsenterprise).  My disks are not smart compatible, so I use this
tool.  It can also set some Seagate only disk parameters (I think Seagate
only).  The tool can test disks while the system is up and accessing the
disks, just like smartd can.  But as I said, I can't use smartd to test my
disks.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Maarten van den Berg
Sent: Thursday, August 19, 2004 5:51 PM
To: linux-raid@vger.kernel.org
Subject: Re: Raid5 Construction Question

On Thursday 19 August 2004 22:26, Kourosh wrote:
> On Thu, Aug 19, 2004 at 10:24:06PM +0200, Maarten van den Berg wrote:
> > On Thursday 19 August 2004 19:52, PAulN wrote:

> I've found that one of the better ways of varifying a disk is to run
> the disk manufacturers disk utilities on it.  They all provide a
> bootable disk to run the utilities.  Several times I've had problems
> similar to this and each time it ended up being a disk that was
> failing.  Run the utility as all the vendors I've dealt with require
> the error code from the utility to process an RMA, so might as well do
> it sooner, rather than later.

I did not do this for multiple reasons.
The first -and by far the most important one- was that I desperately needed 
the data that was on the broken array (it all stemmed from a two-disk raid5 
failure).  I do not trust these vendor-diskettes to leave my data intact.

Secondly it was far easier for me to run this dd test under linux than find
a 
loose floppydrive, connect it to my server, reinstate IRQ 6 and run various 
floppies against it.

And third, as the system had multiple identical promise addon controllers
and 
7 mostly identical ide disks, I figured I couldn't be totally sure the disk 
linux saw as /dev/hdm was disk ??? on controller ?? as reported by such 
floppies.

I do recommend those utilities for a final go / no-go verdict, but you
better 
run them on standalone systems on single disks.  
Or maybe I'm just being too paranoid is all...?

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

