From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Looking for the cause of poor I/O performance
Date: Mon, 6 Dec 2004 16:39:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412061635200.4484-100000@coffee.psychology.mcmaster.ca>
References: <200412051014.30762.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412051014.30762.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > System A:
> > CPUs	2 X 500 MHz
> > RAM	4 X 128 Meg SDRAM
> > Bus	100 MHz
> > Timing buffer-cache reads:   128 MB in  0.87 seconds =147.13 MB/sec
> >
> > System B:
> > CPUs	2 X 1000 MHz
> > RAM	4 X 256 Meg Registered SDRAM
> > Bus	100 MHz
> > Timing buffer-cache reads:   524 MB in  2.00 seconds =262.00 MB/sec
> >
> > Why is system B almost twice as fast?

the buffer-cache is measuring systemcall overhead as well as speed of 
pagecache-to-user-buffer copying.  both those are certainly influenced
by the CPU speed - even by things like mmx.

> > Is registered RAM faster?

no, it's inherently slower (mostly latency, but since bursts are short,
also in bandwidth.)

> Memory interleaving, perhaps? Registered ram has higher latency. It's possible 
> that the machine is made to do memory interleaving with ECC ram to boost 
> performance.. 

sdram means that interleaving is basically irrelevant.  interleaving was
important when a single bank of ram couldn't sustain one transaction per
cycle (EDO, FPM, etc).

