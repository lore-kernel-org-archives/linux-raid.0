From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 02:38:56 -0500
Message-ID: <200412030739.iB37d2913990@www.watkins-home.com>
References: <200412030133.07743.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412030133.07743.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'TJ' <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gigabit!  Lucky :)

I want a Gigabit switch for Christmas!  And a few PCI cards too!

Of course, with Gigabit, I would want/need a better Linux system too!  With
PCI-express and ...  I better wake up and go to bed!  :)

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of TJ
Sent: Friday, December 03, 2004 1:33 AM
To: linux-raid@vger.kernel.org
Cc: Guy
Subject: Re: Looking for the cause of poor I/O performance

> My linux system is a P3-500 with 2 CPUs and 512 Meg RAM.  My system is
much
> faster than my network.  I don't know how your K6-500 compares to my
> P3-500. But RAM may be your issue.  That amount of ram seems very low.
Are
> you swapping?  What is your CPU load during the tests?  If you are at
100%,
> then you are CPU bound.

You've got a dual CPU setup, mine is only single. I'll bet you have a server

chipset too. Still, I have serious doubts that the CPU is at fault. My guess

would be that this could be a VIA chipset problem. The load averages while 
running these tests are allways well below 1. 

I mistyped the amount of memory. I have approx 409 MB. I am not swapping. 

> Your disk performance is faster than a 100BaseT network.  So, your
> performance may not be an issue.

The network is gigabit, with a crossover to the client machine. I used ttcp
to 
verify that the link is capable of over 146 MB/sec.

TJ
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

