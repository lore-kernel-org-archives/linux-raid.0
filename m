From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: RAID1 VS RAID5
Date: Sun, 26 Oct 2003 19:22:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067192568.1280.6.camel@cala>
References: <1067179519.1222.107.camel@cala>
	 <200310261716.17030.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310261716.17030.maarten@vbvb.nl>
To: maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il dom, 2003-10-26 alle 17:16, maarten van den Berg ha scritto:
>   Raid1 being a mirror set it does not make sense to 
> interleave anything. Either disk1 reads it first or disk2 reads it first. 
> Once you get the data from either disk, then you're done; no need to wait for 
> the second disk (giving you the identical datablock).  

OK I have some difficulties to explain it, I will try again: usually
linux do read prefetch so when you read block "n" after it linux reads
block "n+1". So the "n+1" block can be read at the same time on the
other disk.

Reading past mailing lists posts it seems that raid1 behaviour is this:

1) disk idle
2) request for block "n"
3) request is passed to hard disk with head nearer to block "n" (is it
true? I am not sure)
4) request to block "n+1" "n+2" etc. are on the same disk so THE OTHER
DISK IS READY FOR A READ REQUEST FROM OTHER PROCESSES
5) if sequential reading continue after some minutes the other disk is
chosen to not stress too much only one disk (is it true?)

Obviously this behaviour (point 4) helps servers with a lot of
multitasking and processes.

I prefer a "sequential" optimization.

Can it be done?

Thanks again!


