From: "Customer Service" <it4soho@it4soho.com>
Subject: RE: which is better: promise fasttrak-lite 100 or linux softwareraid?
Date: Wed, 18 Feb 2004 06:44:05 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <IKEGIEMOLKKHNAHLOLIDGENHCAAA.it4soho@it4soho.com>
References: <LAW11-F21YS0qPzg9uV00057b3c@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <LAW11-F21YS0qPzg9uV00057b3c@hotmail.com>
To: Jeff Gray <jeffgray@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff --

One item regarding Linux vs Promise Drivers for the FastTrak ATA RAID c=
ards
(both motherboard embedded and separate PCI cards) that has not yet bee=
n
brought up (unless I missed it in my zeal to avoid these damned Windoze=
 Worm
emails) is:

Promise has a SuperSwap drive bay product that allows for real-time
hot-swapping of drive elements with hot-rebuild capability. The Promise
Drivers support this additional hardware, whereas the Linux Drivers do =
not
(so far as I can tell).

Now if you're using RAID for speed/performance only, then the Linux dri=
vers
seem to be best, as they are much more flexible and efficient than the
Promise provided one(s) -- but whereas I wanted high availability and
reliability from my 200+ GB RAID-1 array, I chose to use the Promise dr=
ivers
with the SuperSwap 1000 removable drive trays. I have survived two sepa=
rate
drive failures in the past 4 months and my system uptime is currently  =
245
days and counting.

As always, your mileage may vary... But I do hope you (or someone) find=
s
this information useful...

Best to you all!

Dan McAllister
IT4SOHO, LLC

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Jeff Gray
Sent: Tuesday, February 17, 2004 2:44 PM
To: xwred1@modestolan.com
Cc: linux-raid@vger.kernel.org
Subject: Re: which is better: promise fasttrak-lite 100 or linux
softwareraid?


>From: Matt Thrailkill <xwred1@modestolan.com>
>Linux software raid could be faster in some cases.  The raid drivers f=
or
>most of those card's in Linux (and even Windows) are less than ideal, =
in
>which case Linux software raid would be more reliable.  And its
>certainly more flexible.

Thank you for your reply Matt. Kevin Corry from the EVMS mailing list
cleared that up for me
as well - I will definetly choose Linux software RAID and mdadm over th=
e
Promise solution.

_________________________________________________________________
Say =93good-bye=94 to spam, viruses and pop-ups with MSN Premium -- fre=
e trial
offer! http://click.atdmt.com/AVE/go/onm00200359ave/direct/01/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
