From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 01:33:07 -0500
Message-ID: <200412030133.07743.systemloc@earthlink.net>
References: <200412030354.iB33sD913132@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412030354.iB33sD913132@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Guy <bugzilla@watkins-home.com>
List-Id: linux-raid.ids

> My linux system is a P3-500 with 2 CPUs and 512 Meg RAM.  My system is much
> faster than my network.  I don't know how your K6-500 compares to my
> P3-500. But RAM may be your issue.  That amount of ram seems very low.  Are
> you swapping?  What is your CPU load during the tests?  If you are at 100%,
> then you are CPU bound.

You've got a dual CPU setup, mine is only single. I'll bet you have a server 
chipset too. Still, I have serious doubts that the CPU is at fault. My guess 
would be that this could be a VIA chipset problem. The load averages while 
running these tests are allways well below 1. 

I mistyped the amount of memory. I have approx 409 MB. I am not swapping. 

> Your disk performance is faster than a 100BaseT network.  So, your
> performance may not be an issue.

The network is gigabit, with a crossover to the client machine. I used ttcp to 
verify that the link is capable of over 146 MB/sec.

TJ
