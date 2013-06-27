From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Wed, 26 Jun 2013 19:23:08 -0500
Message-ID: <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
	<CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
	<51BA7B28.9030808@turmel.org>
	<CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
	<CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
	<CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com>
	<51BB8A67.5000605@turmel.org>
	<51BB8B86.9050803@turmel.org>
	<CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
	<alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Everything is going well, I am just trying to replace the parts that
are on the way out.
I ran a 'repair' and it came out with 5477 under
/sys/block/md0/md/mismatch_cnt.  Then a 'check' came out with 0.

Then I went out and bought a couple WD Reds (I'm done with greens now
that I know they lack ERC).  I replaced one of the two drives Phil
said was not ok, which had many reallocations (I can personally see
those) in the smart status.  I then ran another repair to be safe.  It
came up with 0 mismatches, but in the process /dev/sda started giving
me tons (and tons and tons, rolled over dmesg) of these "failed
command: READ FPDMA QUEUED status: { DRDY ERR } error: { UNC }"
errors. sda hadn't been giving me problems before but I'll come back
to it.

The second disk Phil said was "not ok" was this one which showed
"several pending errors".
(original smart status) http://pastie.org/8040852
I was going to replace it with my second spare Red, but the errors
seem to have gone away.
(current smart status) http://pastie.org/8084278
Or maybe I am looking in the wrong place to find the pending errors
(looking at "197 Current_Pending_Sector").  Is the drive currently in
need of replacement?  I'm not sure what I'm looking for.

What about this one (sda), after it gave all of those errors during a
repair?  http://pastie.org/8084292
I get the "5 Reallocated_Sector_Ct", but where do you find pending errors?

What does it mean to get all these "failed command: READ FPDMA QUEUED
status: { DRDY ERR } error: { UNC }" errors and the smart status seems
to be fine even after a repair?

Thanks everyone, I'm learning a lot.
